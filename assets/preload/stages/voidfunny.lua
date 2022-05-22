function onCreate()
	-- background shit
	makeLuaSprite('VoidStageFunny/voidbackground', 'VoidStageFunny/voidbackground', -350, 0);
	setScrollFactor('VoidStage/voidbackground', 0.9, 0.9);
	
	makeLuaSprite('VoidStageFunny/voidforeground', 'VoidStageFunny/voidforeground', -350, 0);
	setScrollFactor('VoidStage/voidforeground', 0.9, 0.9);

	addLuaSprite('VoidStageFunny/voidbackground', false);
	addLuaSprite('VoidStageFunny/voidforeground', false);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end