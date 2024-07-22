package entities.behaviour;

class Goal
{
	public var entity:PathfindingEntity;

	public function new(entity:PathfindingEntity)
	{
		this.entity = entity;
	}

	public function goalSetup() {}

	public function goalTick() {}

	public function takeOwnership():Bool
	{
		return false;
	}

	public function findTargets():Bool
	{
		return false;
	}
}