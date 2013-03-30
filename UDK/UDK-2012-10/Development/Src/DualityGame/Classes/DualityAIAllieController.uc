class DualityAIAllieController extends DualityAIController;

event PostBeginPlay()
{
    super.PostBeginPlay();
    NavigationHandle = new(self) class'NavigationHandle';
}

event Possess(Pawn inPawn, bool bVehicleTransition)
{
    super.Possess(inPawn, bVehicleTransition);
    Pawn.SetMovementPhysics();
}

auto state Idle
{
    event SeePlayer (Pawn Seen)
    {
        super.SeePlayer(Seen);
        if (seen.controller.isA('DualityAIEnemyController')) {
          target = Seen;
          GotoState('Follow');
        }
    }
Begin:
    waitForLanding();

DoneWandering:
    sleep(0.5);
    goto 'Begin';
}
 
state Follow
{
    ignores SeePlayer;
    function bool FindNavMeshPath()
    {
        // Clear cache and constraints (ignore recycling for the moment)
        NavigationHandle.PathConstraintList = none;
        NavigationHandle.PathGoalList = none;
 
        // Create constraints
        class'NavMeshPath_Toward'.static.TowardGoal( NavigationHandle,target );
        class'NavMeshGoal_At'.static.AtActor( NavigationHandle, target,800);
 
        // Find path
        return NavigationHandle.FindPath();
    }
Begin:
 
    if( NavigationHandle.ActorReachable( target) )
    {
        FlushPersistentDebugLines();
 
        //Direct move
        MoveToward( target,target );
    }
    else if( FindNavMeshPath() )
    {
        NavigationHandle.SetFinalDestination(target.Location);
        FlushPersistentDebugLines();
 
        // move to the first node on the path
        if( NavigationHandle.GetNextMoveLocation( TempDest, Pawn.GetCollisionRadius()) )
        {
            MoveTo( TempDest, target );
        }
    }
    else
    {
        //We can't follow, so get the hell out of this state, otherwise we'll enter an infinite loop.
        GotoState('Idle');
    }
    if (VSize(Pawn.Location - target.Location) <= 800)
    {
      pawn.zeromovementvariables();
      GotoState('shoot'); //Start shooting when close enough to the player.
    }
    else
    {
      goto 'Begin';
    }
}

state shoot
{
ignores seePlayer;
Begin:
    pawn.zeromovementvariables();
    sleep(1);
    pawn.startfire(0);
    pawn.stopfire(0);
    target.TakeDamage(4, self, vect(0,0,0), vect(0,0,0), None);
    if (vsize( Pawn.location - target.location) > 800  || target.health <= 0) 
    {
      GotoState('Idle');
    }
    goto 'Begin';
}


DefaultProperties
{
bIsPlayer=true
}

