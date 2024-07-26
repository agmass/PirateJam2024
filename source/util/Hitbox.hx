package util;

import entities.LivingEntity;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import magicEffects.MagicEffect;

class Hitbox extends FlxSprite {
	public var damage = 10.0;
	public var decay = 1.0;
	public var decayWhenStill = true;
	public var possibleTargets:Array<LivingEntity> = [];
	public var effectsWhenHit:Array<MagicEffect> = [];
	public var shooter:LivingEntity;

    public function new(?x,?y,?a) {
		super(x, y, a);
		drag.x = drag.y = 4000;
    }

    override function update(elapsed:Float) {
		if (alive)
		{
			decay -= elapsed;
			for (entity in possibleTargets)
			{
				if (shooter == entity)
				{
					possibleTargets.remove(entity);
					continue;
				}
				if (entity.overlaps(this))
				{
					possibleTargets.remove(entity);
					for (effect in effectsWhenHit)
					{
						effect.apply(entity);
					}
					entity.damage(damage);
					trace(entity.health);
				}
			}
			super.update(elapsed);
			if (decay < 0 || (decayWhenStill && Math.abs(velocity.x) <= 350 && Math.abs(velocity.y) <= 350))
			{
				alive = false;

				FlxTween.tween(this, {alpha: 0}, 0.05, {
					onComplete: (t) ->
					{
						FlxG.state.remove(this);
						destroy();
					}
				});
			}
		}
    }
}