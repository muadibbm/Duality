class DualityProjectile extends UDKProjectile
abstract;

var ParticleSystem projFiringParticle;

var ParticleSystemComponent projSysComp;

simulated function postBeginPlay() {
  super.postBeginPlay();
  setupProjectileSpawning();
}

simulated function setupProjectileSpawning() {
  if (projfiringParticle != none) {
    projSysComp = WorldInfo.MyEmitterPool.spawnEmitterCustomLifetime(projFiringParticle);
    projSysComp.setAbsolute(false,false,false);
    projSysComp.onSystemFinished = particleSystemFinished;
    attachComponent(projSysComp);
  }
}

function init(Vector direction) {
  Velocity = speed * direction;
  Acceleration = accelRate * Normal(velocity);
  setRotation(rotator(direction));
}

simulated function particleSystemFinished(ParticleSystemComponent PSC) {
  if (PSC == projSysComp) {
    detachComponent(projSysComp);
    WorldInfo.MyEmitterPool.onParticleSystemFinished(projSysComp);
    projSysComp = none;
  }
}

simulated function destroyed() {
  if (projSysComp != none) {
    detachComponent(projSysComp);
    WorldInfo.MyEmitterPool.onParticleSystemFinished(projSysComp);
    projSysComp = none;
  }
  super.destroyed();
}

