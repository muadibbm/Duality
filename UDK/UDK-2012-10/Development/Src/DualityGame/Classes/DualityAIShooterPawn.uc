class DualityAIShooterPawn extends DualityPawn
	placeable;

var name weapSocket;

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
    	 AnimSets(3)=AnimSet'Duality.Animations.MOLE_JUMPING'
        AnimTreeTemplate=AnimTree'Duality.Animations.ANIM_MOLE'
        HiddenGame=FALSE
        HiddenEditor=FALSE
    End Object
 
    Mesh=SandboxPawnSkeletalMesh
 
    Components.Add(SandboxPawnSkeletalMesh)
    ControllerClass=class'DualityGame.DualityAIEnemyController'
    InventoryManagerClass=class'DualityGame.DualityInventoryManager'
 
    bJumpCapable=false
    bCanJump=false
 
    GroundSpeed=300.0 

}
