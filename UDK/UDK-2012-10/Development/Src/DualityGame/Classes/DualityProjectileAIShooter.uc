class DualityProjectileAIShooter extends DualityProjectile;

function Init(vector Direction)
{
  local float aimZChange;
  `log("Direction: " @direction);
  aimZChange = 0.1 + rand(0.4);
  Direction.z = Direction.z - aimZChange;
  `log("Direction after change: " @direction);
  super.init(direction);
}

DefaultProperties
{
  ProjFlightTemplate=ParticleSystem'Duality.ParticleSystem.AIProjectile'
  ProjExplosionTemplate=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Impact'
  Lifespan=4.0
  DamageRadius=1.0
  Damage=10
}

