class DualityPickupFactoryParticle_Purple extends DualityPickupFactory
placeable;


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

}

auto state Pickup {

  	event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
	{
    super.Touch(Other, OtherComp, HitLocation, HitNormal);
    `log("On touch!!" );
	}
}

function GiveTo(Pawn P)
{
  local DualityPlayerController catPC;
  catPC= DualityPlayerController(P.controller);
  `log("GiveTo");
  if (P.controller.isA('DualityPlayerController')) {
    if (DualityPlayerPawn(P).handlePurpleParticlePickup()) {
	  pickedUpBy(P);
      `log("Not None");
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

 

	Begin Object Class=StaticMeshComponent Name=PurplePickUpMesh
    	StaticMesh=StaticMesh'Duality.Meshes.PS_PURPLE'
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
	
	
	PickupMesh=PurplePickUpMesh
	Components.Add(PurplePickUpMesh)


}