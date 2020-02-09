#include <sourcemod>
#include <sdktools>
#include <tf2>
#include <tf2_stocks>
#include <sdkhooks>
#define WAIT_SECONDS 30
#define START2_SECONDS 180
#define MAFIA_N 2
#define MTP_N 2
#define MAFIA_TEAM 3
#define OTHER_TEAM 2
#define STALEMATE 0


Handle Beg_Timer;
Handle Waitting_Timer;
int WT_S = WAIT_SECONDS;
int BG_S = START2_SECONDS;
ConVar Mafia_Mod;
int mafia[MAFIA_N];
int MTP[MTP_N];
bool death[MAXPLAYERS+1];
bool MM;
bool M_Selected;
bool global_check[MAXPLAYERS+1];
bool global_RoundEnd;
bool Wins[2];

bool IsValidClient(int client){

if(client <= 0 || client > GetClientCount())return false;

if(IsClientInGame(client))return true;

return false;

}

void TF_SetClass(int client, TFClassType class){

if(IsValidClient(client)){
TF2_SetPlayerClass(client, class, false, false);
TF2_RemoveAllWeapons(client);
TF2_RegeneratePlayer(client);
}

}

int GetClientAliveCount(){

int count;

for(int i; i < GetClientCount(); i++){
if(IsValidClient(i+1))if(GetClientTeam(i+1) != 0 && GetClientTeam(i+1) != 1)count++;
}

return count;

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


bool CheckMTP(int client){

for(int i; i < MAFIA_N; i++){
if(MTP[i] == client)return true;
}
return false;
}

bool CheckMafia(int client){

for(int i; i < MAFIA_N; i++){
if(mafia[i] == client)return true;
}
return false;

}

int Num_MAlive(){

int count;
for(int i; i < GetClientCount(); i++){

if(IsValidClient(i+1))
if(!death[i+1] && GetClientTeam(i+1) == OTHER_TEAM && CheckMafia(i+1))
count++;

}

return count;

}

int Num_Alive(){

int count;
for(int i; i < GetClientCount(); i++){

if(IsValidClient(i+1))
if(!death[i+1] && GetClientTeam(i+1) == OTHER_TEAM && !CheckMafia(i+1))
count++;

}

return count;

}
void EntRemoveAll(const char[] classname){
int ent = -1;
int ref;
while ((ent = FindEntityByClassname(ent, classname)) != -1){

ref = EntIndexToEntRef(ent);  

AcceptEntityInput(ref, "Kill");

}

}

void GiveWeapon(int client){

if(IsValidClient(client)){
TF2_RegeneratePlayer(client);
TF2_RemoveWeaponSlot(client, 2);
TF2_RemoveWeaponSlot(client, 3);
TF2_RemoveWeaponSlot(client, 4);
TF2_RemoveWeaponSlot(client, 5);
}

}


void GetRandomMTP(int[] Police){

if(GetClientAliveCount() > MAFIA_N+MTP_N){
bool Check;

for(int i; i < MTP_N; i++){

if(Check){

Police[i] = GetRandomInt(1, GetClientCount());

if(Police[i-1] == Police[i] || !GetClientTeam(Police[i]) || GetClientTeam(Police[i]) == 1 || CheckMafia(Police[i])){

i--;
continue;

}

break;

}

Police[i] = GetRandomInt(1, GetClientCount());

if(!GetClientTeam(Police[i]) || GetClientTeam(Police[i]) == 1 || CheckMafia(Police[i])){
i--;
continue;
}

Check = true;

}

}

}

void GetRandomMafia(int[] maf){

if(GetClientAliveCount() > MAFIA_N+MTP_N){

bool Check;

for(int i; i < MAFIA_N; i++){

if(Check){

maf[i] = GetRandomInt(1, GetClientCount());

if(maf[i-1] == maf[i] || !GetClientTeam(maf[i]) || GetClientTeam(maf[i]) == 1 || CheckMTP(maf[i])){

i--;
continue;

}

break;

}

maf[i] = GetRandomInt(1, GetClientCount());

if(!GetClientTeam(maf[i]) || GetClientTeam(maf[i]) == 1 || CheckMTP(maf[i])){
i--;
continue;
}

Check = true;

}

}

}


public void OnPluginEnd(){

CloseHandle(Beg_Timer);
CloseHandle(Waitting_Timer);
WT_S = WAIT_SECONDS;
BG_S = START2_SECONDS;
M_Selected = false;
MM = false;

}
public void OnPluginStart(){
Mafia_Mod = CreateConVar("fmp_mafia_mod", "0", "", FCVAR_PROTECTED, true, 0.0, true, 2.0);
HookEvent("player_spawn", HE_PlayerSpawn_CB);
HookEvent("teamplay_round_active", HE_Round_Start);
HookEvent("teamplay_round_win", HE_Round_End);

}

bool _strcmp(const char[] str, const char[] str2){

int count;
int i2;
for(int i; str[i] != 0 && str2[i] != 0; i++){
if(str[i] == str2[i])count++;
i2++;
}

if(i2 == count)return true;
return false;

}
void copystring(int startpos, const char[] str, char[] str2, int str2size){

int i2;
for(int i = startpos; str[i] != 0 && i != str2size; i++){
str2[i2] = str[i];
i2++;
}

}

void PrintToChatTeam(int team, const char[] msg, int client){

char Name[200];

if(IsValidClient(client)){
GetClientName(client, Name, sizeof(Name));
}

if(team == 1){

for(int i; i < GetClientCount(); i++){

if(IsValidClient(i+1)){
if(!CheckMafia(i+1))PrintToChat(i+1, "\x03%s: %s", Name, msg);
}

}

}
else if(team == 2){

for(int i; i < MAFIA_N; i++){

if(IsValidClient(mafia[i])){
PrintToChat(mafia[i], "\x03%s: %s", Name, msg);
}

}

}
	

}
public Action OnClientSayCommand(int client, const char[] command, const char[] sArgs){

if(MM){

char fixed[500];
if(_strcmp(sArgs, "s ")){

copystring(2, sArgs, fixed, sizeof(fixed));
if(CheckMafia(client))PrintToChatTeam(2, fixed, client);
else PrintToChatTeam(1, fixed, client);

return Plugin_Handled;
}

}

return Plugin_Continue;

}


public Action TF2_CalcIsAttackCritical(int client, int weapon, char[] weaponname, bool& result){

if(MM){

if(TF2_GetPlayerClass(client) == TFClass_Spy && weapon == GetPlayerWeaponSlot(client, 0)){
int target = GetClientAimTarget(client, true);
if(IsValidClient(target))
if(TF2_GetPlayerClass(target) == TFClass_Spy)
SDKHooks_TakeDamage(target, 0, 0, 9999.0, 0, -1, NULL_VECTOR,NULL_VECTOR);
}

}

return Plugin_Continue;
}

public void HE_Round_End(Event event, const char[] name, bool dontBroadcast){


if(MM){


global_RoundEnd = true;
M_Selected = false;
static char Name[128];
float slot;
for(int i; i < MAFIA_N; i++){

if(IsValidClient(mafia[i])){
GetClientName(mafia[i], Name, sizeof(Name));

for(int i2; i2 < GetClientCount(); i2++){

if(IsValidClient(i2+1)){
SetHudTextParams(-1.0, -0.73+slot, 12.0, 255, 0, 0, 255);
ShowHudText(i2+1, -1, "마피아%d: %s", i+1, Name);
}

}

slot += 0.025;

}

}

if(Wins[0])
PrintCenterTextAll("마피아 승리!");
else
PrintCenterTextAll("시민 승리!");

}


}

public void HE_Round_Start(Event event, const char[] name, bool dontBroadcast){

if(MM){

global_RoundEnd = false;
M_Selected = true;
Wins[0] = false;
Wins[1] = false;
WT_S = WAIT_SECONDS;
BG_S = START2_SECONDS;

Waitting_Timer = CreateTimer(1.0, Waitting_TimerCB, INVALID_HANDLE, TIMER_REPEAT);
EntRemoveAll("team_round_timer");
EntRemoveAll("func_tracktrain");
EntRemoveAll("func_regenerate");
EntRemoveAll("func_door");
EntRemoveAll("func_respawnroomvisualizer");
EntRemoveAll("func_Respawnroom");
EntRemoveAll("func_brush");

GetRandomMafia(mafia);
GetRandomMTP(MTP);


for(int i; i < GetClientCount(); i++){

if(IsValidClient(i+1)){

if(GetClientTeam(i+1) != 0 && GetClientTeam(i+1) != 1){
death[i+1] = false;
global_check[i+1] = false;
TF_SetClass(i+1, TFClass_Spy);

TF2_RespawnPlayer(i+1);
TF2_RemoveWeaponSlot(i+1, 0);
TF2_RemoveWeaponSlot(i+1, 2);
TF2_RemoveWeaponSlot(i+1, 3);
TF2_RemoveWeaponSlot(i+1, 4);
TF2_RemoveWeaponSlot(i+1, 5);
SetEntPropEnt(i+1, Prop_Send, "m_hActiveWeapon", GetPlayerWeaponSlot(i+1, 1));
}

}

}




}

}

public void HE_PlayerSpawn_CB(Event event, const char[] name, bool dontBroadcast){

int client = GetClientOfUserId(event.GetInt("userid"));

if(MM){



if(death[client]){

TF_SetClass(client, TFClass_Engineer);
global_check[client] = true;
return;

}


ChangeClientTeam(client, OTHER_TEAM);
TF_SetClass(client, TFClass_Spy);

}


}




public void OnGameFrame(){



if(MM){

if(GetClientAliveCount() > MAFIA_N+MTP_N){

for(int i; i < GetClientCount(); i++){

if(IsValidClient(i+1)){

if(GetClientTeam(i+1) == 3){
ChangeClientTeam(i+1, OTHER_TEAM);
TF_SetClass(i+1, TFClass_Spy);
TF2_RespawnPlayer(i+1);
}

if(!global_check[i+1] && TF2_GetPlayerClass(i+1) != TFClass_Spy){
ChangeClientTeam(i+1, OTHER_TEAM);
TF_SetClass(i+1, TFClass_Spy);
TF2_RespawnPlayer(i+1);
}

if(!IsPlayerAlive(i+1)){

if(GetClientTeam(i+1) != 0 && GetClientTeam(i+1) != 1 && !death[i+1]){
death[i+1] = true; 
ChangeClientTeam(i+1, OTHER_TEAM);
TF_SetClass(i+1, TFClass_Spy);
TF2_RespawnPlayer(i+1);
}

}

}

}

if(M_Selected){

if(Num_Alive() == 0){

Wins[0] = true;

ForceWin(OTHER_TEAM);
}

else if(Num_MAlive() == 0){

Wins[1] = true;

ForceWin(OTHER_TEAM);

}

}

}
else{

ForceWin(STALEMATE);
MM = false;
M_Selected = false;
WT_S = WAIT_SECONDS;
BG_S = START2_SECONDS;

}

}

if(Mafia_Mod.IntValue == 1){

if(GetClientAliveCount() > MAFIA_N+MTP_N){
ForceWin(STALEMATE);

MM = true;

ServerCommand("mp_teams_unbalance_limit 0");
ServerCommand("mp_waitingforplayers_cancel 1");
 
}
else{

PrintToServer("you must have more than %d players in your server!", MAFIA_N+MTP_N);

}

Mafia_Mod.SetInt(0);

}

else if(Mafia_Mod.IntValue == 2){

if(GetClientAliveCount() > MAFIA_N+MTP_N){
ForceWin(STALEMATE);

MM = false;

ServerCommand("mp_teams_unbalance_limit 0");
ServerCommand("mp_waitingforplayers_cancel 0");

}
else{

PrintToServer("you must have more than %d players in your server!", MAFIA_N+MTP_N);

}

Mafia_Mod.SetInt(0);

}


}

int global_MCount;
int global_MTPCount;

public Action Waitting_TimerCB(Handle timer){


if(global_RoundEnd)return Plugin_Stop;

WT_S--;
global_MCount++;
global_MTPCount++;

if(!(global_MCount >= 5)){

for(int i; i < MAFIA_N; i++){

if(IsValidClient(mafia[i])){
SetHudTextParams(-1.0, -0.55, 10.0, 255, 0, 0, 255);
ShowHudText(mafia[i], -1, "당신은 마피아 입니다!");
}

}

}

if(!(global_MTPCount >= 5))
for(int i; i < MTP_N; i++){

if(IsValidClient(MTP[i])){
SetHudTextParams(-1.0, -0.55, 10.0, 255, 0, 0, 255);
ShowHudText(MTP[i], -1, "당신은 경찰 입니다!");
}

}

if(WT_S <= 0){
Beg_Timer = CreateTimer(1.0, Beg_TimerCB, INVALID_HANDLE, TIMER_REPEAT);

for(int i; i < MAFIA_N; i++){

if(IsValidClient(mafia[i])){
GiveWeapon(mafia[i]);
SetEntPropEnt(mafia[i], Prop_Send, "m_hActiveWeapon", GetPlayerWeaponSlot(mafia[i], 1));
}

}

for(int i; i < MTP_N; i++){

if(IsValidClient(MTP[i])){
GiveWeapon(MTP[i]);
SetEntPropEnt(MTP[i], Prop_Send, "m_hActiveWeapon", GetPlayerWeaponSlot(MTP[i], 1));
}

}

global_MCount = 0;
global_MTPCount = 0;

return Plugin_Stop;
}

for(int i; i < GetClientCount(); i++){

if(IsValidClient(i+1)){
SetHudTextParams(-1.0, -1.0, 1.0, 255, 0, 0, 255);
ShowHudText(i+1, -1, "%d 초 동안 도망갈시간!", WT_S);

}

}


return Plugin_Continue;
}

public Action Beg_TimerCB(Handle timer){

if(global_RoundEnd)return Plugin_Stop;

BG_S--;

if(BG_S <= 0){
for(int i; i < MAFIA_N; i++)ChangeClientTeam(mafia[i], MAFIA_TEAM);
ForceWin(STALEMATE);
M_Selected = false;
return Plugin_Stop;
}

for(int i; i < GetClientCount(); i++){

if(IsValidClient(i+1)){
SetHudTextParams(-1.0, -0.7, 1.0, 255, 0, 0, 255);
ShowHudText(i+1, -1, "%d 초 동안 마피아들이 활동하기 시작합니다!", BG_S);
}

}

return Plugin_Continue;
}



