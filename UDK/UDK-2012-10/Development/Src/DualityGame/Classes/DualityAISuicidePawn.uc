class DualityAISuicidePawn extends DualityPawn
	placeable;

var ParticleSystem deathAnimation;

function AddDefaultInventory()
{
    //For those in the back who don't follow, SandboxPaintballGun is a custom weapon
    //I've made in an earlier article, don't look for it in your UDK build.
}

event PostBeginPlay()
{
    super.PostBeginPlay();
    AddDefaultInventory(); //GameInfo calls it only for players, so we have to do it ourselves for AI.
}

event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    super.TakeDamage(Damage,InstigatedBy, HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
    Health = FMax(Health-Damage,0);
    WorldInfo.Game.Broadcast(self,Name$": Health:"@Health);
}


DefaultProperties
{
    Begin Object Name=CollisionCylinder
        CollisionHeight=+44.000000
    End Object
 
    Begin Object Class=SkeletalMeshComponent Name=SandboxPawnSkeletalMesh
        SkeletalMesh=SkeletalMesh'Duality.Meshes.Isotope'
        AnimSets(0)=AnimSet'Duality.Animations.ISOTOPE_ATTACKING'
	AnimSets(1)=AnimSet'Duality.Animations.ISOTOPE_ATTACKING'
        AnimTreeTemplate=AnimTree'Duality.Animations.ANIM_ISOTOPE'
        deathAnimation='P_FX_VehicleDeathExplosion';
        HiddenGame=FALSE
        HiddenEditor=FALSE
    End Object
 
    Mesh=SandboxPawnSkeletalMesh
 
    Components.Add(SandboxPawnSkeletalMesh)
    ControllerClass=class'Duality.DualityAISuicideController'
    InventoryManagerClass=class'Duality.DualityInventoryManager'
 
    bJumpCapable=false
    bCanJump=false
 
    GroundSpeed=250.0 

}
