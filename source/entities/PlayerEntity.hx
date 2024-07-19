package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import util.Hitbox;

class PlayerEntity extends LivingEntity {
    public function new(x,y) {
        super(x,y);
        makeGraphic(32,32,FlxColor.BLUE);
        drag.x = drag.y = 2400;
    }
    public function attack(angle=0.0, power=0.0) {
        var hitbox = new Hitbox();
		hitbox.makeGraphic(64, 64);
		hitbox.velocity.setPolarDegrees(400, angle);
		hitbox.x = getMidpoint().x-(hitbox.width/2);
		hitbox.y = getMidpoint().y - (hitbox.height / 2);
        PlayState.hitHitBox(hitbox, true);
        
    }
}