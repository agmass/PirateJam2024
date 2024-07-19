package entities;

import flixel.FlxSprite;

class LivingEntity extends FlxSprite {

    public var health = 0.0;
    public var movementSpeed = 500;
    public var movementModifications:Map<String, Int> = new Map();
    
    public var invincible = false;


    public function death() {
        alive = false;
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