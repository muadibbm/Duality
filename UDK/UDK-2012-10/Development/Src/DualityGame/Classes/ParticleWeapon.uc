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
      RealStartLoc.Z += 2000;
			SpawnedProjectile.Init( Vector(GetAdjustedAim( RealStartLoc )) );
		}

		// Return it up the line
		return SpawnedProjectile;
	}

	return None;
}


// Updated to shoot Decal where mouse is pointing
simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact, optional int NumHits)
{
  local Vector hitLoc;

  hitLoc = Impact.HitLocation;
  hitLoc.Z += 100;

  WorldInfo.MyDecalManager.SpawnDecal (DecalMaterial'DualityL2.Decals.PS_BLUE', // UMaterialInstance used for this decal.
                      hitLoc, // Decal spawned at the hit location.
                      rotator(-Impact.HitNormal), // Orient decal into the surface.
                      128, 128, // Decal size in tangent/binormal directions.
                      256, // Decal size in normal direction.
                      false, // If TRUE, use "NoClip" codepath.
                      FRand() * 360, // random rotation
                      Impact.HitInfo.HitComponent // If non-NULL, consider this component only.
  );
}

simulated function TimeWeaponEquipping()
{
  AttachWeaponTo(Instigator.Mesh,'Blue');
  super.TimeWeaponEquipping();
}

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional Name SocketName)
{
  MeshCpnt.AttachComponentToSocket(Mesh,SocketName);
}


DefaultProperties
{
  FiringStatesArray(0)=WeaponFiring
  WeaponFireTypes(0)=EWFT_InstantHit
  FireInterval(0)=0.1
  Spread(0)=0





  FiringStatesArray(1)=WeaponFiring
  WeaponFireTypes(1)=EWFT_Projectile
  WeaponProjectiles(1)=class'DualityGame.ParticleProjectile'
  FireInterval(1)=0.01
  Spread(1) = 0

	WeaponRange=500

   Begin Object Class=UDKSkeletalMeshComponent Name=BlueMesh
    SkeletalMesh=SkeletalMesh'DualityL2.Meshes.test_PS'
    HiddenGame=false
    HiddenEditor=false
  End object
  Mesh=BlueMesh
  Components.Add(BlueMesh)

  ProjectileSpawnOffset=20.0
}
