// Autosplitter and Load Remover for Sleeping Dogs (DE + OG)
// Works for all current categories
// Credits to riekelt, LeoKeidran, Plasma, SneakyEvil, and everyone who tested this

state("SDHDShip")
{
    // Used for splitting the missions
    string48 currentObjective     : 0x02431108, 0x0;
    string32 autosaveInternalName : 0x2409EE0;
    bool     autosaveIconVisible  : 0x02401208, 0x20;
    bool     missionPassedVisible : 0x243120C;

    // Used for final splits
    bool killedSmileyCat    : 0x02378120, 0x30, 0x20, 0x28, 0xA30;
    bool animationChange    : 0x023CE050, 0x18, 0x8, 0x10, 0x90;
    bool bigSmileLeeChipper : 0x02072EE8, 0xF9C;

    // General addresses to know when to start the run
    bool mainMenuSavesShown : 0x23F20B8;
    bool confirmGame        : 0x023E4CA8, 0x10;
    bool gamePaused         : 0x203C95C;
    bool onMainMenu         : 0x242E580;
    bool loading            : 0x0207B000, 0x260;
    bool chosePopupOption   : 0x0249F468, 0x1E8, 0x0, 0xC0, 0x80C;
    bool readSaves          : 0x240A014;
    bool pausedSavesShown   : 0x0235F860, 0x8, 0x6D4;
    float staticHealth      : 0x2088654;

    // Used for the races
    bool inMission     : 0x20234C4;
    bool popupPrompt   : 0x2431090;
    bool genericFail   : 0x02176418, 0x28, 0x10, 0xA64;
    bool raceStartAnim : 0x02421CB8, 0xE8, 0xF8, 0x30, 0x10, 0x30, 0x9C0;

    int socialTab : 0x024014E8, 0x2C;

    int activeRaceMS   : 0x2430BF0, 0xC;
    int activeRaceSec  : 0x2430BF0, 0x8;
    int activeRaceMins : 0x2430BF0, 0x4;

    int finishedRaceMS   : 0x24312F0;
    int finishedRaceSec  : 0x24312EC;
    int finishedRaceMins : 0x24312E8;
}

state("HKShip")
{
    // Used for splitting the missions
    string48 currentObjective     : 0x10F47E4, 0x0;
    string32 autosaveInternalName : 0x10A12B0;
    bool     autosaveIconVisible  : 0x0109B908, 0x10;
    bool     missionPassedVisible : 0x10F492C;

    // Used for final splits
    bool killedSmileyCat    : 0x010E75C8, 0x24, 0xF0, 0x10, 0x790;
    bool animationChange    : 0x0109F0B4, 0x14;
    bool bigSmileLeeChipper : 0x00FF3EA4, 0xA8;

    // General addresses to know when to start the run
    bool mainMenuSavesShown : 0x00AB2C3C, 0x1B8, 0xFCC;
    bool confirmGame        : 0x010F45BC, 0x4C, 0x138, 0xF4, 0x54, 0x3D4, 0x3C, 0xA4;
    bool gamePaused         : 0x10F457C;
    bool onMainMenu         : 0x1091B30;
    bool loading            : 0x0105B3A8;
    bool chosePopupOption   : 0x011124A8, 0x38, 0x2C, 0x8, 0x28C;
    bool readSaves          : 0x10A1154;
    bool pausedSavesShown   : 0x01089C5C, 0x40;
    float staticHealth      : 0x1007314;

    // Used for the races
    bool inMission     : 0x10A3B84;
    bool popupPrompt   : 0x107A28C;
    bool genericFail   : 0x10F4770;
    bool raceStartAnim : 0x0104F0B0, 0x20, 0x1C, 0x13C, 0x0, 0x10, 0x20, 0x2E0;

    int socialTab : 0x0109B8CC, 0x2C;

    int activeRaceMS   : 0x010F4600, 0xC;
    int activeRaceSec  : 0x010F4600, 0x8;
    int activeRaceMins : 0x010F4600, 0x4;

    // Have not found finished race times in memory yet for OG, final time still needs to be manually confirmed
    int finishedRaceMS   : 0x010F4600, 0xC;
    int finishedRaceSec  : 0x010F4600, 0x8;
    int finishedRaceMins : 0x010F4600, 0x4;
}

