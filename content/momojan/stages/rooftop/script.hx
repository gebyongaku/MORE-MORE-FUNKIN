import funkin.backend.Conductor;
import funkin.objects.Bopper;
import funkin.utils.MathUtil;

var ceu:FlxSprite;
var clouds:FlxSprite;
var predio:FlxSprite;
var front:FlxSprite;

var haruka1:FlxSprite;
var airi1:FlxSprite;
var shizuku1:FlxSprite;

var minori1:FlxSprite;
var airi2:FlxSprite;
var braco:FlxSprite;
var shizuku2:FlxSprite;

var songName:String = Paths.sanitize(PlayState.SONG.song);

function onLoad() 
{

    ceu = new FlxSprite(-1135, -1161).loadGraphic(Paths.image("MMJ/ceu"));
    ceu.scale.set(1, 1);
    ceu.scrollFactor.set(0.1, 0.1);
	add(ceu);

    clouds = new FlxSprite(-1142, -1149).loadGraphic(Paths.image("MMJ/clouds"));
    clouds.scale.set(1, 1);
    clouds.scrollFactor.set(0.8, 1.7);
	add(clouds);

    predio = new FlxSprite(-1143, -1155).loadGraphic(Paths.image("MMJ/predio_atras"));
    predio.scale.set(1, 1);
    predio.scrollFactor.set(1.1, 1.2);
	add(predio);

    front = new FlxSprite(-1172, -1235).loadGraphic(Paths.image("MMJ/front"));
    front.scale.set(1, 1);
    front.scrollFactor.set(1, 1);
	add(front);

    haruka1 = new Bopper(570, 30).loadAtlas("MMJ/step/haruka_minori_bg");
    haruka1.addAnimByIndices('danceLeft', 'minori/haruka gf', MathUtil.numberArray(0, 14), 24, false);
	haruka1.addAnimByIndices('danceRight', 'minori/haruka gf', MathUtil.numberArray(15, 29), 24, false);
    haruka1.dance(); 
    haruka1.animation.play('danceLeft');
	haruka1.scale.set(1, 1);
	haruka1.scrollFactor.set(1, 1);
	haruka1.antialiasing = true;
    haruka1.zIndex = 1;

    airi1 = new Bopper(1100, 10).loadAtlas('MMJ/step/airi_minori_bg');
	airi1.addAnimByPrefix("idle", "minori/airi bg", 24, false);
	airi1.animation.play("idle");
	airi1.scale.set(1, 1);
	airi1.scrollFactor.set(1, 1);
	airi1.antialiasing = true;

    shizuku1 = new Bopper(1390, 10).loadAtlas('MMJ/step/shizuku_minori_bg');
	shizuku1.addAnimByPrefix("idle", "minori/shizuku bg", 24, false);
	shizuku1.animation.play("idle");
	shizuku1.scale.set(1, 1);
	shizuku1.scrollFactor.set(1, 1);
	shizuku1.antialiasing = true;

    minori1 = new Bopper(-680, 60).loadAtlas('MMJ/smile/minori_haruka_bg');
	minori1.addAnimByPrefix("idle", "haruka/minori bg", 24, false);
	minori1.animation.play("idle");
	minori1.scale.set(0.9, 0.9);
	minori1.scrollFactor.set(1, 1);
	minori1.antialiasing = true;

    airi2 = new Bopper(90, 100).loadAtlas("MMJ/smile/airi_haruka_bg");
    airi2.addAnimByIndices('danceLeft', 'haruka/airi bg', MathUtil.numberArray(0, 14), 24, false);
	airi2.addAnimByIndices('danceRight', 'haruka/airi bg', MathUtil.numberArray(15, 29), 24, false);
    airi2.dance(); 
    airi2.animation.play('danceLeft');
	airi2.scale.set(1.03, 1.03);
	airi2.scrollFactor.set(1, 1);
	airi2.antialiasing = true;

    braco = new Bopper(270, 290).loadAtlas("MMJ/smile/airi_braco");
    braco.addAnimByIndices('danceLeft', 'haruka/airi bg 2', MathUtil.numberArray(0, 14), 24, false);
	braco.addAnimByIndices('danceRight', 'haruka/airi bg 2', MathUtil.numberArray(15, 29), 24, false);
    braco.dance(); 
    braco.animation.play('danceLeft');
	braco.scale.set(1.03, 1.03);
	braco.scrollFactor.set(1, 1);
	braco.antialiasing = true;
    braco.zIndex = 1;

    shizuku2 = new Bopper(630, 50).loadAtlas('MMJ/smile/shizuku_haruka_bg');
	shizuku2.addAnimByPrefix("idle", "haruka/shizuku bg", 24, false);
	shizuku2.animation.play("idle");
	shizuku2.scale.set(1.03, 1.03);
	shizuku2.scrollFactor.set(1, 1);
	shizuku2.antialiasing = true;

    if (songName == "step")
    {
        add(haruka1);
        add(airi1);
        add(shizuku1);
    }

    if (songName == "smile")
    {
        add(minori1);
        add(airi2);
        add(braco);
        add(shizuku2);
    }

	public function dance():Void
	{
		danceDir = !danceDir;
		
		if (danceDir) animation.play('danceRight', true);
		else animation.play('danceLeft', true);
	}

}

function onCountdownTick()
{
    haruka1.dance();
    airi1.animation.play("idle");
    shizuku1.animation.play("idle");
    minori1.animation.play("idle");
    airi2.dance();
    braco.dance();
    shizuku2.animation.play("idle");
}

function onBeatHit()
{
    haruka1.dance();
    airi1.animation.play("idle");
    shizuku1.animation.play("idle");
    minori1.animation.play("idle");
    airi2.dance();
    braco.dance();
    shizuku2.animation.play("idle");
}

function onEvent(name, v1, v2)
{
    switch (name)
	{
		case 'Jump':
			switch (v1)
			{
				case 'haruka':
					isCameraOnForcedPos = true;
					snapCamToPos(155, 470);
				case 'bf':
					isCameraOnForcedPos = true;
					snapCamToPos(867, 496);
				case 'gf':
					isCameraOnForcedPos = true;
					snapCamToPos(510, 350);
				case 'normal':
					isCameraOnForcedPos = false;
            }
    }
}
