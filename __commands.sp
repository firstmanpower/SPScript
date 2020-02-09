#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <tf2>
#include <tf2_stocks>


#define TF_SCOUT 1
#define TF_SNIPER 2
#define TF_SOLDIER 3
#define TF_DEMOMAN 4
#define TF_MEDIC 5
#define TF_HEAVY 6
#define TF_PYRO 7
#define TF_SPY 8
#define TF_ENGINEER 9


public void OnPluginStart(){


RegAdminCmd("_commands", _commands, ADMFLAG_GENERIC);
AddCommandListener(CMD1, "mp_spawnplayer");
AddCommandListener(CMD2, "currentadmins");
AddCommandListener(CMD3, "mp_setplayerclass");
AddCommandListener(CMD4, "mp_setplayermodel");
AddCommandListener(CMD5, "mp_setmaxhealth");
}

bool IsAdmin(int client){
if(GetUserAdmin(client) != INVALID_ADMIN_ID && IsClientInGame(client))return true;
return false;
}

int sizeofstring(const char[] str){
int i;

while(true){

if(str[i] == 0)return i;
i++;

}


}
bool _IsNullString(const char[] str){return !str[0];}

void CheckClientName(){

char clientname[100];
char oldclientname[100];
for(int i; i < GetClientCount(); i++){
GetClientName(i+1, clientname, sizeof(clientname));
GetClientName(i+1, oldclientname, sizeof(oldclientname));
if(_strcmp(clientname, "num:")){
clientname[0] = 'X';
clientname[1] = 'X';
clientname[2] = 'X';
clientname[3] = 'X';
}
for(int i2; i2 < sizeofstring(clientname); i2++){
if(clientname[i2] == '|')clientname[i2] = 'N';
}

if(!StrEqual(clientname, oldclientname)){
SetClientName(i+1, clientname);
}

}

}


void __copystring(int startpos, char[] str, char[] str2, int str2size){

int i = startpos;
int i2;
while(true){

if(str[i] == 0 || i2 == str2size)return;
str2[i2] = str[i];
i++;
i2++;

}


}

void _copystring(int startpos, const char[] str, char[] str2, int str2size){

int i = startpos;
int i2;
while(true){

if(str[i] == 0 || i2 == str2size)return;
str2[i2] = str[i];
i++;
i2++;

}


}

int _StringToInt(const char[] str){

int i;
int i2;
char copy[50];
while(true){

if(str[i] == 0)return StringToInt(copy);
switch(str[i]){
case '1':{copy[i2] = '1';i2++;}
case '2':{copy[i2] = '2';i2++;}
case '3':{copy[i2] = '3';i2++;}
case '4':{copy[i2] = '4';i2++;}
case '5':{copy[i2] = '5';i2++;}
case '6':{copy[i2] = '6';i2++;}
case '7':{copy[i2] = '7';i2++;}
case '8':{copy[i2] = '8';i2++;}
case '9':{copy[i2] = '9';i2++;}
case '0':{copy[i2] = '0';i2++;}
}
i++;


}



}

bool Bool_CheckArraysValue(bool[] array, bool value,int arraysize){

for(int i; i < arraysize; i++){

if(array[i] != value)return false;

}

return true;
}

int _findstring(const char[] str, const char[] str2){

int i;

bool[] i2 = new bool[sizeofstring(str2)];
int i2_1;
while(true){
	
if(i2_1 == sizeofstring(str2))if(Bool_CheckArraysValue(i2, true, sizeofstring(str2)))return i;

if(str[i] == 0 || str2[i2_1] == 0)return 0;

if(str[i] == str2[i2_1]){i2[i2_1] = true; i2_1++;}
i++;


}



return 0;

}
int findstring(int startpos, const char[] str){

int i = startpos;
int i2;
while(true){

if(str[i] == 0)return i2;
i++;
i2++;

}



}
bool _strcmp(const char[] str, const char[] str2){

int i;
while(true){

if(str[i] == 0 || str2[i] == 0)return false;
if(str[i] == str2[i] && str[i+1] == 0 || str2[i+1] == 0)return true;
i++;

}


}
int _findplayer(char[] str, const char[] without){

char clientname[100];
int value = _findstring(str, "||")-2;
for(int i; i < GetClientCount(); i++){

if(IsClientInGame(i+1)){
GetClientName(i+1, clientname, sizeof(clientname));

for(int i2; i2 < sizeofstring(without); i2++){

str[value+i2] = 0;
i2++;

}

if(StrEqual(str, clientname))return i+1;
}

}

return 0;

}

int findplayer(const char[] str){

char clientname[100];

for(int i; i < GetClientCount(); i++){

if(IsClientInGame(i+1)){
GetClientName(i+1, clientname, sizeof(clientname));
if(StrEqual(str, clientname))return i+1;
}

}

return 0;
}

void _TFSetPlayerClass(int client, int class){

if(IsClientInGame(client)){

SetEntProp(client, Prop_Send, "m_iClass", class);

TF2_RemoveAllWeapons(client);
TF2_RegeneratePlayer(client);

}

}

void _TFRespawnPlayer(int client){

float pos[3], angle[3];
if(IsClientInGame(client)){

if(IsPlayerAlive(client)){
GetClientAbsOrigin(client, pos);
GetClientEyeAngles(client, angle);
TF2_RespawnPlayer(client);
TeleportEntity(client, pos, angle, NULL_VECTOR);

}
else{
TF2_RespawnPlayer(client);
}

}


}

