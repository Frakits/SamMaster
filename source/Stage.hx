package;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.FlxCamera;

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
    
                    var dotGroup1:FlxSprite = new FlxSprite(-90, -50).loadGraphic(Paths.image("dotsex1", 'sam'));
                    dotGroup1.scale.set(3.5, 3.5);
                    dotGroup1.antialiasing = true;
                    FlxTween.tween(dotGroup1, {y: dotGroup1.y + 100}, 4, {type: FlxTweenType.PINGPONG, ease: FlxEase.quadInOut});
                    
                    var dotGroup2:FlxSprite = new FlxSprite(-90, 100).loadGraphic(Paths.image("dotsex2", 'sam'));
                    dotGroup2.scale.set(3.5, 3.5);
                    dotGroup2.antialiasing = true;
                    FlxTween.tween(dotGroup2, {y: dotGroup2.y + 100}, 4, {type: FlxTweenType.PINGPONG, ease: FlxEase.quadInOut, startDelay: 0.5});
                    
                    var dotGroup3:FlxSprite = new FlxSprite(-90, 250).loadGraphic(Paths.image("dotsex3", 'sam'));
                    dotGroup3.scale.set(3.5, 3.5);
                    dotGroup3.antialiasing = true;
                    FlxTween.tween(dotGroup3, {y: dotGroup3.y + 100}, 4, {type: FlxTweenType.PINGPONG, ease: FlxEase.quadInOut, startDelay: 1});
                    
                    var dotGroup4:FlxSprite = new FlxSprite(-90, 400).loadGraphic(Paths.image("dotsex2", 'sam'));
                    dotGroup4.scale.set(3.5, 3.5);
                    dotGroup4.antialiasing = true;
                    FlxTween.tween(dotGroup4, {y: dotGroup4.y + 100}, 4, {type: FlxTweenType.PINGPONG, ease: FlxEase.quadInOut, startDelay: 1.5});
                    
                    add(dotGroup1);
                    add(dotGroup2);
                    add(dotGroup3);
                    add(dotGroup4);
    
                    var ground:FlxSprite = new FlxSprite(-200, 650).loadGraphic(Paths.image("dipshit", 'sam'));
                    ground.scale.set(1.6, 1.6);
                    ground.antialiasing = true;
                    add(ground);

                    air.cameras = cam;
                    dotGroup1.cameras = cam;
                    dotGroup2.cameras = cam;
                    dotGroup3.cameras = cam;
                    dotGroup4.cameras = cam;
                    ground.cameras = cam;
    
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