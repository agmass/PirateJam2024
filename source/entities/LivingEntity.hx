package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import util.Hitbox;

class LivingEntity extends FlxSprite {

	public var health = 100.0;
    public var movementSpeed = 500;
    public var movementModifications:Map<String, Int> = new Map();
    
	public var invincible = false;
	public var destroyOnDeath = true;


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

    public function damage(damage:Float):Bool {
        if (invincible) {
            return false;
        } else {
            health -= damage;

            if (health <= 0) {
                death();
            }
            return true;
        }
    }
}