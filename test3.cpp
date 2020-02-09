#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>

int SizeOfString(const char* str) {
	int value = 0;
	for (int i = 0; str[i] != 0; i++) {
		value = i;
	}
	return value + 1;
}
void Copy(char* str, const char* str2, int strsize){
	
	for(int i = 0; i < strsize; i++){
		
		str[i] = str2[i];
		
	}
	
}
void MemSet(char* str, char val, int strsize) {
	for (int i = 0; i < strsize; i++) {
		str[i] = val;
	}
}
int Getstrpos(const char* str, const char* str2){
	
	int i2 = 0;
	
	for(int i = 0; i < SizeOfString(str)+1; i++){
		
		
		
	}
	
}


void DeleteBlank(char* str){
	
	char* l_str = new char[SizeOfString(str)+1];
	int i2 = 0;
	for(int i = 0; i < SizeOfString(str)+1; i++){
		
		if(str[i] != ' ' && str[i] != '	'){
			l_str[i2] = str[i];
			i2++;
		}
		
	}
	Copy(str, l_str, SizeOfString(str)+1);
}

void _DeleteBlank(char* str, char* result, int resultsize){
	
	char* l_str = new char[SizeOfString(str)+1];
	int i2 = 0;
	for(int i = 0; i < SizeOfString(str)+1; i++){
		
		if(str[i] != ' ' && str[i] != '	'){
			l_str[i2] = str[i];
			i2++;
		}
		
	}
	Copy(result, l_str, resultsize);
}

void Substr(const char* str, int num, char* result, int resultsize) {

	int i2 = 0;
	char* CS = new char[resultsize];
	MemSet(CS, 0, resultsize);
	for (int i = 0; i < resultsize; i++) {

		if (SizeOfString(str)-num != i2) {
			CS[i] = str[i2];
			i2++;
		}

	}
	Copy(result, CS, resultsize);
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

bool _strcmp(const char* str, const char* str2){
		
	int i2 = 0;
	
	for(int i = 0; i < SizeOfString(str)+1; i++){		
		if(str[i] == str2[i2]){
			i2++;
			if(i2 >= SizeOfString(str2))return true;
		}
		else{
			i2 = 0;
		}		
	}
	
	return false;
	
}

int ___strcmp(const char* str, const char* str2){
		
	int i2 = 0;
	
	for(int i = 0; i < SizeOfString(str)+1; i++){		
		if(str[i] == str2[i2]){
			i2++;
			if(i2 >= SizeOfString(str2))return i;
		}
		else{
			i2 = 0;
		}		
	}
	
	return -1;
	
}


int ____strcmp(int startpos, const char* str, const char* str2){
		
	int i2 = 0;
	
	for(int i = startpos; i < SizeOfString(str)+1; i++){		
		if(str[i] == str2[i2]){
			i2++;
			if(i2 >= SizeOfString(str2))return i;
		}
		else{
			i2 = 0;
		}		
	}
	
	return -1;
	
}




bool __strcmp(int startpos, const char* str, const char* str2){
		
	int i2 = 0;
	
	for(int i = startpos; i < SizeOfString(str)+1; i++){		
		if(str[i] == str2[i2]){
			i2++;
			if(i2 >= SizeOfString(str2))return true;
		}
		else{
			i2 = 0;
		}		
	}
	
	return false;
	
}

void EditFile(char* str, int startpos, int endpos){
	
	for(int i = startpos; i < endpos; i++){
		if(str[i] == '\\'){
			str[i] = '/';
		}
	}
	
}


void Fmp_Scan(const char* str){
	DIR *_dir;
    struct dirent *dire;
	int cysize = SizeOfString(str)+1+256+1;
	FILE* fp;
	FILE* fp2;
	long nbytes = 0;
	char *file_buffer;
	
    _dir = opendir(str);
	
    if(_dir)
    {
		
        while ((dire = readdir(_dir)) != NULL)
        {
			
			if(dire->d_type != DT_DIR && dire->d_name[0] != '.'){
				char * copy = new char[cysize];
				AddStr(str, "\\", copy, cysize);	
				AddStr(copy, dire->d_name, copy, cysize);
				fp = fopen(copy, "r");
				char oldfile_name[300];
				Copy(oldfile_name, copy, 300);
				AddStr("output\\", oldfile_name, oldfile_name, 300);
				fp2 = fopen(oldfile_name, "w");
				if (fp == NULL || fp2 == NULL)return;
				fseek(fp, 0L, SEEK_END);
				nbytes = ftell(fp);
				fseek(fp, 0L, SEEK_SET);
				file_buffer = (char*)calloc(nbytes, sizeof(char));	
				if(file_buffer == NULL)return;
				fread(file_buffer, sizeof(char), nbytes, fp);
				
				int slot01 = ___strcmp(file_buffer, "\"mod_download\"");
				int slot01_1 = ____strcmp(slot01, file_buffer, "}");
				int slot02 = ___strcmp(file_buffer, "\"download\"");
				int slot02_1 = ____strcmp(slot02, file_buffer, "}");
				int slot03 = ___strcmp(file_buffer, "\"mat_download\"");
				int slot03_1 = ____strcmp(slot03, file_buffer, "}");
				int slot04 = ___strcmp(file_buffer, "\"sound_bgm\"");
				int slot04_1 = ____strcmp(slot04, file_buffer, "}");
				
				EditFile(file_buffer, slot01, slot01_1);
				EditFile(file_buffer, slot02, slot02_1);
				EditFile(file_buffer, slot03, slot03_1);
				EditFile(file_buffer, slot04, slot04_1);				
				fputs(file_buffer, fp2);
				fclose(fp2);
				fclose(fp);
			}
			
		}
	}
	
}

int main(int argc, char **argv)
{
	if(argc != 2)return 0;
    Fmp_Scan(argv[1]);
	
    return 0;
}
