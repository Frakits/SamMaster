package;
import flixel.text.FlxText;
import flixel.*;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxSpriteUtil;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;

class FunnyState extends MusicBeatState
{

    var funny:FlxSprite;
    var paused:Bool;
    var funnyText:FlxText;
    override function create()
        {

            funny = new FlxSprite().loadGraphic(Paths.image('funny', 'sam'));
            add(funny);
            funny.alpha = 0;
            funny.screenCenter();
            funny.y += -100;

            funnyText = new FlxText(0, funny.height + -20, 1280, 'never fuck with me ever again', 48);
            funnyText.alignment = CENTER;
            funnyText.alpha = 0;
            add(funnyText);
            super.create();

        }

    override function update(elapsed:Float)
        {
            FlxG.watch.addQuick('alpha', funny.alpha);
            if (FlxG.keys.justPressed.ENTER && funnyText.alpha == 1)
                {
                    MusicBeatState.switchState(new TitleState());
                }
            if (!paused)
                funny.alpha += 0.005 / (ClientPrefs.framerate / 60);

            if (funny.alpha == 1)
                funnyText.alpha += 0.01 / (ClientPrefs.framerate / 60);

            super.update(elapsed);
        }
    override public function onFocusLost():Void
        {   
            if (!paused)
                paused = true;
        }
    override public function onFocus():Void
        {
            if (paused)
                paused = false;
        }
}