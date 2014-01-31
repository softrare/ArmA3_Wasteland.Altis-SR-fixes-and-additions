//	@file Version: 1
//	@file Name: playDead.sqf
//	@file Author: SoftRare
//	@file Created: 28/01/2014 17:05
//  @file Modified: 28/01/2014 23:35
//	@file Args:

if (playingDead < 1) then {

	player playMoveNow "DeadState";
	
	//TODO: "die" using different animations
	//animations: http://community.bistudio.com/wiki/Armed_Assault:_Moves_List
	
	playingDead = 1;
	sleep 1;
	player enablesimulation false;

} else {

	//switchMove or playMove? for some reason playMove doesn't seem to work here
	player switchMove "AmovPpneMstpSnonWnonDnon"; 
	
	playingDead = 0;
	sleep 0.5;
	player enablesimulation true;

};
