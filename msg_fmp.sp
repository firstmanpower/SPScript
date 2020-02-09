#include <sourcemod>
#include <tf2_stocks>

char _Msg[MAXPLAYERS+1][200];

int _findstring(const char[] str, const char[] str2){

int i2;
int _i;
for(int i; str[i] != 0 && str2[i2] != 0; i++){
_i = i;
if(str[i] == str2[i2])i2++;
}

return _i+1;

}

bool findstring(const char[] str, const char[] str2, int number, bool _C_){

int i2;
for(int i; str[i] != 0 && str2[i2] != 0; i++){
if(str[i] == str2[i2])i2++;
else if(_C_){
if(str[i] == str2[i2]-32)i2++;
else if(str[i] == str2[i2]+32)i2++;
}

}
if(i2 == number)return true;
return false;

}

int sizeofstring(const char[] str){
int value;
for(int i; str[i] != 0; i++){
value = i+1;
}
return value;

}

int findplayer(const char[] str){
char targetname[128];

for(int i; i < GetClientCount(); i++){

if(IsClientInGame(i+1)){

GetClientName(i+1, targetname, sizeof(targetname));

if(StrEqual(targetname, str, false))return i+1;
else if(findstring(targetname, str, sizeofstring(str), true))return i+1;

}

}

return 0;

}

void _copy(int startpos, const char[] str, char[] str2, int str2size){
int i2;
for(int i = startpos; str[i] != 0 && i != str2size; i++){
str2[i2] = str[i];
i2++;
}

}


public void OnPluginStart(){

AddCommandListener(MSG, "msg");

}
void _clear(int startpos, char[] str){

for(int i = startpos; str[i] != 0; i++){
str[i] = 0;
}

}

bool _strcmp(const char[] str, const char[] str2){

int i2;
for(int i; str[i] != 0 && str2[i] != 0; i++){
if(str[i] == str2[i])i2++;
else if(str[i] == str2[i]-32)i2++;
else if(str[i] == str2[i]+32)i2++;
}

if(i2 == sizeofstring(str2))return true;
return false;

}

public Action OnClientSayCommand(int client, const char[] command, const char[] sArgs){



if(_strcmp(sArgs, "!msg ")){

for(int i; i < 200; i++){
_Msg[client][i] = 0;
}

_copy(sizeofstring("!msg "), sArgs, _Msg[client], sizeof(_Msg));


if(findstring(sArgs, " !send ", sizeofstring(" !send "), false)){
char fixed[200];
_copy(_findstring(sArgs, " !send "), sArgs, fixed, sizeof(fixed));

char Name[128];
char TName[128];
int target;

target = findplayer(fixed);
if(!target){
PrintToChat(client, "\x03제대로 입력하세요!");
return Plugin_Handled;
}
else if(TF2_GetClientTeam(client) != TF2_GetClientTeam(target)){
PrintToChat(client, "\x03같은 팀이 아닙니다!");
return Plugin_Handled;
}
else if(target == client){
PrintToChat(client, "\x03 자기스스로는 못합니다!");
return Plugin_Handled;
}

GetClientName(client, Name, sizeof(Name));
GetClientName(target, TName, sizeof(TName));
_clear(_findstring(sArgs, " !send ")-12, _Msg[client]);

PrintToChat(target, "\x03%s <- %s", _Msg[client], Name);
PrintToChat(client, "\x03%s -> %s", TName, _Msg[client]);

return Plugin_Handled;
}

return Plugin_Handled;
}



return Plugin_Continue;

}


public Action MSG(int client, const char[] command, int argc){


for(int i; i < 200; i++){
_Msg[client][i] = 0;
}

GetCmdArgString(_Msg[client], sizeof(_Msg));


if(findstring(_Msg[client], " !send ", sizeofstring(" !send "), false)){
char fixed[200];
_copy(_findstring(_Msg[client], " !send "), _Msg[client], fixed, sizeof(fixed));

char Name[128];
char TName[128];
int target;

target = findplayer(fixed);
if(!target){
PrintToChat(client, "\x03제대로 입력하세요!");
return Plugin_Handled;
}
else if(TF2_GetClientTeam(client) != TF2_GetClientTeam(target)){
PrintToChat(client, "\x03같은 팀이 아닙니다!");
return Plugin_Handled;
}
else if(target == client){
PrintToChat(client, "\x03자기스스로는 못합니다!");
return Plugin_Handled;
}

GetClientName(client, Name, sizeof(Name));
GetClientName(target, TName, sizeof(TName));
_clear(_findstring(_Msg[client], " !send ")-12, _Msg[client]);

PrintToChat(target, "\x03%s <- %s", _Msg[client], Name);
PrintToChat(client, "\x03%s -> %s", TName, _Msg[client]);

return Plugin_Handled;
}

return Plugin_Handled;


}
