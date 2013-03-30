class ParticleProjectile extends UDKProjectile;

var ParticleSystemComponent ProjEffects;
var ParticleSystem ProjFlightTemplate;
var ParticleSystem ProjExplosionTemplate;
var AudioComponent ShootMusic, ExplosionMusic;
var SoundCue ShootSound; 
var SoundCue ExplosionSound; 
var bool bSuppressExplosionFX;
var bool bSuppressSound;
var float TossZ;

simulated event PostBeginPlay()
{
  super.PostBeginPlay();
  SpawnFlightEffects();
  ShootMusic.Play();
}

// Initialize this projectile
function Init(vector Direction)
{
  SetRotation(rotator(Direction));
  Velocity = Speed * Direction;
  Velocity.Z += TossZ;
  Acceleration = AccelRate * Normal(Velocity);
}

// Spawn effects required to display projectile
simulated function SpawnFlightEffects()
{
  if (ProjFlightTemplate != None)
  { 
    ProjEffects = WorldInfo.MyEmitterPool.SpawnEmitterCustomLifetime(ProjFlightTemplate);
    ProjEffects.SetAbsolute(false, false, false);
    ProjEffects.SetLODLevel(WorldInfo.bDropDetail ? 1 : 0);
    ProjEffects.OnSystemFinished = MyOnParticleSystemFinished;
    ProjEffects.bUpdateComponentInTick = true;
    AttachComponent(ProjEffects);
  }
}

// Determine what happens when projectile touches an actor
simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
  if (DamageRadius > 0.0)
  {
    Explode( HitLocation, HitNormal );
  }
  else
  {
    Other.TakeDamage(Damage,InstigatorController,HitLocation,MomentumTransfer * Normal(Velocity), MyDamageType,, self);
    Shutdown();
  }
}

// Handle projectile explosion
simulated function Explode(vector HitLocation, vector HitNormal)
{
  if ( Damage > 0.0 && DamageRadius > 0.0 )
  {  
    if ( !bShuttingDown )
    {
      ProjectileHurtRadius(HitLocation, HitNormal );
    }
  }
  SpawnExplosionEffects(HitLocation, HitNormal);
  ShutDown();
}

// Spawn effects for projectile explosion
simulated function SpawnExplosionEffects(vector HitLocation, vector HitNormal)
{
  local Actor EffectAttachActor;

  if (ProjExplosionTemplate != None)
  {
    EffectAttachActor = None;
    WorldInfo.MyEmitterPool.SpawnEmitter(ProjExplosionTemplate, HitLocation, rotator(HitNormal), EffectAttachActor);
  }


  ExplosionMusic.Play();
  bSuppressExplosionFX = true;
}

// Handle when projectile hits a wall
simulated event HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
  Shutdown();
}

// Clean up particle system
simulated function MyOnParticleSystemFinished(ParticleSystemComponent PSC)
{
  if (PSC == ProjEffects)
  {
    // Clear component and return to pool
    DetachComponent(ProjEffects);
    WorldInfo.MyEmitterPool.OnParticleSystemFinished(ProjEffects);
    ProjEffects = None;
  }
}
simulated function Shutdown()
{
  local vector HitLocation, HitNormal;

  bShuttingDown=true;
  HitNormal = normal(Velocity * -1);
  Trace(HitLocation,HitNormal,(Location + (HitNormal*-32)), Location + (HitNormal*32),true,vect(0,0,0));

  if (ProjEffects!=None)
  {
    ProjEffects.DeactivateSystem();
  }

  if (!bSuppressExplosionFX)
  {
    SpawnExplosionEffects(Location, HitNormal);
  }

  SetCollision(false,false);
  Destroy();
}

DefaultProperties
{
  Begin Object Name=CollisionCylinder
    CollisionRadius=8
    CollisionHeight=16
  End Object

  Begin Object Class=AudioComponent Name=Music01Comp
    SoundCue=SoundCue'Duality_Audio.SoundCue.CatShooting'           
  End Object
  ShootMusic=Music01Comp

  bBlockedByInstigator=false;
  TossZ=0.0
  Speed=5000
  MaxSpeed=10000
  AccelRate=4000
  DamageRadius=200.0

  bShuttingDown=false

  Damage=25000000
  MomentumTransfer=10
}
