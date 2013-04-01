class DualityAIAllyPawn extends DualityPawn
	placeable;


function AddDefaultInventory()
{
    InvManager.CreateInventory(class'DualityGame.DualityWeaponAIAlly');
}

event PostBeginPlay()
{
    super.PostBeginPlay();
    AddDefaultInventory(); //GameInfo calls it only for players, so we have to do it ourselves for AI.
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
  super.postInitAnimTree(skelComp);
}

DefaultProperties
{
 
    Begin Object Class=SkeletalMeshComponent Name=SandboxPawnSkeletalMesh
        SkeletalMesh=SkeletalMesh'Duality.Meshes.Ally'
        AnimSets(0)=AnimSet'Duality_Animations.AnimSets.ALLY_ATTACKING'
 	    AnimSets(1)=AnimSet'Duality_Animations.AnimSets.ALLY_IDLE'
        AnimSets(2)=AnimSet'Duality_Animations.AnimSets.ALLY_DYING'
        AnimTreeTemplate=AnimTree'Duality_Animations.AnimTrees.ANIM_ALLY'
        HiddenGame=FALSE
        HiddenEditor=FALSE
    End Object
 
    Mesh=SandboxPawnSkeletalMesh
 
    Components.Add(SandboxPawnSkeletalMesh)
    ControllerClass=class'DualityGame.DualityAIAllyController'
    InventoryManagerClass=class'DualityGame.DualityInventoryManager'
 
    bJumpCapable=false
    bCanJump=false
 
    GroundSpeed=300.0 

}
