class ParticleWeapon_Green extends ParticleWeapon;

DefaultProperties
{
  FiringStatesArray(0)=WeaponFiring
  WeaponFireTypes(0)=EWFT_Projectile
  WeaponProjectiles(0)=class'DualityGame.ParticleProjectile_Green'
  FireInterval(0)=0.1
  Spread(0) = 0

 // Particle system component to attach to player
  Begin Object Class=ParticleSystemComponent Name=ParticleSystemComponent_GREEN
        Template=ParticleSystem'Duality.ParticleSystem.PS_GREEN_SMALL'
        bAutoActivate=true
  End Object
  Particle=ParticleSystemComponent_GREEN
  Components.Add(ParticleSystemComponent_GREEN);

	WeaponRange=1000
}