class DualityPawn extends Pawn;

event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
  super.TakeDamage(Damage,InstigatedBy, HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
}

defaultproperties
{
  bCanPickUpInventory=false

}

