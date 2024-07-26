package entities.behaviour.attacks;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import magicEffects.BurningEffect;
import util.Hitbox;
import util.hitboxes.StickyHitbox;

class Punch
{
	public var fire = false;

	public function new() {}

	public function attack(angle = 0.0, power = 0.0, entity:LivingEntity)
	{
		if (power > 0.85)
		{
			var hitbox = new StickyHitbox();
			if (power > 1)
			{
				power = 1;
			}
			entity.punchCooldown = 0.2;
			hitbox.previousStickX = entity.x;
			hitbox.previousStickY = entity.y;
			hitbox.loadGraphic(AssetPaths.swoosh__png);
			hitbox.scale.set(1.4 * power, 1.4 * power);
			FlxTween.tween(hitbox, {"scale.x": 1 * power, "scale.y": 1 * power}, 0.1, {ease: FlxEase.sineOut});
			hitbox.alpha = 0.6;
			FlxTween.tween(hitbox, {alpha: 0.8}, 0.1);
			hitbox.angle = angle;
			hitbox.velocity.setPolarDegrees(850 * power, angle);
			hitbox.x = entity.getMidpoint().x - (hitbox.width / 2);
			hitbox.y = entity.getMidpoint().y - (hitbox.height / 2);
			hitbox.damage = 10 * power;
			if (fire)
			{
				hitbox.loadGraphic(AssetPaths.fireswoosh__png);
				hitbox.effectsWhenHit = [new BurningEffect(1, 5)];
			}

			PlayState.hitHitBox(hitbox, true, entity);
		}
	}
}