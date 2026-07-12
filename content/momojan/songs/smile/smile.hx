
function onEvent(eventName, value1, value2)
{
	if (eventName == "Jump")
	{
		if (value1 == 'yeahh')
		{
            boyfriend.playAnim('hey', true);
			boyfriend.canDance = false;

			gf.playAnim('cheer', true);
			gf.canDance = false;
		}
	}
}
