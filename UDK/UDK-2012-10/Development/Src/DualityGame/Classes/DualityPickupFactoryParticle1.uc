/**
 * Copyright 1998-2012 Epic Games, Inc. All Rights Reserved.
 */
class DualityPickupFactoryParticle1 extends DualityPickupFactory
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
    SetHidden(true);
	}
}

function GiveTo(Pawn P)
{
  local DualityPlayerController catPC;

  catPC= DualityPlayerController(P.controller);

  if (catPC != None) {
    catPC.handleParticlePickup(class<DualityInventoryItem> (InventoryType));
    pickedUpBy(P);
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

	Begin Object Class=StaticMeshComponent Name=HealthPickUpMesh
    StaticMesh=StaticMesh'Duality.Meshes.Neutron'
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
	PickupMesh=HealthPickUpMesh
	Components.Add(HealthPickUpMesh)

  //InventoryType=class'Duality.DualityParticle1'

}
