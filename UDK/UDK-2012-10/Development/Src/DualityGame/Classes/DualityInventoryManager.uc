class DualityInventoryManager extends InventoryManager;

/*
	 * Switch between weapons using number keys
	 * Weapon Switching Order
	 * 1  Blue
	 * 2  Red
	 * 3  Purple
	 * 4  Yellow
	 * 5  Green
	 */
	
	exec function switchweapon1()
	{
	  SwitchWeapon(0);
	}
	
	exec function switchweapon2()
	{
	  SwitchWeapon(1);
	}
	
	exec function switchweapon3()
	{
	  SwitchWeapon(2);
	}
	
	exec function switchweapon4()
	{
	  SwitchWeapon(3);
	}
	
	exec function switchweapon5()
	{
	  SwitchWeapon(4);	
	}
	
	// Get list of all weapons in the inventory
	simulated function GetWeaponList(out array<DualityWeapon> WeaponList)
	{
	  local DualityWeapon Weap;
	  local int i;
	
	  i = 0;
	  // Create of list of weapons
	  ForEach InventoryActors( class'DualityWeapon', Weap )
	  {
	    if ( WeaponList.Length <= i )
	    {
	      WeaponList.Length = i + 1;
	      WeaponList[i] = Weap;
	      i++;
	    }
	  }
	}
	
	// Switch to weapon at given position
	simulated function SwitchWeapon(byte Position)
	{
	  local array<DualityWeapon> WeaponList;
	
	  // Get the list of weapons
	  GetWeaponList(WeaponList);
	
	  // Exit out if no weapons are in this list.
	  if (WeaponList.Length<=0)
	  {
	    return;
	  }
	
	  // Set weapon to be weapon at given position
	  if (WeaponList.Length > Position)
	  {
	    SetCurrentWeapon(WeaponList[Position]);
	  }
	}


DefaultProperties
{
    PendingFire(0)=0
    PendingFire(1)=0
}	