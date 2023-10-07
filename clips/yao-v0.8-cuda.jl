#== QFT simulation on GPU ==#
# show to use GPU power
using CuYao

nqubits = 20

qft = EasyBuild.qft_circuit(nqubits)

# initialize a quantum state
reg = zero_state(nqubits)

# upload it to GPU
creg = reg |> cu

# it is equivalent to
CuYao.cuzero_state(nqubits)

# excute the Fourier transformation on qubits (4,6,7)
creg |> qft

# measure on the output
measure(creg; nshots=10)

using BenchmarkTools
@btime apply($reg, $qft)

@btime CuYao.CUDA.@sync apply($creg, $qft)