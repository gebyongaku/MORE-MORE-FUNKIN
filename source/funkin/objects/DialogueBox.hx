package funkin.objects;

import funkin.input.Controls;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;

import funkin.states.*;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;
	
	var curCharacter:String = '';
	
	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

    var charName:FlxText;
	var swagDialogue:FlxTypeText;
	
	public var finishThing:Void->Void;
	public var nextDialogueThing:Void->Void = null;
	public var skipDialogueThing:Void->Void = null;
	
	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	
	var bgDia:FlxSprite;
	
	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>) // pessoa que estiver lendo isso ignora que o codigo eh feio eu sou novata guuuh :<
	{
		super();
		
		bgDia = new FlxSprite(-20, -20).loadGraphic(Paths.image("dialogue/bg"));
		bgDia.scrollFactor.set();
		add(bgDia);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'step' | 'smile' | 'love' | 'gift' :
			    hasDialog = true;
		    box = new FlxSprite(-30, -60);
		    box.loadGraphic(Paths.image('dialogue/diaBox'));
			box.scale.set(1.1, 1.1);
		    box.antialiasing = true;
		}
		
		this.dialogueList = dialogueList;
		
		if (!hasDialog) return;
		
        portraitLeft = new FlxSprite(110, 15);
		portraitLeft.frames = Paths.getSparrowAtlas('dialogue/characters/portraitLeft');
		portraitLeft.animation.addByPrefix('minori', 'minori0', 24, false);
		portraitLeft.animation.addByPrefix('minoriwoah', 'minoriwoah', 24, false);
		portraitLeft.animation.addByPrefix('minoriscary', 'minoriscary', 24, false);
		portraitLeft.animation.addByPrefix('minorithink', 'minorithink', 24, false);
		portraitLeft.animation.addByPrefix('minorikawaii', 'minorikawaii', 24, false);
		portraitLeft.animation.addByPrefix('minoridead', 'minoridead', 24, false);
		portraitLeft.animation.addByPrefix('haruka', 'haruka0', 24, false);
		portraitLeft.animation.addByPrefix('harukawoah', 'harukawoah', 24, false);
		portraitLeft.animation.addByPrefix('harukathink', 'harukathink', 24, false);
		portraitLeft.animation.addByPrefix('harukasmile', 'harukasmile', 24, false);
		portraitLeft.animation.addByPrefix('airi', 'airi0', 24, false);
		portraitLeft.animation.addByPrefix('airiwoah', 'airiwoah', 24, false);
		portraitLeft.animation.addByPrefix('airieegh', 'airieegh', 24, false);
		portraitLeft.animation.addByPrefix('airifunnyface', 'airifunnyface', 24, false);
		portraitLeft.animation.addByPrefix('airiangry', 'airiangry', 24, false);
		portraitLeft.animation.addByPrefix('shizuku', 'shizuku0', 24, false);
		portraitLeft.animation.addByPrefix('shizukuwoah', 'shizukuwoah', 24, false);
		portraitLeft.animation.addByPrefix('shizukuhappy', 'shizukuhappy', 24, false);
		portraitLeft.animation.addByPrefix('shizukuarmup', 'shizukuarmup', 24, false);
		portraitLeft.antialiasing = true;
		portraitLeft.setGraphicSize();
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(770, 150);
        portraitRight.frames = Paths.getSparrowAtlas('dialogue/characters/portraitRight');
		portraitRight.animation.addByPrefix('bf', 'bf0', 24, false);
		portraitRight.animation.addByPrefix('bfyeah', 'bfyeah', 24, false);
		portraitRight.animation.addByPrefix('bfmic', 'bfmic', 24, false);
		portraitRight.animation.addByPrefix('bfconfused', 'bfconfused', 24, false);
		portraitRight.animation.addByPrefix('bfwow', 'bfwow', 24, false);
		portraitRight.animation.addByPrefix('bfmiss', 'bfmiss', 24, false);
		portraitRight.animation.addByPrefix('gf', 'gf', 24, false);
		portraitRight.antialiasing = true;
		portraitRight.setGraphicSize();
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
		
		box.setGraphicSize();
		box.updateHitbox();
		add(box);
		
		if (!talkingRight)
		{
			// box.flipX = true;
		}
		
		charName = new FlxText(130, 500, "", 36);
		charName.font = 'FOT RodinNTLGPro EB.otf';
		charName.color = FlxColor.WHITE;
	    charName.borderStyle = FlxTextBorderStyle.OUTLINE;
		charName.borderColor = 0xFF605D7A;
		charName.borderSize = 3.5;
		add(charName);
		
		swagDialogue = new FlxTypeText(130, 560, Std.int(FlxG.width * 0.6), "", 36);
		swagDialogue.font = 'FOT RodinNTLGPro EB.otf';
		swagDialogue.color = FlxColor.WHITE;
		swagDialogue.borderStyle = FlxTextBorderStyle.OUTLINE;
		swagDialogue.borderColor = 0xFF605D7A;
		swagDialogue.borderSize = 3.5;
		add(swagDialogue);
		
		dialogue = new Alphabet(0, 0, "", false);
		// dialogue.x = 90;
		// add(dialogue);
	}
	
	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;
	var dialogueEnded:Bool = false;
	
	override function update(elapsed:Float)
	{
		switch (curCharacter)
        {
		    case 'minori' | 'minoriwoah' | 'minoriscary' | 'minorithink' | 'minorikawaii' | 'minoridead':
			    swagDialogue.sounds = [FlxG.sound.load(Paths.sound('minoripixel'), 0.6)];	
            case 'haruka' | 'harukawoah' | 'harukathink' | 'harukasmile':
			    swagDialogue.sounds = [FlxG.sound.load(Paths.sound('harukapixel'), 0.5)];	
            case 'airi' | 'airiwoah' | 'airieegh' | 'airifunnyface' | 'airiangry':
			    swagDialogue.sounds = [FlxG.sound.load(Paths.sound('airipixel'), 0.4)];	
            case 'shizuku' | 'shizukuwoah' | 'shizukuhappy' | 'shizukuarmup':
			    swagDialogue.sounds = [FlxG.sound.load(Paths.sound('shizukupixel'), 0.6)];	
		    case 'bf' | 'bfyeah' | 'bfmic' | 'bfconfused' | 'bfwow' | 'bfmiss':
			    swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bfpixel'), 0.9)];
		    case 'gf':
			    swagDialogue.sounds = [FlxG.sound.load(Paths.sound('gfpixel'), 0.6)];
		}

		dialogueOpened = true;
		
		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}
		
		if (Controls.instance.ACCEPT)
		{
			if (dialogueEnded)
			{
				remove(dialogue);
				if (dialogueList[1] == null && dialogueList[0] != null)
				{
					if (!isEnding)
					{
						isEnding = true;
							
						FlxTween.tween(box, {alpha: 0}, 1);
						FlxTween.tween(bgDia, {alpha: 0}, 1);
						portraitLeft.visible = false;
						portraitRight.visible = false;
						charName.visible = false;
						swagDialogue.visible = false;
						
						new FlxTimer().start(1.05, function(tmr:FlxTimer) {
							finishThing();
							kill();
						});
					}
				}
				else
				{
					dialogueList.remove(dialogueList[0]);
					startDialogue();
				}
			}
			else if (dialogueStarted)
			{
				swagDialogue.skip();
				
				if (skipDialogueThing != null)
				{
					skipDialogueThing();
				}
			}
		}
		
		super.update(elapsed);
	}

    function theCharName():Void
    {
        switch (curCharacter)
        {
            case 'minori' | 'minoriwoah' | 'minoriscary' | 'minorithink' | 'minorikawaii' | 'minoridead':
                charName.text = 'Minori';
            case 'haruka' | 'harukawoah' | 'harukathink' | 'harukasmile':
                charName.text = 'Haruka';
            case 'airi' | 'airiwoah' | 'airieegh' | 'airifunnyface' | 'airiangry':
                charName.text = 'Airi';
            case 'shizuku' | 'shizukuwoah' | 'shizukuhappy' | 'shizukuarmup':
                charName.text = 'Shizuku';
            case 'bf' | 'bfyeah' | 'bfmic' | 'bfconfused' | 'bfwow' | 'bfmiss':
                charName.text = 'Boyfriend';
            case 'gf':
                charName.text = 'Girlfriend';
            case 'none' | 'MUSIC':
                charName.text = '';
        }
    }

    var portraitLeftY:Float = 15;
    var portraitRightY:Float = 150;

	function animPortrait(portrait:FlxSprite):Void
	{
	    var targetY:Float;

	    if (portrait == portraitLeft)
	        targetY = portraitLeftY;
	    else
 	       targetY = portraitRightY;

	    portrait.y = targetY + 10;
	    portrait.alpha = 0;

	    FlxTween.cancelTweensOf(portrait);

	    FlxTween.tween(portrait, {y: targetY, alpha: 1}, 0.1);
	}

	var isEnding:Bool = false;
	var vaivaivai:String = '';

	function grupinhoaitocomsono(character:String):String
	{
    	switch (character)
    	{
    	    case 'minori' | 'minoriwoah' | 'minoriscary' | 'minorithink' | 'minorikawaii' | 'minoridead':
    	        return 'minori';
    	    case 'haruka' | 'harukawoah' | 'harukathink' | 'harukasmile':
     	       return 'haruka';
     	    case 'airi' | 'airiwoah' | 'airieegh' | 'airifunnyface' | 'airiangry':
    	        return 'airi';
        	case 'shizuku' | 'shizukuwoah' | 'shizukuhappy' | 'shizukuarmup':
        	    return 'shizuku';
        	case 'bf' | 'bfyeah' | 'bfmic' | 'bfconfused' | 'bfwow' | 'bfmiss':
        	    return 'bf';
        	case 'gf':
         		return 'gf';
        }
        return character;
    }

	function startDialogue():Void
	{
		cleanDialog();
        theCharName();
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.065, true);
		swagDialogue.completeCallback = function() {
			dialogueEnded = true;
		};
		
		dialogueEnded = false;

    	var grupinhoaitocomsono:String = grupinhoaitocomsono(curCharacter);
    	var mudou:Bool = grupinhoaitocomsono != vaivaivai;

    	vaivaivai = grupinhoaitocomsono;

        switch (curCharacter)
		{
			case 'MUSIC':
				if (dialogueList[0] == "")
				{
					FlxG.sound.music.stop();
					FlxG.sound.music.volume = 0;
				}
				else
					FlxG.sound.playMusic(Paths.music(dialogueList[0]), 1);
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			case 'none':
				portraitRight.visible = false;
				portraitLeft.visible = false;
			case 'minori' | 'minoriwoah' | 'minoriscary' | 'minorithink' | 'minorikawaii' | 'minoridead':
    		    portraitRight.visible = false;
    		    portraitLeft.visible = true;
        		portraitLeft.animation.play(curCharacter);
        		if (mudou)
        		{
        		    animPortrait(portraitLeft);
        		}
			case 'haruka' | 'harukawoah' | 'harukathink' | 'harukasmile':
    		    portraitRight.visible = false;
    		    portraitLeft.visible = true;
        		portraitLeft.animation.play(curCharacter);
        		if (mudou)
        		{
        		    animPortrait(portraitLeft);
        		}
			case 'airi' | 'airiwoah' | 'airieegh' | 'airifunnyface' | 'airiangry':
    		    portraitRight.visible = false;
    		    portraitLeft.visible = true;
        		portraitLeft.animation.play(curCharacter);
        		if (mudou)
        		{
        		    animPortrait(portraitLeft);
        		}
			case 'shizuku' | 'shizukuwoah' | 'shizukuhappy' | 'shizukuarmup':
    		    portraitRight.visible = false;
    		    portraitLeft.visible = true;
        		portraitLeft.animation.play(curCharacter);
        		if (mudou)
        		{
        		    animPortrait(portraitLeft);
        		}
			case 'bf' | 'bfyeah' | 'bfmic' | 'bfconfused' | 'bfwow' | 'bfmiss':
				portraitLeft.visible = false;
				portraitRight.visible = true;
        		portraitRight.animation.play(curCharacter);
        		if (mudou)
        		{
        			animPortrait(portraitRight);
        		}
			case 'gf':
				portraitLeft.visible = false;
				portraitRight.visible = true;
				portraitRight.animation.play(curCharacter);
        		if (mudou)
        		{
        			animPortrait(portraitRight);
        		}
		}
	}
	// que bonitinho kkkk
	// brigada raul
	
	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
