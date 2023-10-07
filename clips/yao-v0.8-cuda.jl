#== QFT simulation on GPU ==#
using CuYao

nqubits = 20

#s output_delay=2
qft = EasyBuild.qft_circuit(nqubits);

#s output_delay=0.5
# initialize a quantum state
reg = zero_state(nqubits)

# upload the quantum state to GPU
creg = reg |> cu

#+ 2
# it is equivalent to
CuYao.cuzero_state(nqubits)

# execute the Fourier transformation circuit
apply(creg, qft)
#+ 2

# measure on the output
measure(creg; nshots=5)
#+ 2

# compute expectation values X₂X₈
expect(kron(nqubits , 2=>X, 8=>X), creg)

#+ 2
using BenchmarkTools

#s output_delay=3
# the CPU version
@btime apply($reg, $qft)

# the GPU version
@btime CuYao.CUDA.@sync apply($creg, $qft)
