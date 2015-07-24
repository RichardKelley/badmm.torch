local ffi = require 'ffi'

ffi.cdef[[

typedef struct GPUInfo
{
    unsigned int MAX_GRID_SIZE;
    unsigned int MAX_BLOCK_SIZE;
}GPUInfo;

typedef struct ADMM_para
{
    float rho;          // penalty parameter
    float* iter_obj;
    float* iter_time;
    float* iter_err;
    unsigned int MAX_ITER;          // MAX_ITER
    float tol;
}ADMM_para;

typedef struct BADMM_massTrans
{
    int m;
    int n;

    float* C;                       // row major order
    float* a;
    float* b;

    int print_step;

    bool SAVEFILE;
}BADMM_massTrans;

void badmm_getGPUInfo(GPUInfo* g);

void gpuBADMM_MT( BADMM_massTrans* badmm_mt, ADMM_para* badmmpara, GPUInfo* gpu_info);

]]

return ffi.load(package.searchpath('libbadmm', package.cpath))
