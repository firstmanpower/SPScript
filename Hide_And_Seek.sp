#include <sourcemod>
#include <sdktools>
#include <tf2>
#include <tf2_stocks>
#define HUNTERS 2
#define STALEMATE 0
#define RED 2
#define BLU 3
#define HUNTERS_TEAM BLU
#define IT_TEAM RED
#define COUNT 60
#define TIME_TO_HUNT_IT 180

int hunter[HUNTERS];
ConVar HAS_CV;
bool CV_VChanged;
bool RoundEnd;
bool RoundStart;
bool WaittingPlayers;
int count = COUNT;
int TTHI = TIME_TO_HUNT_IT;
int death[MAXPLAYERS+1];
bool StartGame;
Handle Timer1;
Handle Timer2;
int _client_count;

public void OnEntityCreated(int entity, const char[] classname){

if(HAS_CV.BoolValue){
if(StrEqual(classname, "tf_ragdoll")){
AcceptEntityInput(entity, "Kill");
}
}

}

bool IsValidClient(int client){

if(client <= 0 || client > GetClientCount())return false;

if(IsClientInGame(client))return true;

return false;

}

int GetClientAliveCount(){

int count_;

for(int i; i < GetClientCount(); i++){
if(IsValidClient(i+1))if(GetClientTeam(i+1) != 0 && GetClientTeam(i+1) != 1)count_++;
}

return count_;

}

bool IsRealPlayer(int client){

if(IsValidClient(client)){if(GetClientTeam(client) != 0 && GetClientTeam(client) != 1)return true;
else return false;
}

return false;

}

void GetHunter(int[] _hunter){
													
if(GetClientAliveCount() >= HUNTERS && !(GetClientAliveCount() <= 0)){

for(int i; i < HUNTERS; i++){

if(_hunter[i] > GetClientCount())_client_count = 0;
if(i > 0)if(_hunter[i-1] == _hunter[i]){

_client_count++;
_hunter[i] = _client_count;

if(!IsRealPlayer(_hunter[i])){
i--;
continue;
}

}
_client_count++;
_hunter[i] = _client_count;
if(!IsRealPlayer(_hunter[i])){
i--;
continue;
}


}

}

}
bool CheckHunter(int client){

for(int i; i < HUNTERS; i++){
if(hunter[i] == client)return true;
}
return false;
}

void _ChangeTeam(int client){

if(IsValidClient(client)){
if(CheckHunter(client)){
ChangeClientTeam(client, HUNTERS_TEAM);
TF2_RespawnPlayer(client);
}
else{
ChangeClientTeam(client, IT_TEAM);
TF2_RespawnPlayer(client);
}

}

}


void ForceWin(int team){
int ent = -1;
ent = FindEntityByClassname(ent, "game_round_win");
if(ent == -1){

ent = CreateEntityByName("game_round_win");
if(IsValidEntity(ent))DispatchSpawn(ent);

}

if(ent != -1){
SetVariantInt(team);
AcceptEntityInput(ent, "SetTeam");
AcceptEntityInput(ent, "RoundWin");
}

}


public void OnPluginStart(){

HAS_CV = CreateConVar("fmp_hide_and_seek", "0", NULL_STRING, FCVAR_PROTECTED, true, 0.0, true, 1.0);

HookEvent("teamplay_round_active", Round_Start);
HookEvent("teamplay_round_win", Round_End);
HookEvent("player_spawn", Player_Spawn);
RegConsoleCmd("sm_cvt", cvt);
}

public Action cvt(int client, int args){
GetHunter(hunter);
for(int i; i < HUNTERS; i++){
PrintToServer("|%d|", hunter[i]);
}
return Plugin_Handled;
}


float IntToFloat(int value){

char text[60];
Format(text, sizeof(text), "%d", value);
return StringToFloat(text);

}
void EntRemoveAll(const char[] classname){
int ent = -1;
int ref;
while ((ent = FindEntityByClassname(ent, classname)) != -1){

ref = EntIndexToEntRef(ent);  

AcceptEntityInput(ref, "Kill");

}

}



public void Player_Spawn(Event event, const char[] name, bool dontBroadcast){
int client = GetClientOfUserId(event.GetInt("userid"));
if(HAS_CV.BoolValue)if(!CheckHunter(client) && !death[client]){
TF2_AddCondition(client, TFCond_StealthedUserBuffFade, TFCondDuration_Infinite, 0);
CreateTimer(1.0, TestTimer, GetClientSerial(client));
TF2_RemoveAllWeapons(client);
}

}

public Action TestTimer(Handle timer, any serial){

int client = GetClientFromSerial(serial);
if(!IsValidClient(client))return Plugin_Continue;
TF2_AddCondition(client, TFCond_UberchargedCanteen, 1.0, 0);
return Plugin_Continue;
}

public void Round_End(Event event, const char[] name, bool dontBroadcast){

RoundEnd = true;
StartGame = false;
for(int i; i < GetClientCount(); i++)if(!CheckHunter(i+1) && IsValidClient(i+1))SetEntityMoveType(i+1, MOVETYPE_WALK);

}

