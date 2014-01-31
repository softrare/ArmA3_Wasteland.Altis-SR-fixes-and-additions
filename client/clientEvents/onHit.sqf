//	@file Version: 1
//	@file Name: OnHit.sqf
//	@file Author: SoftRare
//	@file Created: 28/01/2014 19:16
//  @file Modified: 28/01/2014 23:35
//	@file Args:

private ["_who"];

_who = _this select 0;

if (_who != player ) exitWith {};

firedOrHitTimer = 0;