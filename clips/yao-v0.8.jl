# The package versions
using Pkg; Pkg.status()

using Yao

#== Section 1: representing a quantum state ==#
# Create a 3-qubit zero state
zero_state(3)

# The quantum state is represented as a vector
statevec(zero_state(3))

# Similarly, we can create a random state
# The element type is also configurable
rand_state(ComplexF32, 3)

# A product state
product_state(bit"110")

# A GHZ state
ghz_state(3)

# A random qutrit state
rand_state(3, nlevel=3)

# A qudit product state
product_state(dit"120;3")

#== Section 2: representing a quantum circuit ==#
# A quantum operator is represented as a matrix, or a Yao block.
# There are two types of blocks: primitive blocks and composite blocks.
#+ 3
#== Section 2.1: Primitive blocks ==#
# Primitive blocks are the basic building blocks of a quantum circuit.
# Pauli X gate
X

using SymEngine

# create a symbolic variable θ
@vars θ

# Rotation X gate
rot(X, θ)

# The matrix representation
mat(rot(X, θ))

# The first argument of `rot` can be any reflexive operator, i.e. O² = 1
# Parameterized SWAP
mat(rot(SWAP, θ))

# Phase gate
mat(phase(θ))

# Shift gate
mat(shift(θ))

# random single qubit matrix block
matblock(rand_unitary(2); tag="random_gate")

# random 2 qutrit matrix block
matblock(rand_unitary(9); nlevel=3, tag="2x3-level")

# Measurement
Measure(2)

# Time evolution, the first argument can be any Hermitian operator
time_evolve(X, 0.3)

#+ 3
#== Section 2.2: Composite blocks ==#
# Put a block at the first qubit of a 3-qubit register
put(3, 1=>X)

# The target gate can be applied on any subset of qubits
put(10, (5, 2, 1) => ConstGate.Toffoli)

# Kronecker product of two blocks
kron(X, X)

# A more general form can be
kron(10, 2=>X, 3=>Y)

# Control the second qubit of a 3-qubit register with the first qubit
control(3, 1, 2=>X)

# Multi-control and inverse control is supported
# Example: if and only if qubit 1 is 1 and qubit 8 is 0,
# apply 2-qubit gate `kron(H, Rz(π/4))` on position (7, 6).
control(10, (1, -8), (7, 6)=>kron(H, Rz(π/4)))

# Chain two blocks into a circuit
chain(3, put(3, 1=>X), control(3, 1, 2=>X))

# It is equivalent to inverse ordered operator multiplication.
control(3, 1, 2=>X) * put(3, 1=>X)

# Scaling a block
im * X

# X₁X₂ + X₂X₃
sum([kron(3, 1=>X, 2=>X), kron(3, 2=>X, 3=>X)])

#== Section 3: quantum Fourier transformation simulation (QFT) ==#
# A QFT circuit is available in `Yao.EasyBuild` module.
EasyBuild.qft_circuit(4)

# *Step by step*
# Let's first define the CPHASE gate
cphase(n, i, j) = control(n, i, j=> shift(2π/(2^(i-j+1))));

# A cphase is defined as
mat(control(2, 2, 1=> shift(θ)))

# with CPHASE gate, we have the qft circuit defined as
hcphases(n, i) = chain(n, i==j ? put(n, i=>H) : cphase(n, j, i) for j in i:n);
qft_circ(n::Int) = chain(n, hcphases(n, i) for i = 1:n)

# Let us check the matrix representation
qft = qft_circ(3)
mat(qft) |> Matrix

# Matrix properties
ishermitian(qft)
isunitary(qft)
isreflexive(qft)

# The dagger of qft
iqft = qft'

# Run the circuit
reg = product_state(bit"011")
out = copy(reg) |> qft
copy(out) |> iqft ≈ reg

# Measure the output (without collapsing state)
res = measure(out; nshots=10)

# Measure the output and collapsing state
res = measure!(out)

# bit strings can be indexed (little endian)
res[1][1]

# Run this quantum algorithm on a 20 qubit register at qubits (4,6,7)
reg = rand_state(20)
reg |> subroutine(20, qft, (4,6,7))

#+ 2
#== Section 3.1: QFT simulation with Tensor Networks ==#
using YaoToEinsum

qft20 = qft_circ(20);

# convert to tensor network and optimize the contraction order
tensornetwork = YaoToEinsum.yao2einsum(qft20;
    initial_state=Dict([i=>0 for i in 1:20]),
    final_state=Dict([i=>0 for i in 1:20]),
    optimizer=YaoToEinsum.TreeSA(nslices=3)
    )

# compute!
contract(tensornetwork)

#+ 3
#== Section 4: Simulate variational quantum algorithms ==#
#+ 1
nbit = 16

# the hamiltonian
hami = EasyBuild.heisenberg(nbit)

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
dc = EasyBuild.variational_circuit(nbit)

# parameter management
dispatch!(dc, :random)

#s output_row_delay = 0.2
for i=1:100
    regδ, paramsδ = expect'(hami, zero_state(16)=>dc)
    dispatch!(-, dc, 0.1*paramsδ)
    @show energy(zero_state(nbit) |> dc)
end

#== Section 5: Rydberg atoms as an example of qudit simulation ==#
# We recommend to use the `Bloqade.jl` package to seriously simulate Rydberg atoms
# Here, we only show how to use Yao to build a Rydberg atom simulator
# In this example, we will use the 3-level Rydberg Hamiltonian to implement the Levine-Pichler Pulse
nbits = 2

reg = zero_state(nbits; nlevel=3)

# prepare all states in (|0> - i|1>)/sqrt(2)
# time evolve π/4 with the Raman pulse Hamiltonian is equivalent to doing a X rotation π/2
apply!(reg, time_evolve(rydberg_chain(nbits; r=1.0), π/4))

expected = join(fill(arrayreg([1.0, -im, 0]; nlevel=3), nbits)...) |> normalize!

@test reg ≈ expected

# |11> -> |W>
reg0 = product_state(dit"11;3")
te = time_evolve(rydberg_chain(2; Ω=1.0, V=1e5), π/sqrt(2))
@test fidelity(reg0 |> te, product_state(dit"12;3") + product_state(dit"21;3") |> normalize!) ≈ 1

# the Levine-Pichler Pulse
Ω = 1.0
τ = 4.29268/Ω
Δ = 0.377371*Ω
V = 1e3
ξ = -3.90242
h1 = rydberg_chain(nbits; Ω=Ω, Δ, V)
h2 = rydberg_chain(nbits; Ω=Ω*exp(im*ξ), Δ, V)
pulse = chain(time_evolve(h1, τ), time_evolve(h2, τ))
@test mat(pulse) * reg.state ≈ apply(reg, pulse).state
@test ishermitian(h1) && ishermitian(h2)

i, j = dit"01;3", dit"11;3"

# half pulse drives |11> to |11>
# the first pulse completes a circle
@test isapprox(pulse[1][j, j]|> abs, 1; atol=1e-3)

ang1 = angle(pulse[i, i]) / π
ang2 = angle(pulse[j, j]) / π
@test isapprox(abs(pulse[i,i]), 1; atol=1e-2)
@test isapprox(abs(pulse[j,j]), 1; atol=1e-2)
@test isapprox(mod(2*ang1 - ang2, 2), 1, atol=1e-2)