int GetClientWithTrace(int client){

float pos[3], angle[3];

GetClientAbsOrigin(client, pos);
GetClientEyeAngles(client, angle);

pos[2] += 80.0;
TR_TraceRayFilter(pos, angle, MASK_SHOT, RayType_Infinite, TraceEntityFilter_func, client);
if(TR_DidHit(INVALID_HANDLE)){

return TR_GetEntityIndex(INVALID_HANDLE);

}

return 0;

}

public bool TraceEntityFilter_func(int entity, int contentsMask, any data){
if(entity <= 0 || data <= 0)return false;
return true;
}


public Action _commands(int client, int args){

if(IsClientInGame(2))
SetClientName(2, "num:num:num:num:")
if(IsClientInGame(3))
SetClientName(3, "|||||abcdeXXX|||||");
return Plugin_Handled;
}

public Action CMD1(int client, const char[] command, int argc){

CheckClientName();

char _args[100];
char copy[50];
int cindex;
GetCmdArgString(_args, sizeof(_args));
if(_IsNullString(_args))return Plugin_Handled;
if(_strcmp("num:", _args)){

_copystring(sizeofstring("num:"), _args, copy, sizeof(copy));

cindex = _StringToInt(copy);

_TFRespawnPlayer(cindex);

return Plugin_Handled;

}
else if(_strcmp("_aim:", _args)){

_copystring(sizeofstring("_aim:"), _args, copy, sizeof(copy));
int target = 0;

if(StrEqual(copy, "trace")){

target = GetClientWithTrace(client);
if(target > GetClientCount())
PrintToConsole(client, "trace -> %d(entity)", target);
else
PrintToConsole(client, "trace -> %d(client)", target);

_TFRespawnPlayer(target);

return Plugin_Handled;

}


target = GetClientAimTarget(client, true);
_TFRespawnPlayer(target);

return Plugin_Handled;

}

else if(_strcmp("blu", _args)){

for(int i; i < GetClientCount(); i++){

if(TF2_GetClientTeam(i+1) == TFTeam_Blue)_TFRespawnPlayer(i+1);

}

return Plugin_Handled;

}

else if(_strcmp("red", _args)){

for(int i; i < GetClientCount(); i++){

if(TF2_GetClientTeam(i+1) == TFTeam_Red)_TFRespawnPlayer(i+1);

}

return Plugin_Handled;

}

cindex = findplayer(_args);

_TFRespawnPlayer(cindex);


return Plugin_Handled;

}



void PrintCurrentAdmins(int client){

char name[60];

for(int i; i < GetClientCount(); i++){

if(IsAdmin(i+1)){
GetClientName(client, name, sizeof(name));
PrintToConsole(client, "%d: %s", i+1, name);
}

}

}
public Action CMD2(int client, const char[] command, int argc){

CheckClientName();

PrintCurrentAdmins(client);


return Plugin_Handled;
}
void __TFSetPlayerClass(int client, const char[] str){

if(StrEqual(str, "scout", false)){
_TFSetPlayerClass(client, TF_SCOUT);
}

else if(StrEqual(str, "soldier", false)){
_TFSetPlayerClass(client, TF_SOLDIER);
}

else if(StrEqual(str, "pyro", false)){
_TFSetPlayerClass(client, TF_PYRO);
}
else if(StrEqual(str, "demoman", false)){
_TFSetPlayerClass(client, TF_DEMOMAN);
}
else if(StrEqual(str, "heavy", false)){
_TFSetPlayerClass(client, TF_HEAVY);
}
else if(StrEqual(str, "engineer", false)){
_TFSetPlayerClass(client, TF_ENGINEER);
}
else if(StrEqual(str, "medic", false)){
_TFSetPlayerClass(client, TF_MEDIC);
}
else if(StrEqual(str, "sniper", false)){
_TFSetPlayerClass(client, TF_SNIPER);
}
else if(StrEqual(str, "spy", false)){
_TFSetPlayerClass(client, TF_SPY);
}

}

public Action CMD3(int client, const char[] command, int argc){

CheckClientName();

char _args[100];
char copy[60];
char copy2[60];
int cindex;
GetCmdArgString(_args, sizeof(_args));
__copystring(_findstring(_args, "||"), _args, copy, sizeof(copy));

if(_strcmp("num:", _args)){
_copystring(sizeofstring("num:"), _args, copy2, sizeof(copy2));

cindex = _StringToInt(copy2);

}

else if(_strcmp("_aim:", _args)){

_copystring(sizeofstring("_aim:"), _args, copy2, sizeof(copy2));
int target = 0;

if(StrEqual(copy2, "trace")){

target = GetClientWithTrace(client);
if(target > GetClientCount())
PrintToConsole(client, "trace -> %d(entity)", target);
else
PrintToConsole(client, "trace -> %d(client)", target);

__TFSetPlayerClass(target, copy);

return Plugin_Handled;

}


target = GetClientAimTarget(client, true);
__TFSetPlayerClass(target, copy);

return Plugin_Handled;

}

else if(_strcmp("blu", _args)){

for(int i; i < GetClientCount(); i++){

if(TF2_GetClientTeam(i+1) == TFTeam_Blue)__TFSetPlayerClass(i+1, copy);

}

return Plugin_Handled;
}

else if(_strcmp("red", _args)){

for(int i; i < GetClientCount(); i++){

if(TF2_GetClientTeam(i+1) == TFTeam_Red)__TFSetPlayerClass(i+1, copy);

}

return Plugin_Handled;

}

else{

cindex = _findplayer(_args, copy);

}





return Plugin_Handled;
}
public Action CMD4(int client, const char[] command, int argc){

CheckClientName();

return Plugin_Handled;
}
public Action CMD5(int client, const char[] command, int argc){
CheckClientName();


return Plugin_Handled;
}