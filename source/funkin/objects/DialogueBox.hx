package funkin.objects;

import funkin.input.Controls;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

import funkin.states.*;

// rewrite this later
// fazendo saporra
class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;
	
	var curCharacter:String = '';
	
	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];
	
	var swagDialogue:FlxTypeText;
	
	var dropText:FlxText;
	
	public var finishThing:Void->Void;
	public var nextDialogueThing:Void->Void = null;
	public var skipDialogueThing:Void->Void = null;
	
	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	
	var bgDia:FlxSprite;
	
	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();
		
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FunkinSound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}
		
		bgDia = new FlxSprite(-20, -20).loadGraphic(Paths.image("dialogue/bg"));
		bgDia.scrollFactor.set();
		add(bgDia);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'step' | 'smile' | 'love':
			    hasDialog = true;
			    box = new FlxSprite(-20, 430);
			    box.frames = Paths.getSparrowAtlas('dialogue/speech_bubble_talking');
			    box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
			    box.animation.addByPrefix('normal', 'speech bubble normal', 24, false);
			    box.antialiasing = true;
		}
		
		this.dialogueList = dialogueList;
		
		if (!hasDialog) return;
		
        portraitLeft = new FlxSprite(120, 50);
		portraitLeft.frames = Paths.getSparrowAtlas('dialogue/characters/portraitLeft');
		portraitLeft.animation.addByPrefix('minori', 'minori0', 24, false);
		portraitLeft.animation.addByPrefix('minoriwoah', 'minoriwoah', 24, false);
		portraitLeft.animation.addByPrefix('minoriscary', 'minoriscary', 24, false);
		portraitLeft.animation.addByPrefix('minorithink', 'minorithink', 24, false);
		portraitLeft.animation.addByPrefix('haruka', 'haruka0', 24, false);
		portraitLeft.animation.addByPrefix('airi', 'airi0', 24, false);
		portraitLeft.animation.addByPrefix('shizuku', 'shizuku0', 24, false);
		portraitLeft.antialiasing = true;
		portraitLeft.setGraphicSize();
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;
		
		portraitRight = new FlxSprite(700, 110);
        portraitRight.frames = Paths.getSparrowAtlas('dialogue/characters/portraitRight');
		portraitRight.animation.addByPrefix('bf', 'bf0', 24, false);
		portraitRight.animation.addByPrefix('bfyeah', 'bfyeah', 24, false);
		portraitRight.animation.addByPrefix('bfconfused', 'bfconfused0', 24, false);
		portraitRight.animation.addByPrefix('bfmiss', 'bfmiss', 24, false);
		portraitRight.animation.addByPrefix('gf', 'gf0', 24, false);
		portraitRight.antialiasing = true;
		portraitRight.setGraphicSize();
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
		
		box.animation.play('normalOpen');
		box.setGraphicSize();
		box.updateHitbox();
		add(box);
		
		box.screenCenter(X);
		
		if (!talkingRight)
		{
			// box.flipX = true;
		}
		
		dropText = new FlxText(240, 502, "", 36);
		dropText.font = 'FOT-RodinNTLG Pro DB.otf';
		dropText.color = 0xFF444466;
		add(dropText);
		
		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 36);
		swagDialogue.font = 'FOT-RodinNTLG Pro DB.otf';
		swagDialogue.color = 0xFF5D5D79;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);
		
		dialogue = new Alphabet(0, 80, "", false, true); // excuse me?????
		// dialogue.x = 90;
		// add(dialogue);
	}
	
	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;
	var dialogueEnded:Bool = false;
	
	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses') portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.visible = false;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}
		
		dropText.text = swagDialogue.text;
		
		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}
		
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
						FlxG.sound.play(Paths.sound('clickText'), 0.4);
							
						new FlxTimer().start(0.2, function(tmr:FlxTimer) {
							box.alpha -= 1 / 5;
							bgDia.alpha -= 1 / 5 * 0.7;
							portraitLeft.visible = false;
							portraitRight.visible = false;
							swagDialogue.alpha -= 1 / 5;
							dropText.alpha = swagDialogue.alpha;
						}, 5);
						
						new FlxTimer().start(1.1, function(tmr:FlxTimer) {
							finishThing();
							kill();
						});
					}
				}
				else
				{
					dialogueList.remove(dialogueList[0]);
					startDialogue();
					FlxG.sound.play(Paths.sound('clickText'), 0.4);
				}
			}
			else if (dialogueStarted)
			{
				FlxG.sound.play(Paths.sound('clickText'), 0.4);
				swagDialogue.skip();
				
				if (skipDialogueThing != null)
				{
					skipDialogueThing();
				}
			}
		}
		
		super.update(elapsed);
	}
	
	var isEnding:Bool = false;
	
	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);
		
		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.08, true);
		swagDialogue.completeCallback = function() {
			dialogueEnded = true;
		};
		
		dialogueEnded = false;
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
			case 'minori':
				portraitRight.visible = false;
				portraitLeft.visible = true;
				portraitLeft.animation.play('minori');
			case 'minoriwoah':
				portraitRight.visible = false;
				portraitLeft.visible = true;
				portraitLeft.animation.play('minoriwoah');
			case 'minoriscary':
				portraitRight.visible = false;
				portraitLeft.visible = true;
				portraitLeft.animation.play('minoriscary');
			case 'minorithink':
				portraitRight.visible = false;
				portraitLeft.visible = true;
				portraitLeft.animation.play('minorithink');

			case 'haruka':
				portraitRight.visible = false;
				portraitLeft.visible = false;

			case 'airi':
				portraitRight.visible = false;
				portraitLeft.visible = false;

			case 'shizuku':
				portraitRight.visible = false;
				portraitLeft.visible = false;

			case 'bf':
				portraitLeft.visible = false;
				portraitRight.visible = true;
				portraitRight.animation.play('bf');
			case 'bfyeah':
				portraitLeft.visible = false;
				portraitRight.visible = true;
				portraitRight.animation.play('bfyeah');
			case 'bfconfused':
				portraitLeft.visible = false;
				portraitRight.visible = true;
				portraitRight.animation.play('bfconfused');
			case 'bfmiss':
				portraitLeft.visible = false;
				portraitRight.visible = true;
				portraitRight.animation.play('bfmiss');

			case 'gf':
				portraitRight.visible = false;
				portraitLeft.visible = false;
		}
	}
	
	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
