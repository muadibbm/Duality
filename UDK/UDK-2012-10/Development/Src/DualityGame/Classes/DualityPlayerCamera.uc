class DualityPlayerCamera extends GamePlayerCamera;

protected function GameCameraBase FindBestCameraType( Actor CameraTarget )
{
  return ThirdPersonCam;
}
 
DefaultProperties
{
  ThirdPersonCameraClass=class'DualityGame.DualityThirdPersonCamera'
}