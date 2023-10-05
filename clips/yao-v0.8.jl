# The package versions
using Pkg; Pkg.status()

using Yao

# Section 1: representing a quantum state
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

# Section 2: representing a quantum circuit
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

# Section 3: quantum circuit simulation

EasyBuild.qft_circuit(4)

# Let's first define the CPHASE gate
cphase(n, i, j) = control(n, i, j=> shift(2π/(2^(i-j+1))));

# To show the definition of a shift gate, the symbolic engine is quite useful
mat(shift(θ))

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

# show to use GPU power
using CuYao
creg = reg |> cu
creg |> subroutine(20, qft, (4,6,7))


#+ 3
############################### VQE
#+ 1
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

#s output_row_delay = 0.2
for i=1:100
    regδ, paramsδ = expect'(hami, zero_state(16)=>dc)
    dispatch!(-, dc, 0.1*paramsδ)
    @show energy(zero_state(nbit) |> dc)
end
