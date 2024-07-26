package map.decorations;

import entities.LivingEntity;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import items.DroppedItem;
import items.PotionItem;

class Chest extends LivingEntity
{
	override public function new(x, y)
	{
		super(x, y);
		loadGraphic(AssetPaths.chest__png, true, 32, 32);
		animation.add("open", [1], 10);
	}

	override function damage(damage:Float):Bool
	{
		animation.play("open");
		if (Std.isOfType(FlxG.state, PlayState) && alive)
		{
			var ps:PlayState = cast FlxG.state;
			var droppedItem = new DroppedItem(x, y, new PotionItem());
			ps.droppedItems.add(droppedItem);
			alive = false;
			allowCollisions = NONE;
			FlxTween.tween(this, {alpha: 0}, 0.25, {
				onComplete: (t) ->
				{
					if (destroyOnDeath)
					{
						ps.chests.remove(this);
						destroy();
					}
				}
			});
		}
		return false;
	}
}