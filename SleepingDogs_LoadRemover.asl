// Load Remover created by riekelt
// Improvements made by LeoKeidran
// Significant guidance provided by Leemyy

state("SDHDShip")
{
	bool loading 		: 0x0207B000, 0x260;
	string150 CurObj 	: 0x02431108, 0x1;
	float health 		: 0x02087B78, 0x14;
	float fixedHealth	: 0x2088654;
	int faceXP 			: 0x02409CE0, 0x340;
	int copXP 			: 0x02409CE0, 0x344;
	int triadXP 		: 0x02409CE0, 0x348;
	int copTrackingXP 	: 0x02409CE0, 0x538;
	int triadTrackingXP : 0x02409CE0, 0x53C;
	float groundX 		: 0x02409CE0, 0x6A8;
	float groundY 		: 0x02409CE0, 0x6AC;
	float groundZ 		: 0x02409CE0, 0x6B0; // height
	float posX			: 0x021738A8, 0x220;
	float posY			: 0x021738A8, 0x224; // height
	float posZ			: 0x021738A8, 0x228;
	int money			: 0x02409CE0, 0x3C4;
}
state("HKShip")
{
	bool loading: 0x000620E0, 0x418;
}

update
{
	vars.oldLocation = vars.currentLocation;
	vars.currentLocation = vars.locationOf(current);
	
	var rememberCutsceneForSeconds = 1;
	
	var wasInCutscene = vars.inCutscene;
	vars.inCutscene = current.fixedHealth == 1000;
	
	//For Debugging
	var deltaTime = 1 / refreshRate;
	if (vars.inCutscene != wasInCutscene)
	{
		vars.inCutsceneSince = 0f;
	}
	vars.inCutsceneSince += vars.inCutscene ? deltaTime : -deltaTime;
	vars.wasInCutscene = vars.inCutsceneSince > -rememberCutsceneForSeconds;
	vars.wasInGameplay = vars.inCutsceneSince < rememberCutsceneForSeconds;
	
	//For "Nowhere" location check
	vars.isNowhere = vars.playerAt(current, "Nowhere", 0);
	vars.wasNowhere = vars.playerAt(old, "Nowhere", 0);
	
	//For Debugging
	if(vars.wasInCutscene && !vars.inCutscene
		&& current.groundX == old.groundX
		&& current.groundY == old.groundY
		&& current.groundZ == old.groundZ)
	{
		vars.cutsceneEndX = current.groundX;
		vars.cutsceneEndY = current.groundY;
		vars.cutsceneEndZ = current.groundZ;
	}
	if(vars.wasInGameplay && vars.inCutscene)
	{
		vars.cutsceneStartX = old.groundX;
		vars.cutsceneStartY = old.groundY;
		vars.cutsceneStartZ = old.groundZ;
	}
	
}

isLoading
{
	return (current.loading);
}

