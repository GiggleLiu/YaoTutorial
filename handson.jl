using Yao, QuAlgorithmZoo

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

using BenchmarkTools
@benchmark $reg |> $(concentrate(20, qft, (4,1,6,5))) seconds=1

# show to use GPU power
using CuYao, CuArrays
creg = reg |> cu
@benchmark CuArrays.@sync $creg |> $(concentrate(20, qft, (4,1,6,5)))

nbit = 16
dc = random_diff_circuit(nbit)
dc = dc |> autodiff(:BP)

# parameter management
dispatch!(dc, :random)

out = zero_state(nbit) |> dc

sx(i) = put(nbit, i=>X)
sy(i) = put(nbit, i=>Y)
sz(i) = put(nbit, i=>Z)

hami = sum([sx(i)*sx(i+1)+sy(i)*sy(i+1)+sz(i)*sz(i+1) for i=1:nbit-1])

∇out = copy(out) |> hami
backward!((copy(out), ∇out), dc)
grad = gradient(dc)

using Statistics: var, std
std(grad)
