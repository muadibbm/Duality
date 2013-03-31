class DualityWeaponRed extends DualityWeapon;

DefaultProperties
{
  FiringStatesArray(0)=WeaponFiring
  WeaponFireTypes(0)=EWFT_Projectile
  WeaponProjectiles(0)=class'DualityGame.DualityProjectileRed'
  FireInterval(0)=0.1
  Spread(0) = 0
  
  // Particle system component to attach to player
  Begin Object Class=ParticleSystemComponent Name=ParticleSystemComponent_RED
        Template=ParticleSystem'Duality.ParticleSystem.PS_RED_SMALL'
        bAutoActivate=true
  End Object
  Particle=ParticleSystemComponent_RED
  Components.Add(ParticleSystemComponent_RED);


	WeaponRange=1000
}
