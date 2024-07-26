package entities;

import entities.behaviour.attacks.Punch;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import haxe.rtti.CType.Abstractdef;
import magicEffects.MagicEffect;
import util.Hitbox;
class LivingEntity extends FlxSprite
{

	public var health = 100.0;
	public var maxHealth = 100.0;
	public var movementSpeed = 350;
    public var movementModifications:Map<String, Int> = new Map();
	public var punchCooldown = 1.0;
	public var invincible = false;
	public var appliedEffects:Map<String, MagicEffect> = [];
	public var destroyOnDeath = true;
	public var punch = new Punch();
	public var healthBar:FlxBar = new FlxBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT);

	override public function new(?x, ?y)
	{
		super(x, y);
		healthBar.createFilledBar(FlxColor.BLACK, FlxColor.RED, true);
	}

    public function death() {
        alive = false;
		if (destroyOnDeath)
		{
			FlxG.state.remove(this);
			destroy();
		}
	}

	public function getMovementSpeed():Int
	{
		var finalSpeed = movementSpeed;
		for (i in movementModifications)
		{
			finalSpeed += i;
		}
		return finalSpeed;
    }

	override function update(elapsed:Float)
	{
		healthBar.value = health;
		healthBar.setRange(0, maxHealth);
		punchCooldown -= elapsed;
		super.update(elapsed);
		healthBar.x = x - ((healthBar.width - width) / 2);
		healthBar.y = y - 24;
		for (effect in appliedEffects)
		{
			effect.tick(elapsed);
		}
	}

    public function damage(damage:Float):Bool {
        if (invincible) {
            return false;
		}
		else
		{
			var singleBlood = new FlxSprite(0, 0);
			singleBlood.loadGraphic(AssetPaths.bloodpng__png, true, 16, 8);
			singleBlood.animation.add("1", [FlxG.random.int(0, 2)]);
			singleBlood.animation.play("1");
			singleBlood.x = getMidpoint().x;
			singleBlood.y = getMidpoint().y;
			singleBlood.offset.x = 4;
			singleBlood.offset.y = 4;
			singleBlood.setSize(7, 4);
			singleBlood.drag.x = singleBlood.drag.y = 600;
			singleBlood.velocity.setPolarDegrees(150, FlxG.random.int(0, 360));
			PlayState.getBlood().add(singleBlood);
            health -= damage;

            if (health <= 0) {
                death();
            }
            return true;
        }
	}
	public function hasStatusEffect(name:String):Bool
	{
		return appliedEffects.exists(name);
	}
}