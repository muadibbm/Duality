class DualityWeapon_Mega extends DualityWeapon;

DefaultProperties
{
  FiringStatesArray(0)=WeaponFiring
  WeaponFireTypes(0)=EWFT_Projectile
  WeaponProjectiles(0)=class'DualityGame.DualityProjectile_Mega'
  FireInterval(0)=0.1
  Spread(0) = 0

  // Particle system component to attach to player
  Begin Object Class=ParticleSystemComponent Name=ParticleSystemComponent_MEGA
        Template=ParticleSystem'Duality.ParticleSystem.PS_MEGA_SMALL'
        bAutoActivate=true
  End Object
  Particle=ParticleSystemComponent_MEGA
  Components.Add(ParticleSystemComponent_MEGA);

	WeaponRange=1000
}
