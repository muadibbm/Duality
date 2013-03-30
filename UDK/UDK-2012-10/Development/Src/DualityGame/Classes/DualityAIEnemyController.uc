class DualityAIEnemyController extends DualityAIController;

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
      if (seen.controller.isA('DualityPlayerController') || seen.controller.isA('DualityAIAllieController')) {
        Pawn.LockDesiredRotation(false);
        target = Seen;
        GotoState('Follow');
      }
    }
Begin:
    waitForLanding();
DoneWandering:
    if (pawn.desiredRotation == Rot(0,0,0)) {
      Pawn.setdesiredRotation(Rot(0,32768,0),true,false,,);
    } else {
      Pawn.setdesiredRotation(Rot(0,0,0),true,false,,);
    }
    sleep(2.0 + rand(1.0));
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
        if (pawn.isA('DualityAIShooterPawn')) {
        class'NavMeshGoal_At'.static.AtActor( NavigationHandle, target,800 );
        } else {
        class'NavMeshGoal_At'.static.AtActor( NavigationHandle, target,128 );
        }
 
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
        //NavigationHandle.DrawPathCache(,TRUE);
 
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
      if (VSize(Pawn.Location - target.Location) <= 800  || target.health <= 0)
      {
        pawn.zeromovementvariables();
        GotoState('shoot'); //Start shooting when close enough to the player.
      }
      else
      {
      goto 'Begin';
      }
    } else {
        if (VSize(Pawn.Location - target.Location) <= 128  || target.health <= 0)
      {
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
    pawn.zeromovementvariables();
    sleep(1);
    pawn.startfire(0);
    pawn.stopfire(0);
    target.TakeDamage(4, self, vect(0,0,0), vect(0,0,0), None);
    if (vsize( Pawn.location - target.location) > 800 || target.health <= 0) 
    {
      GotoState('Idle');
    }
    goto 'Begin';
}

state Kamikaze
{

Begin:
    Pawn.ZeroMovementVariables();
    Sleep(1); //Give the pawn the time to stop.
    target.TakeDamage(400, self, vect(0,0,0), vect(0,0,0), None);
    pawn.takedamage(pawn.health, self, vect(0,0,0), vect(0,0,0), None);
 //   SpawnExplosionParticleSystem(DualityAIPawn(pawn).deathAnimation);
    GotoState('Idle');
}

DefaultProperties
{
bIsPlayer=true
}

