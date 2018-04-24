/**
* Inventory / weapon selection 
*/
class FGSInventory extends object;

var Int WeaponsCategory;
var Int LastWeaponCategory;
var Int WeaponsIndex;

var Array <Weapon> Weapons;
var Array <Weapon> WeaponsCategory1;
var Array <Weapon> WeaponsCategory2;
var Array <Weapon> WeaponsCategory3;
var Array <Weapon> WeaponsCategory4;
var Array <Weapon> WeaponsCategory5;
var Array <Weapon> WeaponsCategory6;

var class<Inventory> InventoryClassesArray[21];
var SPawn LocalPlayer;
var Weapon LastUsedWeapon;
var Weapon SwitchWeapon;
var Int CurrentWeaponIndex;
var Int CurrentWeaponCategory;
var Bool bWeaponSwitchInProgress; 


function SetUpLocalPlayer(SPawn Player)
{
    LocalPlayer = Player;
}

function ChangeWeapon(Int Index, optional Bool OutOfAmmoChange = false, optional Bool Scroll = false, optional Int ScrollUp)
{ 
	local Int i; 
	local Array<Weapon> CurrentWeaponsArray;
	local Bool DoNotIncrement;

    GetWeaponsFromPawn();

    if(WeaponsCategory != Index)
    {
		WeaponsCategory = Index;
		WeaponsIndex = 0;
    }

	if(Index == 100)
	{
		if(LastUsedWeapon != None || LastUsedWeapon.AmmoCount > 0)
			ChangeToSelectedWeapon(True);
		else if(OutOfAmmoChange)
		{
			LocalPlayer.WeaponReloadPoseBlend.SetBlendTarget(0.0, 0.5);
			ChangeWeapon(1);
		}
	}
	else
	{
		CurrentWeaponsArray = GetCurrentWeaponsArray();

		if(CurrentWeaponsArray.length > 0)
		{
			if(CurrentWeaponsArray.length > 0)
			{
				if(WeaponsIndex == CurrentWeaponsArray.length)
				{
					WeaponsIndex = 0;
				}

				SwitchWeapon = CurrentWeaponsArray[WeaponsIndex];
			}

			if(!DoNotIncrement)
			{
				if(ScrollUp == 1)
			    	WeaponsIndex++;
				else if(ScrollUp == 2)
					WeaponsIndex--;
				else
		 	   		WeaponsIndex++;
			}
		}
	}
}

function Array <Weapon> GetWeaponArrayByNumber(Int Number)
{
	switch(Number)
	{
		case 0:
			return WeaponsCategory1;
		case 1:
			return WeaponsCategory2;
		case 2:
			return WeaponsCategory3;
		case 3:
			return WeaponsCategory4;
		case 4:
			return WeaponsCategory5;
		case 5:
			return WeaponsCategory6;
		default:
			return WeaponsCategory1;
	}
}

function Array<Weapon> GetCurrentWeaponsArray(optional Int Index = -1)
{
	if(Index == -1)
	{
		if(WeaponsCategory < 1)
			WeaponsCategory = 6;
		else if(WeaponsCategory > 6)
			WeaponsCategory = 1;
	}

	switch(WeaponsCategory)
	{
		case 1:
			return WeaponsCategory1;

		case 2:
			return WeaponsCategory2;

		case 3:
			return WeaponsCategory3;

		case 4:
			return WeaponsCategory4;

		case 5:
			return WeaponsCategory5;

		case 6:
			return WeaponsCategory6;

		default:
			return WeaponsCategory1;
	}
}

function SetLastWeaponUsed()
{
	if(LastUsedWeapon != Weapon(LocalPlayer.Weapon))
		LastUsedWeapon = Weapon(LocalPlayer.Weapon);
}

function ChangeToSelectedWeapon(optional Bool SwitchToLastWeaponUsed)
{
	if(!bWeaponSwitchInProgress && SwitchWeapon != None && ( !SwitchToLastWeaponUsed || ( ( ( SwitchWeapon != LastUsedWeapon ) || LastUsedWeapon == None ) ) ) )
	{
		bWeaponSwitchInProgress = True;

		if(SwitchToLastWeaponUsed)
			SwitchWeapon = LastUsedWeapon;

		SetLastWeaponUsed();

		LocalPlayer.InvManager.SetCurrentWeapon(SwitchWeapon); 
		LocalPlayer.WeaponReloadPoseBlend.SetBlendTarget(0.0, 0.5);
		LocalPlayer.PlaySound(SoundCue'Sound_01.menu.Inventory.hover_01_cue');

		WeaponsCategory = 0;

		LocalPlayer.SetTimer(0.5, False, 'WeaponSwitchComplete');
	}
}

