#include <sourcemod>
#include <sdktools>
#include <tf2>
#include <tf2_stocks>

#define SUIT_MAX 100 
#define Charging_Seconds 1.0
#define Suit_Damaged_Formula(%1) ( %1 / 4 )
 
bool HEV_enable;

int suit[MAXPLAYERS+1];
char class[50][MAXPLAYERS+1];
char _cond[50][MAXPLAYERS+1];
int health[MAXPLAYERS+1];
int maxhealth[MAXPLAYERS+1];
bool Heal_stoped[MAXPLAYERS+1];
ConVar ED_hev_suit;
Handle TFCond_Timer[MAXPLAYERS+1];

bool IsValidClient(int client){

if(client <= 0)return false;
if(IsClientInGame(client))return true;
return false;

}

void ZeroMemory(char[] str, int strsize){

for(int i; i < strsize; i++){
str[i] = 0;
}

}

bool IsBoss(int client){

if(maxhealth[client] >= 400)return true;
return false;

}

void PrintHudMsg(int client, const char[] Msg, int color[4], int color2[4], float x, float y, float holdtime, int channel = 3, float fxtime = 6.0, float fadeout = 0.1, float fadein = 0.1, int effect = 0){

	Handle hudmsg = StartMessageOne("HudMsg", client);
	
	BfWriteByte(hudmsg, channel) 
	
	BfWriteFloat(hudmsg, x); //x
	BfWriteFloat(hudmsg, y); //y
	
	BfWriteByte(hudmsg, color[0]); //r1
	BfWriteByte(hudmsg, color[1]); //g1
	BfWriteByte(hudmsg, color[2]); //b1
	BfWriteByte(hudmsg, color[3]); //a1
	
	BfWriteByte(hudmsg, color2[0]); //r2
	BfWriteByte(hudmsg, color2[1]); //g2
	BfWriteByte(hudmsg, color2[2]); //b2
	BfWriteByte(hudmsg, color2[3]); //a2
	
	BfWriteByte(hudmsg, effect); //effect
	BfWriteFloat(hudmsg, fadein); //fadeinTime
	BfWriteFloat(hudmsg, fadeout); //fadeoutTime
	BfWriteFloat(hudmsg, holdtime); //holdtime
	
	BfWriteFloat(hudmsg, fxtime); //fxtime //6.0
	BfWriteString(hudmsg, Msg); //Message
	EndMessage();
	
}

public void TF2_OnConditionAdded(int client, TFCond condition){

if(HEV_enable){

if(condition == TFCond_Healing && !IsBoss(client)){

Heal_stoped[client] = false;
TFCond_Timer[client] = CreateTimer(Charging_Seconds, SuitCharge, GetClientSerial(client), TIMER_REPEAT);

}

}

}
public void TF2_OnConditionRemoved(int client, TFCond condition){

if(HEV_enable){

if(condition == TFCond_Healing){

Heal_stoped[client] = true;

}

}


}


public Action SuitCharge(Handle timer, any serial){

int client = GetClientFromSerial(serial);
if(!IsValidClient(client) || !IsPlayerAlive(client) || !TF2_IsPlayerInCondition(client, TFCond_Healing) || IsBoss(client) || Heal_stoped[client])return Plugin_Stop;

suit[client] += 1;
if(suit[client] > SUIT_MAX)suit[client] = SUIT_MAX;
return Plugin_Continue;
}


