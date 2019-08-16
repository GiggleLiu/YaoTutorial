using Yao, QuAlgorithmZoo

qc = QFTCircuit(4)

mat(qc)

ishermitian(qc)
isunitary(qc)
isreflexive(qc)

reg = rand_state(20)
reg |> concentrate(20, qc, (4,1,6,5))

using BenchmarkTools
@benchmark $reg |> $(concentrate(20, qc, (4,1,6,5))) seconds=1

using CuYao, CuArrays
creg = reg |> cu
@benchmark CuArrays.@sync $creg |> $(concentrate(20, qc, (4,1,6,5)))

nbit = 16
dc = random_diff_circuit(nbit)
dc = dc |> autodiff(:BP)

dispatch!(dc, :random)

out = zero_state(nbit) |> dc

sx(i) = put(nbit, i=>X)
sy(i) = put(nbit, i=>Y)
sz(i) = put(nbit, i=>Z)

#hami = sum([sx(i)*sx(i+1)+sy(i)*sy(i+1)+sz(i)*sz(i+1) for i=1:nbit-1])
hami = sum([sx(i)*sx(i+1)+sy(i)*sy(i+1)+sz(i)*sz(i+1) for i=1:1])

∇out = copy(out) |> hami
#@benchmark backward!((copy(out), ∇out), dc)
backward!((copy(out), ∇out), dc)
grad = gradient(dc)

using Statistics: var, std
std(grad)
