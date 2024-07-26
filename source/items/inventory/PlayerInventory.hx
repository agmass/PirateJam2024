package items.inventory;

import flixel.FlxG;
import flixel.tweens.FlxTween;
import ui.SlotUI;

class PlayerInventory
{
	public var potions:Array<Item> = [];

	public function new() {}

	public function removeItem(potionItem:Item)
	{
		potions.remove(potionItem);
		if (Std.isOfType(FlxG.state, PlayState))
		{
			var state:PlayState = cast FlxG.state;
			state.slotsRight.forEachOfType(SlotUI, (sui) ->
			{
				if (sui.refItem == potionItem)
				{
					FlxTween.completeTweensOf(sui);
					state.slotsRight.remove(sui);
					state.slotsRight.remove(sui.containerItem);
					state.lastUpdated = -1;
					sui.destroy();
				}
			});
		}
	}

	public function addPotion(potionItem:Item)
	{
		potions.push(potionItem);
		if (Std.isOfType(FlxG.state, PlayState))
		{
			var state:PlayState = cast FlxG.state;
			var slot = new SlotUI(-1000, -1000);
			slot.refreshUI(potionItem);
			state.slotsRight.add(slot);
			state.slotsRight.add(slot.containerItem);
		}
	}
}