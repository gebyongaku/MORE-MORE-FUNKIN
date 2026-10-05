var endingPlayed:Bool = false;

function onEndSong()
{
	if (PlayState.isStoryMode && !endingPlayed)
	{
		endingPlayed = true;
		endingCutscene = true;

		videoCutscene('gift', false);

		return Function_Stop;
	}

	return Function_Continue;
}

function onEvent(eventName, value1, value2)
{
	if (eventName == "Jump")
	{
		if (value1 == 'black')
		{
			camGame.visible = value2 == 'on' ? false : true;
		}

		if (value1 == 'fufu')
		{
            dad.playAnim('funny', true);
			dad.canDance = false;
		}

        if (value1 == 'volta')
        {
            dad.canDance = true;
        }
	}
}
