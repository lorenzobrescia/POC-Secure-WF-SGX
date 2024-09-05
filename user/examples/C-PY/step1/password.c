#include <stdio.h>
#include <string.h>
#include <math.h>

typedef struct{
	int length;
	int charset;
	int entropy;
	int predict;
	int common;
} Score;

int scoreLength(char*);
int scoreCharset(int);
double entropy(char*);
int scoreEntropy(double);
int scorePredict(char*);
int scoreCommon(char*);

#define CHARSET 36
#define PASS_FILE "input/enc/pass.txt"
#define TOP_PSW_FILE "input/enc/commons.txt"
#define RES_FILE "results/res.txt"

int main(){
	Score score;
	FILE* fp_in = fopen(PASS_FILE, "r");
	FILE* fp_out = fopen(RES_FILE, "w");
	int max_psw_len = 40;
	char psw[max_psw_len];
	double mean;
	// int weak = 0, fair = 0, strong = 0;
	while(fgets(psw, max_psw_len, fp_in)) {
		score.length = scoreLength(psw);
		score.charset = scoreCharset(CHARSET);
		score.entropy = scoreEntropy(entropy(psw));
		score.predict = scorePredict(psw);
		score.common = scoreCommon(psw);
		mean = (score.length + score.charset + score.entropy + score.predict + score.common) / 5.0f;
		fprintf(fp_out, "%lf\n", mean);
		/*if(mean >= 8)
			strong++;
		else if(mean >= 4)
			fair++;
		else
			weak++;
		printf("Length %d\n", score.length);
		printf("Charset %d\n", score.charset);
		printf("Entropy %d\n", score.entropy);
		printf("Predict %d\n", score.predict);
		printf("Common %d\n", score.common);
		printf("Final score of '%s' is: %lf\n\n", psw, mean); */
	}

	fclose(fp_in);
	fclose(fp_out);
	return 0;
}

int scoreLength(char* psw){
	int score, len;
	len = strlen(psw);
	if(len > 12)
		score = 10;
	else if(len >= 10)
		score = 8;
	else if(len >= 8)
		score = 6;
	else if(len >= 6)
		score = 4;
	else
		score = 0 ;
	return score;
}

int scoreCharset(int charset){
	int score;
	switch(charset){
		case 26:
			score = 2;
			break;
		case 36:
			score = 4;
			break;
		case 52:
			score = 6;
			break;
		case 62:
		case 84:
			score = 8;
			break;
		case 96:
			score = 10;
			break;
		default:
			score = 0;
	}
	return score;
}

//H = len * log_2(charset)
double entropy(char* psw){
	int len;
	double log2;
	len = strlen(psw);
	log2 = log(CHARSET) / log(2);
	return len * log2;
}

int scoreEntropy(double entropy){
	int score;
	if(entropy > 85)
		score = 10;
	else if(entropy > 66)
		score = 8;
	else if(entropy > 47)
		score = 6;
	else if(entropy > 28)
		score = 4;
	else
		score = 2;
	return score;
}

int scorePredict(char* psw){
	int score = 8, len = strlen(psw);
	int consecutive = 1;
	int penalty = 0;
	for(int i = 1; i < len; i++){
		if (psw[i-1] + 1 == psw[i]){
			consecutive++;
			if(consecutive >= 3)
				penalty++;
		}
		else consecutive = 1;
	}
	return (score - penalty < 0 ? 0 : score - penalty);
}

int scoreCommon(char* psw){
	FILE* fp = fopen(TOP_PSW_FILE, "r");
	int score = 8;
	int max_psw_len = 255;
	char common_psw[max_psw_len];
	while(fgets(common_psw, max_psw_len, fp)) {
		if(strcmp(common_psw, psw) == 0){
			score = 3;
			break;
		}
	}
	return score;
}