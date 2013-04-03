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
            Pawn.LockDesiredRotation(false);
            target = Seen;
            GotoState('Follow');
        }
      }
    }
Begin:
    waitForLanding();
    if (DualityPawn(pawn).freezeAI) {
        sleep(2.0);
        goto 'Begin';
    }
    if (pawn.health <= 0) {
        goto 'Died';
    }
    if (pawn.desiredRotation == Rot(0,0,0)) {
      Pawn.setdesiredRotation(Rot(0,32768,0),true,false,,);
    } else {
      Pawn.setdesiredRotation(Rot(0,0,0),true,false,,);
    }
    //`log("Enemy AI is rotating");
    sleep(2.0);
    Pawn.LockDesiredRotation(false);
    goto 'Begin';
Died:
        Pawn.ZeroMovementVariables();
    pawn.startfire(0);
    pawn.stopfire(0);
    DualityAISuicidePawn(Pawn).hide();
    Pawn.died(self,none,Vect(0,0,0));
    sleep(1);
    DualityPawn(pawn).hide();
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
            //class'NavMeshGoal_At'.static.AtActor( NavigationHandle, target,800 );
        }
        // Find path
        return NavigationHandle.FindPath();
    }
Begin:
    waitForLanding();
    if (pawn.health <= 0) {
        goto 'Died';
    }
    if (DualityPawn(pawn).freezeAI) {
        sleep(2.0);
        goto 'Begin';
    }
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
    if (pawn.isA('DualityAIShooterPawn')) {
      if (VSize(Pawn.Location - target.Location) <= 1200  || target.health <= 0)
      {
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
        GotoState('Kamikaze'); //Start shooting when close enough to the player.
      } 
      else
      {
        goto 'Begin';
      }
    }
Died:
        Pawn.ZeroMovementVariables();
    pawn.startfire(0);
    pawn.stopfire(0);
    DualityAISuicidePawn(Pawn).hide();
    Pawn.died(self,none,Vect(0,0,0));
    sleep(1);
    DualityPawn(pawn).hide();
}

state shoot
{
ignores seePlayer;
Begin:
    Pawn.ZeroMovementVariables();
    if (DualityPawn(pawn).freezeAI) {
        sleep(2.0);
        goto 'Begin';
    }
    if (pawn.health <= 0) {
        goto 'Died';
    }
    SetFocalPoint(target.Location);
    Focus = target;
    pawn.startfire(0);
    pawn.stopfire(0);
    target.takeDamage(2, self, vect(0,0,0), vect(0,0,0), None);
    if (vsize( Pawn.location - target.location) > 1200 || target.health <= 0) 
    {
      GotoState('Idle');
    }
    sleep(1);
    goto 'Begin';
Died:
      Pawn.ZeroMovementVariables();
    pawn.startfire(0);
    pawn.stopfire(0);
    DualityAISuicidePawn(Pawn).hide();
    Pawn.died(self,none,Vect(0,0,0));
    sleep(1);
    DualityPawn(pawn).hide();
}

state Kamikaze
{

Begin:
    if (DualityPawn(pawn).freezeAI) {
        sleep(2.0);
        goto 'Begin';
    }
    Pawn.ZeroMovementVariables();
    pawn.startfire(0);
    pawn.stopfire(0);
    DualityAISuicidePawn(Pawn).hide();
    Pawn.died(self,none,Vect(0,0,0));
    sleep(1);
    DualityPawn(pawn).hide();
}

DefaultProperties
{
bIsPlayer=true
}

