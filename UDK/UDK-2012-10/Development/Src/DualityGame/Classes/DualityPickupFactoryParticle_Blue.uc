class DualityPickupFactoryParticle_Blue extends DualityPickupFactory
placeable;


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

}

auto state Pickup {

  	event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
	{
    super.Touch(Other, OtherComp, HitLocation, HitNormal);
  
	}
}

function GiveTo(Pawn P)
{
  if (P.controller.isA('DualityPlayerController')) {
    if (DualityPlayerPawn(P).handleBlueParticlePickup()) {
	  pickedUpBy(P);
      SetHidden(true);
  	}
  } else {
  	`log("Should never happen");
  }
}



defaultproperties
{
	bPredictRespawns=false
	bIsSuperItem=false
	RespawnTime=30.000000
	MaxDesireability=0.700000

	bRotatingPickup=true
	YawRotationRate=16384

	bFloatingPickup=true
	bRandomStart=true
	BobSpeed=1.0
	BobOffset=5.0

 

	Begin Object Class=StaticMeshComponent Name=BluePickUpMesh
    	StaticMesh=StaticMesh'Duality.Meshes.PS_BLUE'
	 	CastShadow=FALSE
		bCastDynamicShadow=FALSE
		bAcceptsLights=TRUE
		bForceDirectLightMap=TRUE
		LightEnvironment=PickupLightEnvironment

		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true

		CollideActors=true
		BlockActors=false
		BlockRigidBody=false

		MaxDrawDistance=4500
	End Object
	
	
	PickupMesh=BluePickUpMesh
	Components.Add(BluePickUpMesh)


}