startup
{
    vars.missionSets = new Dictionary<string, HashSet<string>>()
    {
        { "Any%", new HashSet<string>() {
            "$SGTITLE_WELCOME_TO_HONG_KONG",
            "$SGTITLE_GOING_UNDER",
            "$SGTITLE_VENDOR_EXTORTION",
            "$SGTITLE_VENDOR_FAVOR",
            "$SGTITLE_NIGHT_MARKET_CHASE",
            "$SGTITLE_STICK_UPANDDELIVERY",
            "$SGTITLE_MINI_BUS",
            "$SGTITLE_POPSTAR_1",
            "$SGTITLE_POPSTAR_2",
            "$SGTITLE_AMANDA",
            "$SGTITLE_BAM_BAM_CLUB",
            "$SGTITLE_POPSTAR_3",
            "$SGTITLE_RACE_CASE_START",
            "$SGTITLE_PENDREWS_BUGS",
            "$SGTITLE_TIFFANYS_GUN",
            "$SGTITLE_SWEATSHOP",
            "$SGTITLE_HOTSHOT_LEAD_2",
            "$SGTITLE_UNCLE_PO",
            "$SGTITLE_BRIDE_TO_BE",
            "$SGTITLE_RACE_HOTSHOT_LEAD_3",
            "$SGTITLE_WEDDING",
            "$SGTITLE_HOTSHOT_LEAD_4",
            "$SGTITLE_THE_NEW_BOSS",
            "$SGTITLE_TOP_GLAMOUR_AMBUSH",
            "$SGTITLE_MRS_CHUS_REVENGE",
            "$SGTITLE_FINAL_KILL",
            "$SGTITLE_INITIATION",
            "$SGTITLE_JACKIE_ARRESTED",
            "$SGTITLE_HOSPITAL_SHOOTOUT",
            "$SGTITLE_IMPORTANT_VISITOR",
            "$SGTITLE_FAST_GIRLS",
            "$SGTITLE_BAD_LUCK",
            "$SGTITLE_THE_BIG_HIT",
            "$SGTITLE_THE_FUNERAL",
            "$SGTITLE_CIVIL_DISCORD",
            "$SGTITLE_BURIED_ALIVE",
            "$SGTITLE_THE_ELECTION"
        }},
        { "NiNP", new HashSet<string>() {
            "$SGTITLE_BIG_TROUBLE",
            "$SGTITLE_CHINESE_MAGIC",
            "$SGTITLE_HAPPY_CATS_ARMY",
            "$SGTITLE_CLEAN_OUT_THE_RATS",
            "$SGTITLE_REVENGE_X2",
            "$SGTITLE_GHOSTS_OF_THE_PAST"
        }},
        { "YoTS", new HashSet<string>() {
            "$SGTITLE_ENDOFTHEWORLD",
            "$SGTITLE_ILLUMINATION",
            "$SGTITLE_BOMBSCARE1",
            "$SGTITLE_BOMBSCARE2",
            "$SGTITLE_BOMBSCARE3",
            "$SGTITLE_BOMBBUS",
            "$SGTITLE_HEADOFTHESNAKE",
            "$SGTITLE_SDURIOTS",
            "$SGTITLE_SDUSHOOTER1",
            "$SGTITLE_SDUSHOOTER2",
            "$SGTITLE_SDUVANSHOOTER"
        }},
        { "Wedding%", new HashSet<string>() {
            "$SGTITLE_GOING_UNDER",
            "$SGTITLE_VENDOR_EXTORTION",
            "$SGTITLE_VENDOR_FAVOR",
            "$SGTITLE_NIGHT_MARKET_CHASE",
            "$SGTITLE_STICK_UPANDDELIVERY",
            "$SGTITLE_MINI_BUS",
            "$SGTITLE_POPSTAR_1",
            "$SGTITLE_POPSTAR_2",
            "$SGTITLE_AMANDA",
            "$SGTITLE_BAM_BAM_CLUB",
            "$SGTITLE_POPSTAR_3",
            "$SGTITLE_RACE_CASE_START",
            "$SGTITLE_PENDREWS_BUGS",
            "$SGTITLE_TIFFANYS_GUN",
            "$SGTITLE_SWEATSHOP",
            "$SGTITLE_HOTSHOT_LEAD_2",
            "$SGTITLE_UNCLE_PO",
            "$SGTITLE_BRIDE_TO_BE",
            "$SGTITLE_RACE_HOTSHOT_LEAD_3"
        }}
    };

    vars.firstMissionDetection = new Dictionary<string, string>()
    {
        { "$SGTITLE_WELCOME_TO_HONG_KONG", "Any%" },
        { "$SGTITLE_BIG_TROUBLE",          "NiNP" },
        { "$SGTITLE_ENDOFTHEWORLD",        "YoTS" },
        { "$SGTITLE_GOING_UNDER",          "Wedding%" }
    };

    vars.finalObjectives = new Dictionary<string, string>()
    {
        { "Any%", "$MISSION_BIGSMILELEE_ICE_CHIPPER" },
        { "NiNP", "$MISSION_HC_DEFEAT_HAPPY_CAT" },
        { "YoTS", "MISSION_CNY_EOW_ARRESTSUSPECT" }
    };

    vars.finalMissions = new Dictionary<string, string>()
    {
        { "Wedding%", "$SGTITLE_WEDDING" }
    };

    Func<string, bool, bool, bool> DetectRunType =
        (mission, cSaveIcon, oSaveIcon) =>
        {
            if (
                vars.runType != "Unknown" ||
                (!cSaveIcon || (!oSaveIcon && cSaveIcon))
            )
            {
                return false;
            }

            if (!vars.firstMissionDetection.ContainsKey(mission))
            {
                return false;
            }

            vars.runType = vars.firstMissionDetection[mission];
            vars.completedMissions.Clear();
            vars.lastCompletedMission = "";
            return true;
        };
    vars.DetectRunType = DetectRunType;

    Func<string, bool> IsValidMission =
        (mission) =>
            vars.missionSets.ContainsKey(vars.runType) &&
            vars.missionSets[vars.runType].Contains(mission) &&
            !vars.completedMissions.Contains(mission);
    vars.IsValidMission = IsValidMission;

    Func<string, bool> ShouldFinalSplit =
        (currentObjective) =>
        {
            if (!vars.missionSets.ContainsKey(vars.runType))
            {
                return false;
            }

            if (vars.finalObjectives.ContainsKey(vars.runType))
            {
                return
                    vars.completedMissions.Count ==
                    vars.missionSets[vars.runType].Count &&
                    currentObjective ==
                    vars.finalObjectives[vars.runType];
            }

            return
                vars.completedMissions.Count ==
                vars.missionSets[vars.runType].Count;
        };
    vars.ShouldFinalSplit = ShouldFinalSplit;

    // Race Info
    Func<int, int, int, int> TimeToMs =
        (mins, secs, ms) =>
        {
            return mins * 60000 + secs * 1000 + ms;
        };
    vars.TimeToMs = TimeToMs;
}

