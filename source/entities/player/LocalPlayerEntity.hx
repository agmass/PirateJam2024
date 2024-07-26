package entities.player;

import entities.behaviour.attacks.Punch;
import flixel.FlxG;
import items.PotionItem;

class LocalPlayerEntity extends PlayerEntity
{
	override public function new(x, y)
	{
		super(x, y);
		for (i in 0...5)
		{
			inventory.addPotion(new PotionItem());
		}
	}


	override function update(elapsed:Float)
	{
		handleMovementInputs();
		if (FlxG.mouse.justPressed)
		{
			var Xdistance = FlxG.mouse.x - x;
			var Ydistance = FlxG.mouse.y - y;
			punch.attack(Math.atan2(Ydistance, Xdistance) * 180 / Math.PI, 1 - (punchCooldown * 2), this);
		}
		super.update(elapsed);
	}

	override function damage(damage:Float):Bool
	{
		if (damage > 0 && !invincible)
		{
			FlxG.camera.shake(0.0005 * damage, 0.1);
		}
		return super.damage(damage);
	}

	function handleMovementInputs()
	{
		var up:Bool = false;
		var down:Bool = false;
		var left:Bool = false;
		var right:Bool = false;
		up = FlxG.keys.anyPressed([UP, W]);
		down = FlxG.keys.anyPressed([DOWN, S]);
		left = FlxG.keys.anyPressed([LEFT, A]);
		right = FlxG.keys.anyPressed([RIGHT, D]);
		if (up && down)
			up = down = false;
		if (left && right)
			left = right = false;
		if (left)
		{
			flipX = true;
		}
		if (right)
		{
			flipX = false;
		}
		if (up || down || left || right)
		{
			var newAngle:Float = 0;
			if (up)
			{
				animation.play("forward");
				newAngle = -90;
				if (left)
					newAngle -= 45;
				else if (right)
					newAngle += 45;
			}
			else if (down)
			{
				animation.play("walk");
				newAngle = 90;
				if (left)
					newAngle += 45;
				else if (right)
					newAngle -= 45;
			}
			else if (left)
			{
				animation.play("sidestep");
				newAngle = 180;
			}
			else if (right)
			{
				animation.play("sidestep");
				newAngle = 0;
			}
			velocity.setPolarDegrees(getMovementSpeed(), newAngle);
		}
		else
		{
			animation.play("idle");
		}
	}
}