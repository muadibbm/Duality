class DualityAIShooterPawn extends DualityPawn
	placeable;


var ParticleSystem deathAnimation;

function AddDefaultInventory()
{
    //For those in the back who don't follow, SandboxPaintballGun is a custom weapon
    //I've made in an earlier article, don't look for it in your UDK build.
    InvManager.CreateInventory(class'Duality.DualityShockRifle');
}



event PostBeginPlay()
{
    super.PostBeginPlay();
    AddDefaultInventory(); //GameInfo calls it only for players, so we have to do it ourselves for AI.
}

DefaultProperties
{
    Begin Object Name=CollisionCylinder
        CollisionHeight=+44.000000
    End Object
 
    Begin Object Class=SkeletalMeshComponent Name=SandboxPawnSkeletalMesh
        SkeletalMesh=SkeletalMesh'Duality.Meshes.Mole'
        AnimSets(0)=AnimSet'Duality.Animations.MOLE_WALKING'
     	AnimSets(1)=AnimSet'Duality.Animations.MOLE_IDLE'
     	AnimSets(2)=AnimSet'Duality.Animations.MOLE_DYING'
    	 AnimSets(3)=AnimSet'Duality.Animations.MOLE_JUMP'
        AnimTreeTemplate=AnimTree'Duality.Animations.ANIM_MOLE'
        deathAnimation='P_FX_VehicleDeathExplosion';
        HiddenGame=FALSE
        HiddenEditor=FALSE
    End Object
 
    Mesh=SandboxPawnSkeletalMesh
 
    Components.Add(SandboxPawnSkeletalMesh)
    ControllerClass=class'Duality.DualityAIShooterController'
    InventoryManagerClass=class'Duality.DualityInventoryManager'
 
    bJumpCapable=false
    bCanJump=false
 
    GroundSpeed=300.0 

}
