package;

import entities.LivingEntity;
import entities.PathfindingEntity;
import entities.enemies.TestingEnemy;
import entities.player.LocalPlayerEntity;
import entities.player.PlayerEntity;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.util.FlxDirectionFlags;
import flixel.util.FlxTimer;
import haxe.Json;
import items.DroppedItem;
import lime.utils.Assets;
import magicEffects.FireEffect;
import map.MapData;
import map.decorations.Chest;
import openfl.filters.BlurFilter;
import ui.SlotUI;
import util.FlxOgmo3LoaderButCool;
import util.FlxTilemapLighting;
import util.Hitbox;

typedef Layer =
{
	data:Array<Int>,
	entities:Array<Dynamic>
}

typedef MyObj =
{
	layers:Array<Layer>,
	width:Int,
	height:Int
}


class PlayState extends FlxState
{
	public var localPlayer:LocalPlayerEntity;
	var mouseObject:FlxSprite = new FlxSprite(0, 0).makeGraphic(18, 18);
	
	var belowPlayer:FlxGroup = new FlxGroup();
	var collideable:FlxGroup = new FlxGroup();

	public var chests:FlxTypedGroup<Chest> = new FlxTypedGroup();
	public var droppedItems:FlxTypedGroup<DroppedItem> = new FlxTypedGroup();

	public var slotsRight:FlxGroup = new FlxGroup();

	var selected = 0;

	public var lastUpdated = -1;
	var blood:FlxSpriteGroup = new FlxSpriteGroup();

	var lightingCam:FlxCamera = new FlxCamera(0, 0, 0, 0, 0);
	var uiCam:FlxCamera = new FlxCamera(0, 0, 0, 0, 0);
	
	override public function create()
	{
		add(collideable);
		collideable.add(belowPlayer);
		add(blood);
		collideable.add(chests);
		add(droppedItems);
		localPlayer = new LocalPlayerEntity(20,20);
		add(localPlayer);
		add(localPlayer.healthBar);
		add(mouseObject);
		add(slotsRight);
		slotsRight.camera = uiCam;
		FlxG.camera.zoom = 1.5;
		
		loadMemoryMap(Json.stringify(getCurrentMap().generate()));
		lightingCam.bgColor.alpha = 0;
		FlxG.cameras.add(lightingCam, false);
		uiCam.bgColor.alpha = 0;
		FlxG.cameras.add(uiCam, false);
		FlxG.camera.follow(localPlayer, FlxCameraFollowStyle.LOCKON);
		lightingCam.follow(localPlayer, FlxCameraFollowStyle.LOCKON);
		super.create();
		
	}
	public var mapd:MapData = new MapData();

	public function getCurrentMap()
	{
		return mapd;
	}

	public static function getTilemap():FlxTilemap
	{
		var ps:PlayState = cast FlxG.state;
		return ps.walls;
	}
	public static function getBlood():FlxSpriteGroup
	{
		var ps:PlayState = cast FlxG.state;
		return ps.blood;
	}
	var e = 0;
	override public function update(elapsed:Float)
	{
		lightingTick();
		FlxG.worldBounds.set(FlxG.camera.viewLeft - 200, FlxG.camera.viewTop - 200, FlxG.camera.viewWidth + 200, FlxG.camera.viewHeight + 200);
		lightingCam.zoom = FlxG.camera.zoom;
		lightingCam.scroll.x = FlxG.camera.scroll.x;
		lightingCam.scroll.y = FlxG.camera.scroll.y;
		mouseObject.x = FlxG.mouse.x;
		mouseObject.y = FlxG.mouse.y;
		var i = 0;
		selected -= Math.floor(FlxG.mouse.wheel / 120);
		slotsRight.forEachOfType(SlotUI, (sui) ->
		{
			sui.x = FlxG.width - 86;
			sui.y = (64 + 20) * i;
			if (Math.round(selected) == i && lastUpdated != i)
			{
				lastUpdated = i;
				uiCam.follow(sui, FlxCameraFollowStyle.LOCKON, 2);
				sui.select();
				slotsRight.forEachOfType(SlotUI, (sui2) ->
				{
					if (sui != sui2)
						sui2.deselect();
				});
			}
			if (FlxG.keys.justPressed.E)
			{
				if (Math.round(selected) == i)
				{
					sui.refItem.use(localPlayer);
				}
			}

			i++;
		});
		if (FlxG.keys.pressed.F)
		{
			FlxG.overlap(mouseObject, blood, (m, bloodObject:FlxSprite) ->
			{
				bloodObject.alpha -= elapsed * 10;
				if (bloodObject.alpha <= 0.2)
				{
					blood.remove(bloodObject);
					bloodObject.destroy();
				}
			});
			}
		if (FlxG.keys.justPressed.K)
		{
			var enemy = new TestingEnemy(FlxG.mouse.x, FlxG.mouse.y);
			forEachOfType(PlayerEntity, (pe) ->
			{
				enemy.possibleTargets.push(pe);
			});
			add(enemy);
		}
		super.update(elapsed);
		FlxG.collide(localPlayer, collideable);
		FlxG.collide(droppedItems, collideable);
		FlxG.collide(blood, collideable);
	}
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;
	var lighting:FlxTilemap;
	var lightBounds:FlxTilemap;
	public function loadMemoryMap(mapData)
	{
		map = new FlxOgmo3LoaderButCool(AssetPaths.ogmo__ogmo, mapData);
		walls = cast map.loadTilemap(AssetPaths.tilesDBG__png, "walls");
		walls.follow();
		walls.follow(lightingCam);
		walls.setTileProperties(19, NONE);
		belowPlayer.add(walls);
		lightBounds = cast map.loadTilemap(AssetPaths.light__png, "lighting");
		lightBounds.follow();
		add(lightBounds);
		lighting = cast map.loadTilemap(AssetPaths.light__png, "lighting");
		lighting.follow();
		add(lighting);
		lighting.camera = lightingCam;
		localPlayer.setPosition(walls.getMidpoint().x, walls.getMidpoint().y);
		map.loadEntities(placeEntities, "entities");
	}

