/**
* Music system for fgs
*/
class FGSMusic extends object;

/** Default music array */
var array<SoundCue>	MusicArray1;
var array<SoundCue> MoodArray;

var Spawn LocalPlayer;
var AudioComponent MusicPlayer;
var SoundCue LastSong;

var Float Volume;

var Float MaxFade;
var Float MinFade;

var Float MaxWait;
var Float MinWait;

var Float NextTimeToPlay;

var Bool bIsActive;
var Bool bWaitingForSong;
var Bool bDisabled;

simulated function Tick(Float DeltaTime)
{
	MusicPlayer.Location = LocalPlayer.Location;
}

function InitPlayer(Spawn Player)
{
	LocalPlayer = Player;
}

function Init(AudioComponent Music)
{
	MusicPlayer = Music;
	MoodArray = MusicArray1;
	Volume = class'Config_FGS'.static.getMusicVolume();
	StartMusic(1);
	StopMusic(1);
	bIsActive = True;	
}

function StartMusic(Float FadeInTime)
{
	local SoundCue MusicToPlay;
	local int Index;
	local Float FadeIn;

	if(!bDisabled)
	{
		MusicToPlay = LastSong;

		if(!MusicPlayer.IsPlaying())
		{
			if(MoodArray.length > 1)
			{
				do
				{
					SetFadeTime(FadeInTime, FadeIn);
					Index = Rand(MoodArray.length);
					MusicToPlay = MoodArray[Index];
				}
				until(MusicToPlay != LastSong && MusicToPlay != None);
			}
			else
			{
				MusicToPlay = MoodArray[0];
			}

			MusicPlayer.SoundCue = MusicToPlay;
			LastSong = MusicToPlay;
			MusicPlayer.FadeIn(FadeIn, volume);
			bIsActive = True;		
		}
	}
}

function StopMusic(Float FadeOutTime)
{
	local Float FadeOut;

	SetFadeTime(FadeOutTime, FadeOut);	
	bIsActive = False;
	Sidescroller(class'WorldInfo'.static.GetWorldInfo().game).ClearTimer('beginMusic');
	MusicPlayer.FadeOut(FadeOut, 0);
}

function StopMusicAndPlayNext()
{
	bIsActive = False;
	Sidescroller(class'WorldInfo'.static.GetWorldInfo().game).ClearTimer('beginMusic');
	MusicPlayer.Stop();
	StartMusic(0);
}

function StopCurrentSong(Float FadeOutTime)
{
	local Float FadeOut;

	if(MusicPlayer.IsPlaying())
	{
		SetFadeTime(FadeOutTime, FadeOut);	
		MusicPlayer.FadeOut(FadeOut, 0);
	}
	
	bIsActive = True;	
}

function ResumeMusic(Float FadeInTime)
{
	local Float FadeIn;

	SetFadeTime(FadeInTime, FadeIn);	
	MusicPlayer.FadeIn(FadeIn, volume);
	bIsActive = True;
}

function SetMood(FGSMusicMood NewMood)
{
	if(!bIsActive)
	{
		bIsActive = True;
		StartMusic(-1);
	}

	MoodArray = NewMood.Songs;
	MinFade = NewMood.MinFade;
	MaxFade = NewMood.MaxFade;
	MinWait = NewMood.MinWait;
	MaxWait = NewMood.MaxWait;
}

function ResetMood()
{
	MoodArray = MusicArray1;
	MinFade = default.MinFade;
	MaxFade = default.MaxFade;
	MinWait = default.MinWait;
	MaxWait = default.MaxWait;	
}

function LowerVolume()
{
	MusicPlayer.AdjustVolume(0.5, volume / 3);
}

function ResetVolume()
{
	MusicPlayer.AdjustVolume(0.5, volume);
}

function Float GetRandomFadeTime()
{
	return RandRange(MinFade, MaxFade);
}

function Float SetFadeTime(Float NewTime, out Float ActualTime)
{
	if(NewTime == -1)
	{
		ActualTime = getRandomFadeTime();
	}
	else
	{
		ActualTime = NewTime;
	}
}

simulated function TurnOff()
{
	bDisabled = True;
}

simulated function TurnOn()
{
	bDisabled = false;
}

