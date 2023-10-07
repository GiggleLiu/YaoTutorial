#== QFT simulation with Tensor Networks ==#
using YaoToEinsum, Yao

nqubits = 33

qft = EasyBuild.qft_circuit(nqubits);

# convert to tensor network and optimize the contraction order
tensornetwork = YaoToEinsum.yao2einsum(qft;
    initial_state=Dict([i=>0 for i in 1:nqubits]),
    final_state=Dict([i=>0 for i in 1:nqubits])
    )
    
# using the slicing technique to reduce space complexity
tensornetwork = YaoToEinsum.yao2einsum(qft;
    initial_state=Dict([i=>0 for i in 1:nqubits]),
    final_state=Dict([i=>0 for i in 1:nqubits]),
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
