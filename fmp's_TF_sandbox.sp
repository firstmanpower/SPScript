#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <tf2>
#include <tf2_stocks>

/*

플러그인 버전: 1


*/

#define MASS_MAX 1000.0
#define MASS_MIN -1000.0

#define MAX_BUILD 100
#define K_TAP	'	'
#define K_SPACE ' '
#define WORD(%1) ( ( %1 > 64 && %1 < 91 ) || ( %1 > 96 && %1 < 123 ) )
#define V_PHYSICS "6"

static int build[MAXPLAYERS+1];
static char entity_name[MAXPLAYERS+1][MAX_BUILD][300];
static float entity_origin[MAXPLAYERS+1][MAX_BUILD][3];
static float entity_angle[MAXPLAYERS+1][MAX_BUILD][3];
static int entity_index[MAXPLAYERS+1][MAX_BUILD];

public bool filter(int entity, int contentsMask){
return false;
}

void GetAim(int client, float vec[3]){

	float origin[3];
	float angle[3];

	angle[0] = GetEntPropFloat(client, Prop_Send, "m_angEyeAngles[0]"); 
	angle[1] = GetEntPropFloat(client, Prop_Send, "m_angEyeAngles[1]");

	GetEntPropVector(client, Prop_Send, "m_vecOrigin", origin);

	origin[2] += 70.0;

	TR_TraceRayFilter(origin, angle, MASK_SHOT, RayType_Infinite, filter);

	if(TR_DidHit(INVALID_HANDLE))TR_GetEndPosition(vec, INVALID_HANDLE);

}

int GetAim2(int client){

	float origin[3];
	float angle[3];

	angle[0] = GetEntPropFloat(client, Prop_Send, "m_angEyeAngles[0]"); 
	angle[1] = GetEntPropFloat(client, Prop_Send, "m_angEyeAngles[1]");

	GetEntPropVector(client, Prop_Send, "m_vecOrigin", origin);

	origin[2] += 70.0;

	TR_TraceRayFilter(origin, angle, MASK_SHOT, RayType_Infinite, filter);

	if(TR_DidHit(INVALID_HANDLE))return TR_GetEntityIndex(INVALID_HANDLE);

}


bool IsOwner(int owner, int eidx){


if(!IsValidEntity(eidx) || !IsValidEntity(owner))return false;

char ent_name[50];
char name[50];
GetEntPropString(eidx, Prop_Data, "m_iName", ent_name, 50);
Format(name, 50, "FMP_ENT_%d", owner);

if(StrEqual(ent_name, name))return true;

for(int i; i < build[owner]; i++)if(entity_index[owner][i] == eidx)return true;

return false;

}

