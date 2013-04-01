class DualityProjectileAIShooter extends DualityProjectile;

function Init(vector Direction)
{
  `log("Direction: " @direction);
  Direction.z = Direction.z - 0.2;
  `log("Direction after change: " @direction);
  super.init(direction);
}

DefaultProperties
{
  ProjFlightTemplate=ParticleSystem'Duality.ParticleSystem.AIProjectile'
  ProjExplosionTemplate=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Impact'
  Lifespan=4.0
  Damage=20
}

