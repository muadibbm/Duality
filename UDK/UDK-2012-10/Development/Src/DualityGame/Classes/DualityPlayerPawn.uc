class DualityPlayerPawn extends DualityPawn;


simulated function PostBeginPlay()
{
  super.PostBeginPlay();
  AddDefaultInventory();
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
  super.postInitAnimTree(SkelComp);
}

function AddDefaultInventory()
{

}


function bool ReorganizeParticles() 
{
  local array<DualityWeapon> WeaponList;
  local int i;
  DualityInventoryManager(InvManager).getWeaponList(WeaponList);
  for (i = 0; i < weaponList.Length; i++) {
    Mesh.DetachComponent(weaponList[i].Particle);
  }
  for (i = 0; i < weaponList.Length; i++) {
    if (i == 0) {
      Mesh.AttachComponentToSocket(weaponList[0].Particle, 'Weapon1');
    } else if (i == 1) {
      Mesh.AttachComponentToSocket(weaponList[1].Particle, 'Weapon2');
    } else if (i == 2) {
      Mesh.AttachComponentToSocket(weaponList[2].Particle, 'Weapon3');
    } else if (i == 3) {
      Mesh.AttachComponentToSocket(weaponList[3].Particle, 'Weapon4');  
    } else if (i == 4) {
      Mesh.AttachComponentToSocket(weaponList[4].Particle, 'Weapon5');  
    }
  }
  return true;

}


function bool HandleBlueParticlePickup() 
{
  local array<DualityWeapon> WeaponList;
  DualityInventoryManager(InvManager).getWeaponList(WeaponList);
  if (weaponList.length < 5) {
    InvManager.CreateInventory(class'DualityGame.DualityWeapon_Blue');
    return AttachNewParticle(WeaponList);
  }
  return false;
}

function bool HandleGreenParticlePickup() 
{
  local array<DualityWeapon> WeaponList;
  DualityInventoryManager(InvManager).getWeaponList(WeaponList);
  if (weaponList.length < 5) {
    InvManager.CreateInventory(class'DualityGame.DualityWeapon_Green');
    return AttachNewParticle(WeaponList);
  }
  return false;
}

function bool HandleRedParticlePickup() 
{
  local array<DualityWeapon> WeaponList;
  DualityInventoryManager(InvManager).getWeaponList(WeaponList);
  if (weaponList.length < 5) {
    InvManager.CreateInventory(class'DualityGame.DualityWeapon_Red');
    return AttachNewParticle(WeaponList);
  }
  return false;
}

function bool HandleYellowParticlePickup() 
{
  local array<DualityWeapon> WeaponList;
  DualityInventoryManager(InvManager).getWeaponList(WeaponList);
  if (weaponList.length < 5) {
    InvManager.CreateInventory(class'DualityGame.DualityWeapon_Yellow');

    return AttachNewParticle(WeaponList);
  }
  return false;
}

function bool HandlePurpleParticlePickup() 
{
  local array<DualityWeapon> WeaponList;
  DualityInventoryManager(InvManager).getWeaponList(WeaponList);
  if (weaponList.length < 5) {
    InvManager.CreateInventory(class'DualityGame.DualityWeapon_Purple');
   
   return AttachNewParticle(WeaponList);
  }
  return false;
}

function bool AttachNewParticle(array<DualityWeapon> WeaponList)
{
    weaponList.length = 0;
    DualityInventoryManager(InvManager).getWeaponList(WeaponList);
    if (weaponList.length == 1) {
      Mesh.AttachComponentToSocket(weaponList[0].Particle, 'Weapon1');
          return true;
    } else if (weaponList.length == 2) {
      Mesh.AttachComponentToSocket(weaponList[1].Particle, 'Weapon2');
         return true;
    } else if (weaponList.length == 3) {
      Mesh.AttachComponentToSocket(weaponList[2].Particle, 'Weapon3');
          return true;
    } else if (weaponList.Length == 4) {
      Mesh.AttachComponentToSocket(weaponList[3].Particle, 'Weapon4');  
          return true;
    } else if (weaponList.Length == 5) {
      Mesh.AttachComponentToSocket(weaponList[4].Particle, 'Weapon5');  
          return true;
    }

}


function bool removeParticle()
{
  local array<DualityWeapon> WeaponList;
  local DualityWeapon w;
  DualityInventoryManager(InvManager).getWeaponList(WeaponList);
  w = WeaponList[0];
  if (weaponList.length > 0) {
    InvManager.RemoveFromInventory(WeaponList[0]);
    Mesh.DetachComponent(w.Particle);
    ReorganizeParticles();
    return true;
  }
  return false;
}


DefaultProperties
{

  // Player's health/mass
  Health=1000;
  HealthMax=1000;
  bCanPickupInventory=true;	
	
  // Player initial speed
  GroundSpeed=500

  // Define custom inventory manager class
  InventoryManagerClass=class'DualityGame.DualityInventoryManager'
	
 // Light environment for model.
  Begin Object Class=DynamicLightEnvironmentComponent Name=PawnLightEnvironment
	  ModShadowFadeoutTime=0.25
    MinTimeBetweenFullUpdates=0.2
    AmbientGlow=(R=.01,G=.01,B=.01,A=1)
		AmbientShadowColor=(R=0.15,G=0.15,B=0.15)
    bSynthesizeSHLight=true
  End Object
  Components.Add(PawnLightEnvironment)


  Begin Object Class=SkeletalMeshComponent Name=PawnMesh
	  // These are object properties
	  CastShadow=true
	  bCastDynamicShadow=true
	  bOwnerNoSee=false
	  LightEnvironment=PawnLightEnvironment;
	  BlockRigidBody=true;
	  CollideActors=true;
	  BlockZeroExtent=true;
	
	  PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
	  AnimSets(0)=AnimSet'Duality_Animations.AnimSets.CAT_IDLE'
  	AnimSets(1)=AnimSet'Duality_Animations.AnimSets.CAT_FORWARD'
	  AnimSets(2)=AnimSet'Duality_Animations.AnimSets.CAT_BACKWARD'
  	AnimSets(3)=AnimSet'Duality_Animations.AnimSets.CAT_SHOOTING'
    AnimSets(4)=AnimSet'Duality_Animations.AnimSets.CAT_DYING'
	  AnimTreeTemplate=AnimTree'Duality_Animations.AnimTrees.ANIM_CATALYST'
	  SkeletalMesh=SkeletalMesh'Duality.Meshes.catalyst'
  End Object

  CollisionType=COLLIDE_BlockAll
  Begin Object Name=CollisionCylinder
    CollisionRadius=+0023.000000
    CollisionHeight=+0050.000000
  End Object
  CylinderComponent=CollisionCylinder


  // Set up collision cylinder for pawn
  Mesh=PawnMesh;
  Components.Add(PawnMesh); 

}