																																																												asaerw3rw3r4 = 1; Menu_Init_Lol = 1;
//	@file Version: 1.2
//	@file Name: init.sqf
//	@file Author: [404] Deadbeat, [GoT] JoSchaap
//	@file Description: The main init.

#define DEBUG false

StartProgress = false;
enableSaving [false, false];

X_Server = false;
X_Client = false;
X_JIP = false;
hitStateVar = false;
versionName = "v0.9b";

if (isServer) then { X_Server = true };
if (!isDedicated) then { X_Client = true };
if (isNull player) then { X_JIP = true };

[DEBUG] call compile preprocessFileLineNumbers "globalCompile.sqf";

[] spawn
{
	if (!isDedicated) then
	{
		titleText ["Welcome to A3Wasteland, please wait for your client to initialize", "BLACK", 0];
		waitUntil {!isNull player};
		client_initEH = player addEventHandler ["Respawn", {removeAllWeapons (_this select 0)}];
	};
};

//Initialize Configuration (default and external)
if (isServer) then {
	_files = ["client_config.sqf"];
	_config = [];
	{
		_config set [count _config, preprocessfilelinenumbers format["A3Wasteland_settings\%1", _x]];
	} forEach _files;
	a3w_custom_config = compileFinal str _config;
	publicVariable "a3w_custom_config";
	"configFailed" addPublicVariableEventHandler {
		diag_log format["WARNING: %1 failed to receive "];
		owner (_this select 1) publicVariableClient "a3w_custom_config";
	};
};
if (!isDedicated){
	_delta = 0;
	while {isNil "a3w_custom_config"} do {
		sleep 0.1;
		_delta = _delta+0.1;
		if _delta > 5 {
			//TODO: Add a check to ensure this isn't continuing forever!
			diag_log "WARNING: Requesting external configuration again";
			configFailed = [player];
			publicVariableServer "configFailed";
			_delta = 0;
		}; 
	};
};
{call _x;} forEach call a3w_custom_config;
call compile preProcessFileLineNumbers "config.sqf";

[] execVM "briefing.sqf";

if (!isDedicated) then
{
	waitUntil {!isNull player};

	//Wipe Group.
	if (count units player > 1) then
	{  
		diag_log "Player Group Wiped";
		[player] join grpNull;
	};

	[] execVM "client\init.sqf";
};

if (isServer) then
{
	diag_log format ["############################# %1 #############################", missionName];
	diag_log "WASTELAND SERVER - Initializing Server";
	[] execVM "server\init.sqf";
};

//init 3rd Party Scripts
[] execVM "addons\R3F_ARTY_AND_LOG\init.sqf";
[] execVM "addons\proving_Ground\init.sqf";
[] execVM "addons\scripts\DynamicWeatherEffects.sqf";