public void OnGameFrame(){

if(HEV_enable){

for(int i = 1; i <= GetClientCount(); i++){

if(IsValidClient(i) && IsPlayerAlive(i) && TF2_GetClientTeam(i) != TFTeam_Unassigned && TF2_GetClientTeam(i) != TFTeam_Spectator && !IsBoss(i)){


health[i] = GetClientHealth(i);
maxhealth[i] = TF2_GetPlayerResourceData(i, TFResource_MaxHealth);


int pr[3]; 
int sc[3];

pr[0] = GetPlayerWeaponSlot(i, 0);
sc[0] = GetPlayerWeaponSlot(i, 1);
if(IsValidEntity(pr[0])){

pr[1] = GetEntData(pr[0], FindSendPropInfo("CBaseCombatWeapon", "m_iClip1"));
pr[2] = GetEntData(i, GetEntProp(pr[0], Prop_Send, "m_iPrimaryAmmoType")*4+FindSendPropInfo("CBasePlayer", "m_iAmmo"));

}
if(IsValidEntity(sc[0])){

sc[1] = GetEntData(sc[0], FindSendPropInfo("CBaseCombatWeapon", "m_iClip1"));
sc[2] = GetEntData(i, GetEntProp(sc[0], Prop_Send, "m_iPrimaryAmmoType")*4+FindSendPropInfo("CBasePlayer", "m_iAmmo"));

}
if(pr[1] == -1)pr[1] = 0;
if(sc[1] == -1)sc[1] = 0;			
if(sc[2] == -1)sc[2] = 0;
if(pr[2] == -1)pr[2] = 0;
			
switch(TF2_GetPlayerClass(i)){

case TFClass_Scout:{
class[i] = "스카웃";
}
case TFClass_Soldier:{
class[i] = "솔져";
}
case TFClass_Pyro:{
class[i] = "파이로";
}
case TFClass_DemoMan:{
class[i] = "데모맨";
}
case TFClass_Heavy:{
class[i] = "헤비";
}
case TFClass_Engineer:{
class[i] = "엔지니어";
}
case TFClass_Medic:{
class[i] = "메딕";

int weapon = GetPlayerWeaponSlot(i, 1);
int target; 
if(IsValidEntity(weapon))target = GetEntPropEnt(weapon, Prop_Send, "m_hHealingTarget");
if(IsValidClient(target)){
char Info2[50];
char clientname[128];
GetClientName(target, clientname, 128);
Format(Info2, 50, "이름: %s\n상대방 슈트: %d%%", clientname, suit[target], health[target]);
PrintHudMsg(i, Info2, {10, 255, 10, 255}, {10, 255, 10, 255}, -0.030, -1.0, 0.01, 2, 0.1, 0.1);
}

}
case TFClass_Sniper:{
class[i] = "스나이퍼";
}
case TFClass_Spy:{
class[i] = "스파이";
}

}

ZeroMemory(_cond[i], sizeof(_cond));

if(health[i] <= maxhealth[i]/3){
_cond[i] = "나쁨";
}

else if(health[i] <= maxhealth[i]/2){
_cond[i] = "보통";
}

else if(health[i] <= maxhealth[i]-1){
_cond[i] = "좋음";
}

else if(health[i] >= maxhealth[i]){
_cond[i] = "매우 좋음";
}


char Info[300];
Format(Info, 300, "클래스: %s\n체력 상태: %s\n주무기 상태: %d | %d\n보조무기 상태: %d | %d\n슈트: %d", class[i], _cond[i], pr[1], pr[2], sc[1], sc[2], suit[i]);
PrintHudMsg(i, Info, {255, 165, 0, 255}, {255, 165, 0, 255}, 0.030, -1.0, GetGameFrameTime(), 3, 0.05, 0.05);

}
else{

suit[i] = 0;

}

}

}

}





public void OnPluginStart(){
ED_hev_suit = CreateConVar("ED_hev_suit", "0", "", FCVAR_REPLICATED, true, 0.0, true, 1.0);
HookConVarChange(ED_hev_suit,  ED_hev_suitCB);
HookEvent("player_spawn", PlayerSpawn);
HookEvent("player_hurt", PlayerHurt);
RegAdminCmd("sm_setsuit", setsuit, ADMFLAG_SLAY);
}

public Action setsuit(int client, int args){

if(HEV_enable){

char arg1[32], arg2[32];

GetCmdArg(1, arg1, sizeof(arg1));
GetCmdArg(2, arg2, sizeof(arg2));

if(args != 2)return Plugin_Handled;

char target_name[MAX_TARGET_LENGTH];
int target_list[MAXPLAYERS+1], target_count;
bool tn_is_ml;
 
if ((target_count = ProcessTargetString(arg1,client,target_list,MAXPLAYERS,COMMAND_FILTER_ALIVE,target_name,MAX_TARGET_LENGTH,tn_is_ml)) <= 0){
	ReplyToTargetError(client, target_count);
	return Plugin_Handled;
}
 
for (int i = 0; i < target_count; i++){
suit[target_list[i]] = StringToInt(arg2);
if(suit[target_list[i]] > SUIT_MAX)suit[target_list[i]] = SUIT_MAX;
}

}
 
return Plugin_Handled;
}

public void ED_hev_suitCB(ConVar convar, const char[] oldValue, const char[] newValue){
HEV_enable = ED_hev_suit.BoolValue;
}

public void PlayerHurt(Event event, const char[] name, bool dontBroadcast){

if(HEV_enable){

int client = GetClientOfUserId(event.GetInt("userid"));
int attacker = GetClientOfUserId(event.GetInt("attacker"));
int damage = event.GetInt("damageamount");
if(suit[client] != 0){
suit[client] -= Suit_Damaged_Formula(damage);
if(suit[client] < 0)suit[client] = 0;
SetEntityHealth(client, event.GetInt("health")+(damage%(suit[client]+1)-1));
}

}

}

public void PlayerSpawn(Event event, const char[] name, bool dontBroadcast){

if(HEV_enable){

int client = GetClientOfUserId(event.GetInt("userid"));
suit[client] = 0;

}

}