void PrintHudMsg(int client, const char[] Msg, int color[4], int color2[4], float x, float y, float holdtime, int channel, float fxtime, float fadeout, float fadein, int effect){

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

void RemoveAllEntities(int client){

if(!IsValidEntity(client))return;

int ent = -1;

while ((ent = FindEntityByClassname(ent, "prop_dynamic")) != -1)
if(IsOwner(client, ent))
_RemoveEntity(EntIndexToEntRef(ent), client);

}

void _RemoveEntity(int eidx, int client){

if(IsOwner(client, eidx))
AcceptEntityInput(eidx, "Kill");

}

void SpawnDynamicProp(const char[] modelname, int client){

int ent = CreateEntityByName("prop_dynamic");
entity_index[client][build[client]] = ent;
float origin[3];

if(build[client] > MAX_BUILD){

build[client] = MAX_BUILD;
return;

}

Format(entity_name[client][build[client]], 300, "FMP_ENT_%d", client);
DispatchKeyValue(ent, "targetname", entity_name[client][build[client]]);
GetAim(client, origin);
DispatchKeyValueVector(ent, "origin", origin);
DispatchKeyValue(ent, "solid", V_PHYSICS);
DispatchKeyValue(ent, "model", modelname);
DispatchSpawn(ent);

build[client]++;

}

void SpawnPhysicsProp(const char[] modelname, float mass, int client){

int ent = CreateEntityByName("prop_physics");
entity_index[client][build[client]] = ent;
float origin[3];

if(build[client] > MAX_BUILD){

build[client] = MAX_BUILD;
return;

}

Format(entity_name[client][build[client]], 300, "FMP_ENT_%d", client);
DispatchKeyValue(ent, "targetname", entity_name[client][build[client]]);
GetAim(client, origin);
DispatchKeyValueVector(ent, "origin", origin);

if(mass > MASS_MAX)mass = MASS_MAX;
else if(mass < MASS_MIN)mass = MASS_MIN;

DispatchKeyValueFloat(ent, "massscale", mass);
DispatchKeyValue(ent, "model", modelname);
DispatchSpawn(ent);

build[client]++;

}


void MemSet(char[] str, int strsize){

for(int i; i < strsize; i++)str[i] = 0;

}

void Copy(char[] str, const char[] str2, int strsize){

MemSet(str, strsize);

for(int i; i < strsize; i++)str[i] = str2[i];

}

void Copy2(int startpos, const char[] str2, const char[] stopsig, char[] str, int strsize){

int i2;
int i3;

MemSet(str, strsize);

for(int i = startpos; str2[i] != 0; i++){


if(i3 == CS(stopsig)+1)return;

if(str2[i] == stopsig[i3] && stopsig[0] != 0)i3++;

else{

if(i2 == strsize)return;
str[i2] = str2[i];
i2++;

}

}

}


void DeleteBlank(char[] str){

int strsize = CS(str)+3;
char[] str2 = new char[strsize];

int i2;

for(int i; i < strsize; i++)
if(str[i] != K_SPACE && str[i] != K_TAP){

str2[i2] = str[i];
i2++;

}

Copy(str, str2, strsize);

}

int CS(const char[] str){

int value;

for(int i; str[i] != 0; i++)value = i;

return value;

}

bool IsStringAva(int startpos, const char[] str){

for(int i = startpos; i <= CS(str); i++)

if(str[i] != K_SPACE && str[i] != K_TAP)return true;

return false;

}

bool StrEqual2(int endidx, const char[] str, const char[] str2, bool mode){

if(mode){

int i2;

for(int i; i < CS(str)+1; i++){

if(i == endidx)break;
if(str[i] == str2[i2])i2++;

}


if(i2 == CS(str2)+1)return true;

}

else{

int i2;

for(int i; i < CS(str)+1; i++){

if(i == endidx)break;
if(str[i] == str2[i2])i2++;
else if((str[i]+32 == str2[i2] || str[i]-32 == str2[i2] || str[i] == str2[i2]+32 || str[i] == str2[i2]-32) && WORD(str[i]) && WORD(str2[i2]))i2++;

}

if(i2 == CS(str2)+1)return true;

}

return false;
}


public void OnClientDisconnect(int client){

RemoveAllEntities(client);

}

public Action OnPlayerRunCmd(int client, int& buttons, int& impulse, float vel[3], float angles[3], int& weapon, int& subtype, int& cmdnum, int& tickcount, int& seed, int mouse[2]){

if ((buttons & IN_ATTACK2) == IN_ATTACK2){


float endvec[3], c_angle[3], origin[3], result[3];
int ent = GetClientAimTarget(client, false);

if(IsValidEntity(ent)){
GetAim(client, endvec);

c_angle[0] = GetEntPropFloat(client, Prop_Send, "m_angEyeAngles[0]"); 
c_angle[1] = GetEntPropFloat(client, Prop_Send, "m_angEyeAngles[1]");

GetEntPropVector(ent, Prop_Send, "m_vecOrigin", origin);

result[0] = origin[0] + c_angle[0];
result[1] = origin[1] ;
result[2] = origin[2] + c_angle[1];

TeleportEntity(ent, result, NULL_VECTOR, NULL_VECTOR);

}

}
return Plugin_Continue;


}


public void OnPluginStart(){

for(int i; i < MAXPLAYERS+1; i++)
for(int i2; i2 < MAX_BUILD; i2++)
entity_index[i][i2] = -5;

}

public void OnGameFrame(){



for(int i = 1; i <= GetClientCount(); i++){

if(IsValidEntity(i)){

char msg[30];
Format(msg, 30, "%d/%d", build[i], MAX_BUILD);
PrintHudMsg(i, msg, {255, 255, 255, 255}, {255, 255, 255, 255}, -1.0, 0.15, GetGameFrameTime(), 5, 6.0, 0.1, 0.1, 0);

for(int i2; i2 < MAX_BUILD; i2++)
if(!IsValidEntity(entity_index[i][i2]) && entity_index[i][i2] != -5){

build[i]--;
entity_index[i][i2] = -5;
if(build[i] < 0)build[i] = 0;

}

}


}


}



public Action OnClientCommand(int client, int args){
	char cmd[30], arg1[50], arg2[50];
	GetCmdArg(0, cmd, 30);
	GetCmdArg(1, arg1, 50);
	GetCmdArg(2, arg2, 50);
	if (StrEqual(cmd, "fsm", false)){
		
		if(arg1[0] != 0)SpawnDynamicProp(arg1, client);
		
		return Plugin_Handled;
	}
	else if (StrEqual(cmd, "fss", false)){
		
		if(arg1[0] != 0){
		
		if(arg2[0] != 0)SpawnPhysicsProp(arg1, StringToFloat(arg2), client);
		else SpawnPhysicsProp(arg1, 1.0, client);
		
		}
		
		return Plugin_Handled;
	}
	else if(StrEqual(cmd, "remove", false)){
		_RemoveEntity(GetClientAimTarget(client, false), client);
		return Plugin_Handled;
	}
	else if(StrEqual(cmd, "remove_all", false)){
		RemoveAllEntities(client);
		return Plugin_Handled;
	}
	else if(StrEqual(cmd, "test", false)){
		
		char test[30];
		
		Copy2(CS("hello")+1, "hello world", "", test, 30);
		DeleteBlank(test);
		
		PrintToChat(client, "%s", test);
		return Plugin_Handled;
		
	}
	return Plugin_Continue;
}

public Action OnClientSayCommand(int client, const char[] command, const char[] sArgs){

int sArgs2size = CS(sArgs)+3;
char[] sArgs2 = new char[sArgs2size];
char arg1[60];

Copy(sArgs2, sArgs, sArgs2size);

DeleteBlank(sArgs2);

if(StrEqual2(CS("fsm")+1, sArgs2, "fsm", false)){



Copy2(CS("fsm")+1, sArgs2, "", arg1, 60);

if(arg1[0] != 0){

PrintToChat(client, "%s", arg1);

}

return Plugin_Handled;
}

else if(StrEqual2(CS("fss")+1, sArgs2, "fss", false)){

char arg2[60];

Copy2(CS("fss")+1, sArgs2, ":", arg1, 60);

if(arg1[0] != 0){

Copy2(CS("fss")+CS(arg1)+3, sArgs2, "", arg2, 60);


if(arg2[0] != 0)
SpawnPhysicsProp(arg1, StringToFloat(arg2), client);

else SpawnPhysicsProp(arg1, 1.0, client);

}

return Plugin_Handled;

}


return Plugin_Continue;
}