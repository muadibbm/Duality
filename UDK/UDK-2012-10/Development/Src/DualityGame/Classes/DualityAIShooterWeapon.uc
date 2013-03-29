class DualityAIShooterWeapon extends DualityWeapon;

simulated function Projectile ProjectileFire() {
  local Vector projLocation, weapSocketLocation;
  local Rotator projRotation, weapSocketRotation;
  local class<Projectile> projectileClass;
  local Projectile projSpawned;

  DualityAIShooterPawn(Instigator).Mesh.getSocketWorldLocationAndRotation(DualityAIShooterPawn(instigator).weapSocket, weapSocketLocation, weapSocketRotation);

  projLocation = WeapSocketLocation;
  projRotation = instigator.rotation;

  // Get the projectile class
  projectileClass = getProjectileClass();

  if (projectileClass != none) {
    // Spawn the projectile setting the projectile's owner to myself
    projSpawned = spawn(projectileClass, self,, projLocation, projRotation);

    // Check if we've spawn the projectile, and that it isn't going to be deleted
    if (projSpawned != none) {
      projSpawned.init(Vector(projRotation));
    }
  }
  return projSpawned;
}

DefaultProperties
{
  weaponFireTypes(0)=EWFT_Projectile
  weaponFireTypes(1)=EWFT_Projectile
  weaponProjectiles(0)=class'DualityGame.DualityAIProjectile'
  weaponProjectiles(1)=class'DualityGame.DualityAIProjectile'

  fireInterval(0)=1.0
  fireInterval(1)=1.0
}