public void Round_Start(Event event, const char[] name, bool dontBroadcast){

RoundEnd = false;
StartGame = false;

if(HAS_CV.BoolValue){

EntRemoveAll("team_round_timer");
EntRemoveAll("func_tracktrain");
EntRemoveAll("func_regenerate");
EntRemoveAll("func_door");
EntRemoveAll("func_respawnroomvisualizer");
EntRemoveAll("func_Respawnroom");
EntRemoveAll("func_brush");

GetHunter(hunter);

Timer1 = CreateTimer(1.0, Counting, INVALID_HANDLE, TIMER_REPEAT);

for(int i; i < MAXPLAYERS+1; i++)death[i] = false;

for(int i; i < GetClientCount(); i++)_ChangeTeam(i+1);


}

}


public Action StartTimer(Handle timer){


TTHI--;

if(!HAS_CV.IntValue || RoundEnd){
for(int i; i < HUNTERS; i++)TF2_RemoveCondition(hunter[i], TFCond_FreezeInput);
TTHI = TIME_TO_HUNT_IT;
StartGame = false;
return Plugin_Stop;
}

if(TTHI <= 0){
ForceWin(IT_TEAM);
StartGame = false;
TTHI = TIME_TO_HUNT_IT;
return Plugin_Stop;
}

for(int i; i < GetClientCount(); i++){

if(IsValidClient(i+1)){
SetHudTextParams(-1.0, -0.7, 1.0, 255, 100, 50, 255);
ShowHudText(i+1, -1, "%d 초동안 살아 남을시간!", TTHI);
}

}

StartGame = true;

return Plugin_Continue;
}

public Action Counting(Handle timer){

count--;

if(!HAS_CV.BoolValue || RoundEnd){
for(int i; i < HUNTERS; i++)TF2_RemoveCondition(hunter[i], TFCond_FreezeInput);

count = COUNT;
return Plugin_Stop;
}

if(count <= 0){
for(int i; i < HUNTERS; i++)TF2_RemoveCondition(hunter[i], TFCond_FreezeInput);
Timer2 = CreateTimer(1.0, StartTimer, INVALID_HANDLE, TIMER_REPEAT);

for(int i; i < GetClientCount(); i++)if(!CheckHunter(i+1) && IsValidClient(i+1))SetEntityMoveType(i+1, MOVETYPE_NONE);

count = COUNT;
return Plugin_Stop;
}

for(int i; i < GetClientCount(); i++){

if(IsValidClient(i+1)){
SetHudTextParams(-1.0, -0.7, 1.0, 255, 100, 50, 255);
ShowHudText(i+1, -1, "%d 초동안 숨을 시간!", count);
}

}

for(int i; i < HUNTERS; i++)TF2_AddCondition(hunter[i], TFCond_FreezeInput, TFCondDuration_Infinite, 0);

return Plugin_Continue;
}





int ITAliveCount(){

int _count;

for(int i; i < GetClientCount(); i++){
if(!death[i+1] && !CheckHunter(i+1) && GetClientTeam(i+1) == IT_TEAM)_count++;
}

return _count;

}

public void OnGameFrame(){

if(HAS_CV.BoolValue){

for(int i; i < GetClientCount(); i++){
if(IsValidClient(i+1)){

if(CheckHunter(i+1) && GetClientTeam(i+1) == IT_TEAM)_ChangeTeam(i+1);
if(!CheckHunter(i+1) && GetClientTeam(i+1) == HUNTERS_TEAM)_ChangeTeam(i+1);
if(GetClientTeam(i+1) == HUNTERS_TEAM && TF2_IsPlayerInCondition(i+1, TFCond_StealthedUserBuffFade))TF2_RemoveCondition(i+1, TFCond_StealthedUserBuffFade);
if(!StartGame && !IsPlayerAlive(i+1) && GetClientTeam(i+1) != 0 && GetClientTeam(i+1) != 1)_ChangeTeam(i+1);

}

}

}



if(StartGame){


for(int i; i < GetClientCount(); i++){

if(IsValidClient(i+1)){
if(!IsPlayerAlive(i+1) && !CheckHunter(i+1) && GetClientTeam(i+1) == IT_TEAM)death[i+1] = true;

}

}

if(ITAliveCount() == 0){

ForceWin(HUNTERS_TEAM);

}


}

if(!(GetClientAliveCount() >= HUNTERS+1) && HAS_CV.BoolValue){
HAS_CV.SetBool(false);
PrintToServer("you must have more than %d players in your server!", HUNTERS);
}

if(HAS_CV.BoolValue && !CV_VChanged){

CV_VChanged = true;
ForceWin(STALEMATE);
ServerCommand("mp_waitingforplayers_cancel 1");
ServerCommand("mp_teams_unbalance_limit 0");

}

else if(!HAS_CV.BoolValue&& CV_VChanged){

CV_VChanged = false;

}


}
