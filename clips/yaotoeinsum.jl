#== QFT simulation with Tensor Networks ==#
using YaoToEinsum

qft20 = EasyBuild.qft_circuit(28);

# convert to tensor network and optimize the contraction order
tensornetwork = YaoToEinsum.yao2einsum(qft20;
    initial_state=Dict([i=>0 for i in 1:20]),
    final_state=Dict([i=>0 for i in 1:20])
    )
    
# using the slicing technique to reduce space complexity
tensornetwork = YaoToEinsum.yao2einsum(qft20;
    initial_state=Dict([i=>0 for i in 1:20]),
    final_state=Dict([i=>0 for i in 1:20]),
    optimizer=YaoToEinsum.TreeSA(nslices=3)
    )

# compute!
contract(tensornetwork)

# Utilize the power of GPU
using CUDA, BenchmarkTools

# upload tensors to your CUDA device.
cutensornetwork = cu(tensornetwork)

# the CPU version
@btime contract($tensornetwork)

# the GPU version
@btime CUDA.@sync contract($cutensornetwork)