init
{
    vars.runType = "Unknown";
    vars.completedMissions = new HashSet<string>();
    vars.lastCompletedMission = "";
    vars.completedMs = 0;
    vars.currentRaceMs = 0;
    vars.startedRace = false;
    vars.activeInRace = false;
    vars.canSplit = false;
}

start
{
    if (
        (current.gamePaused && current.socialTab == 4) &&
        (current.popupPrompt && current.chosePopupOption)
    ) // Loading a race from the social hub
    {
        vars.runType = "Race";
        vars.completedMs   = 0;
        vars.currentRaceMs = 0;
        vars.startedRace   = false;
        vars.activeInRace  = false;
        vars.canSplit      = false;
        return true;
    }
    else if (
        (
            (current.onMainMenu || current.staticHealth == -1) &&
            current.mainMenuSavesShown &&
            old.mainMenuSavesShown &&
            current.popupPrompt &&
            current.chosePopupOption
        ) // New Game from Main Menu
        ||
        (
            current.gamePaused &&
            current.confirmGame &&
            current.readSaves &&
            !current.pausedSavesShown
        ) // Load Save from In Game and Main Menu (Somewhat Unstable on DE)
    )
    {
        vars.runType = "Unknown";
        vars.completedMissions.Clear();
        vars.lastCompletedMission = "";
        vars.canSplit = false;
        return true;
    }
}

