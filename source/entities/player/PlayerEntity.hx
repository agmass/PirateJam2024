package entities.player;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import util.Hitbox;

class PlayerEntity extends LivingEntity
{
	public function new(x, y)
	{
		destroyOnDeath = false;
		super(x, y);
		makeGraphic(32, 32, FlxColor.BLUE);
		drag.x = drag.y = 2400;
	}
}