defaultproperties
{
	MinFade = 20.0f
	MaxFade = 60.0f	
	MinWait = 29.0f
	MaxWait = 150.0f
	bIsActive = True
	bWaitingForSong = false
	LastSong = None
	bDisabled = false

	MusicArray1[0]	 = 	SoundCue'MusicSystemSongs.Action.01cue'
	MusicArray1[1]	 = 	SoundCue'MusicSystemSongs.Action.02cue'
	MusicArray1[2]	 = 	SoundCue'MusicSystemSongs.Action.03cue'
	MusicArray1[3]	 = 	SoundCue'MusicSystemSongs.Action.04cue'
	MusicArray1[4]	 = 	SoundCue'MusicSystemSongs.Action.05cue'
	MusicArray1[5]	 = 	SoundCue'MusicSystemSongs.Action.06cue'
	MusicArray1[6]	 = 	SoundCue'MusicSystemSongs.Action.07cue'

	MusicArray1[7]	 = 	SoundCue'MusicSystemSongs.Alien.01cue'
	MusicArray1[8]	 = 	SoundCue'MusicSystemSongs.Alien.02cue'
	MusicArray1[9]	 = 	SoundCue'MusicSystemSongs.Alien.03cue'
	MusicArray1[10]	 = 	SoundCue'MusicSystemSongs.Alien.04cue'
	MusicArray1[11]	 = 	SoundCue'MusicSystemSongs.Alien.05cue'
	MusicArray1[12]	 = 	SoundCue'MusicSystemSongs.Alien.06cue'
	MusicArray1[13]	 = 	SoundCue'MusicSystemSongs.Alien.07cue'

	MusicArray1[14]	 = 	SoundCue'MusicSystemSongs.Atmospheric.01cue'
	MusicArray1[15]	 = 	SoundCue'MusicSystemSongs.Atmospheric.02cue'
	MusicArray1[16]	 = 	SoundCue'MusicSystemSongs.Atmospheric.03cue'
	MusicArray1[17]	 = 	SoundCue'MusicSystemSongs.Atmospheric.04cue'
	MusicArray1[18]	 = 	SoundCue'MusicSystemSongs.Atmospheric.05cue'
	MusicArray1[19]	 = 	SoundCue'MusicSystemSongs.Atmospheric.06cue'
	MusicArray1[20]	 = 	SoundCue'MusicSystemSongs.Atmospheric.07cue'

	MusicArray1[21]	 = 	SoundCue'MusicSystemSongs.Happy.01cue'
	MusicArray1[22]	 = 	SoundCue'MusicSystemSongs.Happy.02cue'
	MusicArray1[23]	 = 	SoundCue'MusicSystemSongs.Happy.03cue'
	MusicArray1[24]	 = 	SoundCue'MusicSystemSongs.Happy.04cue'
	MusicArray1[25]	 = 	SoundCue'MusicSystemSongs.Happy.05cue'
	MusicArray1[26]	 = 	SoundCue'MusicSystemSongs.Happy.06cue'
	MusicArray1[27]	 = 	SoundCue'MusicSystemSongs.Happy.07cue'

	MusicArray1[28]	 = 	SoundCue'MusicSystemSongs.Intense.01cue'
	MusicArray1[29]	 = 	SoundCue'MusicSystemSongs.Intense.02cue'
	MusicArray1[30]	 = 	SoundCue'MusicSystemSongs.Intense.03cue'
	MusicArray1[31]	 = 	SoundCue'MusicSystemSongs.Intense.04cue'
	MusicArray1[32]	 = 	SoundCue'MusicSystemSongs.Intense.05cue'
	MusicArray1[33]	 = 	SoundCue'MusicSystemSongs.Intense.06cue'
	MusicArray1[34]	 = 	SoundCue'MusicSystemSongs.Intense.07cue'

	MusicArray1[35]	 = 	SoundCue'MusicSystemSongs.Mysterious.01cue'
	MusicArray1[36]	 = 	SoundCue'MusicSystemSongs.Mysterious.02cue'
	MusicArray1[37]	 = 	SoundCue'MusicSystemSongs.Mysterious.03cue'
	MusicArray1[38]	 = 	SoundCue'MusicSystemSongs.Mysterious.04cue'
	MusicArray1[39]	 = 	SoundCue'MusicSystemSongs.Mysterious.05cue'
	MusicArray1[40]	 = 	SoundCue'MusicSystemSongs.Mysterious.06cue'
	MusicArray1[41]	 = 	SoundCue'MusicSystemSongs.Mysterious.07cue'

	MusicArray1[42]	 = 	SoundCue'MusicSystemSongs.Sad.01cue'
	MusicArray1[43]	 = 	SoundCue'MusicSystemSongs.Sad.02cue'
	MusicArray1[44]	 = 	SoundCue'MusicSystemSongs.Sad.03cue'
	MusicArray1[45]	 = 	SoundCue'MusicSystemSongs.Sad.04cue'
	MusicArray1[46]	 = 	SoundCue'MusicSystemSongs.Sad.05cue'
	MusicArray1[47]	 = 	SoundCue'MusicSystemSongs.Sad.06cue'
	MusicArray1[48]	 = 	SoundCue'MusicSystemSongs.Sad.07cue'
}