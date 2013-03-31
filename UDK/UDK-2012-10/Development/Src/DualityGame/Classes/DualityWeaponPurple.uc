class DualityWeaponPurple extends DualityWeapon;

DefaultProperties
{
  FiringStatesArray(0)=WeaponFiring
  WeaponFireTypes(0)=EWFT_Projectile
  WeaponProjectiles(0)=class'DualityGame.DualityProjectilePurple'
  FireInterval(0)=0.1
  Spread(0) = 0

  // Particle system component to attach to player
  Begin Object Class=ParticleSystemComponent Name=ParticleSystemComponent_PURPLE
        Template=ParticleSystem'Duality.ParticleSystem.PS_PURPLE_SMALL'
        bAutoActivate=true
  End Object
  Particle=ParticleSystemComponent_PURPLE
  Components.Add(ParticleSystemComponent_PURPLE);

  WeaponRange=1000
}
