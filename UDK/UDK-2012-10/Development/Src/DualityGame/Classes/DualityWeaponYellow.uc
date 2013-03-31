class DualityWeaponYellow extends DualityWeapon;

DefaultProperties
{
  FiringStatesArray(0)=WeaponFiring
  WeaponFireTypes(0)=EWFT_Projectile
  WeaponProjectiles(0)=class'DualityGame.DualityProjectileYellow'
  FireInterval(0)=0.1
  Spread(0) = 0

  // Particle system component to attach to player
  Begin Object Class=ParticleSystemComponent Name=ParticleSystemComponent_YELLOW
        Template=ParticleSystem'Duality.ParticleSystem.PS_YELLOW_SMALL'
        bAutoActivate=true
  End Object
  Particle=ParticleSystemComponent_YELLOW
  Components.Add(ParticleSystemComponent_YELLOW);

	WeaponRange=1000
}
