class ParticleWeapon_Blue extends ParticleWeapon;

DefaultProperties
{
  FiringStatesArray(0)=WeaponFiring
  WeaponFireTypes(0)=EWFT_Projectile
  WeaponProjectiles(0)=class'DualityGame.ParticleProjectile_Blue'
  FireInterval(0)=0.1
  Spread(0) = 0

  // Particle system component to attach to player
  Begin Object Class=ParticleSystemComponent Name=ParticleSystemComponent_BLUE
        Template=ParticleSystem'Duality.ParticleSystem.PS_BLUE_SMALL'
        bAutoActivate=true
  End Object
  Particle=ParticleSystemComponent_BLUE
  Components.Add(ParticleSystemComponent_BLUE);
 // Mesh.HideBoneByName('Blue',PBO_None );

	WeaponRange=1000
}
