#include <dirent.h>
#include <stdio.h>

#define TEXT_S "models"
#define PRTN "AddFileToDownloadsTable(\"%s%s\");\n"
#define PRTN_PRECACHE "PrecacheModel(\"%s%s\", true);\n"
#define PRTN_SOUNDPRECACHE "PrecacheSound(\"%s%s\", true);\n"
#define DELETE_S "models/"
/*


*/
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

void _Delete(char* str, const char* strn){
	int strsize = SizeOfString(str)+1;
	char* copy = new char[strsize];
	int i2 = 0;
	for(int i = SizeOfString(strn); i < strsize; i++){
		copy[i2] = str[i];
		i2++;
	}
	Copy(str, copy, strsize);
}
void Delete(char* str, int strsize){
	
	for(int i = 0; i < strsize; i++){
		
		if(str[i] == '\\'){
			
			str[i] = '/';
			
		}
		
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
	MemSet(result, 0, resultsize);
	Copy(result, CS, resultsize);

}



void listfile(const char* str, FILE* file, FILE* file2){
	DIR *_dir;
    struct dirent *dir;
	int _0cysize = SizeOfString(str)+2;
	char * copy = new char[_0cysize];
	char * oldcopy = new char[_0cysize];
	AddStr(str, "/", copy, _0cysize);
	Copy(oldcopy, copy, _0cysize);
	_Delete(oldcopy, DELETE_S);
	Delete(copy, _0cysize);
    _dir = opendir(str);
	
    if(_dir)
    {
		
        while ((dir = readdir(_dir)) != NULL)
        {
			
			if(dir->d_type != DT_DIR && dir->d_name[0] != '.'){
				printf(PRTN, copy, dir->d_name);
				fprintf(file, PRTN, copy, dir->d_name);
				if(StrEqual(str, "models", true)){
				printf(PRTN_PRECACHE, oldcopy, dir->d_name);
				fprintf(file2, PRTN_PRECACHE, oldcopy, dir->d_name);
				}
				else if(StrEqual(str, "sound", true)){
				printf(PRTN_SOUNDPRECACHE, oldcopy, dir->d_name);
				fprintf(file2, PRTN_SOUNDPRECACHE, oldcopy, dir->d_name);
				}
			}
			else if(dir->d_name[0] != '.'){
				DIR *__dir;
				struct dirent *___dir;
				int cysize = _0cysize+SizeOfString(dir->d_name)+1;
				char *_copy = new char[cysize];
				char *_oldcopy = new char[cysize];
				AddStr(copy, dir->d_name, _copy, cysize);
				AddStr(_copy, "/", _copy, cysize);
				Copy(_oldcopy, _copy, cysize);
				_Delete(_oldcopy, DELETE_S);
				__dir = opendir(_copy);
				

				if(__dir){
		
					while ((___dir = readdir(__dir)) != NULL){
						if(___dir->d_type != DT_DIR && ___dir->d_name[0] != '.'){
							printf(PRTN, _copy, ___dir->d_name);
							fprintf(file, PRTN, _copy, ___dir->d_name);
							if(StrEqual(str, "models", true)){
							printf(PRTN_PRECACHE, _oldcopy, ___dir->d_name);
							fprintf(file2, PRTN_PRECACHE, _oldcopy, ___dir->d_name);
							}
							else if(StrEqual(str, "sound", true)){
							printf(PRTN_SOUNDPRECACHE, _oldcopy, ___dir->d_name);
							fprintf(file2, PRTN_SOUNDPRECACHE, _oldcopy, ___dir->d_name);
							}
						}
						else if(___dir->d_name[0] != '.'){
							DIR *__1dir;
							struct dirent *___1dir;
							int _1cysize = cysize+SizeOfString(___dir->d_name)+1;
							char *_1copy = new char[_1cysize];
							char *_1oldcopy = new char[_1cysize];
							AddStr(_copy, ___dir->d_name, _1copy, _1cysize);
							AddStr(_1copy, "/", _1copy, _1cysize);
							Copy(_1oldcopy, _1copy, _1cysize);
							_Delete(_1oldcopy, DELETE_S);
							__1dir = opendir(_1copy);
							
	
							if(__1dir){
		
								while ((___1dir = readdir(__1dir)) != NULL){
								if(___1dir->d_type != DT_DIR && ___1dir->d_name[0] != '.'){
									printf(PRTN, _1copy, ___1dir->d_name);
									fprintf(file, PRTN, _1copy, ___1dir->d_name);
									if(StrEqual(str, "models", true)){
									printf(PRTN_PRECACHE, _1oldcopy, ___1dir->d_name);
									fprintf(file2, PRTN_PRECACHE, _1oldcopy, ___dir->d_name);
									}
									else if(StrEqual(str, "sound", true)){
									printf(PRTN_SOUNDPRECACHE, _1oldcopy, ___1dir->d_name);
									fprintf(file2, PRTN_SOUNDPRECACHE, _1oldcopy, ___1dir->d_name);
									}
								}
								else if(___1dir->d_name[0] != '.'){
									DIR *__2dir;
									struct dirent *___2dir;
									int _2cysize = _1cysize+SizeOfString(___1dir->d_name)+2;
									char *_2copy = new char[_2cysize];
									char *_2oldcopy = new char[_2cysize];
									AddStr(_1copy, ___1dir->d_name, _2copy, _2cysize);
									AddStr(_2copy, "/", _2copy, _2cysize);
									Copy(_2oldcopy, _2copy, _2cysize);
									_Delete(_2oldcopy, DELETE_S);
									__2dir = opendir(_2copy);
							
	
									if(__2dir){
		
										while ((___2dir = readdir(__2dir)) != NULL){
											if(___2dir->d_type != DT_DIR && ___2dir->d_name[0] != '.'){
												printf(PRTN, _2copy, ___2dir->d_name);
												fprintf(file, PRTN, _2copy, ___2dir->d_name);
												if(StrEqual(str, "models", true)){
												printf(PRTN_PRECACHE, _2oldcopy, ___2dir->d_name);
												fprintf(file2, PRTN_PRECACHE, _2oldcopy, ___2dir->d_name);
												}
												else if(StrEqual(str, "sound", true)){
												printf(PRTN_SOUNDPRECACHE, _2oldcopy, ___2dir->d_name);
												fprintf(file2, PRTN_SOUNDPRECACHE, _2oldcopy, ___2dir->d_name);
												}
											}
											else if(___2dir->d_name[0] != '.'){
											DIR *__3dir;
											struct dirent *___3dir;
											int _3cysize = _2cysize+SizeOfString(___2dir->d_name)+1;
											char *_3copy = new char[_3cysize];
											char *_3oldcopy = new char[_3cysize];
											AddStr(_2copy, ___2dir->d_name, _3copy, _3cysize);
											AddStr(_3copy, "/", _3copy, _3cysize);
											Copy(_3oldcopy, _3copy, _3cysize);
											_Delete(_3oldcopy, DELETE_S);
											
											__3dir = opendir(_3copy);
							
	
											if(__3dir){
		
												while ((___3dir = readdir(__3dir)) != NULL){
													if(___3dir->d_type != DT_DIR && ___3dir->d_name[0] != '.'){
														printf(PRTN, _3copy, ___3dir->d_name);
														fprintf(file, PRTN, _3copy, ___3dir->d_name);
														if(StrEqual(str, "models", true)){
														printf(PRTN_PRECACHE, _oldcopy, ___dir->d_name);
														fprintf(file2, PRTN_PRECACHE, _oldcopy, ___dir->d_name);
														}
														else if(StrEqual(str, "sound", true)){
														printf(PRTN_SOUNDPRECACHE, _3oldcopy, ___3dir->d_name);
														fprintf(file2, PRTN_SOUNDPRECACHE, _3oldcopy, ___3dir->d_name);
														}
													}
													else if(___3dir->d_name[0] != '.'){
													DIR *__4dir;
													struct dirent *___4dir;
													int _4cysize = _3cysize+SizeOfString(___3dir->d_name)+1;
													char *_4copy = new char[_4cysize];
													char *_4oldcopy = new char[_4cysize];
													AddStr(_3copy, ___3dir->d_name, _4copy, _4cysize);
													AddStr(_4copy, "/", _4copy, _4cysize);
													Copy(_4oldcopy, _4copy, _4cysize);
													_Delete(_4oldcopy, DELETE_S);
													__4dir = opendir(_4copy);
							
	
													if(__4dir){
		
														while ((___4dir = readdir(__4dir)) != NULL){
														if(___4dir->d_type != DT_DIR && ___4dir->d_name[0] != '.'){
															printf(PRTN, _4copy, ___4dir->d_name);
															fprintf(file, PRTN, _4copy, ___4dir->d_name);
															if(StrEqual(str, "models", true)){
															printf(PRTN_PRECACHE, _4oldcopy, ___4dir->d_name);
															fprintf(file2, PRTN_PRECACHE, _4oldcopy, ___4dir->d_name);
															}
															else if(StrEqual(str, "sound", true)){
															printf(PRTN_SOUNDPRECACHE, _4oldcopy, ___4dir->d_name);
															fprintf(file2, PRTN_SOUNDPRECACHE, _4oldcopy, ___4dir->d_name);
															}
															
														}
														else if(___4dir->d_name[0] != '.'){
														DIR *__5dir;
														struct dirent *___5dir;
														int _5cysize = _4cysize+SizeOfString(___4dir->d_name)+1;
														char *_5copy = new char[_5cysize];
														char *_5oldcopy = new char[_5cysize];
														AddStr(_4copy, ___4dir->d_name, _5copy, _5cysize);
														AddStr(_5copy, "/", _5copy, _5cysize);
														Copy(_5oldcopy, _5copy, _5cysize);
														_Delete(_5oldcopy, DELETE_S);
														__5dir = opendir(_5copy);
							
	
														if(__5dir){
		
														while ((___5dir = readdir(__5dir)) != NULL){
														if(___5dir->d_type != DT_DIR && ___5dir->d_name[0] != '.'){
															printf(PRTN, _5copy, ___5dir->d_name);
															fprintf(file, PRTN, _5copy, ___5dir->d_name);				
															if(StrEqual(str, "models", true)){
															printf(PRTN_PRECACHE, _5oldcopy, ___5dir->d_name);
															fprintf(file2, PRTN_PRECACHE, _5oldcopy, ___5dir->d_name);
															}
															else if(StrEqual(str, "sound", true)){
															printf(PRTN_SOUNDPRECACHE, _5oldcopy, ___5dir->d_name);
															fprintf(file2, PRTN_SOUNDPRECACHE, _5oldcopy, ___5dir->d_name);
															}
														}
														else if(___5dir->d_name[0] != '.'){
															printf("NEED!\n");
														}
														
														}
														closedir(__5dir);
														}
								
														}
													
														}
														closedir(__4dir);
													}
								
													}
													
												}
												closedir(__3dir);
											}
								
											}									
										}
										closedir(__2dir);
									}
								
								}
						
								}
								closedir(__1dir);
							}
						}
			
					}
					closedir(__dir);
				}
			}
			
        }

        closedir(_dir);
    }
	
}




int main(int argc, char **argv)
{
	if(argc != 2)return 0;

	FILE* OutPut;
	FILE* OutPut_Precache;
	OutPut = fopen("Output.txt", "w");
	OutPut_Precache = fopen("Output_precache.txt", "w");
	listfile(argv[1], OutPut, OutPut_Precache);
	fclose(OutPut);
	fclose(OutPut_Precache);
    return 0;
}