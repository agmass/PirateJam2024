package items;

import entities.player.PlayerEntity;
import flixel.system.FlxAssets.FlxShader;
import openfl.display.Shader;

class Item {
	public var referenceSpriteID = 0;
	public var inventoryShaders:FlxShader;

	public function new() {}

	public function use(player:PlayerEntity) {}
}