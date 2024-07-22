package util;

import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import haxe.Json;
import lime.utils.Assets;

class FlxOgmo3LoaderButCool extends FlxOgmo3Loader
{
	override public function new(projectData:String, levelData:String)
	{
		super(projectData, AssetPaths.empty__json);
		project = parseProjectJSON(Assets.getText(projectData));
		level = parseLevelJSON(levelData);
	}

	static function parseLevelJSON(json:String):LevelData
	{
		return cast Json.parse(json);
	}

	/**
	 * Parse OGMO Editor Project .ogmo text
	 */
	static function parseProjectJSON(json:String):ProjectData
	{
		return cast Json.parse(json);
	}
}