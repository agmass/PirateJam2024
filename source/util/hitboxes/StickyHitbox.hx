package util.hitboxes;

class StickyHitbox extends Hitbox
{
	public var previousStickX = 0.0;
	public var previousStickY = 0.0;

	override function update(elapsed:Float)
	{
		if (shooter != null && alive)
		{
			x -= previousStickX - shooter.x;
			y -= previousStickY - shooter.y;
			previousStickX = shooter.x;
			previousStickY = shooter.y;
		}
		super.update(elapsed);
	}
}