package magicEffects;

import entities.LivingEntity;
import flixel.util.FlxColor;
import shaders.Outline;

class BurningEffect extends MagicEffect
{
	override public function new(levels, times)
	{
		super(levels, times);
		name = "burning";
	}

	var buildup = 0.0;

	override function apply(player:LivingEntity)
	{
		super.apply(player);
		affectedPlayer.shader = new Outline(FlxColor.ORANGE, 2, 2);
	}

	override function onRemoved()
	{
		if (affectedPlayer != null)
			affectedPlayer.shader = null;
		super.onRemoved();
	}

	override function tick(elapsed:Float)
	{
		super.tick(elapsed);
		buildup += elapsed;
		if (buildup >= 0.3)
		{
			affectedPlayer.damage(5 * level);
		}
	}
}