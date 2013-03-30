class DualityAISuicidePawn extends DualityPawn
	placeable;

function AddDefaultInventory()
{
  
}

event PostBeginPlay()
{
    super.PostBeginPlay();
    AddDefaultInventory(); //GameInfo calls it only for players, so we have to do it ourselves for AI.
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
  super.postInitAnimTree(skelComp);
  if (skelComp == mesh) {
    deathAnim = AnimNodePlayCustomAnim(Mesh.FindAnimNode('dying'));
  }
}


DefaultProperties
{
    Begin Object Name=CollisionCylinder
        CollisionHeight=+44.000000
    End Object
 
    Begin Object Class=SkeletalMeshComponent Name=SandboxPawnSkeletalMesh
        SkeletalMesh=SkeletalMesh'Duality.Meshes.Isotope'
        AnimSets(0)=AnimSet'Duality_Animations.AnimSets.ISOTOPE_ATTACKING'
      	AnimSets(1)=AnimSet'Duality_Animations.AnimSets.ISOTOPE_DYING'
        AnimTreeTemplate=AnimTree'Duality_Animations.AnimTrees.ANIM_ISOTOPE'
        HiddenGame=FALSE
        HiddenEditor=FALSE
    End Object
 
    Mesh=SandboxPawnSkeletalMesh
 
    Components.Add(SandboxPawnSkeletalMesh)
    ControllerClass=class'DualityGame.DualityAIEnemyController'
    InventoryManagerClass=class'DualityGame.DualityInventoryManager'
 
    bJumpCapable=false
    bCanJump=false
 
    GroundSpeed=250.0 

}
