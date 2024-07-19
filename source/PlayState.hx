package;

import entities.LivingEntity;
import entities.LocalPlayerEntity;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import openfl.filters.BlurFilter;
import util.FlxTilemapLighting;
import util.Hitbox;

class PlayState extends FlxState
{
	var localPlayer:LocalPlayerEntity;
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;
	var lighting:FlxTilemap;
	var lightBounds:FlxTilemap;
	var belowPlayer:FlxGroup = new FlxGroup();
	
	override public function create()
	{
		add(belowPlayer);
		localPlayer = new LocalPlayerEntity(20,20);
		add(localPlayer);
		FlxG.camera.zoom = 1.5;
		
		loadMap(AssetPaths.level__json);
		FlxG.camera.follow(localPlayer, FlxCameraFollowStyle.LOCKON);
		super.create();
		
	}

	override public function update(elapsed:Float)
	{
		var marked = [];
		for (i in lightBounds.getTileInstances(0)) {
			if (lightBounds.getTileCoordsByIndex(i, false).x > FlxG.camera.viewLeft - 16
				&& lightBounds.getTileCoordsByIndex(i, false).x < FlxG.camera.viewRight+16) {
				if (lightBounds.getTileCoordsByIndex(i, false).y > FlxG.camera.viewTop - 16
					&& lightBounds.getTileCoordsByIndex(i, false).y < FlxG.camera.viewBottom+16) {
					var alive = walls.ray(localPlayer.getMidpoint(), lightBounds.getTileCoordsByIndex(i));
						
					if (alive) {
						lighting.setTileByIndex(i, 0);
						
					} else {
						lighting.setTileByIndex(i, 1);
					}
				}
			}
		}
		for (i in lighting.getTileInstances(0))
		{
			if (lightBounds.getTileCoordsByIndex(i, false).x > FlxG.camera.viewLeft-16
				&& lightBounds.getTileCoordsByIndex(i, false).x < FlxG.camera.viewRight+16)
			{
				if (lightBounds.getTileCoordsByIndex(i, false).y > FlxG.camera.viewTop-16
					&& lightBounds.getTileCoordsByIndex(i, false).y < FlxG.camera.viewBottom+16)
				{
					var coords = lighting.getTileCoordsByIndex(i, false);
					var cx = Math.floor(coords.x/8);
					var cy = Math.floor(coords.y/8);
					lighting.setTile(cx - 1, cy, 0);
					lighting.setTile(cx + 1, cy, 0);
					lighting.setTile(cx , cy-1, 0);
					lighting.setTile(cx , cy+1, 0);
					lighting.setTile(cx - 1, cy - 1, 0);
					lighting.setTile(cx - 1, cy + 1, 0);
					lighting.setTile(cx + 1, cy - 1, 0);
					lighting.setTile(cx + 1, cy + 1, 0);
					
					lighting.setTile(cx - 2, cy, 0);
					lighting.setTile(cx + 2, cy, 0);
					lighting.setTile(cx, cy - 2, 0);
					lighting.setTile(cx, cy + 2, 0);
					lighting.setTile(cx - 2, cy - 2, 0);
					lighting.setTile(cx - 2, cy + 2, 0);
					lighting.setTile(cx + 2, cy - 2, 0);
					lighting.setTile(cx + 2, cy + 2, 0);

					lighting.setTile(cx - 1, cy - 2, 0);
					lighting.setTile(cx - 1, cy + 2, 0);
					lighting.setTile(cx + 1, cy - 2, 0);
					lighting.setTile(cx + 1, cy + 2, 0);

					lighting.setTile(cx - 2, cy - 1, 0);
					lighting.setTile(cx - 2, cy + 1, 0);
					lighting.setTile(cx + 2, cy - 1, 0);
					lighting.setTile(cx + 2, cy + 1, 0);
				}
			}
		}
		
		super.update(elapsed);
		FlxG.collide(localPlayer, walls);
	}

	public function loadMap(mapper) {
		map = new FlxOgmo3Loader(AssetPaths.ogmo__ogmo, mapper);
		walls = cast map.loadTilemap(AssetPaths.tilesDBG__png, "walls");
		walls.follow();
		walls.setTileProperties(19, NONE);
		belowPlayer.add(walls);
		lightBounds = cast map.loadTilemap(AssetPaths.light__png, "lighting");
		lightBounds.follow();
		add(lightBounds);
		lighting = cast map.loadTilemap(AssetPaths.light__png, "lighting");
		lighting.follow();
		add(lighting);
		map.loadEntities(placeEntities, "entities");
	}
	public static function hitHitBox(hitbox:Hitbox, debug=false) {
		var ps:PlayState = cast FlxG.state;
		if (debug) {
			ps.add(hitbox);
		}
		ps.forEachOfType(LivingEntity, (le)->{
			if (!le.invincible)
				hitbox.possibleTargets.push(le);
		});
	}
	public function placeEntities(entity:EntityData) {
		if (entity.name == "player")
		{
			localPlayer.setPosition(entity.x, entity.y);
		}
	}
}
