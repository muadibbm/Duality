class DualityPlayerPawn extends DualityPawn;

// Tells the PlayerController what Camera Style to set the camera in initially
simulated function name GetDefaultCameraMode(PlayerController RequestedBy)
{
	  return 'ThirdPerson';
}

function AddDefaultInventory()
{
    InvManager.CreateInventory(class'DualityGame.ParticleWeapon');
}


DefaultProperties
{
    // Player's health/mass
    Health=1000;
    HealthMax=1000;
	
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
		AnimSets(0)=AnimSet'Duality.Animations.TestAnimSet'
		AnimTreeTemplate=AnimTree'Duality.Animations.TestAnimTree'
		SkeletalMesh=SkeletalMesh'Duality.Meshes.CatFinal'
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