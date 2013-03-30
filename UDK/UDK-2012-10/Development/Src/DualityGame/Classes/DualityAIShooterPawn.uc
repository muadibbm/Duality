class DualityAIShooterPawn extends DualityPawn
	placeable;

var name weapSocket;

function AddDefaultInventory()
{


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
        AnimSets(0)=AnimSet'Duality_Animations.AnimSets.MOLE_WALKING'
     	AnimSets(1)=AnimSet'Duality_Animations.AnimSets.MOLE_IDLE'
     	AnimSets(2)=AnimSet'Duality_Animations.AnimSets.MOLE_DYING'
    	 AnimSets(3)=AnimSet'Duality_Animations.AnimSets.MOLE_JUMPING'
        AnimTreeTemplate=AnimTree'Duality_Animations.AnimTrees.ANIM_MOLE'
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
