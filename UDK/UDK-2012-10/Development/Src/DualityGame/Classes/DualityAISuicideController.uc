class DualityAISuicideController extends AIController;

var Actor target;
var() Vector TempDest;

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
        target = Seen;
 
        GotoState('Follow');
    }
Begin:
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
            //DrawDebugLine(Pawn.Location,TempDest,255,0,0,true);
            //DrawDebugSphere(TempDest,16,20,255,0,0,true);
 
            MoveTo( TempDest, target );
        }
    }
    else
    {
        //We can't follow, so get the hell out of this state, otherwise we'll enter an infinite loop.
        GotoState('Idle');
    }
    if (VSize(Pawn.Location - target.Location) <= 128)
    {
      GotoState('Kamikaze'); //Start shooting when close enough to the player.
    }
    else
    {
    goto 'Begin';
    }
}

state Kamikaze
{

Begin:
    Pawn.ZeroMovementVariables();
    Sleep(1); //Give the pawn the time to stop.
    target.TakeDamage(400, self, vect(0,0,0), vect(0,0,0), None);
    pawn.Died(self, None, vect(0,0,0));
 //   SpawnExplosionParticleSystem(DualityAIPawn(pawn).deathAnimation);
    GotoState('Idle');
}

DefaultProperties
{
}

