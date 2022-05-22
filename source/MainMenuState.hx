package;

import editors.ChartingState;
import flixel.util.FlxTimer;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.util.FlxSpriteUtil;
import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.effects.particles.FlxEmitter;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.5.2h'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var transitioning:Bool = false;
	var cerc:FlxSprite;
	var bgScroll:FlxBackdrop;
	var emitterBg:FlxEmitter;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	private var camStage:FlxCamera;
	var character:FlxSprite;
	
	var optionShit:Array<String> = [
		'play',
		#if ACHIEVEMENTS_ALLOWED 'awards', #end
		'credits',
		#if !switch 'donate', #end
		'options'
	];
	var optionOffsets:Array<Dynamic> = [
		[275, -135],
		[275, -155],
		[-380, -240],
		[275, -245],
		[275, -160]
	];

	var magenta:FlxSprite;
	var debugKeys:Array<FlxKey>;
	var debugbox:FlxSprite;
	var circlePath:Float = 0.1;
	var circlePath2:Float = 0.05;
	var stageBG:Stage;

	override function create()
	{
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;
		camStage = new FlxCamera();
		camStage.bgColor.alpha = 0;


		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camStage);
		FlxG.cameras.add(camGame);
		camGame.bgColor.alpha = 0;
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		stageBG = new Stage('void', camStage);
		camStage.zoom = 0.75;
		camStage.scroll.y = 200;
		camStage.angle = -2;
		add(stageBG);
		
		bgScroll = new FlxBackdrop(Paths.image('checkerboard'), 5, 5, true, true);
		bgScroll.scrollFactor.set();
		bgScroll.screenCenter();
		bgScroll.velocity.set(50, 50);
		add(bgScroll);
		
		emitterBg = new FlxEmitter(FlxG.width / 2, FlxG.height, 5000);
		emitterBg.launchMode = FlxEmitterMode.SQUARE;
		emitterBg.makeParticles(5, 5, FlxColor.BLACK, 5000);
		emitterBg.launchAngle.set(90, 90);
		emitterBg.velocity.set(-100, -175, 100, -350);
		emitterBg.scale.set(4, 4, 4, 4, 0, 0, 0, 0);
		emitterBg.start(false, 0.025, 100000);
		emitterBg.lifespan.set(3, 4.75);
		emitterBg.angle.set(-90, 90);
		emitterBg.drag.set(50, 50, 150, 150);
		add(emitterBg);
		
		character = new FlxSprite(275, -245);
		character.scale.set(0.7, 0.7);
		character.antialiasing = true;
		add(character);
		
		var bars:FlxSprite = new FlxSprite().loadGraphic(Paths.image('bars'));
		bars.screenCenter();
		add(bars);

		cerc = new FlxShapeCircle(-260, 420, 375, {thickness: 35, color: 0xFF212121, scaleMode: NORMAL,}, 0xFFf0f0f0);
		cerc.antialiasing = true;
		cerc.updateHitbox();
		add(cerc);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			if (optionShit[i] == 'play')
				{
					menuItem.scale.x = scale;
					menuItem.scale.y = scale;	
				}
			else{
				menuItem.scale.x = scale - 0.3;
				menuItem.scale.y = scale - 0.3;
			}
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
		}

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		emitterBg.x = FlxG.random.float(0, FlxG.width);
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		FlxG.watch.addQuick("curSelected", curSelected);
		FlxG.watch.addQuick("x", cerc.x);
		FlxG.watch.addQuick("y", cerc.y);
		FlxG.watch.addQuick("beatShit", curStep);
		Conductor.songPosition = FlxG.sound.music.time;

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				if (curSelected > 0)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						changeItem(-1);
						circlePath = 0.05;
						circlePath2 = 0.1;
					}
			}

			if (controls.UI_DOWN_P)
			{
				if (curSelected < 4)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						changeItem(1);
						circlePath = 0.1;
						circlePath2 = 0.05;
					}
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}
			if(FlxG.keys.justPressed.F)
				{
					FlxG.resizeGame(640, 720);
				}

			if (controls.ACCEPT)
			{
				transitioning = true;

				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					FlxTween.tween(cerc.scale, {x: 5, y: 3}, 0.5, {ease: FlxEase.quintOut});


					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							//FlxTween.tween(spr.scale, {x: 1.2, y: 1.2}, 2, {ease: FlxEase.circInOut});
							FlxTween.tween(spr, {x: (1280 / 2) - (spr.width / 2), y: (720 / 2) - (spr.height / 2)}, 2, {ease: FlxEase.quintInOut, onComplete: function(twn:FlxTween)
							{
								new FlxTimer().start(0.5, function (tmr:FlxTimer)
									{
										var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'play':
										MusicBeatState.switchState(new FreeplayState());
									#if MODS_ALLOWED
									case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
									#end
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										LoadingState.loadAndSwitchState(new options.OptionsState());
								}
									});
								
							}
						});
					}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
			{
				var pos = curSelected - spr.ID;
				//if (pos > 1)
				//	pos = 500;
				if (pos < 0)
					pos = -1 - spr.ID + curSelected;
				var previousSelected = curSelected - 1;
				spr.updateHitbox();
				
				if (transitioning == false)
				spr.y = FlxMath.lerp(spr.y, (-pos * 100) + 480, circlePath / (ClientPrefs.framerate / 240));

				if (spr.ID == curSelected)
					{
						if (transitioning == false)
							spr.x = FlxMath.lerp(spr.x, 50 + 100, circlePath2 / (ClientPrefs.framerate / 240));
					}
				if (spr.ID > curSelected)
					{
						spr.x = FlxMath.lerp(spr.x, 175 + 100, circlePath2 / (ClientPrefs.framerate / 240));
					}
				if (spr.ID < previousSelected)
					{
						spr.x = FlxMath.lerp(spr.x, -800 + 100, circlePath2 / (ClientPrefs.framerate / 240));
					}
				else if (spr.ID < curSelected)
					{
						spr.x = FlxMath.lerp(spr.x, -340 + 100, circlePath2 / (ClientPrefs.framerate / 240));
					}
			});
	}
	
	override function beatHit()
	{
		super.beatHit();
		FlxTween.tween(FlxG.camera, {zoom:1.025}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;
		var curPortrait:String = optionShit[curSelected];
		character.setPosition(optionOffsets[curSelected][0]+30, optionOffsets[curSelected][1]-5);
		
		FlxTween.cancelTweensOf(character);
		FlxTween.tween(character, {y: optionOffsets[curSelected][1]+5}, 2, {ease: FlxEase.quadInOut, type: PINGPONG});
		character.loadGraphic(Paths.image('portraits/$curPortrait', 'sam'));
		
		FlxG.camera.shake(0.00125, 0.1);

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
			}

		});
	}
}
