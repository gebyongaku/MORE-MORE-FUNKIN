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

    haruka1 = new Bopper(525, 20).loadAtlas("MMJ/step/haruka_minori_bg");
    haruka1.addAnimByIndices('danceLeft', 'minori/haruka gf', MathUtil.numberArray(0, 14), 24, false);
	haruka1.addAnimByIndices('danceRight', 'minori/haruka gf', MathUtil.numberArray(15, 29), 24, false);
    haruka1.dance(); 
    haruka1.animation.play('danceLeft');
	haruka1.scale.set(1, 1);
	haruka1.scrollFactor.set(1, 1);
	haruka1.antialiasing = true;
    haruka1.zIndex = 1;
	add(haruka1);

    airi1 = new Bopper(1100, 10).loadAtlas('MMJ/step/airi_minori_bg');
	airi1.addAnimByPrefix("idle", "minori/airi bg", 24, false);
	airi1.animation.play("idle");
	airi1.scale.set(1, 1);
	airi1.scrollFactor.set(1, 1);
	airi1.antialiasing = true;
	add(airi1);

    shizuku1 = new Bopper(1400, 20).loadAtlas('MMJ/step/shizuku_minori_bg');
	shizuku1.addAnimByPrefix("idle", "minori/shizuku bg", 24, false);
	shizuku1.animation.play("idle");
	shizuku1.scale.set(1, 1);
	shizuku1.scrollFactor.set(1, 1);
	shizuku1.antialiasing = true;
	add(shizuku1);

    if (songName == 'smile')
    {
        haruka1.alpha = 0;
        airi1.alpha = 0;
        shizuku1.alpha = 0;
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
}

function onBeatHit()
{
    haruka1.dance();
    airi1.animation.play("idle");
    shizuku1.animation.play("idle");
}
