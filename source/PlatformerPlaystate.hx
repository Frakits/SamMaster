package;

import flixel.addons.display.FlxExtendedSprite;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.util.FlxCollision;
import flixel.input.keyboard.FlxKey;

class PlatformerPlaystate extends MusicBeatState
{
    var player:Player;
    var ground:FlxSprite;
    var wall:FlxSprite;
    var secondWall:FlxSprite;

    override function create()
        {
            player = new Player(500, 400);
            player.setGravity(0, 1700, 1000, 1000);
            add(player);

            ground = new FlxSprite(0, 650).makeGraphic(1280, 650, FlxColor.BLUE);
            ground.immovable = true;
            add(ground);

            wall = new FlxSprite(1150, 400).makeGraphic(500, 650, FlxColor.BLUE);
            wall.immovable = true;
            add(wall);

            secondWall = new FlxSprite (550, 100).makeGraphic(150, 400, FlxColor.BLUE);
            secondWall.immovable = true;
            add(secondWall);
        }
    
    override function update(elapsed:Float)
        {
            FlxG.collide();

            super.update(elapsed);
        }
}