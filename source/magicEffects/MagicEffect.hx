package magicEffects;

import entities.LivingEntity;
import entities.player.PlayerEntity;

class MagicEffect
{
	public var level:Int = 0;
	public var time:Float = 0;
	public var name = "null";
	public var affectedPlayer:LivingEntity;

	public function new(levels, times)
	{
		level = levels;
		time = times;
	}

	public function apply(player:LivingEntity)
	{
		affectedPlayer = player;
		player.appliedEffects.set(name, this);
	}

	public function onRemoved()
	{
		affectedPlayer.appliedEffects.remove(name);
	}

	public function tick(elapsed:Float)
	{
		time -= elapsed;
		if (time <= 0)
		{
			onRemoved();
		}
	}
}