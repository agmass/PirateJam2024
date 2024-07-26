package magicEffects;

import entities.LivingEntity;
import entities.player.PlayerEntity;

class FireEffect extends MagicEffect
{
	override public function new(levels, times)
	{
		super(levels, times);
		name = "fire";
	}

	override function apply(player:LivingEntity)
	{
		super.apply(player);
		player.punch.fire = true;
	}

	override function onRemoved()
	{
		super.onRemoved();
		affectedPlayer.punch.fire = false;
	}
}