# The package versions
using Pkg; Pkg.status()

using Yao

#== Section 1: representing a quantum state ==#
zero_state(3)

# The quantum state is represented as a vector
statevec(zero_state(3))

# Similarly, we can create a random state, a product state or a GHZ state
# The element type is also configurable
rand_state(ComplexF32, 3)

product_state(bit"110")

ghz_state(3)

# As a new feature in Yao@v0.8, qudit states are also supported
# The following creates a random 3-level state
rand_state(3, nlevel=3)

# To create a qudit product state, we can use
product_state(dit"120;3")

#== Section 2: representing a quantum circuit ==#
# A quantum operator is represented as a matrix, or a Yao block.
# There are two types of blocks, primitive blocks and composite blocks.
# Primitive blocks are the basic building blocks of a quantum circuit.
X  # Pauli X

using SymEngine

@vars θ  # symbolic variable θ

rot(X, θ)  # Rotation X

mat(rot(X, θ))

# The first argument of `rot` can be any reflexive operator, i.e. O² = 1
mat(rot(SWAP, θ))  # Parameterized SWAP

mat(phase(θ)) # Phase gate

mat(shift(θ)) # Shift gate

matblock(rand_unitary(2); tag="random_gate") # random single qubit matrix block

matblock(rand_unitary(9); nlevel=3, tag="2x3-level") # random 2 qutrit matrix block

Measure(2)  # Measurement

time_evolve(X, 0.3)  # Time evolution, the first block can be any Hermitian operator

# Composite blocks
put(3, 1=>X)   # Put a block at the first qubit of a 3-qubit register

kron(X, X)     # Kronecker product of two blocks

control(3, 1, 2=>X)  # Control the second qubit of a 3-qubit register with the first qubit

chain(3, put(3, 1=>X), control(3, 1, 2=>X))  # Chain two blocks into a circuit

im * X   # Scaling a block

# X₁X₂ + X₂X₃
sum([kron(3, 1=>X, 2=>X), kron(3, 2=>X, 3=>X)])

#== Section 3: quantum Fourier transformation simulation ==#

EasyBuild.qft_circuit(4)

# Let's first define the CPHASE gate
cphase(n, i, j) = control(n, i, j=> shift(2π/(2^(i-j+1))));

# A cphase is defined as
mat(control(2, 2, 1=> shift(θ)))

# with CPHASE gate, we have the qft circuit defined as
hcphases(n, i) = chain(n, i==j ? put(n, i=>H) : cphase(n, j, i) for j in i:n);
qft_circ(n::Int) = chain(n, hcphases(n, i) for i = 1:n)

qft = qft_circ(3)
mat(qft) |> Matrix

# Note: this circuit is already defined in Yao as `Yao.EasyBuild.qft_circuit`,

# find matrix properties
ishermitian(qft)
isunitary(qft)
isreflexive(qft)

# get the dagger of qft
iqft = qft'

# run an qft block on a register
reg = product_state(bit"011")
out = copy(reg) |> qft
copy(out) |> iqft ≈ reg

# perform measurements on the output
res = measure(out; nshots=10)

# bit strings can be indexed (in a little endian way)
res[1][1]

# if we want to run this quantum algorithm on a 20 qubit register at qubits (4,5,6,7)
reg = rand_state(20)
reg |> subroutine(20, qft, (4,6,7))

#+ 2
#== Section 3.1: QFT simulation on GPU ==#
# show to use GPU power
using CuYao
creg = reg |> cu
creg |> subroutine(20, qft, (4,6,7))

#+ 2
#== Section 3.2: QFT simulation with Tensor Networks ==#
using YaoToEinsum

qft20 = qft_circ(20);

# convert to tensor network and optimize the contraction order
tensornetwork = YaoToEinsum.yao2einsum(qft20;
    initial_state=Dict([i=>0 for i in 1:20]),
    final_state=Dict([i=>0 for i in 1:20]),
    optimizer=TreeSA(nslices=3)
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
dc = variational_circuit(nbit)

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
Ω = 1.0   # sign flipped
τ = 4.29268/Ω
Δ = 0.377371*Ω
V = 1e3
ξ = -3.90242  # sign flipped
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