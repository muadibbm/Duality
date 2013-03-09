class ParticleWeapon extends UDKWeapon;

// Set position of mesh
simulated event SetPosition(UDKPawn Holder)
{
  local SkeletalMeshComponent compo;
  local SkeletalMeshSocket socket;
  local Vector FinalLocation;
 
  compo = Holder.Mesh;
 
  if( compo != none )
  {
    socket = compo.GetSocketByName('WeaponSocket');
    if( socket != none )
    {
      FinalLocation = compo.GetBoneLocation(socket.BoneName);
    }
  } //And we probably should do something similar for the rotation <img src="http://www.moug-portfolio.info/wp-includes/images/smilies/icon_smile.gif" alt=":)" class="wp-smiley"> 
 
  SetLocation(FinalLocation);
}

// Updated to shoot Decal where mouse is pointing
simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact, optional int NumHits)
{
  local Vector hitLoc;

  hitLoc = Impact.HitLocation;
  hitLoc.Z += 100;

  WorldInfo.MyDecalManager.SpawnDecal (DecalMaterial'HU_Deck.Decals.M_Decal_GooLeak', // UMaterialInstance used for this decal.
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
  AttachWeaponTo(Instigator.Mesh,'WeaponSocket');
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

  Begin Object Class=UDKSkeletalMeshComponent Name=GunMesh
    //SkeletalMesh=SkeletalMesh'WP_LinkGun.Mesh.SK_WP_LinkGun_3P'
    HiddenGame=false
    HiddenEditor=false
  End object
  Mesh=GunMesh
  Components.Add(GunMesh)
}
