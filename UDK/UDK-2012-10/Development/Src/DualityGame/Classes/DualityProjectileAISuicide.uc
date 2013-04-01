class DualityProjectileAISuicide extends DualityProjectile;

function Init(vector Direction)
{
  `log("Direction: " @direction);
  Direction.z = Direction.z - 0.2;
  `log("Direction after change: " @direction);
  super.init(direction);
}

DefaultProperties
{
  ProjFlightTemplate=ParticleSystem'Duality.ParticleSystem.SuicideExplosion'
  ProjExplosionTemplate=ParticleSystem'Duality.ParticleSystem.SuicideExplosion'
  Speed=5
  Lifespan=1
  Damage=400
}
