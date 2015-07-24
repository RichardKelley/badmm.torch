local badmm = {}
badmm.C = require 'badmm.ffi'
local ffi = require 'ffi'

function badmm.create_ADMM_para(rho, MAX_ITER, tol, print_step)
    local admm_para = ffi.new('ADMM_para')
    -- ffi.gc(admm_para, destroy_ADMM_para)
    admm_para.rho = rho
    admm_para.MAX_ITER = MAX_ITER
    admm_para.tol = tol
    local iter_size = 1
    if print_step > 0 then
        iter_size = math.floor(MAX_ITER / print_step + 1);
    end
    -- these store the objective, time and error for each iteration, for later printing.
    admm_para.iter_obj = ffi.new('float[?]', iter_size)
    admm_para.iter_time = ffi.new('float[?]', iter_size)
    admm_para.iter_err = ffi.new('float[?]', iter_size)
    return admm_para
end



return badmm
