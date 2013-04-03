class DualityAIProjectile extends UDKProjectile;

defaultProperties {
 // projFiringParticle=ParticleSystem'ClassContent.particleSystems.BlastParticle'

  speed=1000
  maxSpeed=1000
  accelRate=2000.0

  damage=0.1
  damageRadius=0
  momentumTransfer=0

  myDamageType=class'DamageType'
  LifeSpan=3.0

  bCollideWorld=true
  drawScale=1.0
}