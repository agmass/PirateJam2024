package util;

import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.util.FlxDestroyUtil;

class FlxTilemapLighting extends FlxTilemap {
	public function betterray(start:FlxPoint, end:FlxPoint, ?result:FlxPoint):Bool
	{
		// trim the line to the parts inside the map
		final trimmedStart = calcRayEntry(start, end);
		final trimmedEnd = calcRayExit(start, end);

		start.putWeak();
		end.putWeak();

		if (trimmedStart == null || trimmedEnd == null)
		{
			FlxDestroyUtil.put(trimmedStart);
			FlxDestroyUtil.put(trimmedEnd);
			return true;
		}

		start = trimmedStart;
		end = trimmedEnd;

		inline function clearRefs()
		{
			trimmedStart.put();
			trimmedEnd.put();
		}

		final startIndex = getTileIndexByCoords(start);
		final endIndex = getTileIndexByCoords(end);

		// If the starting tile is solid, return the starting position
		if (getTileCollisions(getTileByIndex(startIndex)) != NONE)
		{
			if (result != null)
				result.copyFrom(start);

			clearRefs();
			return false;
		}

		final startTileX = startIndex % widthInTiles;
		final startTileY = Std.int(startIndex / widthInTiles);
		final endTileX = endIndex % widthInTiles;
		final endTileY = Std.int(endIndex / widthInTiles);
		var hitIndex = -1;

		if (start.x == end.x)
		{
			hitIndex = checkColumn(startTileX, startTileY, endTileY);
			if (hitIndex != -1 && result != null)
			{
				// check the bottom
				result.copyFrom(getTileCoordsByIndex(hitIndex, false));
				result.x = start.x;
				if (start.y > end.y)
					result.y += scaledTileHeight;
			}
		}
		else
		{
			// Use y = mx + b formula
			final m = (start.y - end.y) / (start.x - end.x);
			// y - mx = b
			final b = start.y - m * start.x;

			final movesRight = start.x < end.x;
			final inc = movesRight ? 1 : -1;
			final offset = movesRight ? 1 : 0;
			var tileX = startTileX;
			var tileY = 0;
			var xPos = 0.0;
			var yPos = 0.0;
			var lastTileY = startTileY;

			while (tileX != endTileX)
			{
				xPos = x + (tileX + offset) * scaledTileWidth;
				yPos = m * xPos + b;
				tileY = Math.floor((yPos - y) / scaledTileHeight);
				hitIndex = checkColumn(tileX, lastTileY, tileY);
				if (hitIndex != -1)
					break;
				lastTileY = tileY;
				tileX += inc;
			}

			if (hitIndex == -1)
				hitIndex = checkColumn(endTileX, lastTileY, endTileY);

			if (hitIndex != -1 && result != null)
			{
				result.copyFrom(getTileCoordsByIndex(hitIndex, false));
				if (Std.int(hitIndex / widthInTiles) == lastTileY)
				{
					if (start.x > end.x) {
						//result.x += scaledTileWidth;
                    } else {
                        //result.x -= scaledTileWidth;
                    }

					// set result to left side
					result.y = m * result.x + b; // mx + b
				}
				else
				{
					// if ascending
					if (start.y > end.y)
					{
						// change result to bottom
						//result.y += scaledTileHeight;
					}
					// otherwise result is top

					// x = (y - b)/m
					result.x = (result.y - b) / m;
				}
			}
		}

		clearRefs();
		return hitIndex == -1;
	}
}