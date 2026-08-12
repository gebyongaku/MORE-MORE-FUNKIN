package funkin.states;

import funkin.backend.macro.GitMacro;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

import funkin.data.*;
import funkin.states.options.*;
import funkin.states.*;
import funkin.states.editors.MasterEditorMenu;

// todo add null safety later
class MainMenuState extends MusicBeatState
{
	public static var curSelected:Int = 0;
	
	final debugKeys:Array<FlxKey> = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));
	
	var optionShit:Array<String> = ['story_mode', 'freeplay', 'credits', 'options'];

	var posX:Array<Float> = [720, 710, 950, 700];
	var posY:Array<Float> = [110, 288, 300, 490];
	
	var canInteract:Bool = false;
	
	var menuItems:Null<FlxTypedGroup<FlxSprite>> = null;
	var mmjnins:Null<FlxTypedGroup<FlxSprite>> = null;
	
	var phone:Null<FlxSprite> = null;
	var magenta:Null<FlxSprite> = null;

	override function create()
	{
		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		
		DiscordClient.changePresence("In the Menus");
		
		FlxG.cameras.reset();
		
		persistentUpdate = persistentDraw = true;
		
		initStateScript();
		
		final yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);

		var bg:FlxSprite = new FlxSprite(-80, 0, Paths.image('menus/menuBG'));
		bg.scrollFactor.set(0, yScroll);
		bg.scale.scale(1.175);
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		phone = new FlxSprite(640, 10, Paths.image('menus/phone'));
		phone.updateHitbox();
		phone.scale.scale(1.18);
		add(phone);
		
		magenta = new FlxSprite(-80, 0, Paths.image('menus/menuDesat'));
		magenta.scrollFactor.copyFrom(bg.scrollFactor);
		magenta.scale.copyFrom(bg.scale);
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.color = 0xFFfd719b;
		add(magenta);
		
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);
		
		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 20;
	
			final menuItem:FlxSprite = new FlxSprite(posX[i], posY[i]);
			menuItem.frames = Paths.getSparrowAtlas('menus/mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.scale.scale(0.9);
			menuItem.ID = i;
			menuItems.add(menuItem);
			
			final scr:Float = optionShit.length < 6 ? 0 : (optionShit.length - 4) * 0.135;
			
			menuItem.scrollFactor.set(0, scr);
			menuItem.updateHitbox();
		}

        mmjnins = new FlxTypedGroup<FlxSprite>();
        add(mmjnins);

        var folder = FileSystem.readDirectory('assets/images/menus/momojanin/');

        for (i in 0...1)
        {
            var momojaRandom = Path.withoutExtension(FlxG.random.getObject(folder));
            var mmjin:FlxSprite = new FlxSprite(25, 25);

            mmjin.frames = Paths.getSparrowAtlas('menus/momojanin/' + momojaRandom);
            mmjin.animation.addByPrefix('idle', 'idle', 24);
            mmjin.animation.play('idle');

            mmjnins.add(mmjin);
        }
		
		final ver = "MORE MORE FUNKIN' V1.0.0" + "\nNightmare Vision Engine V" + Main.NMV_VERSION + '\nPsych Engine V' + Main.PSYCH_VERSION + "\nFriday Night Funkin' V" + Main.FUNKIN_VERSION;
		
		final verionDesc:FlxText = new FlxText(12, 0, 0, ver, 16);
		verionDesc.setFormat(Paths.DEFAULT_FONT, 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		verionDesc.borderSize = 1.5;
		verionDesc.y = FlxG.height - verionDesc.height - 12;
		verionDesc.scrollFactor.set();
		add(verionDesc);
		
		changeSelection();
		
		super.create();
		
		scriptGroup.call('onCreate', []);
	}
	
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null && FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			if (FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}
		
		if (!canInteract)
		{
			if (controls.UI_UP_P || controls.UI_DOWN_P)
			{
				FunkinSound.play(Paths.sound('scrollMenu'));
				changeSelection(controls.UI_UP_P ? -1 : 1);
			}
			
			if (controls.BACK)
			{
				canInteract = true;
				FunkinSound.play(Paths.sound('cancelMenu'));
				FlxG.switchState(TitleState.new);
			}
			
			scriptGroup.set('curSelected', curSelected);
			
			if (controls.ACCEPT)
			{
				if (scriptGroup.call('onSelect', [optionShit[curSelected]]) != ScriptConstants.STOP_FUNC)
				{
					canInteract = true;
					FunkinSound.play(Paths.sound('confirmMenu'));
					
					final selectedObj = menuItems.members[curSelected];
					
					FlxFlicker.flicker(selectedObj, 1, 0.06, false, false, (s) -> {
						switch (optionShit[curSelected])
						{
							case 'story_mode':
								FlxG.switchState(StoryMenuState.new);
							case 'freeplay':
								FlxG.switchState(FreeplayState.new);
							case 'credits':
								FlxG.switchState(CreditsState.new);
							case 'options':
								FlxG.switchState(funkin.states.options.OptionsState.new);
								OptionsState.onPlayState = false;
						}
					});
					
					menuItems.forEachAlive(item -> if (item != selectedObj) FlxTween.tween(item, {alpha: 0}, 0.4, {ease: FlxEase.quadOut}));
				}
			}
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				canInteract = true;
				FlxG.switchState(MasterEditorMenu.new);
			}
		}
		
		super.update(elapsed);
		
		scriptGroup.call('onUpdatePost', [elapsed]);
	}
	
	function changeSelection(diff:Int = 0)
	{
		final lastCurSel = curSelected;
		curSelected = FlxMath.wrap(curSelected + diff, 0, menuItems.length - 1);
		
		if (scriptGroup.call('onChangeSelection', [curSelected]) == ScriptConstants.STOP_FUNC) return;
		
		final prevObj = menuItems.members[lastCurSel];
		prevObj.animation.play('idle');
		prevObj.updateHitbox();
		
		var newObj = menuItems.members[curSelected];
		newObj.animation.play('selected');
		newObj.centerOffsets();
		
		final add:Float = menuItems.length > 4 ? menuItems.length * 8 : 0;
	}
}