	public function loadMap(mapper)
	{
		map = new FlxOgmo3Loader(AssetPaths.ogmo__ogmo, mapper);
		walls = cast map.loadTilemap(AssetPaths.tilesDBG__png, "walls");
		walls.follow();
		walls.follow(lightingCam);
		walls.setTileProperties(19, NONE);
		belowPlayer.add(walls);
		lightBounds = cast map.loadTilemap(AssetPaths.light__png, "lighting");
		lightBounds.follow();
		add(lightBounds);
		lighting = cast map.loadTilemap(AssetPaths.light__png, "lighting");
		lighting.follow();
		add(lighting);
		lighting.allowCollisions = FlxDirectionFlags.NONE;
		lighting.camera = lightingCam;
		map.loadEntities(placeEntities, "entities");
	}
	public static function hitHitBox(hitbox:Hitbox, debug = false, shooter:LivingEntity)
	{
		hitbox.shooter = shooter;
		var ps:PlayState = cast FlxG.state;
		if (debug)
		{
			ps.add(hitbox);
		}
		ps.forEachOfType(LivingEntity, (le) ->
		{
			if (!le.invincible && shooter != le)
				hitbox.possibleTargets.push(le);
		}, true);
	}
	public function placeEntities(entity:EntityData)
	{
		if (entity.name == "player")
		{
			localPlayer.setPosition(entity.x, entity.y);
		}
		if (entity.name == "chest")
		{
			if (Reflect.getProperty(entity.values, "spawnChance") >= FlxG.random.int(0, 100))
			{
				var chest = new Chest(entity.x, entity.y);
				chests.add(chest);
			}
		}
	}
	/**
	 * Returns a new array full of every map index of the requested tile type.
	 *
	 * @param   index  The requested tile type.
	 * @return  An Array with a list of all map indices of that tile type.
	 */
	public function getTileInstancesWithinScreenSpace(index:Int, tilemap:FlxTilemap):Array<Int>
	{
		var array:Array<Int> = null;
		var i:Int = Math.floor(FlxG.camera.viewLeft / 8) + (Math.floor(FlxG.camera.viewTop / 8) * tilemap.widthInTiles);
		var l:Int = Math.floor(FlxG.camera.viewRight / 8) + (Math.floor(FlxG.camera.viewBottom / 8) * tilemap.widthInTiles);

		while (i < l)
		{
			if (lightBounds.getTileCoordsByIndex(i, false).x > FlxG.camera.viewLeft - 16
				&& lightBounds.getTileCoordsByIndex(i, false).x < FlxG.camera.viewRight + 16)
			{
				if (lightBounds.getTileCoordsByIndex(i, false).y > FlxG.camera.viewTop - 16
					&& lightBounds.getTileCoordsByIndex(i, false).y < FlxG.camera.viewBottom + 16)
				{
					if (tilemap.getTileByIndex(i) == index)
					{
						if (array == null)
						{
							array = [];
						}
						array.push(i);
					}
				}
			} // << extra "oh god oh shit oh fuck" protection
			i++;
		}

		return array;
	}
	var lastscrollx = 0.0;
	var lastscrolly = 0.0;

	public function lightingTick()
	{
		var marked:Array<Int> = [];
		// if (lastscrollx != FlxG.camera.viewLeft || lastscrolly != FlxG.camera.viewTop)
		// {
		var tileIns = getTileInstancesWithinScreenSpace(0, lightBounds);
		if (tileIns != null)
		{
			for (i in tileIns)
			{
				var alive = walls.ray(localPlayer.getMidpoint(), lightBounds.getTileCoordsByIndex(i));

				if (alive)
				{
					lighting.setTileByIndex(i, 0);
				}
				else
				{
					lighting.setTileByIndex(i, 1);
				}
			}
		}

		var tileIns2 = getTileInstancesWithinScreenSpace(0, lighting);

		if (tileIns2 != null)
		{
			for (i in tileIns2)
			{
				var coords = lighting.getTileCoordsByIndex(i, false);
				var cx = Math.floor(coords.x / 8);
				var cy = Math.floor(coords.y / 8);
				for (xc in -2...3)
				{
					for (yc in -2...3)
					{
						lightBounds.setTile(cx + xc, cy + yc, 0);
						lighting.setTile(cx + xc, cy + yc, 0);
					}
				}
			}
		}
	}
	// lastscrollx = FlxG.camera.viewLeft;
	// lastscrolly = FlxG.camera.viewTop;
	// }
}