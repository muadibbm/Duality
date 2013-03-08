class DualityPlayerCamera extends Camera;

// Initializing static variables
var float Dist;

DefaultProperties
{
	  // Set initial FreeCam distance
	  FreeCamDistance=256.f
}

function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime)
{
	  // Declare local variables
	  local vector Loc, Pos, HitLocation, HitNormal;
	  local rotator Rot;
	  local Actor HitActor;
	  local CameraActor CamActor;
	  local bool bDoNotApplyModifiers;
	  local TPOV OrigPOV;

	  // Store previous POV
	  OrigPOV = OutVT.POV;

	  // Default FOV on viewtarget
	  OutVT.POV.FOV = DefaultFOV;

	  // Viewing through a camera actor.
	  CamActor = CameraActor(OutVT.Target);
      if( CamActor != None ) {
		  CamActor.GetCameraView(DeltaTime, OutVT.POV);
		  // Grab aspect ratio from the CameraActor.
		  bConstrainAspectRatio = bConstrainAspectRatio || CamActor.bConstrainAspectRatio;
		  OutVT.AspectRatio = CamActor.AspectRatio;

		  // See if the CameraActor wants to override the PostProcess settings used.
		  CamOverridePostProcessAlpha = CamActor.CamOverridePostProcessAlpha;
		  CamPostProcessSettings = CamActor.CamOverridePostProcess;
	  } else {
		  // Give Pawn Viewtarget a chance to dictate the camera position.
		  // If Pawn doesn't override the camera view, then we proceed with our own defaults
          if( Pawn(OutVT.Target) == None || !Pawn(OutVT.Target).CalcCamera(DeltaTime, OutVT.POV.Location, OutVT.POV.Rotation, OutVT.POV.FOV)) {
			  // Don't apply modifiers when using these debug camera modes. 
			  bDoNotApplyModifiers = true;
			  switch(CameraStyle) {
				  case 'Fixed' : // No update, keeps previous view
					  OutVT.POV = OrigPOV;
					  break;
				  // Enters here as long as CameraStyle is still set to ThirdPerson
				  case 'ThirdPerson' : 
				  case 'FreeCam' :
					  // Setting the camera location and rotation to the viewtarget's
					  Loc = OutVT.Target.Location; 
					  Rot = OutVT.Target.Rotation;

                      if (CameraStyle == 'ThirdPerson') {
						  // Setting the rotation of the camera to the rotation of the pawn
						  Rot = PCOwner.Rotation; 
					  }

					  // OutVT.Target.GetActorEyesViewPoint(Loc, Rot);
                      if(CameraStyle == 'FreeCam') {
						  Rot = PCOwner.Rotation;
					  }
					  Loc += FreeCamOffset >> Rot;
					
					  // Linear interpolation algorithm. This is the "smoothing," so the camera doesn't jump between zoom levels
                      if (Dist != FreeCamDistance) {
						  // Increment Dist towards FreeCamDistance, which is where you want your camera to be.
						  // Increments a percentage of the distance between them according to the third term, in this case, 0.15 or 15%
						  Dist = Lerp(Dist,FreeCamDistance,0.15); 
					  }
					
					  Pos = Loc - Vector(Rot) * Dist; 
					  // @fixme, respect BlockingVolume.bBlockCamera=false
					

					  // This determines if the camera will pass through a mesh by tracing a path to the view target.
					  HitActor = Trace(HitLocation, HitNormal, Pos, Loc, FALSE, vect(12,12,12));

					  // This is where the location and rotation of the camera are actually set
					  OutVT.POV.Location = (HitActor == None) ? Pos : HitLocation;
					  OutVT.POV.Rotation = Rot;
					  break;
				  // Simple first person, view through viewtarget's 'eyes'
				  case 'FirstPerson' : 
					  default : OutVT.Target.GetActorEyesViewPoint(OutVT.POV.Location, OutVT.POV.Rotation);
					  break;

			  }
		  }
	  }

      if( !bDoNotApplyModifiers ) {
		  // Apply camera modifiers at the end (view shakes for example)
		  ApplyCameraModifiers(DeltaTime, OutVT.POV);
	  }
	  //`log( WorldInfo.TimeSeconds  @ GetFuncName() @ OutVT.Target @ OutVT.POV.Location @ OutVT.POV.Rotation @ OutVT.POV.FOV );
}