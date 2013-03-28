class ParticleProjectile extends UDKProjectile;

var ParticleSystem ProjFlightTemplate;
var ParticleSystemComponent ProjEffects;
var float TossZ;

simulated event PostBeginPlay()
{
  super.PostBeginPlay();
  SpawnFlightEffects();
}

function Init(vector Direction)
{
  SetRotation(rotator(Direction));
  Velocity = Speed * Direction;
  Velocity.Z += TossZ;
  Acceleration = AccelRate * Normal(Velocity);
}

simulated function SpawnFlightEffects()
{
  if (ProjFlightTemplate != None)
  {
    ProjEffects = WorldInfo.MyEmitterPool.SpawnEmitterCustomLifetime(ProjFlightTemplate);
    ProjEffects.SetAbsolute(false, false, false);
    ProjEffects.SetLODLevel(WorldInfo.bDropDetail ? 1 : 0);
    //ProjEffects.OnSystemFinished = MyOnParticleSystemFinished;
    ProjEffects.bUpdateComponentInTick = true;
    AttachComponent(ProjEffects);
  }
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    if ( Other != Instigator )
    {
      WorldInfo.MyDecalManager.SpawnDecal ( DecalMaterial'DualityL2.Decals.PS_BLUE', HitLocation, rotator(-HitNormal), 128, 128, 256, false, FRand() * 360, none );
        Other.TakeDamage( Damage, InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
        Destroy();
    }
}
 
simulated event HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
    //Velocity = MirrorVectorByNormal(Velocity,HitNormal); //That's the bounce
    SetRotation(Rotator(Velocity));
    TriggerEventClass(class'SeqEvent_HitWall', Wall);
}

DefaultProperties
{
  Begin Object Name=CollisionCylinder
    CollisionRadius=8
    CollisionHeight=16
  End Object

  bBlockedByInstigator=false;
  TossZ=0.0
  Speed=1
	MaxSpeed=100
	AccelRate=500
  ProjFlightTemplate=ParticleSystem'Duality.ParticleSystem.PS_BLUE'

  Damage=25000000
  MomentumTransfer=10
}
