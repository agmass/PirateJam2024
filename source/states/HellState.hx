package states;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import shaders.ColoredItemShader;

class HellState extends FlxState
{
	var silly:FlxSprite = new FlxSprite(0, 0, AssetPaths.test__png);
	var sillyShader = new ColoredItemShader(FlxColor.BLUE);

	override function create()
	{
		silly.scale.set(4, 4);
		silly.updateHitbox();
		silly.screenCenter();
		silly.shader = sillyShader;
		add(silly);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}