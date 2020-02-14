#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <tf2_stocks>

static float null_vec[3] = {0.0, 0.0, 0.0};

float radius;
float dmg;

ConVar explode_radi;
ConVar explode_dmg;


public void OnGameFrame(){

radius = explode_radi.FloatValue;
dmg = 	explode_dmg.FloatValue;

}



public void OnPluginStart(){

AddCommandListener(explode, "explode");
explode_radi = CreateConVar("explode_radi", "500.0", "", FCVAR_REPLICATED);
explode_dmg = CreateConVar("explode_dmg", "300.0", "", FCVAR_REPLICATED);

}

public Action explode(int client, const char[] command, int argc){

	if(TF2_GetClientTeam(client) == TFTeam_Spectator || TF2_GetClientTeam(client) == TFTeam_Unassigned || !IsPlayerAlive(client))return Plugin_Continue;
	
	float vec[3];
	GetEntPropVector(client, Prop_Send, "m_vecOrigin", vec);
	
	for(int i = 1; i <= GetClientCount(); i++){
	
	if(TF2_GetClientTeam(client) != TF2_GetClientTeam(i)){
	
	float vec2[3];
	GetEntPropVector(i, Prop_Send, "m_vecOrigin", vec2);
	
	if(GetVectorDistance(vec, vec2, false) <= radius)
	SDKHooks_TakeDamage(i, client, client, dmg/(GetVectorDistance(vec, vec2, false)/150), 0, -1, null_vec, vec2);
		
		
	}
	
	}
	
	return Plugin_Continue;
	
}