startup
{ 
	//Setup variables for use
	vars.doneSplits = new HashSet<string>();
	
	vars.inCutscene = false;
	vars.wasInCutscene = false;
	vars.wasInGameplay = false;
	vars.inCutsceneSince = 0f;
	
	vars.isNowhere = false;
	vars.wasNowhere = false;
	
	vars.currentLocation = "unknown";
	vars.oldLocation = "unknown";
	
	
	//Debugging usage
	vars.cutsceneEndX = 0f;
	vars.cutsceneEndY = 0f;
	vars.cutsceneEndZ = 0f;
	vars.cutsceneStartX = 0f;
	vars.cutsceneStartY = 0f;
	vars.cutsceneStartZ = 0f;
	vars.splitInCutscene = false;
	vars.splitWasInCutscene = false;
	vars.lastSplit = "";
	
	//Setting for Any% or Wedding% Start
	
	settings.Add("anyStart", true, "Any% Start");
	settings.Add("weddingStart", false, "Wedding% Start");
	
	// Creates list of splits, left side is variable/internal name. Right is display name.
	settings.Add("splits", true, "Splits");
	
	vars.missionsList = new Dictionary<string,string> 
	{ 	
		{"LOCATION End of Intro Chase","Intro Chase"},
		{"LOCATION End of Intro Fights","Intro Fights"},
		{"XP MISSION_VENDOREXTORTION_RETURN_WITH_MONEY","Vendor Extortion (End)"},
		{"XP MISSION_VENDOREXTORTION_FINISH_DELIVERY","Susan's Lunch (End)"},
		{"XP MISSION_NIGHTMARKETCHASE_OBJECTIVE_012","Night Market Chase (End)"},
		{"XP MISSION_STICKUP_OBJECTIVE_007","Stick Up and Delivery (End)"},
		{"XP MISSION_MINIBUS_OBJECTIVE_010","Mini Bus Racket (End)"},
		{"XP CASE_POPSTAR_TALKTO_DIRTYMING","Identified Supplier (End)"}, //new
		{"XP CASE_PS_CALL_TENG","Lok Fu Park Drug Bust (End)"}, //new
		{"LOCATION End of Amanda","Amanda (End)"},
		{"XP MISSION_BAMBAMBCLUB_OBJECTIVE_016","Club Bam Bam (End)"},
		{"XP CASE_PS3_PARK_SUPPLIER_CAR","Popstar (End)"},
		{"LOCATION Snitch Cutscene","Go to the Restaurant"},
		{"LOCATION Induction","Induction (End)"},
		{"XP MISSION_PB_LEAVE_AREA","Listening In (End)"},
		{"XP MISSION_TIFFANYSGUN_OBJECTIVE_016","Chain of Evidence (End)"},
		{"XP MISSION_SWEATSHOP_OBJECTIVE_011","Payback (End)"},
		{"XP CASE_HS2_PARK_VAN","Gathered Surveillance (End)"},
		{"XP MISSION_UNCLEPO_OBJECTIVE_PARK_VEHICLE","Uncle Po (End)"},
		{"XP MISSION_BRIDETOBE_OBJECTIVE_012","Bride to Be (End)"},
		{"LOCATION WATER_STREET_RACE","Water Street Race (End)"}, //Edgecase situation
		{"XP MISSION_WEDDING_OBJECTIVE_013","The Wedding (End)"},
		{"XP CASE_HS4_ESCAPE_COPS","Hotshot Race (End)"},
		{"XP MISSION_MRSCHUSREVENGE_OBJECTIVE_007","Mrs. Chu's Revenge (End)"},
		{"XP MISSION_THENEWBOSS_OBJECTIVE_010","Meet the New Boss (End)"},
		{"LOCATION Loose Ends","Loose Ends (End)"}, //MISSION_TOPGLAMOUR_OBJECTIVE_012 is after a phone call. New check needed
		{"XP MISSION_FINALKILL_OBJECTIVE_017","Final Kill (End)"},
		{"XP MISSION_INITIATION_OBJECTIVE_10","Initiation (End)"},
		{"XP MISSION_JACKIEARRESTED_OBJECTIVE_012","Dockyard Heist (End)"},
		{"XP MISSION_BOSSESMEET_OBJECTIVE_017","Intensive Care (End)"},
		{"XP MISSION_IMPORTANTVISITOR_OBJECTIVE_016","Important Visitor (End)"},
		{"XP MISSION_FASTGIRLS_OBJECTIVE_009","Fast Girls (End)"},
		{"XP MISSION_BADLUCK_OBJECTIVE_016","Bad Luck (End)"},
		{"XP MISSION_THEBIGHIT_OBJECTIVE_021","Conflicting Loyalties (End)"},
		{"XP MISSION_FUNERAL_OBJECTIVE_018","The Funeral (End)"},
		{"XP MISSION_CIVILDISCORD_OBJECTIVE_013","Civil Discord (End)"},
		{"XP MISSION_BURIEDALIVE_OBJECTIVE_013","Buried Alive (End)"},
		{"LOCATION End of Election","The Election (End)"},
		{"LOCATION Ice Chipper Lee", "End Split"}
	};
	
	// Automatically takes all above to create toggleable settings.
	foreach (var Tag in vars.missionsList)
	{
		//Enables mission end splits and Locations.
		if (Tag.Key.Contains("XP") || Tag.Key.Contains("LOCATION") && !Tag.Key.Contains("Snitch")) {
			settings.Add(Tag.Key, true, Tag.Value, "splits");
		}
		else
		{
		settings.Add(Tag.Key, false, Tag.Value, "splits");
		}
	}
			
	
	//Utility function to make lookup more readable
	//Name "vec3" refers to the X Y Z values of coordinates in game
	Func<double, double, double, Tuple<float, float, float>> Vec3 = (double x, double y, double z) =>
		 new Tuple<float, float, float>((float)x, (float)y, (float)z);
	
	//Utility function to make lookup more readable
	//Name "Location" refers to Vec3 above + detection range + optional mission string
	Func<
		Tuple<float, float, float>,
		double,
		string,
		Tuple<Tuple<float, float, float>,
			float,
			string>>
		Location = (Tuple<float, float, float> position, double range, string objective) =>
		 new Tuple<Tuple<float, float, float>, float, string>(position, (float)range, objective);
	
	//Lookup creation of locations and their coordinates
	var locations =
		new Dictionary<string, Tuple<Tuple<float, float, float>, float, string>>(StringComparer.OrdinalIgnoreCase) {
			
			//Name, Location((Vec3(X, Y, Z), Range, Objective string)
			{"Nowhere", Location(Vec3(0, 0, 0), 0, null)},
			{"Tutorial", Location(Vec3(-1854.349, -1641.585, 0.210), 5, null)},
			{"End of Intro Chase", Location(Vec3(1062.252, -43.00966, 14.83472), 1, null)},
			{"Wedding% Start", Location(Vec3(1059.478, -39.73544, 14.83472), 0.2, null)},
			{"End of Intro Fights", Location(Vec3(935.7, -221.1838, 16.0005), 0.3, null)},
			{"End of Amanda", Location(Vec3(885.9518, -468.5711, 15.56128), 1, "MISSION_AMANDA_OBJECTIVE_DEFEAT_STUDENTS")},
			{"Induction End", Location(Vec3(1581.927, 454.7356, 0.1100691), 0.2, null)},
			{"Snitch Cutscene", Location(Vec3(894.3939, -114.492, 23.10077), 0.2, "GLOBAL_MISSION_SNITCH")},
			{"Loose Ends End", Location(Vec3(1420.719, -525.1333, 6.648087), 2, null)},
			{"End of Election", Location(Vec3(-27.66542, 1444.057, 7.176795), 1, null)},
			{"Ice Chipper Lee", Location(Vec3(-385.366, -530.5806, 0.5959374), 0.2, "MISSION_BIGSMILELEE_ICE_CHIPPER")} //End Split location
	};
	
	//Comparing float values is too precise, so we look at a range to allow for some leniency.
	Func<float, double, double, bool> isNear =
		(float value, double comparand, double epsilon) => {
			var delta = value - comparand;
			return -epsilon <= delta && delta <= +epsilon;
	};
	vars.isNear = isNear;
	
	//Function to determine whether the player's ground coordinates are at a location.
	Func<dynamic, string, double, bool> playerAt = (dynamic state, string locationName, double range) => {
		var checkLocation = locations[locationName];
		var position = checkLocation.Item1;
		return isNear(state.groundX, position.Item1, range)
			&& isNear(state.groundY, position.Item2, range)
			&& isNear(state.groundZ, position.Item3, range);
	};
	vars.playerAt = playerAt;
	
	Func<dynamic, string> locationOf = (dynamic state) => {
		foreach(var entry in locations) {
			var position = entry.Value.Item1;
			var range = entry.Value.Item2;
			var objective = entry.Value.Item3;
			if(isNear(state.groundX, position.Item1, range)
				&& isNear(state.groundY, position.Item2, range)
				&& isNear(state.groundZ, position.Item3, range)
				&& (objective == null || objective == state.CurObj))
			{
				return entry.Key;
			}
		}
		return "unknown";
	};
	
	vars.locationOf = locationOf;

}