function WeaponSwitchComplete()
{
	bWeaponSwitchInProgress = False;
}

function GetWeaponsFromPawn()
{
    local Inventory TempInv;
	
	Weapons.Length = 0;

	foreach LocalPlayer.InvManager.InventoryActors(class'Inventory', TempInv)
	{
	    if(TempInv != None && !TempInv.IsA('FGSWeap_HEGrenade'))
        {
			`log( Weapon(TempInv)$" was added to the weapons Array");
            Weapons.AddItem(Weapon(TempInv));
        }	
	}

	SetUpInventory();
}

function SetUpInventory()
{
	local Int i;
	
	WeaponsCategory1.length = 0;
	WeaponsCategory2.length = 0;
	WeaponsCategory3.length = 0;
	WeaponsCategory4.length = 0;
	WeaponsCategory5.length = 0;
	WeaponsCategory6.length = 0;
	
    for(i = 0; i < Weapons.length; i++)
    {
        switch(Weapons[i].InventoryGroup)
        {
            case 1:
            WeaponsCategory1.AddItem(Weapons[i]);
            break;
            case 2:
            WeaponsCategory2.AddItem(Weapons[i]);
            break;
            case 3:
            WeaponsCategory3.AddItem(Weapons[i]);
            break;
            case 4:
            WeaponsCategory4.AddItem(Weapons[i]);
            break;
            case 5:
            WeaponsCategory5.AddItem(Weapons[i]);
            break;
            case 6:
            WeaponsCategory6.AddItem(Weapons[i]);
            break;
        }
    } 
}

function SetCurrentWeaponSwitch()
{
	GetWeaponsFromPawn();
	SwitchWeapon = GetCurrentWeaponsArray()[WeaponsIndex - 1];
}

function ScrollPrevWeapon()
{
	local Int NewWeaponsIndex;
	local Int Length;
	local Int Steps;

	NewWeaponsIndex = WeaponsIndex - 1;

	if(NewWeaponsIndex <= 0)
	{
		do
		{
			Steps++;
			WeaponsCategory--;
			Length = GetCurrentWeaponsArray().Length;
		}
		until(Length != 0 || Steps == 6);

		NewWeaponsIndex = GetCurrentWeaponsArray().Length;
	}

	WeaponsIndex = NewWeaponsIndex;

	ChangeWeapon(WeaponsCategory);

	WeaponsIndex = NewWeaponsIndex;

	SetCurrentWeaponSwitch();
}

function ScrollNextWeapon()
{
	local Int Length; 
	local Int Steps;

	if(WeaponsIndex >= GetCurrentWeaponsArray().Length)
	{
		WeaponsIndex = 0;

		do{
			Steps++;
			WeaponsCategory++;
			Length = GetCurrentWeaponsArray(WeaponsCategory).Length;
		}
		until(Length != 0 || Steps == 6);
	}

	if(WeaponsCategory > 6)
	{
		WeaponsCategory =  1;
		WeaponsIndex = 0;
	}

	ChangeWeapon(WeaponsCategory);

	SetCurrentWeaponSwitch();
}

function ScrollLeft()
{
	local Int Length;
	local Int Steps;

	do
	{
		Steps++;
		WeaponsCategory--;
		Length = GetCurrentWeaponsArray().Length;
	}
	until(Length != 0 || Steps == 6);

	if(WeaponsCategory <= 0)
		WeaponsCategory = 6;

	if(WeaponsIndex >= GetCurrentWeaponsArray().Length)
		WeaponsIndex = GetCurrentWeaponsArray().Length;

	SetCurrentWeaponSwitch();
}

function ScrollRight()
{
	local Int Length;
	local Int Steps;

	do
	{
		Steps++;
		WeaponsCategory++;
		Length = GetCurrentWeaponsArray().Length;
	}
	until(Length != 0 || Steps == 6);

	if(WeaponsCategory > 6)
		WeaponsCategory = 1;

	if(WeaponsIndex >= GetCurrentWeaponsArray().Length)
		WeaponsIndex = GetCurrentWeaponsArray().Length;

	SetCurrentWeaponSwitch();
}

function LastWeaponUsed()
{
	ChangeWeapon(100);
}

defaultproperties
{
    WeaponsCategory=0
    LastWeaponCategory=0
    WeaponsIndex=0
}