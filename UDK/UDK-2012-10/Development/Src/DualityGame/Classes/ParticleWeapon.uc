class ParticleWeapon extends UDKWeapon;

var float ProjectileSpawnOffset;

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
      FinalLocation = compo.GetBoneLocation(socket.BoneName);
    }
  } 
  SetLocation(FinalLocation);
}

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

simulated function Projectile ProjectileFire()
{
	local vector RealStartLoc, StartTrace, EndTrace, AimDir, HitLocation, HitNormal;
	local Projectile	SpawnedProjectile;
  local Actor HitActor;

	// tell remote clients that we fired, to trigger effects
	IncrementFlashCount();

	if( Role == ROLE_Authority )
	{
		// this is the location where the projectile is spawned.
		RealStartLoc = GetPhysicalFireStartLoc();
    StartTrace = Instigator.GetWeaponStartTraceLocation();
    
    if ( RealStartLoc != StartTrace )
    {
      EndTrace = StartTrace + vector(GetAdjustedAim( StartTrace ) * GetTraceRange());
      HitActor = Instigator.Trace(HitLocation, HitNormal, EndTrace, StartTrace, FALSE);

      if (HitActor != None)
      {
        AimDir = HitLocation - RealStartLoc;
      }
      else
      {
        AimDir = RealStartLoc;
      }
    }
    else
    {
      AimDir = RealStartLoc;
    }
  
    `log("Spawn Projectile");
		// Spawn projectile
		SpawnedProjectile = Spawn(GetProjectileClass(),,, RealStartLoc);
		if( SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe )
		{
			SpawnedProjectile.Init( Vector(GetAdjustedAim( RealStartLoc )) );
		}
    
		// Return it up the line
		return SpawnedProjectile;
	}

	return None;
}

// Set weapon to be single shot
simulated function bool ShouldRefire()
{
	ClearPendingFire(0);
	return false;
}

simulated function TimeWeaponEquipping()
{
  AttachWeaponTo(Instigator.Mesh,'BRAIN');
  super.TimeWeaponEquipping();
}

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional Name SocketName)
{
  MeshCpnt.AttachComponentToSocket(Mesh,SocketName);
}


DefaultProperties
{
  ProjectileSpawnOffset=20.0
}
