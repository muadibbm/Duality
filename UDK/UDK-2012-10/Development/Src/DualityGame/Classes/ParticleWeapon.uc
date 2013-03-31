class ParticleWeapon extends UDKWeapon;

var float ProjectileSpawnOffset;
var ParticleSystemComponent Particle;

// Set position of mesh
simulated event SetPosition(UDKPawn Holder)
{
  local SkeletalMeshComponent compo;
  local SkeletalMeshSocket socket;
  local Vector FinalLocation;

  compo = Holder.Mesh;
 
  if( compo != none )
  {
    socket = compo.GetSocketByName('BRAIN');
    if( socket != none )
    {
     
      ItemRemovedFromInvManager();
      FinalLocation = compo.GetBoneLocation(socket.BoneName);
    }
  } 
  SetLocation(FinalLocation);
}

// Set firing location to be the brain of character
simulated function vector GetPhysicalFireStartLoc(optional vector AimDir)
{
  Local SkeletalMeshComponent AttachedMesh;
  local vector SocketLocation;
  Local DualityPawn DP;
	
  DP = DualityPawn(Owner);
  
  AttachedMesh = DP.Mesh;
  AttachedMesh.GetSocketWorldLocationAndRotation('BRAIN', SocketLocation);
  return SocketLocation;
}

// Fire projectile
simulated function Projectile ProjectileFire()
{
  local vector RealStartLoc;
  local Projectile SpawnedProjectile;

  // this is the location where the projectile is spawned.
  RealStartLoc = GetPhysicalFireStartLoc();
  
  // Spawn projectile
  SpawnedProjectile = Spawn(GetProjectileClass(),,, RealStartLoc);
  if( SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe )
  {
    SpawnedProjectile.Init( Vector(GetAdjustedAim( RealStartLoc )) );
  }

  // Return it up the line
  return SpawnedProjectile;
}

// Set weapon to be single shot
simulated function bool ShouldRefire()
{
  ClearPendingFire(0);
  return false;
}

// Equip weapon for character
simulated function TimeWeaponEquipping()
{
  AttachWeaponTo(Instigator.Mesh,'BRAIN');
  super.TimeWeaponEquipping();
}

// Attach weapon to character mesh
simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional Name SocketName)
{
  MeshCpnt.AttachComponentToSocket(Mesh,SocketName);
}


DefaultProperties
{
  ProjectileSpawnOffset=20.0
}