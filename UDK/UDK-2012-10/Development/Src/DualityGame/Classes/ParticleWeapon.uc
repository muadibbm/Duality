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
    socket = compo.GetSocketByName('Blue');
    if( socket != none )
    {
      FinalLocation = compo.GetBoneLocation(socket.BoneName);
    }
  } 
 
  SetLocation(FinalLocation);
}

simulated function vector GetPhysicalFireStartLoc(optional vector AimDir)
{
	local vector FireStartLoc, HitLocation, HitNormal, FireDir, FireEnd, ProjBox;
	local Actor HitActor;
	local rotator FireRot;
	local class<Projectile> FiredProjectileClass;
	local int TraceFlags;

	if( Instigator != none )
	{
		FireRot = Instigator.GetViewRotation();
		FireDir = vector(FireRot);
		FireStartLoc = Instigator.GetPawnViewLocation() + (FireDir * FireOffset.X);
		//FireStartLoc = Instigator.GetPawnViewLocation() + (FireOffset >> FireRot);

		FiredProjectileClass = GetProjectileClass();
		if ( FiredProjectileClass != None )
		{
			FireEnd = FireStartLoc + FireDir * ProjectileSpawnOffset;
			TraceFlags = bCollideComplex ? TRACEFLAG_Bullet : 0;
			if ( FiredProjectileClass.default.CylinderComponent.CollisionRadius > 0 )
			{
				FireEnd += FireDir * FiredProjectileClass.default.CylinderComponent.Translation.X;
				ProjBox = FiredProjectileClass.default.CylinderComponent.CollisionRadius * vect(1,1,0);
				ProjBox.Z = FiredProjectileClass.default.CylinderComponent.CollisionHeight;
				HitActor = Trace(HitLocation, HitNormal, FireEnd, Instigator.Location, true, ProjBox,,TraceFlags);
				if ( HitActor == None )
				{
					HitActor = Trace(HitLocation, HitNormal, FireEnd, FireStartLoc, true, ProjBox,,TraceFlags);
				}
				else
				{
					FireStartLoc = Instigator.Location - FireDir*FiredProjectileClass.default.CylinderComponent.Translation.X;
					FireStartLoc.Z = FireStartLoc.Z + FMin(Instigator.EyeHeight, Instigator.CylinderComponent.CollisionHeight - FiredProjectileClass.default.CylinderComponent.CollisionHeight - 1.0);
					return FireStartLoc;
				}
			}
			else
			{
				HitActor = Trace(HitLocation, HitNormal, FireEnd, FireStartLoc, true, vect(0,0,0),,TraceFlags);
			}
			return (HitActor == None) ? FireEnd : HitLocation - 3*FireDir;
		}
		return FireStartLoc;
	}
	return Location;
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
	ClearPendingFire(1);
	return false;
}

simulated function TimeWeaponEquipping()
{
  AttachWeaponTo(Instigator.Mesh,'CANNON_LEFT');
  super.TimeWeaponEquipping();
}

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional Name SocketName)
{
  MeshCpnt.AttachComponentToSocket(Mesh,SocketName);
}


DefaultProperties
{

  FiringStatesArray(0)=WeaponFiring
  WeaponFireTypes(0)=EWFT_Projectile
  WeaponProjectiles(0)=class'DualityGame.ParticleProjectile'
  FireInterval(0)=0.1
  Spread(0) = 0

	WeaponRange=1000

  ProjectileSpawnOffset=20.0
}
