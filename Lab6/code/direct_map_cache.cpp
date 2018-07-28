#include <iostream>
#include <vector>
#include <math.h>

using namespace std;

struct cache_content{
	bool v = false;
	int timestamp = 0;
	unsigned int  tag = 0; 
};

const int K=1024;

void simulate(int cache_size, int block_size, int n){
	unsigned int tag,index,x;
	int num_block = (cache_size / block_size);
	int set = (num_block / n);
	int offset_bit = (int) log2(block_size);
	int index_bit = (int) log2(set);
	int line= cache_size>>(offset_bit);
	
	cache_content *cache = new cache_content[line];

	vector <int> instr_hit;
	vector <int> instr_miss;
  	FILE * fp=fopen("Trace.txt","r");					//read file
	int instr = 1;
	int time_count = 1;
	while(fscanf(fp,"%x",&x)!=EOF){
		index=(x>>offset_bit)&(line/n-1);
		tag=x>>(index_bit+offset_bit);
		bool hit = false;
		for(int i = 0; i < n; i ++){
			if(cache[index * n + i].v && cache[index * n + i].tag == tag){	// hit		
				instr_hit.push_back(instr);
				hit = true;
				cache[index * n + i].timestamp = time_count;
				break;
			}		
		}
		
		if(!hit){		//miss
			instr_miss.push_back(instr);   
			int picked_index;
			int min_timestamp = 1e9;
			for(int i = 0; i < n; i ++){	
				if(!cache[index * n + i].timestamp){
                    picked_index = i;
                    break;
                }
                else if (cache[index * n + i].timestamp < min_timestamp){
                	picked_index = i;
                	min_timestamp = cache[index * n + i].timestamp;
				}
			}
			cache[index * n + picked_index].v = true;
			cache[index * n + picked_index].timestamp = time_count;			
			cache[index * n + picked_index].tag = tag;
		}
		time_count += 1;
		instr += 1;
	}
	fclose(fp);
	double miss = ((double)(instr_miss.size())/(instr_hit.size() + instr_miss.size())) * 100;
	FILE * fpt=fopen("result.txt","w");
	fprintf(fpt, "Cache size: %d    Block size: %d    Associativity: %d\n", cache_size, block_size, n);
	fprintf(fpt,"Hits instructions: ");
	for(int i = 0; i < instr_hit.size(); i ++)
		fprintf(fpt, "%d,", instr_hit[i]);
	fprintf(fpt, "\n\nMisses instructions: ");
	for(int i = 0; i < instr_miss.size(); i ++)
		fprintf(fpt, "%d,", instr_miss[i]);
	fprintf(fpt, "\n\nMiss rate: %.2f%\n", miss);	
	fclose(fpt);
	delete [] cache;
}
	
int main(){
	int c_size, b_size, associativity;
	cout << "Please enter the cache size (in KB): ";
	cin >> c_size;
	cout << "Please enter the block size (in B): ";
	cin >> b_size;
	cout << "Please enter the associativity: ";
	cin >> associativity;
	simulate(c_size * K, b_size, associativity);
	cout << endl << "Please check the generated result.txt" << endl;
	/*---------------------------------
	// 2a test
	for(int i = 2; i <= 5; i ++){
		simulate(64, pow(2, i), 1);
		simulate(128, pow(2, i), 1);
		simulate(256, pow(2, i), 1);
		simulate(512, pow(2, i), 1);
	}
	// 2b test
	for(int i = 0; i <= 5; i ++){
		simulate(pow(2, i) * K, 32, 1);
		simulate(pow(2, i) * K, 32, 2);
		simulate(pow(2, i) * K, 32, 4);
		simulate(pow(2, i) * K, 32, 8);
	}
	----------------------------------*/
	
}
