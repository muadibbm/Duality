class ParticleProjectile extends UDKProjectile;

var ParticleSystem ProjFlightTemplate;
var ParticleSystemComponent ProjEffects;
var float TossZ;

simulated event PostBeginPlay()
{
  super.PostBeginPlay();
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
  if (WorldInfo.NetMode != NM_DedicatedServer && ProjFlightTemplate != None)
  {
    ProjEffects = WorldInfo.MyEmitterPool.SpawnEmitterCustomLifetime(ProjFlightTemplate);
    ProjEffects.SetAbsolute(false, false, false);
    ProjEffects.SetLODLevel(WorldInfo.bDropDetail ? 1 : 0);
    //ProjEffects.OnSystemFinished = MyOnParticleSystemFinished;
    ProjEffects.bUpdateComponentInTick = true;
    AttachComponent(ProjEffects);
  }
}

DefaultProperties
{
  bBlockedByInstigator=false;
  Speed=1
  MaxSpeed=1
  ProjFlightTemplate=ParticleSystem'Duality.ParticleSystem.PS_BLUE'
}
