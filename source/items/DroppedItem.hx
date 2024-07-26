package items;

import entities.player.PlayerEntity;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class DroppedItem extends FlxSprite
{
	public var item:Item;

	var plr:PlayerEntity;
	var twn:FlxTween;

	var lifespan = 0.0;

	override public function new(x, y, items)
	{
		super(x, y);
		item = items;
		loadGraphic(AssetPaths.itemsheet__png, true, 64, 64);
		animation.add("1", [item.referenceSpriteID]);
		animation.play("1");
		scale.set(0.35, 0.35);
		shader = item.inventoryShaders;
		angle = FlxG.random.int(0, 360);
		drag.x = drag.y = 1000;
		velocity.setPolarDegrees(350, FlxG.random.int(0, 360));
	}

	override function update(elapsed:Float)
	{
		lifespan += elapsed;
		if (Std.isOfType(FlxG.state, PlayState) && alive && lifespan >= 0.20)
		{
			var ps:PlayState = cast FlxG.state;
			ps.forEachOfType(PlayerEntity, (pe) ->
			{
				if (pe.getPosition().distanceTo(getPosition()) <= 32)
				{
					plr = pe;
					alive = false;
					pe.inventory.addPotion(item);
					ps.droppedItems.remove(this);
					destroy();
				}
			});
		}
		if (alive)
			super.update(elapsed);
	}
}