//	@file Version: 1
//	@file Name: OnFired.sqf
//	@file Author: SoftRare
//	@file Created: 28/01/2014 19:20
//  @file Modified: 28/01/2014 23:30
//	@file Args:

private ["_who"];

_who = _this select 0;

if (_who != player ) exitWith {};

firedOrHitTimer = 0;