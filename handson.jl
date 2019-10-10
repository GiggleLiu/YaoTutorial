using Yao, YaoExtensions

# Quantum Block Intermediate Representation
qft = QFTCircuit(4)

@edit QFTCircuit(4)

# get matrix
mat(qft)

# analyze properties
ishermitian(qft)
isunitary(qft)
isreflexive(qft)

# dagger
iqft = qft'

# arithmatics
MyHGate = Rz(-π/2)*Rx(-π/2)*Rz(-π/2)
mat(phase(-π/2)*MyHGate) ≈ mat(H)

# tuning the structure
function replace_hadamard(tree)
    tree isa HGate && return deepcopy(MyHGate)
    return chsubblocks(tree, replace_hadamard.(subblocks(tree)))
end

myqft = replace_hadamard(qft)

# apply an algorithm
reg = product_state(bit"0110")
out = copy(reg) |> qft
copy(out) |> iqft ≈ reg

measure(out; nshots=100)

# the performance
reg = rand_state(20)
reg |> concentrate(20, qft, (4,5,6,7))

# show to use GPU power
using CuYao, CuArrays
creg = reg |> cu
creg |> concentrate(20, qft, (4,1,6,5))

nbit = 16

# the hamiltonian
hami = heisenberg(nbit)

# exact diagonalization
hmat = mat(hami)
using KrylovKit
eg, vg = eigsolve(hmat, 1, :SR)

# imaginary time evolution
te = time_evolve(hami |> cache, -10im)
reg = rand_state(nbit)
energy(reg) = real(expect(hami, reg))
energy(reg)
reg |> te |> normalize!
energy(reg)

# vqe
dc = variational_circuit(nbit)

# parameter management
dispatch!(dc, :random)

for i=1:100
    regδ, paramsδ = expect'(hami, zero_state(16)=>dc)
    dispatch!(-, dc, 0.1*paramsδ)
    @show energy(zero_state(nbit) |> dc)
end
