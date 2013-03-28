class DualityPlayerPawn extends DualityPawn;

var ParticleSystemComponent blue;
var ParticleSystemComponent green;
var ParticleSystemComponent purple;
var ParticleSystemComponent yellow;
var ParticleSystemComponent red;

simulated function PostBeginPlay()
{
  super.PostBeginPlay();
  Mesh.AttachComponentToSocket(blue, 'Blue');
  Mesh.AttachComponentToSocket(green, 'Green');
  Mesh.AttachComponentToSocket(purple, 'Purple');
  Mesh.AttachComponentToSocket(yellow, 'Yellow');
  Mesh.AttachComponentToSocket(red, 'Red');
}



function AddDefaultInventory()
{
  InvManager.CreateInventory(class'DualityGame.ParticleWeapon');
}

DefaultProperties
{
  // Particle system component to attach to player
  Begin Object Class=ParticleSystemComponent Name=ParticleSystemComponent0
        Template=ParticleSystem'Duality.ParticleSystem.PS_BLUE'
        bAutoActivate=true
  End Object
  blue=ParticleSystemComponent0
  Components.Add(ParticleSystemComponent0)
    // Particle system component to attach to player
  Begin Object Class=ParticleSystemComponent Name=ParticleSystemComponent1
        Template=ParticleSystem'Duality.ParticleSystem.PS_GREEN'
        bAutoActivate=true
  End Object
  green=ParticleSystemComponent1
  Components.Add(ParticleSystemComponent1)
    // Particle system component to attach to player
  Begin Object Class=ParticleSystemComponent Name=ParticleSystemComponent2
        Template=ParticleSystem'Duality.ParticleSystem.PS_PURPLE'
        bAutoActivate=true
  End Object
  purple=ParticleSystemComponent2
  Components.Add(ParticleSystemComponent2)
    // Particle system component to attach to player
  Begin Object Class=ParticleSystemComponent Name=ParticleSystemComponent3
        Template=ParticleSystem'Duality.ParticleSystem.PS_YELLOW'
        bAutoActivate=true
  End Object
  yellow=ParticleSystemComponent3
  Components.Add(ParticleSystemComponent3)
    // Particle system component to attach to player
  Begin Object Class=ParticleSystemComponent Name=ParticleSystemComponent4
        Template=ParticleSystem'Duality.ParticleSystem.PS_RED'
        bAutoActivate=true
  End Object
  red=ParticleSystemComponent4
  Components.Add(ParticleSystemComponent4)

  // Player's health/mass
  Health=1000;
  HealthMax=1000;
  	bCanPickupInventory=true;	
	
  // Player initial speed
  GroundSpeed=500
  bCanPickupInventory=true

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
	  AnimSets(0)=AnimSet'Duality.Animations.CAT_IDLE'
  	  AnimSets(1)=AnimSet'Duality.Animations.CAT_FORWARD'
	  AnimSets(2)=AnimSet'Duality.Animations.CAT_BACKWARD'
  	  AnimSets(3)=AnimSet'Duality.Animations.CAT_SHOOTING'
	  AnimTreeTemplate=AnimTree'Duality.Animations.ANIM_CATALYST'
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