class DualityAIEnemyController extends DualityAIController;

event PostBeginPlay()
{
    super.PostBeginPlay();
    if ( NavigationHandle == None ) {
        InitNavigationHandle();
    }
}

event Possess(Pawn inPawn, bool bVehicleTransition)
{
    super.Possess(inPawn, bVehicleTransition);
    Pawn.SetMovementPhysics();
    pawn.LockDesiredRotation(False);
}

auto state Idle
{
    event SeePlayer (Pawn Seen)
    {
      super.SeePlayer(Seen);
      if (seen.controller.isA('DualityPlayerController') || seen.controller.isA('DualityAIAllyController')) {
        if (seen.health > 0) {
            `log("Enemy AI saw ally pawn");
            Pawn.LockDesiredRotation(false);
            target = Seen;
            GotoState('Follow');
        }
      }
    }
Begin:
    waitForLanding();
    if (pawn.desiredRotation == Rot(0,0,0)) {
      Pawn.setdesiredRotation(Rot(0,32768,0),true,false,,);
    } else {
      Pawn.setdesiredRotation(Rot(0,0,0),true,false,,);
    }
    //`log("Enemy AI is rotating");
    sleep(2.0);
    Pawn.LockDesiredRotation(false);
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
        class'NavMeshGoal_At'.static.AtActor( NavigationHandle, target,32 );
        if (pawn.isA('DualityAIShooterPawn')) {
            `log("Enemy AI is shooter");
            //class'NavMeshGoal_At'.static.AtActor( NavigationHandle, target,800 );
        } else {
            `log("Enemy AI is suicide");
        }
 
        // Find path
        return NavigationHandle.FindPath();
    }
Begin:
    waitForLanding();
    `log("Enemy AI is chasing ally pawn");
    if( NavigationHandle.ActorReachable( target) )
    {
        FlushPersistentDebugLines();
        `log("Enemy AI finds out target is reachable directly");
        //Direct move
        MoveToward( target,target );
    }
    else if( FindNavMeshPath() )
    {
        NavigationHandle.SetFinalDestination(target.Location);
        FlushPersistentDebugLines();
        `log("Enemy AI looks for path to target");
        // move to the first node on the path
        if( NavigationHandle.GetNextMoveLocation( TempDest, Pawn.GetCollisionRadius()) )
        { 
            MoveTo( TempDest, target );
        }
    }
    else
    {
        //We can't follow, so get the hell out of this state, otherwise we'll enter an infinite loop.
        `log("Enemy AI finds out target is unreachable");
        GotoState('Idle');
    }
    if (pawn.isA('DualityAIShooterPawn')) {
      if (VSize(Pawn.Location - target.Location) <= 1200  || target.health <= 0)
      {
        `log("Enemy shooter in range");
        pawn.zeromovementvariables();
        GotoState('shoot'); //Start shooting when close enough to the player.
      }
      else
      {
        
      goto 'Begin';
      }
    } else {
        if (VSize(Pawn.Location - target.Location) <= 256 || target.health <= 0)
      {
        `log("Enemy suicide in range");
        GotoState('Kamikaze'); //Start shooting when close enough to the player.
      } 
      else
      {
        goto 'Begin';
      }
    }
}

state shoot
{
ignores seePlayer;
Begin:
    Pawn.ZeroMovementVariables();
    SetFocalPoint(target.Location);
    Focus = target;
    pawn.startfire(0);
    pawn.stopfire(0);
    `log("Enemy shooter shooting player");
    if (vsize( Pawn.location - target.location) > 1200 || target.health <= 0) 
    {
      GotoState('Idle');
    }
    sleep(1);
    goto 'Begin';
}

state Kamikaze
{

Begin:
    Pawn.ZeroMovementVariables();
    pawn.startfire(0);
    pawn.stopfire(0);
    `log("Enemy suicide suiciding");
    DualityAISuicidePawn(Pawn).hide();
    Pawn.died(self,none,Vect(0,0,0));
    Sleep(1);
    GotoState('Idle');
}

DefaultProperties
{
bIsPlayer=true
}