start
{
	if (settings["anyStart"]){
		return (vars.wasInCutscene
			&& vars.currentLocation == "Tutorial"
			&& vars.wasNowhere
			&& settings["anyStart"]
		);
	}
	else
	{
		return (vars.currentLocation == "Wedding% Start"
		);
	}
}

split
{
	//Split if at location (used typically for cutscene start/end)
	if (vars.currentLocation != "unknown")
	{
		var Key = "LOCATION " + vars.currentLocation;

		if (!vars.doneSplits.Contains(Key))
		{
			vars.doneSplits.Add(Key);
			vars.lastSplit = Key;
			//If the setting is enabled, will return true and cause a split.
			return (settings[Key]);
		}
	}
	
	//First race, Induction, objective string is inconsistent. Custom checks:
	if (current.money == (old.money + 1200) && vars.currentLocation == "Induction End")
	{
		var Key = "LOCATION Induction";
		if (!vars.doneSplits.Contains(Key))
		{
			vars.doneSplits.Add(Key);
			vars.lastSplit = Key;
			
			return (settings[Key]);
		}
	}
	
	//Loose Ends, objective string is inconsistent. Custom checks:
	if (current.money == (old.money + 60000) && vars.currentLocation == "Loose Ends End")
	{
		
		var Key = "LOCATION Loose Ends";
		if (!vars.doneSplits.Contains(Key))
		{
			vars.doneSplits.Add(Key);
			vars.lastSplit = Key;
			
			return (settings[Key]);
		}
		
	}
	
	//Water Street Race has no objective string. Custom checks:
	if (current.copXP > old.copXP
		&& current.money == (old.money + 20000)
		&& (vars.isNear(current.posX, 1445, 5) && vars.isNear(current.posY, -285, 5) && vars.isNear(current.posZ, 4.5, 3))
		)
	{
		var Key = "LOCATION WATER_STREET_RACE";
		if (!vars.doneSplits.Contains(Key))
		{
			vars.doneSplits.Add(Key);
			vars.lastSplit = Key;
			
			return (settings[Key]);
		}
	}
	
	//Checks if you have gained XP to split, which happens at the end of a mission
	if (current.faceXP > old.faceXP || current.copXP > old.copXP || current.triadXP > old.triadXP || current.money > (old.money + 200))
	{
		var Key = "XP " + current.CurObj;
		if (!vars.doneSplits.Contains(Key))
		{
			vars.doneSplits.Add(Key);
			vars.lastSplit = Key;
			
			return (settings[Key]);
		}
	}
	
}

onReset{
	vars.doneSplits.Clear();
}