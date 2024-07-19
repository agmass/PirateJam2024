package util;

import entities.LivingEntity;
import flixel.FlxG;
import flixel.FlxSprite;

class Hitbox extends FlxSprite {
	public var damage = 10;
	public var decay = 1.0;
	public var decayWhenStill = true;
	public var possibleTargets:Array<LivingEntity> = [];
	public var shooter:LivingEntity;

    public function new(?x,?y,?a) {
		super(x, y, a);
		drag.x = drag.y = 2000;
    }

    override function update(elapsed:Float) {
        decay -= elapsed;
        for (entity in possibleTargets) {
            if (shooter==entity) {
                possibleTargets.remove(entity);
                continue;
            }
            if (entity.overlaps(this)) {
                possibleTargets.remove(entity);
				entity.damage(damage);
				trace(entity.health);
            }
        }
		super.update(elapsed);
		if (decay < 0 || (decayWhenStill && velocity.x == 0 && velocity.y == 0)) {
            FlxG.state.remove(this);
            destroy();
        }
    }
}