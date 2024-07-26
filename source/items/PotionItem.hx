package items;

import entities.player.PlayerEntity;
import flixel.FlxG;
import flixel.util.FlxColor;
import magicEffects.FireEffect;
import magicEffects.MagicEffect;
import shaders.ColoredItemShader;

class PotionItem extends Item
{
	public var effects:Array<MagicEffect> = [new FireEffect(0, 10)];

	public function new()
	{
		super();
		referenceSpriteID = 1;
		inventoryShaders = new ColoredItemShader(FlxColor.fromHSL(FlxG.random.int(0, 360), FlxG.random.float(0, 1), FlxG.random.float(0, 1)));
	}

	override function use(player:PlayerEntity)
	{
		if (Std.isOfType(FlxG.state, PlayState))
		{
			for (effect in effects)
			{
				effect.apply(player);
			}
			player.inventory.removeItem(this);
		}
		super.use(player);
	}
}