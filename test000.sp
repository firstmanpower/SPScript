#include <sourcemod>


int SizeOfString(const char[] text){

int value;
for(int i; text[i] != 0; i++)value = i;
return value + 1;

}


void copy(char[] text, const char[] copy){

for(int i; i < SizeOfString(copy); i++)text[i] = copy[i];

}
 
void _copy(int startpos, char[] text, const char[] copy){

int i2;

for(int i = startpos; copy[i2] != 0; i++){
text[i] = copy[i2];
i2++;
}

} 

void MV_Download(const char[] text, int mod = 0){

int textsize = SizeOfString(text);
char[] mdl = new char[6 + textsize];
char[] dx80 = new char[11 + textsize];
char[] dx90 = new char[11 + textsize];
char[] phy = new char[6 + textsize];
char[] vvd = new char[6 + textsize];
char[] sw = new char[9 + textsize];

char[] vmt = new char[6 + textsize];
char[] vtf = new char[6 + textsize];



switch(mod){

case 0:{

copy(mdl, text);
_copy(textsize, mdl, ".mdl");

copy(dx80, text);
_copy(textsize, dx80, ".dx80.vtx");

copy(dx90, text);
_copy(textsize, dx90, ".dx90.vtx");

copy(phy, text);
_copy(textsize, phy, ".phy");

copy(vvd, text);
_copy(textsize, vvd, ".vvd");

copy(sw, text);
_copy(textsize, sw, ".sw.vtx");

AddFileToDownloadsTable(mdl);
AddFileToDownloadsTable(dx80);
AddFileToDownloadsTable(dx90);
AddFileToDownloadsTable(phy);
AddFileToDownloadsTable(vvd);
AddFileToDownloadsTable(sw);

PrecacheModel(mdl);

}

case 1:{

copy(vmt, text);
_copy(textsize, vmt, ".vmt");

copy(vtf, text);
_copy(textsize, vtf, ".vtf");

AddFileToDownloadsTable(vmt);
AddFileToDownloadsTable(vtf);

}


}


}