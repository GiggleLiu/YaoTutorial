using Yao, YaoExtensions

# ] st Yao

qft_circuit(4)

# Let's first define the CPHASE gate
cphase(n, i, j) = control(n, i, j=> shift(2π/(2^(i-j+1))));

# To show the definition of a shift gate, the symbolic engine is quite useful
@vars θ
mat(shift(θ))

# A cphase is defined as
mat(control(2, 2, 1=> shift(θ)))

# with CPHASE gate, we have the qft circuit defined as
hcphases(n, i) = chain(n, i==j ? put(n, i=>H) : cphase(n, j, i) for j in i:n);
qft_circ(n::Int) = chain(n, hcphases(n, i) for i = 1:n)

qft = qft_circ(3)
mat(qft) |> Matrix

# Note: this circuit is already defined in YaoExtensions,
# try: `using YaoExtensions: qft_circ`

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
using CuYao, CuArrays
creg = reg |> cu
creg |> subroutine(20, qft, (4,6,7))


############################### VQE
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
