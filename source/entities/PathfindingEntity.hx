package entities;

import entities.behaviour.BasicPathfindingGoal;
import entities.behaviour.Goal;

class PathfindingEntity extends LivingEntity
{
	public var possibleTargets:Array<LivingEntity> = [];
	public var goals:Array<Goal> = [];
	public var currentGoal:Goal = null;
	public var target:LivingEntity = null;
	public var enemyDetectionRange:Float = 300;

	public function new(?x, ?y)
	{
		super(x, y);
		setupGoals();
		drag.x = drag.y = 2400;
	}

	public function setupGoals()
	{
		goals.push(new BasicPathfindingGoal(this));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (currentGoal == null)
		{
			for (goal in goals)
			{
				if (goal.takeOwnership())
				{
					currentGoal = goal;
					goal.goalSetup();
					break;
				}
			}
		}
		else
		{
			currentGoal.goalTick();
		}
	}
}