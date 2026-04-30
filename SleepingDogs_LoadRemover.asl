// Load Remover created by Plasma
// Splitter made by LeoKeidran
// Extra help from ahmeher

state("SDHDShip")
{
	bool 	loading 			: 0x0207B000, 0x260;
	float 	fixedHealth			: 0x2088654;

	string150 CurObj 			: 0x02431108, 0x1;
	string32 saveName			: 0x2409EE9;		 // Autosave name
	bool	bslChipper			: 0x02072EE8, 0xF9C; // turns true when Big Smile Lee is chippered at the end of any%

	float groundX 				: 0x02409CE0, 0x6A8; // Used for verifying the save being loaded.

	bool 	autosaveIconVisible : 0x02401208, 0x20;
	bool 	mainMenuSavesShown 	: 0x23F20B8;
	bool 	onMainMenu         	: 0x242E580;
	bool 	chosePopupOption 	: 0x0249F468, 0x1E8, 0x0, 0xC0, 0x80C;
	bool 	popupPrompt  		: 0x2431090;
}
state("HKShip") // Addresses provided by ahmeher
{
	bool loading				: 0x000620E0, 0x418;
	float fixedHealth      		: 0x1007314;

	string150 CurObj   			: 0x10F47E4, 0x1;
	string32 saveName 			: 0x10A12B9;
	bool bslChipper			 	: 0x00FF3EA4, 0xA8;

	bool autosaveIconVisible  	: 0x0109B908, 0x10;
	bool mainMenuSavesShown		: 0x00AB2C3C, 0x1B8, 0xFCC;
	bool onMainMenu        		: 0x1091B30;
	bool chosePopupOption   	: 0x011124A8, 0x38, 0x2C, 0x8, 0x28C;
	bool popupPrompt   			: 0x107A28C;
}

update
{
	// On first boot, health in fixed memory is -1.
	vars.justBooted = (current.fixedHealth == -1) ? true : false;

	//sets firstSplit up to be used in preventing double splits or first split not breaking
	if (settings["anyStart"])
	{
		vars.firstSplit = "WELCOME_TO_HONG_KONG";

	}
	else if (settings["weddingStart"])
	{
		vars.firstSplit = "GOING_UNDER";
	}

	//sets weddingSlot to true if player is located at coordinates that match wedding slot. Else, false.
	vars.weddingSlot = ((893 <= current.groundX && current.groundX <= 895) || (1058 <= current.groundX && current.groundX <= 1060)) ? true : false;


}

isLoading
{
	return (current.loading);
}

