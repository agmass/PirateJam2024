package ui;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import items.Item;

class SlotUI extends FlxSprite
{
	public var containerItem:FlxSprite = new FlxSprite(0, 0);
	public var refItem:Item = null;

	override public function new(?x, ?y)
	{
		super(x, y);
		containerItem.x = x;
		loadGraphic(AssetPaths.slot__png);
		containerItem.loadGraphic(AssetPaths.itemsheet__png, true, 64, 64);
		containerItem.y = y;
		deselect();
		scrollFactor.set(0, 1);
		containerItem.scrollFactor.set(0, 1);
	}

	public function deselect()
	{
		FlxTween.globalManager.completeTweensOf(this);
		FlxTween.tween(scale, {x: 0.75, y: 0.75}, 0.15, {ease: FlxEase.circInOut});
	}

	public function select()
	{
		FlxTween.globalManager.completeTweensOf(this);
		FlxTween.tween(scale, {x: 1, y: 1}, 0.15, {ease: FlxEase.circInOut});
	}

	public function refreshUI(x)
	{
		refItem = x;
		containerItem.shader = x.inventoryShaders;
		containerItem.animation.add("1", [x.referenceSpriteID], 10);
		containerItem.animation.play("1");
	}

	override function update(elapsed:Float)
	{
		containerItem.x = x;
		containerItem.y = y;
		containerItem.scale.set(scale.x, scale.y);
		containerItem.alpha = alpha;
		super.update(elapsed);
	}
}