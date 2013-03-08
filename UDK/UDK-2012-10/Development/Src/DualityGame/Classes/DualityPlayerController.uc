class DualityPlayerController extends GamePlayerController;

//This event is triggered when play begins
simulated event PostBeginPlay() 
{
    super.PostBeginPlay();
}



//Functions for zooming in and out
exec function NextWeapon()
{
	  //Checks that the the value FreeCamDistance isn't further than we want the camera to go.
    if (PlayerCamera.FreeCamDistance < 768) {
		  PlayerCamera.FreeCamDistance += 64*(PlayerCamera.FreeCamDistance/256); 
	  }
}

exec function PrevWeapon()
{
	  // Checking if the distance is at our minimum distance
	  if (PlayerCamera.FreeCamDistance > 256) {
		  // Scaling the zoom for distance
		  PlayerCamera.FreeCamDistance -= 64*(PlayerCamera.FreeCamDistance/256);
	  }
}

DefaultProperties
{
	  CameraClass=class 'DualityPlayerCamera'
	  DefaultFOV=90.f
}