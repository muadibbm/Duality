class DualityPawn extends Pawn;


var AnimNodePlayCustomAnim deathAnim;
var bool freezeAI;

event PostBeginPlay()
{
  super.postBeginPlay();
  freezeAI = false;
}

function hide() {
    mesh.setHidden(true);
}


event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
  super.TakeDamage(Damage,InstigatedBy, HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
  Health = FMax(Health-Damage,0);
  //WorldInfo.Game.Broadcast(self,Name$": Health:"@Health);
  if (health <= 0) {
    if (deathAnim != none) {
      deathAnim.PlayCustomAnim('DIE',1.00f,,-1.f);
      self.died(InstigatedBy, DamageType, HitLocation);
      SetPhysics(PHYS_Falling);
    }
  }
}


simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
  super.postInitAnimTree(skelComp);
  if (skelComp == mesh) {
    deathAnim = AnimNodePlayCustomAnim(Mesh.FindAnimNode('Dying'));
  }
}

defaultproperties
{
  bCanPickUpInventory=false
}

