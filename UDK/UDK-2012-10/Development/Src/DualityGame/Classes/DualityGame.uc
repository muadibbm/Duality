class DualityGame extends FrameworkGame;

//These are the properties for the game
defaultproperties
{
  PlayerControllerClass=class'DualityGame.DualityPlayerController'
  DefaultPawnClass=class'DualityGame.DualityPlayerPawn'
  HUDType=class'DualityGame.DualityHUD'
  bDelayedStart=false
}