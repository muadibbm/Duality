class DualityPlayerPawn extends DualityPawn;

var ParticleSystemComponent green;
var ParticleSystemComponent purple;
var ParticleSystemComponent yellow;
var ParticleSystemComponent red;
var bool bParticle1TimerOn;

simulated function PostBeginPlay()
{
  super.PostBeginPlay();
  if (controller.isA('DualityPlayerController')) {
    `log("Wow, good stuff.");
  } else {
    `log("WTF IS WRONG WITH YOU");
  }
  //Mesh.AttachComponentToSocket(blue, 'Blue');

  //Mesh.AttachComponentToSocket(green, 'Green');
  //Mesh.AttachComponentToSocket(purple, 'Purple');
  //Mesh.AttachComponentToSocket(yellow, 'Yellow');
  //Mesh.AttachComponentToSocket(red, 'Red');
  AddDefaultInventory();
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
  super.postInitAnimTree(skelComp);
}

function AddDefaultInventory()
{
  //InvManager.CreateInventory(class'DualityGame.GreenParticleWeapon');
  //InvManager.CreateInventory(class'DualityGame.BlueParticleWeapon');
  //InvManager.CreateInventory(class'DualityGame.RedParticleWeapon');
  //InvManager.CreateInventory(class'DualityGame.PurpleParticleWeapon');
  //InvManager.CreateInventory(class'DualityGame.YellowParticleWeapon');
}


function bool HandleBlueParticlePickup() {
  local array<ParticleWeapon> WeaponList;
  DualityInventoryManager(InvManager).getWeaponList(WeaponList);
  if (weaponList.length < 5) {
    InvManager.CreateInventory(class'DualityGame.BlueParticleWeapon');
    weaponList.length = 0;
    DualityInventoryManager(InvManager).getWeaponList(WeaponList);
    if (weaponList.length == 1) {
      `log("List size still 1");
      Mesh.AttachComponentToSocket(weaponList[0].Particle, 'Red');
      return true;
    } else if (weaponList.length == 2) {
      Mesh.AttachComponentToSocket(weaponList[1].Particle, 'Yellow');
      `log("SHOULD ATTACH to socket, but not attaching to socket");
      return true;
    } else if ( weaponList.length == 3) {
      Mesh.AttachComponentToSocket(weaponList[1].Particle, 'Yellow');
      `log("Index is WRONG");
    }
  }
  `log("Weapon list is too large");
  return false;
  //GroundSpeed=GroundSpeed/2.00;
  // Particle system component to attach to player
 // Mesh.HideBoneByName('Blue',PBO_None );
  //if (!bParticle1TimerON) {
   // SetTimer(1.0,false, 'ParticlePickupTimewr');
   // bParticle1TimerOn=true;
  //}
}


function ParticlePickupTimer () {
 // GroundSpeed=GroundSpeed*2.00;
 // bParticle1TimerOn=true;
}


DefaultProperties
{


  // Particle system component to attach to player
  Begin Object Class=ParticleSystemComponent Name=ParticleSystemComponent_GREEN
        Template=ParticleSystem'Duality.ParticleSystem.PS_GREEN_SMALL'
        bAutoActivate=true
  End Object
  green=ParticleSystemComponent_GREEN
 //Components.Add(ParticleSystemComponent_GREEN);

  // Particle system component to attach to player
  Begin Object Class=ParticleSystemComponent Name=ParticleSystemComponent_PURPLE
        Template=ParticleSystem'Duality.ParticleSystem.PS_PURPLE_SMALL'
        bAutoActivate=true
  End Object
  purple=ParticleSystemComponent_PURPLE
// Components.Add(ParticleSystemComponent_PURPLE);

  // Particle system component to attach to player
  Begin Object Class=ParticleSystemComponent Name=ParticleSystemComponent_YELLOW
        Template=ParticleSystem'Duality.ParticleSystem.PS_YELLOW_SMALL'
        bAutoActivate=true
  End Object
  yellow=ParticleSystemComponent_YELLOW
 //Components.Add(ParticleSystemComponent_YELLOW);

  // Particle system component to attach to player
  Begin Object Class=ParticleSystemComponent Name=ParticleSystemComponent_RED
        Template=ParticleSystem'Duality.ParticleSystem.PS_RED_SMALL'
        bAutoActivate=true
  End Object
  red=ParticleSystemComponent_RED
 // Components.Add(ParticleSystemComponent_RED);


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
	  // NOTE: Mesh properties to change to add new model or animation set
	  PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
	  AnimSets(0)=AnimSet'Duality_Animations.AnimSets.CAT_IDLE'
  	AnimSets(1)=AnimSet'Duality_Animations.AnimSets.CAT_FORWARD'
	  AnimSets(2)=AnimSet'Duality_Animations.AnimSets.CAT_BACKWARD'
  	AnimSets(3)=AnimSet'Duality_Animations.AnimSets.CAT_SHOOTING'
    AnimSets(4)=AnimSet'Duality_Animations.AnimSets.CAT_DYING'
	  AnimTreeTemplate=AnimTree'Duality_Animations.AnimTrees.ANIM_CATALYST'
	  SkeletalMesh=SkeletalMesh'Duality.Meshes.catalyst'
  End Object


  // Set up collision cylinder for pawn
  Mesh=PawnMesh;
  Components.Add(PawnMesh); 
	CollisionType=COLLIDE_BlockAll
	Begin Object Name=CollisionCylinder
		CollisionRadius=+0023.000000
		CollisionHeight=+0050.000000
	End Object
	CylinderComponent=CollisionCylinder
}