local badmm = require 'badmm'
local ffi = require 'ffi'
require 'cutorch'

-- setup GPUInfo that badmm wants
local gpu_info = ffi.new('GPUInfo')
badmm.C.badmm_getGPUInfo(gpu_info);


-- example inputs
m = 100
n = 50
C = torch.FloatTensor(100, 50):uniform()

-- create the BADMM_massTrans structure
local badmm_mt = ffi.new('BADMM_massTrans')

badmm_mt.m = m -- number of rows of matrix
badmm_mt.n = n   -- number of columns of matrix

badmm_mt.C = C:data()

badmm_mt.a = nil -- NULL
badmm_mt.b = nil -- NULL

badmm_mt.print_step = 0

badmm_mt.SAVEFILE = false

-- create the ADMM_para structure, with ADMM options
local admm_para = badmm.create_ADMM_para(0.001, 2000, 1e-4, badmm_mt.print_step)

badmm.C.gpuBADMM_MT(badmm_mt, admm_para, gpu_info);
