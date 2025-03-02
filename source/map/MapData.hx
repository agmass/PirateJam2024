package map;

import PlayState.MyObj;
import flixel.FlxG;
import haxe.Json;
import lime.utils.Assets;

typedef Jigsaw =
{
	room:String,
	rotation:Int,
	origin:Int,
	x:Int,
	y:Int
}

class MapData
{
	public var size = 25;

	public function new() {}

	public function generate():MyObj
	{
		var json:MyObj = Json.parse(Assets.getText(AssetPaths.level__json));

		var toCreate:Array<Jigsaw> = [
			{
				room: AssetPaths.RoomEnterance__json,
				rotation: 0,
				origin: -1,
				x: Math.floor((json.width / 2) / 32),
				y: Math.floor((json.height / 2) / 32)
			}
		];

		var occupiedPositions = [];
		var loops = 0;
		var shuffleTimer = 3;
		while (loops < size)
		{
			if (toCreate.length == 0)
			{
				loops = 100;
			}
			for (jigsaw in toCreate)
			{
				if (jigsaw.x > json.width || jigsaw.y > json.height)
				{
					trace("OOB");
					toCreate.remove(jigsaw);
					continue;
				}
				loops++;
				trace(occupiedPositions);
				var continueornot = true;
				for (i in occupiedPositions)
				{
					if (i[0] == jigsaw.x && i[1] == jigsaw.y)
					{
						trace("occupied");
						toCreate.remove(jigsaw);
						continueornot = false;
						break;
					}
				}
				if (!continueornot)
				{
					continue;
				}
				if (loops > size)
				{
					toCreate.remove(jigsaw);
					break;
				}
				occupiedPositions.push([jigsaw.x, jigsaw.y]);
				shuffleTimer--; 
				json = pasteIntoJson(json, Json.parse(Assets.getText(jigsaw.room)), jigsaw.x, jigsaw.y, jigsaw.rotation);
				toCreate.remove(jigsaw);
				if (jigsaw.room == AssetPaths.RoomX__json)
				{
					for (y in 0...4)
					{
						if (jigsaw.origin != y
							&& !occupiedPositions.contains([jigsaw.x + rotationIndexToX(y), jigsaw.y + rotationIndexToY(y)]))
						{
							toCreate.push(newJigsaw(jigsaw, y));
						}
					}
				}
				if (jigsaw.room == AssetPaths.RoomEnterance__json)
				{
					for (y in 0...4)
					{
						if (y == 0)
						{
							continue;
						}
						if (jigsaw.origin != y
							&& !occupiedPositions.contains([jigsaw.x + rotationIndexToX(y), jigsaw.y + rotationIndexToY(y)]))
						{
							toCreate.push(newJigsaw(jigsaw, y));
						}
					}
				}
				if (jigsaw.room == AssetPaths.RoomStraight__json)
				{
					for (y in 0...4)
					{
						if (jigsaw.rotation == 0 || jigsaw.rotation == 2)
						{
							if (y == 1 || y == 3)
							{
								continue;
							}
						}
						else
						{
							if (y == 0 || y == 2)
							{
								continue;
							}
						}
						if (jigsaw.origin != y
							&& !occupiedPositions.contains([jigsaw.x + rotationIndexToX(y), jigsaw.y + rotationIndexToY(y)]))
						{
							toCreate.push(newJigsaw(jigsaw, y));

						}
					}
				}
				if (shuffleTimer < 0)
				{
					shuffleTimer = 3;
					FlxG.random.shuffle(toCreate);
					break;
				}
			}
		}
		return json;
	}

	public function newJigsaw(jigsaw:Jigsaw, y:Int):Jigsaw
	{
		var possibleRooms:Array<String> = [
			AssetPaths.RoomStraight__json,
			AssetPaths.RoomStraight__json,
			AssetPaths.RoomStraight__json,
			AssetPaths.RoomShortcut__json,
			AssetPaths.RoomX__json,
			AssetPaths.RoomX__json,
			AssetPaths.RoomX__json,
			AssetPaths.RoomX__json
		];
		var rot = y;
		var room = possibleRooms[FlxG.random.int(0, possibleRooms.length - 1)];
		var orig = findOrigin(y);
		return {
			room: room,
			rotation: rot,
			origin: jigsaw.rotation,
			x: jigsaw.x + rotationIndexToX(rot),
			y: jigsaw.y + rotationIndexToY(rot)
		};
	}

	public function rotationIndexToY(r):Int
	{
		return r == 0 ? 16 : r == 2 ? -16 : 0;
	}

	public function rotationIndexToX(r):Int
	{
		return r == 1 ? 16 : r == 3 ? -16 : 0;
	}

	public function findOrigin(r):Int
	{
		return r == 0 ? 2 : r == 2 ? 0 : r == 1 ? 3 : r == 3 ? 1 : -1;
	}

	public function pasteIntoJson(targetJson:MyObj, copyJson:MyObj, x, y, r):MyObj
	{
		if (r == 0)
		{
			targetJson.layers[0].data = combineLayers(targetJson, copyJson, x, y, 0, 32);
			targetJson.layers[1].data = combineLayers(targetJson, copyJson, x * 4, y * 4, 1, 8);
		}
		else
		{
			targetJson.layers[0].data = combineLayers(targetJson, rotate(copyJson, 0, r, 32), x, y, 0, 32);
			targetJson.layers[1].data = combineLayers(targetJson, rotate(copyJson, 1, r, 8), x * 4, y * 4, 1, 8);
		}
		for (entity in copyJson.layers[2].entities)
		{
			entity.x += x * 32;
			entity.y += y * 32;
			targetJson.layers[2].entities.push(entity);
		}
		return targetJson;
	}

	public function rotate(copyJson:MyObj, ind, times, sizeOfTiles):MyObj
	{
		var copylist = copyJson.layers[ind].data.copy();
		var pastelist = [];
		for (rotations in 0...times)
		{
			pastelist = [];
			var cw = copyJson.width;

			var ch = Math.floor(copyJson.height / sizeOfTiles);
			for (y in 0...ch)
			{
				for (x in 0...Math.round(cw / sizeOfTiles))
				{
					var newX = ch - 1 - y;
					var newY = x;
					pastelist[(newY * Math.round(cw / sizeOfTiles)) + newX] = copylist[(y * Math.round(cw / sizeOfTiles)) + x];
				}
			}
			copylist = pastelist;
		}
		copyJson.layers[ind].data = pastelist;
		return copyJson;
	}

	public function combineLayers(targetJson:MyObj, copyJson:MyObj, x, y, ind, size):Array<Int>
	{
		var pastelist = targetJson.layers[ind].data;
		var copylist = copyJson.layers[ind].data;
		var cw = copyJson.width;

		var pw = targetJson.width;
		var ch = Math.floor(copyJson.height / size) - 1;
		var rx = 0;
		var ry = 0;
		for (i in 0...copylist.length)
		{
			pastelist[
				cast((Math.floor(y) + Math.floor(ry)) * (pw / size)) + Math.floor(x) + Math.floor(rx)
			] = copylist[i];
			rx++;
			if (rx >= (cw / size))
			{
				rx = 0;
				ry++;
			}
		}
		targetJson.layers[ind].data = pastelist;
		return targetJson.layers[ind].data;
	}
}