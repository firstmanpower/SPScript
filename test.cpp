
#include <dirent.h>
#include <stdio.h>
 

bool StrEqual(const char* str, const char* str2, bool caseSensitive) {
	if (!caseSensitive) {
		for (int i = 0; str[i] != 0 && str2[i] != 0; i++) {
			if (str[i] != str2[i])return false;
		}
		return true;
	}
	else {
		for (int i = 0; str[i] != 0 && str2[i] != 0; i++) {
			if (str[i] != str2[i] - 32 && str[i] != str2[i] && str[i] != str2[i] + 32)return false;
		}
		return true;
	}

	return false;

}

int SizeOfString(const char* str) {
	int value = 0;
	for (int i = 0; str[i] != 0; i++) {
		value = i;
	}
	return value + 1;
}

void MemSet(char* str, char val, int strsize) {
	for (int i = 0; i < strsize; i++) {
		str[i] = val;
	}
}

void Copy(char* str, const char* str2, int strsize) {
	for (int i = 0; i < strsize; i++) {
		str[i] = str2[i];
	}
}

void _Delete(char* str, int strsize){
	char* copy = new char[strsize];
	int i2 = 0;
	MemSet(copy, 0, strsize);
	for(int i = 65; i < strsize; i++){
		copy[i2] = str[i];
		i2++;
	}
	MemSet(str, '\0', strsize);
	Copy(str, copy, strsize);
}
void Delete(char* str, int strsize){
	
	for(int i = 0; i < strsize; i++){
		
		if(str[i] == '\\'){
			
			str[i] = '/';
			
		}
		
	}
	
}

void listfile(const char* str){
	DIR *_dir;
    struct dirent *dir;
	char * copy = new char[SizeOfString(str)+1];
	Copy(copy, str, SizeOfString(str)+1);

    _dir = opendir(str);
	
    if(_dir)
    {
		Delete(copy, SizeOfString(str));
		_Delete(copy, SizeOfString(str));
		printf("//----------------%s-----------------\n", copy);
        while ((dir = readdir(_dir)) != NULL)
        {
			
			if(dir->d_type != DT_DIR && dir->d_name[0] != '.')printf("AddFileToDownloadsTable(\"%s%s\");\n", copy, dir->d_name);
			else if(dir->d_name[0] != '.')printf("folder: %s\n", dir->d_name);
			
        }
		
        closedir(_dir);
    }
	
}

void AddStr(const char* str, const char* str2, char* result, int resultsize) {

	int i2 = 0;
	int i3 = 0;
	char* CS = new char[resultsize];
	MemSet(CS, 0, resultsize);
	for (int i = 0; i < resultsize; i++) {

		if (SizeOfString(str) != i2) {
			CS[i] = str[i2];
			i2++;
			
		}
		else if(SizeOfString(str2) != i3){
			CS[i] = str2[i3];
			i3++;
		}
	}
	Copy(result, CS, resultsize);

}

int main(int argc, char **argv)
{   	
	if(argc != 2)return 0;
	
	if(StrEqual(argv[1], "null", true)){
		listfile("C:\\steamcmd\\steamapps\\common\\Team Fortress 2 Dedicated Server\\tf\\models\\");
		return 0;
	}
	
	char result[500];
	AddStr("C:\\steamcmd\\steamapps\\common\\Team Fortress 2 Dedicated Server\\tf\\models\\", argv[1], result, 500);
	if(result[SizeOfString(result)] != '/'){
		result[SizeOfString(result)] = '/';
	}
	listfile(result);

    return 0;
}