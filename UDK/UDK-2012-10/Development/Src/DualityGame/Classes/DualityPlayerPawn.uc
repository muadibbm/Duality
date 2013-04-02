class DualityPlayerPawn extends DualityPawn;

var SkeletalMeshComponent PlayerMesh;
var MaterialInstanceConstant PlayerMatInst;


simulated function PostBeginPlay()
{
  super.PostBeginPlay();

  // Code for changing the material of the player to reflect health
  PlayerMatInst = new class'MaterialInstanceConstant';
  PlayerMatInst.SetParent(PlayerMesh.GetMaterial(1));
  PlayerMesh.SetMaterial(1, PlayerMatInst);
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
  super.postInitAnimTree(SkelComp);
}

function AddDefaultInventory()
{

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
    } else if (weaponList.length == 2) {
      Mesh.AttachComponentToSocket(weaponList[1].Particle, 'Weapon2');
    } else if (weaponList.length == 3) {
      Mesh.AttachComponentToSocket(weaponList[2].Particle, 'Weapon3');
    } else if (weaponList.Length == 4) {
      Mesh.AttachComponentToSocket(weaponList[3].Particle, 'Weapon4');  
    } else if (weaponList.Length == 5) {
      Mesh.AttachComponentToSocket(weaponList[4].Particle, 'Weapon5');  
      combineParticles(weaponList); //check if all 5 are different
    }
    
 

    return true;
}

function bool combineParticles(array<DualityWeapon> weaponList)
{
  local bool foundBlue;
  local bool foundGreen;
  local bool foundPurple;
  local bool foundRed;
  local bool foundYellow;
  local int i;
  foundRed = false;
  foundBlue = false;
  foundGreen = false;
  foundYellow = false;
  foundPurple = false;

 `log("Combiner called!" );

  for (i = 0; i < weaponList.Length; i++) {
    if (weaponList[i].isA('DualityWeapon_Blue')) {
      foundBlue = true;
      
    }else if (weaponList[i].isA('DualityWeapon_Green')){
      foundGreen = true;
    
    }else if (weaponList[i].isA('DualityWeapon_Purple')){
      foundPurple = true;
     
    }else if (weaponList[i].isA('DualityWeapon_Red')){
      foundRed = true;
    
    }else if (weaponList[i].isA('DualityWeapon_Yellow')){
      foundYellow = true;
    
    }
  }

  if (foundPurple && foundBlue && foundRed && foundGreen && foundYellow){ //all 5 weapons are found
    for (i = 0; i < weaponList.Length; i++) { //erase all 5 in inventory and from sockets
      removeParticle();
    }
    
    //if (weaponList.length == 0) { //THIS IS ALWAYS FALSE?!?! WHY?!?!
    InvManager.CreateInventory(class'DualityGame.DualityWeapon_Mega'); //add MEGA to inventory
    AttachNewParticle(weaponList);
    //Mesh.AttachComponentToSocket(weaponList[0].Particle, 'Weapon1'); //THIS SHOULD BE THE CENTER!  
  }

return true;

}

event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
  local LinearColor matColor;

  super.TakeDamage(Damage,InstigatedBy, HitLocation,Momentum,DamageType,HitInfo,DamageCauser);

  // Code for changing player mesh color when health changes
 // if (health == 100) {
  `log("Damge being taken");
  matColor = MakeLinearColor(5,Health/2,Health*2,1);
  PlayerMatInst.SetVectorParameterValue('Health_Color', matColor);
  //}

}


function bool removeParticle()
{
  local array<DualityWeapon> WeaponList;
  local DualityWeapon w;
  DualityInventoryManager(InvManager).getWeaponList(WeaponList);
  w = WeaponList[0];
  if (weaponList.length > 0) {
    InvManager.RemoveFromInventory(w);
    Mesh.DetachComponent(w.Particle);
    ReorganizeParticles();
    return true;
  }
  return false;
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

DefaultProperties
{

  // Player's health/mass
  Health=2000;
  HealthMax=2000;
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
	  AnimSets(0)=AnimSet'Duality_Animations.AnimSets.CAT_IDLE2'
  	AnimSets(1)=AnimSet'Duality_Animations.AnimSets.CAT_FORWARD2'
	  AnimSets(2)=AnimSet'Duality_Animations.AnimSets.CAT_BACKWARD2'
  	AnimSets(3)=AnimSet'Duality_Animations.AnimSets.CAT_SHOOTING2'
    AnimSets(4)=AnimSet'Duality_Animations.AnimSets.CAT_DYING2'
    AnimSets(5)=AnimSet'Duality_Animations.AnimSets.CAT_JUMP'
    AnimSets(6)=AnimSet'Duality_Animations.AnimSets.CAT_LEFT'
    AnimSets(7)=AnimSet'Duality_Animations.AnimSets.CAT_RIGHT'
	  AnimTreeTemplate=AnimTree'Duality_Animations.AnimTrees.ANIM_CATALYST2'
	  SkeletalMesh=SkeletalMesh'Duality.Meshes.CATALYST2'
  End Object

  CollisionType=COLLIDE_BlockAll
  Begin Object Name=CollisionCylinder
    CollisionRadius=+0023.000000
    CollisionHeight=+0050.000000
  End Object
  CylinderComponent=CollisionCylinder


  // Set up collision cylinder for pawn
  Mesh=PawnMesh;
  PlayerMesh=PawnMesh;
  Components.Add(PawnMesh); 
}