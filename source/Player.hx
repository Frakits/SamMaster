package flixel.addons.display;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.plugin.FlxMouseControl;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets;
import flixel.util.FlxCollision;
import flixel.util.FlxDirectionFlags;

/**
 * An enhanced FlxSprite that is capable of receiving mouse clicks, being dragged and thrown, mouse springs, gravity and other useful things
 *
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
 */
class FlxExtendedSprite extends FlxSprite
{

	/**
	 * An FlxRect region of the game world within which the sprite is restricted during mouse drag
	 */
	public var boundsRect:FlxRect;

	/**
	 * An FlxSprite the bounds of which this sprite is restricted during mouse drag
	 */
	public var boundsSprite:FlxSprite;

	/**
	 * Does this sprite have gravity applied to it?
	 */
	public var hasGravity:Bool = false;

	/**
	 * The x axis gravity influence
	 */
	public var gravityX:Int;

	/**
	 * The y axis gravity influence
	 */
	public var gravityY:Int;

	/**
	 * Determines how quickly the Sprite come to rest on the walls if the sprite has x gravity enabled
	 */
	public var frictionX:Float;

	/**
	 * Determines how quickly the Sprite come to rest on the ground if the sprite has y gravity enabled
	 */
	public var frictionY:Float;

	/**
	 * If the velocity.x of this sprite falls between zero and this amount, then the sprite will come to a halt (have velocity.x set to zero)
	 */
	public var toleranceX:Float;

	/**
	 * If the velocity.y of this sprite falls between zero and this amount, then the sprite will come to a halt (have velocity.y set to zero)
	 */
	public var toleranceY:Float;


	/**
	 * A FlxPoint consisting of this sprites world x/y coordinates
	 */
	public var point(get, set):FlxPoint;

	/**
	 * Returns a FlxRect consisting of the bounds of this Sprite.
	 */
	public var rect(get, never):FlxRect;

	/**
	 * Creates a white 8x8 square FlxExtendedSprite at the specified position.
	 * Optionally can load a simple, one-frame graphic instead.
	 *
	 * @param	X				The initial X position of the sprite.
	 * @param	Y				The initial Y position of the sprite.
	 * @param	SimpleGraphic	The graphic you want to display (OPTIONAL - for simple stuff only, do NOT use for animated images!).
	 */
	public function new(X:Float = 0, Y:Float = 0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);
	}

	/**
	 * Core update loop
	 */
	override public function update(elapsed:Float):Void
	{

		if (hasGravity == true)
		{
			updateGravity();
		}

		super.update(elapsed);
	}

	/**
	 * Called by update, applies friction if the sprite has gravity to stop jittery motion when slowing down
	 */
	function updateGravity():Void
	{
		//	A sprite can have horizontal and/or vertical gravity in each direction (positiive / negative)

		//	First let's check the x movement
		if (velocity.x != 0)
		{
			if (acceleration.x < 0)
			{
				//	Gravity is pulling them left
				if ((touching & WALL) != 0)
				{
					drag.y = frictionY;

					if ((wasTouching & WALL) == 0)
					{
						if (velocity.x < toleranceX)
						{
							velocity.x = 0;
						}
					}
				}
				else
				{
					drag.y = 0;
				}
			}
			else if (acceleration.x > 0)
			{
				//	Gravity is pulling them right
				if ((touching & WALL) != 0)
				{
					//	Stop them sliding like on ice
					drag.y = frictionY;

					if ((wasTouching & WALL) == 0)
					{
						if (velocity.x > -toleranceX)
						{
							velocity.x = 0;
						}
					}
				}
				else
				{
					drag.y = 0;
				}
			}
		}

		//	Now check the y movement
		if (velocity.y != 0)
		{
			if (acceleration.y < 0)
			{
				//	Gravity is pulling them up (velocity is negative)
				if ((touching & CEILING) != 0)
				{
					drag.x = frictionX;

					if ((wasTouching & CEILING) == 0)
					{
						if (velocity.y < toleranceY)
						{
							velocity.y = 0;
						}
					}
				}
				else
				{
					drag.x = 0;
				}
			}
			else if (acceleration.y > 0)
			{
				//	Gravity is pulling them down (velocity is positive)
				if ((touching & FLOOR) != 0)
				{
					//	Stop them sliding like on ice
					drag.x = frictionX;

					if ((wasTouching & FLOOR) == 0)
					{
						if (velocity.y > -toleranceY)
						{
							velocity.y = 0;
						}
					}
				}
				else
				{
					drag.x = 0;
				}
			}
		}
	}


	/**
	 * Bounds Rect check for the sprite drag
	 */
	function checkBoundsRect():Void
	{
		if (x < boundsRect.left)
		{
			x = boundsRect.x;
		}
		else if ((x + width) > boundsRect.right)
		{
			x = boundsRect.right - width;
		}

		if (y < boundsRect.top)
		{
			y = boundsRect.top;
		}
		else if ((y + height) > boundsRect.bottom)
		{
			y = boundsRect.bottom - height;
		}
	}
	/**
	 * Gravity can be applied to the sprite, pulling it in any direction. Gravity is given in pixels per second and is applied as acceleration.
	 * If you don't want gravity for a specific direction pass a value of zero. To cancel it entirely pass both values as zero.
	 *
	 * @param	GravityX	A positive value applies gravity dragging the sprite to the right. A negative value drags the sprite to the left. Zero disables horizontal gravity.
	 * @param	GravityY	A positive value applies gravity dragging the sprite down. A negative value drags the sprite up. Zero disables vertical gravity.
	 * @param	FrictionX	The amount of friction applied to the sprite if it hits a wall. Allows it to come to a stop without constantly jittering.
	 * @param	FrictionY	The amount of friction applied to the sprite if it hits the floor/roof. Allows it to come to a stop without constantly jittering.
	 * @param	ToleranceX	If the velocity.x of the sprite falls between 0 and +- this value, it is set to stop (velocity.x = 0)
	 * @param	ToleranceY	If the velocity.y of the sprite falls between 0 and +- this value, it is set to stop (velocity.y = 0)
	 */
	public function setGravity(GravityX:Int, GravityY:Int, FrictionX:Float = 500, FrictionY:Float = 500, ToleranceX:Float = 10, ToleranceY:Float = 10):Void
	{
		hasGravity = true;

		gravityX = GravityX;
		gravityY = GravityY;

		frictionX = FrictionX;
		frictionY = FrictionY;

		toleranceX = ToleranceX;
		toleranceY = ToleranceY;

		if (GravityX == 0 && GravityY == 0)
		{
			hasGravity = false;
		}

		acceleration.x = GravityX;
		acceleration.y = GravityY;
	}

	/**
	 * Switches the gravity applied to the sprite. If gravity was +400 Y (pulling them down) this will swap it to -400 Y (pulling them up)
	 * To reset call flipGravity again
	 */
	public function flipGravity():Void
	{
		if (!Math.isNaN(gravityX) && gravityX != 0)
		{
			gravityX = -gravityX;
			acceleration.x = gravityX;
		}

		if (!Math.isNaN(gravityY) && gravityY != 0)
		{
			gravityY = -gravityY;
			acceleration.y = gravityY;
		}
	}

	inline function get_point():FlxPoint
	{
		return _point;
	}

	inline function set_point(NewPoint:FlxPoint):FlxPoint
	{
		return _point = NewPoint;
	}

	inline function get_rect():FlxRect
	{
		_rect.x = x;
		_rect.y = y;
		_rect.width = width;
		_rect.height = height;

		return _rect;
	}
}

typedef MouseCallback = FlxExtendedSprite->Int->Int->Void;
