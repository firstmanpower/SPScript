//그냥 테스트로 만든거임 데헷
#include <sourcemod>
#include <sdkhooks>
#include <sdktools>

#define MAX_COUNT_TO_SPAWN 5
#define PAL MAXPLAYERS+1
bool var_CreateTrap_Cmd[PAL];
int count[PAL];
int _ents[PAL][MAX_COUNT_TO_SPAWN];

public void OnPluginStart(){

RegAdminCmd("sm_toggle_create_trap", CreateTrap_Cmd, ADMFLAG_SLAY);
AddCommandListener(MedicCMD, "SpawnBread"); //E 키 눌럿을때
HookEvent("arena_round_start", Earena_round_start);

}
public void OnEntityDestroyed(int entity){

int client = findOwner(entity);
if(client){
count[client]--;
}

}
public void Earena_round_start(Event event, const char[] name, bool dontBroadcast){

for(int i; i < MAXPLAYERS+1; i++)count[i] = 0;

}

public bool TracePlayer(int entity, int contentsMask, any data){
	if(IsClientInGame(data))return true;
	return false;
}

public int findOwner(int entity){

for(int i; i < GetClientCount(); i++){

for(int i_; i_ < MAX_COUNT_TO_SPAWN; i_++){
if(entity == _ents[i+1][i_])return i+1;
}

}
return 0;

}

public Action MedicCMD(int client, const char[] command, int argc){
	if(var_CreateTrap_Cmd[client] && count[client] != MAX_COUNT_TO_SPAWN){
	float pos[3];
	GetClientAbsOrigin(client, pos);
	int ent = CreateEntityByName("prop_dynamic");
	DispatchKeyValue(ent, "model", "models/weapons/c_models/c_bread/c_bread_cinnamon.mdl");
	DispatchKeyValue(ent, "solid", "6");
	DispatchKeyValue(ent, "renderamt", "110");
	DispatchKeyValueVector(ent, "origin", pos);
	DispatchSpawn(ent);
	_ents[client][count[client]] = ent;
	SDKHook(ent, SDKHook_StartTouch, entHooking);
	count[client]++;
	
	}
	
    return Plugin_Handled;
}

public Action entHooking(int entity, int other){
if(IsValidEntity(entity) && findOwner(entity) != other){
SDKHooks_TakeDamage(other, 0, 0, 5000.0, 0, -1, NULL_VECTOR, NULL_VECTOR);
AcceptEntityInput(entity, "Kill");
}
return Plugin_Continue;
}


public Action CreateTrap_Cmd(int client, int args){
	var_CreateTrap_Cmd[client] = !var_CreateTrap_Cmd[client];
	if(var_CreateTrap_Cmd[client])PrintToChat(client, "함정 만들기 모드: On");
	else if(!var_CreateTrap_Cmd[client])PrintToChat(client, "함정 만들기 모드: Off");
    return Plugin_Handled;
}
