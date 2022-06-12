package;

import flixel.addons.display.FlxExtendedSprite;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.util.FlxCollision;

class PlatformerPlaystate extends MusicBeatState
{
    var player:Player;

    override function create()
        {
            player = new Player(500, 400);
            player.setGravity(100, 0, 0, 0, 0, 0);
            add(player);
        }
    
    override function update(elapsed:Float):Void
        {
            FlxG.collide(player, FlxCollision.)
        }
}