package entities.enemies;

import entities.behaviour.attacks.Punch;
import flixel.util.FlxColor;
import js.html.svg.MarkerElement;

class TestingEnemy extends PathfindingEntity
{
	public function new(?x, ?y)
	{
		super(x, y);
		movementSpeed = 400;
		makeGraphic(32, 32, FlxColor.RED);
	}

	override function update(elapsed:Float)
	{
		if (punchCooldown <= 0.25)
		{
			movementModifications.remove("punch");
		}
		if (punchCooldown <= 0)
		{
			if (target != null)
			{
				if (target.getPosition().distanceTo(getPosition()) <= 100)
				{
					var Xdistance = target.x - x;
					var Ydistance = target.y - y;
					movementModifications.set("punch", -400);
					Punch.attack(Math.atan2(Ydistance, Xdistance) * 180 / Math.PI, 1, this);
					punchCooldown = 0.8;
				}
			}
		}
		super.update(elapsed);
	}
}