startup
{ 
	//Setup variables for use
	vars.doneSplits = new HashSet<string>();
	vars.justBooted = false;

	vars.firstSplit = "";
	vars.weddingSlot = false;

	//Debugging usage
	vars.lastSplit = "";
	vars.oldSplit = "";
	vars.olderSplit = "";
	
	//Setting for Any% or Wedding% Start
	
	settings.Add("anyStart", true, "Any% Start");
	settings.Add("weddingStart", false, "Wedding% Start");
	
	// Creates list of splits, left side is variable/internal name. Right is display name.
	settings.Add("splits", true, "Splits");
	
	vars.missionsList = new Dictionary<string,string> 
	{
		{"WELCOME_TO_HONG_KONG","Intro Chase"},
		{"GOING_UNDER","Intro Fights"},
		{"VENDOR_EXTORTION","Vendor Extortion (End)"},
		{"VENDOR_FAVOR","Susan's Lunch (End)"},
		{"NIGHT_MARKET_CHASE","Night Market Chase (End)"},
		{"STICK_UPANDDELIVERY","Stick Up and Delivery (End)"},
		{"MINI_BUS","Mini Bus Racket (End)"},
		{"POPSTAR_1","Identified Supplier (End)"},
		{"POPSTAR_2","Lok Fu Park Drug Bust (End)"},
		{"AMANDA","Amanda (End)"},
		{"BAM_BAM_CLUB","Club Bam Bam (End)"},
		{"POPSTAR_3","Popstar (End)"}, //No Snitch autosave, instead game uses "Popstar_3" (meaning if you load this, you have to go to the snitch cutscene)
		{"RACE_CASE_START","Induction (End)"},
		{"PENDREWS_BUGS","Listening In (End)"},
		{"TIFFANYS_GUN","Chain of Evidence (End)"},
		{"SWEATSHOP","Payback (End)"},
		{"HOTSHOT_LEAD_2","Gathered Surveillance (End)"},
		{"UNCLE_PO","Uncle Po (End)"},
		{"BRIDE_TO_BE","Bride to Be (End)"},
		{"RACE_HOTSHOT_LEAD_3","Water Street Race (End)"},
		{"WEDDING","The Wedding (End)"},
		{"HOTSHOT_LEAD_4","Hotshot Race (End)"},
		{"MRS_CHUS_REVENGE","Mrs Chu's Revenge (End)"},
		{"THE_NEW_BOSS","Meet the New Boss (End)"},
		{"TOP_GLAMOUR_AMBUSH","Loose Ends (End)"},
		{"FINAL_KILL","Final Kill (End)"},
		{"INITIATION","Initiation (End)"},
		{"JACKIE_ARRESTED","Dockyard Heist (End)"},
		{"HOSPITAL_SHOOTOUT","Intensive Care (End)"},
		{"IMPORTANT_VISITOR","Important Visitor (End)"},
		{"FAST_GIRLS","Fast Girls (End)"},
		{"BAD_LUCK","Bad Luck"},
		{"THE_BIG_HIT","Conflicting Loyalties (End)"},
		{"THE_FUNERAL","The Funeral (End)"},
		{"CIVIL_DISCORD","Civil Discord (End)"},
		{"BURIED_ALIVE","Buried Alive (End)"},
		{"THE_ELECTION","The Election (End)"},
		{"BIG_SMILE_LEE","Big Smile Lee (End)"} // End split does not utilise auto save
	};
	
	// Automatically takes all above to create toggleable settings.
	foreach (var Tag in vars.missionsList)
	{
		//Enables mission end splits and Locations.
		if (Tag.Key.Contains("Snitch")) {
			settings.Add(Tag.Key, false, Tag.Value, "splits");
		}
		else
		{
		settings.Add(Tag.Key, true, Tag.Value, "splits");
		}
	}


}

start
{
	// Checks if any% start is selected -- can still start if runner hits No on prompt... not sure how to fix.
	if (settings["anyStart"])
	{
		return ((current.onMainMenu || vars.justBooted) // checks if either on menu or just booted.
			&& current.mainMenuSavesShown
			&& old.mainMenuSavesShown
			&& current.popupPrompt
			&& current.chosePopupOption
		);
	} //checks if wedding start is selected -- will split on *any* save load, need to apply fix.
	else if (settings["weddingStart"])
	{
		return(current.loading
			&& current.mainMenuSavesShown	//main menu only. May need to review for loading the save from pause menu instead
			&& old.mainMenuSavesShown
			&& current.popupPrompt
			&& vars.weddingSlot
		);
	}
	vars.oldSplit = "";
	vars.olderSplit = "";
	vars.lastSplit = "";
}

split
{
	//Final Split check
	if ((current.bslChipper) && (current.CurObj == "MISSION_BIGSMILELEE_ICE_CHIPPER"))
	{
		var Key = "BIG_SMILE_LEE";
		if (!vars.doneSplits.Contains(Key))
		{
			vars.doneSplits.Add(Key);



			vars.lastSplit = Key;
			
			return (settings[Key]);
		}
	}
		
	//General splits at the end of mission
	if ((current.autosaveIconVisible == true) && ((current.saveName != old.saveName) || (current.saveName == vars.firstSplit)))
		//checks if autosave icon is present to split. Additional checks added to prevent double splits after resets, and to guarantee first split works if you reset early.
	{
		var Key = current.saveName;
		if (!vars.doneSplits.Contains(Key))
		{
			vars.doneSplits.Add(Key);

			//debug of splits
			vars.olderSplit = vars.oldSplit;
			vars.oldSplit = vars.lastSplit;


			vars.lastSplit = Key;
			
			return (settings[Key]);
		}
	}
}

onReset
{
	vars.doneSplits.Clear();
}
