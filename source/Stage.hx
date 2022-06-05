package;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.math.FlxRandom;

class Stage extends FlxTypedGroup<FlxSprite>
{
    public function new( stage:String, ?camera:FlxCamera = null)
        {
            super();
            getStage(stage, camera);
            
        }
    public function changeStage(newStage:String, ?camera:FlxCamera = null)
        {
            clear();
            getStage(newStage, camera);
        }
    public function getStage(stage:String, ?camera:FlxCamera = null)
        {
            var cam:Array<FlxCamera> = FlxCamera.defaultCameras;
            if(camera != null) {
                cam = [camera];
            }
            switch(stage)
            {
                case 'void':
                    var air:FlxSprite = new FlxSprite(-400, -200).makeGraphic(2750, 1200);
                    air.setGraphicSize(FlxG.width * FlxG.height);
                    add(air);
                    for (i in 0...60)
                        {
                            var num:Int = new FlxRandom().int(1, 5);
                            var stripe:FlxSprite = new FlxSprite(-850 + (60) * i, new FlxRandom().int(-120, -240)).loadGraphic(Paths.image('stripe$num', 'sam'));
                            FlxTween.tween(stripe, {y: new FlxRandom().int(-20, -120)}, new FlxRandom().float(6, 8), {ease: FlxEase.quadInOut, type:PINGPONG});
                            add(stripe);
                            stripe.cameras = cam;
                        }
    
                    var ground:FlxSprite = new FlxSprite(-200, 850).loadGraphic(Paths.image("dipshit", 'sam'));
                    ground.scale.set(2.5, 2.5);
                    add(ground);

                    ground.cameras = cam;
                    air.cameras = cam;

                case 'glitchyvoid':
                    
                    var darksky:FlxSprite = new FlxSprite().loadGraphic(Paths.image('dark sky', 'sam'));
                    darksky.scale.set(1.6, 1.6);
                    add(darksky);
                    
                    var ground:FlxSprite = new FlxSprite(-200, 650).loadGraphic(Paths.image("dark dipshit", 'sam'));
                    ground.scale.set(1.6, 1.6);
                    ground.antialiasing = true;
                    add(ground);    

                    darksky.cameras = cam;
                    ground.cameras = cam;
            }
        }
}