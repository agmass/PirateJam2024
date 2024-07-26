package entities.player;

import entities.behaviour.attacks.Punch;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import items.inventory.PlayerInventory;
import magicEffects.MagicEffect;
import util.Hitbox;

class PlayerEntity extends LivingEntity
{
	public var inventory:PlayerInventory = new PlayerInventory();
	public function new(x, y)
	{
		destroyOnDeath = false;
		super(x, y);
		loadGraphic(AssetPaths.playercharacter__png, true, 18, 32);
		drag.x = drag.y = 2400;
		animation.add("idle", [0], 8);
		animation.add("walk", [0, 1, 2, 3], 8);
		animation.add("sidestep", [5, 6, 7, 8, 9, 10, 11, 12, 13, 14], 14);
		animation.add("forward", [16, 17, 18, 19], 8);
	}

}