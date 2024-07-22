package entities.behaviour;

import flixel.path.FlxPath;
import flixel.tile.FlxTilemap;

class BasicPathfindingGoal extends Goal
{
	var tilemap:FlxTilemap = PlayState.getTilemap();

	override function goalSetup()
	{
		entity.path = new FlxPath();
		super.goalSetup();
	}

	override function goalTick()
	{
		if (entity.target != null)
		{
			var pathpoints = tilemap.findPath(entity.getMidpoint(), entity.target.getMidpoint());
			if (pathpoints != null)
			{
				entity.path.start(pathpoints, entity.getMovementSpeed(), FORWARD, false, true);
			}
		}
		else
		{
			entity.currentGoal = null;
		}
		super.goalTick();
	}

	override public function takeOwnership():Bool
	{
		if (entity.target == null)
			return findTargets();
		return false;
	}

	override public function findTargets():Bool
	{
		for (possibleTarget in entity.possibleTargets)
		{
			if (entity.getMidpoint().distanceTo(possibleTarget.getMidpoint()) <= entity.enemyDetectionRange)
			{
				entity.target = possibleTarget;
				return true;
			}
		}
		return false;
	}
}