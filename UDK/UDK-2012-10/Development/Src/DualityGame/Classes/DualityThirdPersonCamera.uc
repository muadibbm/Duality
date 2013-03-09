class DualityThirdPersonCamera extends GameCameraBase;

var float ThirdPersonCamOffsetX;
var float ThirdPersonCamOffsetY;
var float ThirdPersonCamOffsetZ;
var Rotator CurrentCamOrientation;
var Rotator DesiredCamOrientation;
 
function UpdateCamera( Pawn P, GamePlayerCamera CameraActor, float DeltaTime, out TViewTarget OutVT )
{
  local float Radius, Height;
  local vector X,Y,Z,Pos,Loc,HitLocation,HitNormal;
  local Actor HitActor;
 
  // We will be working with coordinates in pawn space, but rotated according to the Desired Rotation.
  P.GetAxes(DesiredCamOrientation,X,Y,Z); 
  //Get the pawn's height as a base for the Z offset.
  P.GetBoundingCylinder(Radius, Height); 

  // Set camera location according to offsets
  Pos = P.Location + ThirdPersonCamOffsetX * X + ThirdPersonCamOffsetY * Y + (Height+ThirdPersonCamOffsetZ) * Z; 
  OutVT.POV.Location = Pos;

  Loc = OutVT.Target.Location;
  // This determines if the camera will pass through a mesh by tracing a path to the view target.
	HitActor = CameraActor.Trace(HitLocation, HitNormal, Pos, Loc, FALSE, vect(12,12,12)); 

	// This is where the location and rotation of the camera are actually set
  if ( DesiredCamOrientation != CurrentCamOrientation )
  {
    CurrentCamOrientation = RInterpTo(CurrentCamOrientation,DesiredCamOrientation,DeltaTime,100);
  }
  OutVT.POV.Location = (HitActor == None) ? Pos : HitLocation;
  OutVT.POV.Rotation = CurrentCamOrientation;
}
 
function ProcessViewRotation( float DeltaTime, Actor ViewTarget, out Rotator out_ViewRotation, out Rotator out_DeltaRot )
{
  DesiredCamOrientation = out_ViewRotation + out_DeltaRot;
}
 
DefaultProperties
{
  ThirdPersonCamOffsetX=-220.0
  ThirdPersonCamOffsetY=0.0
  ThirdPersonCamOffsetZ=-17.0
}