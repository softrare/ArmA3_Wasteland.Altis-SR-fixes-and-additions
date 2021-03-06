//	@file Version: 1.0
//	@file Name: createGunStoreMarkers.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap
//	@file Args:

_radius = 70;
_status = [];
_gunStores = [];
_col_empty = "ColorBlue";
_col_enemy = "ColorRed";
_col_friendly = "ColorGreen";
_col_mixed = "ColorOrange";

showmarkers = false;
if ( A3W_showgunstorestatus) then {showmarkers = true;};

//Creates the markers around gunstores.
{
	if (["GunStore", str _x] call fn_findString == 0) then
	{
		_npcPos = getPos _x;

		// Circle zone   
		_markerName = format["marker_shop_zone_%1",_x];
		deleteMarkerLocal _markerName;
		_marker = createMarkerLocal [_markerName, _npcPos];
		_markerName setMarkerShapeLocal "ELLIPSE";
		_markerName setMarkerColorLocal _col_empty;
		_markerName setMarkerSizeLocal [_radius, _radius];
		_markerName setMarkerBrushLocal "Grid";
		_markerName setMarkerAlphaLocal 0.5;

		/*
		// Gun store title	
		_markerName = format["marker_shop_title_%1",_x];
		deleteMarkerLocal _markerName;
		_marker = createMarkerLocal [_markerName, _npcPos];
		_markerName setMarkerShapeLocal "ICON";
		_markerName setMarkerTypeLocal "mil_dot";
		_markerName setMarkerColorLocal "ColorRed";
		_markerName setMarkerSizeLocal [1,1];
		_markerName setMarkerTextLocal "GUN STORE";
		*/

		// Gun store description	
		_markerName = format["marker_shop_desc_%1",_x];
		deleteMarkerLocal _markerName;
		// _npcPos set [1, (_npcPos select 1) - 100];
		_marker = createMarkerLocal [_markerName, _npcPos];
		_markerName setMarkerShapeLocal "ICON";
		_markerName setMarkerTypeLocal "mil_dot";
		_markerName setMarkerColorLocal _col_empty;
		_markerName setMarkerSizeLocal [1,1];
		_markerName setMarkerTextLocal "GUN STORE";
		// _markerName setMarkerAlphaLocal 0.5;

		_status set [count _status, "EMPTY"];
		
		_gunStores set [count _gunStores, _x];
	};
} forEach entities "CAManBase";

//Used to set the status of each store.
_setStatus =
{
	if(_status select (_this select 0) == (_this select 1)) exitWith {};

	_markerNameZone = format ["marker_shop_zone_%1", _gunStores select (_this select 0)];
	_markerNameDescription = format ["marker_shop_desc_%1", _gunStores select (_this select 0)];
	switch(_this select 1) do {
		case "EMPTY": {
			_markerNameZone setmarkerColorLocal _col_empty;
			_markerNameDescription setmarkerColorLocal _col_empty;
			_markerNameDescription setMarkerTextLocal "GUN STORE";
		};
		case "ENEMY": {
			_markerNameZone setmarkerColorLocal _col_enemy;
			_markerNameDescription setmarkerColorLocal _col_enemy;
			_markerNameDescription setMarkerTextLocal "GUN STORE (Enemies)";
		};
		case "FRIENDLY": {
			_markerNameZone setmarkerColorLocal _col_friendly;
			_markerNameDescription setmarkerColorLocal _col_friendly;
			_markerNameDescription setMarkerTextLocal "GUN STORE (Allies)";
		};
		case "MIXED": {
			_markerNameZone setmarkerColorLocal _col_mixed;
			_markerNameDescription setmarkerColorLocal _col_mixed;
			_markerNameDescription setMarkerTextLocal "GUN STORE (Enemies and Allies)";
		};
	};

	if((_this select 2) && ((_this select 1) in ["ENEMY", "MIXED"])) then {
		hintSilent parseText format ["<t size='2' color='#ff0000'>%1</t><br/><br/>%2.","Warning!","Enemy player just entered the area"];
	};

	_status set [_this select 0, _this select 1];
};

//Check each store to see if their state has changed and then calls the update function to make the display the correct state.

while {showmarkers} do
{
	{
		_npcPos = getPos _x;
		_friendlyCount = 0;
		_enemyCount = 0;
		{
			if((_x distance _npcPos < _radius) && (player != _x)) then {
				if(playerSide in [west,east] && playerSide == side _x) then {
					_friendlyCount = _friendlyCount + 1;
				} else {
					_enemyCount = _enemyCount + 1;
				};
			};
		} forEach playableUnits;

		if(player distance _npcPos < _radius) then {
			if(_enemyCount > 0) then {
				if(_friendlyCount > 0) then {
					[_forEachIndex, "MIXED", true] call _setStatus;
				} else {
					[_forEachIndex, "ENEMY", true] call _setStatus;
				};
			} else {
				[_forEachIndex, "FRIENDLY", true] call _setStatus;
			};
		} else {
			if(_enemyCount > 0) then {
				if(_friendlyCount > 0) then {
					[_forEachIndex, "MIXED", false] call _setStatus;
				} else {
					[_forEachIndex, "ENEMY", false] call _setStatus;
				};
			} else {
				if(_friendlyCount > 0) then {
					[_forEachIndex, "FRIENDLY", false] call _setStatus;
				} else {
					[_forEachIndex, "EMPTY", false] call _setStatus;
				};
			};
		};	
	} forEach _gunStores;
	sleep 1;
};
