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

# show to use GPU power
using CuYao, CuArrays
creg = reg |> cu
creg |> concentrate(20, qft, (4,1,6,5))

nbit = 16

# the hamiltonian
hami = heisenberg(nbit)

# the energy
expect(hami, out)

energy(reg) = real(expect(hami, reg))
energy(zero_state(nbit) |> dc)

# exact diagonalization
using KrylovKit
hmat = mat(hami)
eg, vg = eigsolve(hmat, 1, :SR)

# imaginary time evolution
te = time_evolve(hami |> cache, -10im)
reg = rand_state(nbit)
energy(reg)
reg |> te |> normalize!
energy(reg)

# vqe
dc = random_diff_circuit(nbit)
dc = dc |> autodiff(:BP)

# parameter management
dispatch!(dc, :random)

out = zero_state(nbit) |> dc

# get the gradient
∇out = copy(out) |> hami
backward!((copy(out), ∇out), dc)
grad = gradient(dc)

function grad()
    out = zero_state(nbit) |> dc
    dout = copy(out) |> hami
    backward!((copy(out), dout), dc)
    return gradient(dc)
end

dispatch!(-, dc, 0.01*grad())
energy(zero_state(nbit) |> dc)