update
{
    vars.canSplit = false;

    if (vars.runType == "Unknown")
    {
        if (!(current.onMainMenu || current.gamePaused || current.loading))
        {
            vars.DetectRunType(
                current.autosaveInternalName,
                current.autosaveIconVisible,
                old.autosaveIconVisible
            );
        }

        return;
    }
    else if (vars.runType == "Race")
    {
        if (!current.raceStartAnim && old.raceStartAnim)
        {
            vars.startedRace = true;
        }

        vars.activeInRace =
            vars.startedRace &&
            (
                current.activeRaceMins != old.activeRaceMins ||
                current.activeRaceSec  != old.activeRaceSec  ||
                current.activeRaceMS   != old.activeRaceMS
            );

        if (vars.activeInRace)
        {
            vars.currentRaceMs =
                vars.TimeToMs(
                    current.activeRaceMins,
                    current.activeRaceSec,
                    current.activeRaceMS
                );
        }
        else if (
            (current.chosePopupOption && current.loading) ||
            (current.genericFail && !old.genericFail)
        )
        {
            vars.currentRaceMs = 0;
        }

        if (
            vars.startedRace &&
            !current.inMission &&
            old.inMission &&
            vars.currentRaceMs > 0
        )
        {
            vars.completedMs +=
                vars.TimeToMs(
                    current.finishedRaceMins,
                    current.finishedRaceSec,
                    current.finishedRaceMS
                );

            vars.currentRaceMs = 0;
            vars.activeInRace  = false;
            vars.startedRace   = false;
            vars.canSplit      = true;
        }
    }
    else
    {
        if (!(current.onMainMenu || current.gamePaused || current.loading))
        {
            // Final split is either based on finishing the final objective or seeing the passed screen
            if (vars.ShouldFinalSplit(current.currentObjective))
            {
                bool finalCondition = false;

                if (vars.finalObjectives.ContainsKey(vars.runType))
                {
                    if (vars.runType == "Any%")
                    {
                        finalCondition =
                            !old.bigSmileLeeChipper &&
                            current.bigSmileLeeChipper;
                    }
                    else if (vars.runType == "NiNP")
                    {
                        finalCondition = current.killedSmileyCat;
                    }
                    else if (vars.runType == "YoTS")
                    {
                        finalCondition =
                            !old.animationChange &&
                            current.animationChange;
                    }
                }
                else
                {
                    bool isCorrectFinalMission =
                        vars.finalMissions.ContainsKey(vars.runType) &&
                        old.autosaveInternalName ==
                        vars.finalMissions[vars.runType];

                    finalCondition =
                        isCorrectFinalMission &&
                        !old.missionPassedVisible &&
                        current.missionPassedVisible;
                }

                if (finalCondition)
                {
                    vars.canSplit = true;
                    return;
                }
            }

            // Mission Split
            if (!(!current.autosaveIconVisible || (!old.autosaveIconVisible && current.autosaveIconVisible))) // Only tries to split if the autosave icon is visible
            {
                if (vars.IsValidMission(current.autosaveInternalName))
                {
                    vars.completedMissions.Add(current.autosaveInternalName);
                    vars.lastCompletedMission = current.autosaveInternalName;
                    vars.canSplit = true;
                }
            }
        }
    }
}

split
{
    if (vars.canSplit)
    {
        vars.canSplit = false;
        return true;
    }
}

isLoading
{
    if (vars.runType == "Race")
    {
        return true;
    }

    return current.loading;
}

gameTime
{
    if (vars.runType == "Race")
    {
        return TimeSpan.FromMilliseconds(
            vars.completedMs + vars.currentRaceMs
        );
    }
}

reset
{
    if (vars.runType == "Race")
    {
        return
            vars.startedRace &&
            !current.inMission &&
            vars.currentRaceMs == 0;
    }
}
