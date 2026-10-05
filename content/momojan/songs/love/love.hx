function onLoad()
{
	videoCutscene('love', true);
}

function onEvent(eventName, value1, value2)
{
	if (eventName == "Jump")
	{
		if (value1 == 'ughhy')
		{
            dad.playAnim('ugh', true);
			dad.canDance = false;
		}
	}
}
