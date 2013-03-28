class DualityPlayerController extends GamePlayerController;

var CameraAnimInst CameraAnimPlayer;
var bool bParticle1TimerOn;

function HandleParticlePickup(class <DualityInventoryItem> inv) {
  Pawn.Groundspeed = Pawn.GroundSpeed/2.00;

  if (!bParticle1TimerON) {
    SetTimer(10.0,false, 'ParticlePickupTimer');
    bParticle1TimerOn=true;
  }
}

function ParticlePickupTimer () {
  Pawn.GroundSpeed=Pawn.GroundSpeed*2.00;
  bParticle1TimerOn=true;
}

DefaultProperties
{
	CameraClass=class'DualityGame.DualityPlayerCamera'
}