function onCreate()
	-- background shit
	makeLuaSprite('VoidStage/voidbackground', 'VoidStage/voidbackground', -350, 0);
	setScrollFactor('VoidStage/voidbackground', 0.9, 0.9);
	
	makeLuaSprite('VoidStage/voidforeground', 'VoidStage/voidforeground', -350, 0);
	setScrollFactor('VoidStage/voidforeground', 0.9, 0.9);

	addLuaSprite('VoidStage/voidbackground', false);
	addLuaSprite('VoidStage/voidforeground', false);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end