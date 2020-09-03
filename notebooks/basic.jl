### A Pluto.jl notebook ###
# v0.11.11

using Markdown
using InteractiveUtils

# ╔═╡ 81f8df66-ec75-11ea-04b0-11cee809c77e
using Yao, SymEngine, Random, YaoExtensions

# ╔═╡ d834b49c-eccd-11ea-1164-5dc2b9b4a8e2
begin
	# for pretty printing
	using YaoPlots, Compose, Latexify
	CircuitStyles.setfontfamily("ubuntu")
	CircuitStyles.setparamtextsize(10pt)
end;

# ╔═╡ 3e93b328-ed8c-11ea-3fde-c94b476c5d41
using CuYao

# ╔═╡ b08d33c4-ed72-11ea-33a5-7d0c8592a0a9
θ, ϕ = Basic(:θ), Basic(:ϕ)

# ╔═╡ 9d9c3a4e-ed72-11ea-142e-7b062a145417
function pretty_print(x::AbstractArray)
	if eltype(x) <: Union{AbstractFloat,Complex{<:AbstractFloat}}
		y = round.(x; digits=2)
	else
		y = x
	end
	latexify(y)
end

# ╔═╡ 547d81ea-ed60-11ea-264d-ab5eb70e5714
md"## Construct a quantum circuit"

# ╔═╡ 7d221520-ed60-11ea-08a6-371dbe930ae7
md"# Everything is matrix"

# ╔═╡ ff4a50b0-ed62-11ea-3282-b5ea4b1b9fde
md"## A Hadamard gate has a matrix presentation"

# ╔═╡ f6518b3a-ed72-11ea-2dd5-73420ccdfac5
mat(H)

# ╔═╡ d9fb87cc-ed2e-11ea-16ff-670e4a030c85
mat(Basic, H) |> pretty_print

# ╔═╡ e8a9c1b2-ed60-11ea-19f9-b75751973013
H |> vizcircuit

# ╔═╡ 11e693aa-ed63-11ea-2ea2-95fe8eb85001
md"## Expands the Hilbert space"

# ╔═╡ 8a60d1f4-ed60-11ea-3f5f-45c711f1558c
mat(Basic, put(3, 2=>H)) |> pretty_print

# ╔═╡ dcd11e76-ed60-11ea-391f-b7e3578a157a
vizcircuit(put(3, 2=>H))

# ╔═╡ 22e09606-ed63-11ea-3ffe-53ae3e76ae9f
md"""## "Multiply" two matrices"""

# ╔═╡ 3af3f0fa-ed61-11ea-0766-9d41c8d4db93
mat(chain(H, Rx(θ))) |> pretty_print

# ╔═╡ 448e5720-ed61-11ea-11be-ff46f07e3252
chain(H, Rx(θ)) |> vizcircuit

# ╔═╡ f0f1e3ba-ed63-11ea-10ab-bf5f7af3adba
md"""## "Kronecker Product" """

# ╔═╡ 9c8ce5e2-ed61-11ea-12c4-57e7d83f8ae1
mat(kron(H, Rx(θ))) |> pretty_print

# ╔═╡ a70021cc-ed61-11ea-24f7-a3cf1614a3f2
kron(H, Rx(θ)) |> vizcircuit

# ╔═╡ ae2e3470-ed70-11ea-155e-31a8f66c9005
md"""## Taking adjoint"""

# ╔═╡ d5cda738-ed70-11ea-33b8-e9aa7353e205
chain(H, Rx(θ)) |> vizcircuit

# ╔═╡ c6f6346e-ed70-11ea-19e2-03c81c897504
chain(H, Rx(θ))' |> vizcircuit

# ╔═╡ 33e5e9dc-ed64-11ea-3fec-bf7be4a2d2cd
md"# Even addition"

# ╔═╡ 4230075e-ed64-11ea-15f3-63b7ae0ff40e
+(H, Rx(θ))

# ╔═╡ f363b878-ed70-11ea-1ade-4b8f02236c1a
mat(+(H, Rx(θ))) |> pretty_print

# ╔═╡ 8f1feea4-ed70-11ea-1b13-e9c19bb83837
md"## QFT Circuit"

# ╔═╡ 41bd7534-ed73-11ea-3a5f-9d77f4daae02
CircuitStyles.setparamtextsize(8pt)

# ╔═╡ 2ac12362-ed5f-11ea-1b5f-7146763da866
cphase(n, i, j) = control(n, i, j=> shift(2π/(2^(i-j+1))));

# ╔═╡ 961670d4-ed70-11ea-1edb-0d347d2f1836
function qft_circuit(n::Int)
	c = chain(n)
	for i=1:n, j=i:n
		push!(c, i==j ? put(n, i=>H) : cphase(n, j, i))
	end
	return c
end;

# ╔═╡ 9df73be4-ed70-11ea-39cb-d5990dc1564d
qft = qft_circuit(4);

# ╔═╡ a46d2148-ed70-11ea-06af-55510ae77c5e
qft |> vizcircuit(scale=0.7)

# ╔═╡ 221f50e4-ed64-11ea-2225-f5b93983fec4
md"## QFT applied on a quantum state"

# ╔═╡ 40ed2b6a-ed71-11ea-23bc-b95b07d52933
reg = rand_state(4)

# ╔═╡ 0bd4d464-ed71-11ea-2fe0-035209d2f34f
copy(reg) |> qft ≈ reg

# ╔═╡ 329570fe-ed71-11ea-35c1-255311494b20
copy(reg) |> qft |> qft' ≈ reg

# ╔═╡ 6bca9c08-ed73-11ea-2791-9d07f1379180
md"# Automatic differentiation"

# ╔═╡ 35170d06-ed85-11ea-3187-73cf54715a30
md"## Expectation value"

# ╔═╡ ea07f3bc-ed80-11ea-1fe8-69e5a97d493f
function heisenberg(nbit::Int; periodic::Bool=true)
    map(1:(periodic ? nbit : nbit-1)) do i
        j=i%nbit+1
        repeat(nbit,X,(i,j)) + repeat(nbit, Y, (i,j)) + repeat(nbit, Z, (i,j))
    end |> sum
end

# ╔═╡ 0b0985d8-ed81-11ea-2800-85f980a28373
h = heisenberg(4)

# ╔═╡ 2f2db904-ed81-11ea-000a-3fa169c9300a
initial_state = zero_state(4)

# ╔═╡ 39231c74-ed84-11ea-11c5-192d4ca5932a
CircuitStyles.setparamtextsize(7pt);

# ╔═╡ 626c8316-ed81-11ea-0292-c1d355f176f4
circuit_ansatz = variational_circuit(4, 2);

# ╔═╡ 9193fa6e-ed83-11ea-3903-afda416ee22e
circuit_ansatz |> vizcircuit(scale=0.6; w_depth=0.7)

# ╔═╡ 1999d444-ed84-11ea-1ed7-eb0e1d2e51cd
dispatch!(circuit_ansatz, :random) |> vizcircuit(scale=0.6, w_depth=0.7)

# ╔═╡ 121f1f76-ed82-11ea-1d19-07103f71a6b7
expect(h, initial_state=>circuit_ansatz)

# ╔═╡ d4333d92-ed80-11ea-3416-db41a1a6a010
δreg0, δcircuit = expect'(h, initial_state=>circuit_ansatz);

# ╔═╡ ba251996-ed84-11ea-237b-77bfbc5be2c8
δcircuit

# ╔═╡ 1efdce60-ed85-11ea-10b2-85a4409fdd36
md"## Operator fidelity"

# ╔═╡ c09825fa-ed84-11ea-0bbf-957368d32bef
operator_fidelity(circuit_ansatz, qft)

# ╔═╡ ea87ce60-ed84-11ea-0c03-ff90e32832ec
operator_fidelity'(circuit_ansatz, qft)

# ╔═╡ 2a1bf04c-ed85-11ea-186b-892fac29e9df
md"## Fidelity"

# ╔═╡ f0276bbe-ed84-11ea-30c8-09d5c94d253d
fidelity(zero_state(4) => circuit_ansatz, zero_state(4)=>qft)

# ╔═╡ 0d9db176-ed85-11ea-356a-69e4705ecf7a
fidelity'(zero_state(4) => circuit_ansatz, zero_state(4)=>qft)

# ╔═╡ 8d446ef6-ed80-11ea-286a-47054161c512
md"## Lower level"

# ╔═╡ e5bbb648-ed76-11ea-070e-57bd022543a0
δy = rand_state(4)

# ╔═╡ edf7ea5c-ed76-11ea-3fbd-dd7047146439
x = rand_state(4)

# ╔═╡ ad47ed0c-ed78-11ea-1fad-a33acab92643
y = copy(x) |> qft

# ╔═╡ fd1092ac-ed74-11ea-3747-17492bfbd01c
(δx, x_), δparams = Yao.AD.apply_back((δy, copy(y)), qft)

# ╔═╡ 0bf8a9a6-ed77-11ea-334c-2ba8c5a24c46
x_ ≈ x

# ╔═╡ 00201032-ed7d-11ea-06a6-1dfff1bb0532
Yao.AD.mat_back(qft, Random.randn!(mat(qft)))

# ╔═╡ a5b9b59c-ed7e-11ea-1cdd-893d5bf2fbda
randn!(mat(qft))

# ╔═╡ dfdb96d4-ed8b-11ea-0ea3-511e3f7fbf51
md"# GPU"

# ╔═╡ 38448132-ed8c-11ea-3dbf-9976b36e4920
cureg = zero_state(4) |> cu

# ╔═╡ 4d348682-ed8c-11ea-3a4c-f1ccd5370956
cureg |> qft

# ╔═╡ Cell order:
# ╠═81f8df66-ec75-11ea-04b0-11cee809c77e
# ╠═d834b49c-eccd-11ea-1164-5dc2b9b4a8e2
# ╠═b08d33c4-ed72-11ea-33a5-7d0c8592a0a9
# ╠═9d9c3a4e-ed72-11ea-142e-7b062a145417
# ╟─547d81ea-ed60-11ea-264d-ab5eb70e5714
# ╟─7d221520-ed60-11ea-08a6-371dbe930ae7
# ╟─ff4a50b0-ed62-11ea-3282-b5ea4b1b9fde
# ╠═f6518b3a-ed72-11ea-2dd5-73420ccdfac5
# ╠═d9fb87cc-ed2e-11ea-16ff-670e4a030c85
# ╠═e8a9c1b2-ed60-11ea-19f9-b75751973013
# ╟─11e693aa-ed63-11ea-2ea2-95fe8eb85001
# ╠═8a60d1f4-ed60-11ea-3f5f-45c711f1558c
# ╠═dcd11e76-ed60-11ea-391f-b7e3578a157a
# ╟─22e09606-ed63-11ea-3ffe-53ae3e76ae9f
# ╠═3af3f0fa-ed61-11ea-0766-9d41c8d4db93
# ╠═448e5720-ed61-11ea-11be-ff46f07e3252
# ╟─f0f1e3ba-ed63-11ea-10ab-bf5f7af3adba
# ╠═9c8ce5e2-ed61-11ea-12c4-57e7d83f8ae1
# ╠═a70021cc-ed61-11ea-24f7-a3cf1614a3f2
# ╟─ae2e3470-ed70-11ea-155e-31a8f66c9005
# ╠═d5cda738-ed70-11ea-33b8-e9aa7353e205
# ╠═c6f6346e-ed70-11ea-19e2-03c81c897504
# ╟─33e5e9dc-ed64-11ea-3fec-bf7be4a2d2cd
# ╠═4230075e-ed64-11ea-15f3-63b7ae0ff40e
# ╠═f363b878-ed70-11ea-1ade-4b8f02236c1a
# ╟─8f1feea4-ed70-11ea-1b13-e9c19bb83837
# ╟─41bd7534-ed73-11ea-3a5f-9d77f4daae02
# ╠═2ac12362-ed5f-11ea-1b5f-7146763da866
# ╠═961670d4-ed70-11ea-1edb-0d347d2f1836
# ╠═9df73be4-ed70-11ea-39cb-d5990dc1564d
# ╠═a46d2148-ed70-11ea-06af-55510ae77c5e
# ╟─221f50e4-ed64-11ea-2225-f5b93983fec4
# ╠═40ed2b6a-ed71-11ea-23bc-b95b07d52933
# ╠═0bd4d464-ed71-11ea-2fe0-035209d2f34f
# ╠═329570fe-ed71-11ea-35c1-255311494b20
# ╟─6bca9c08-ed73-11ea-2791-9d07f1379180
# ╟─35170d06-ed85-11ea-3187-73cf54715a30
# ╠═ea07f3bc-ed80-11ea-1fe8-69e5a97d493f
# ╠═0b0985d8-ed81-11ea-2800-85f980a28373
# ╠═2f2db904-ed81-11ea-000a-3fa169c9300a
# ╟─39231c74-ed84-11ea-11c5-192d4ca5932a
# ╠═626c8316-ed81-11ea-0292-c1d355f176f4
# ╠═9193fa6e-ed83-11ea-3903-afda416ee22e
# ╠═1999d444-ed84-11ea-1ed7-eb0e1d2e51cd
# ╠═121f1f76-ed82-11ea-1d19-07103f71a6b7
# ╠═d4333d92-ed80-11ea-3416-db41a1a6a010
# ╠═ba251996-ed84-11ea-237b-77bfbc5be2c8
# ╟─1efdce60-ed85-11ea-10b2-85a4409fdd36
# ╠═c09825fa-ed84-11ea-0bbf-957368d32bef
# ╠═ea87ce60-ed84-11ea-0c03-ff90e32832ec
# ╟─2a1bf04c-ed85-11ea-186b-892fac29e9df
# ╠═f0276bbe-ed84-11ea-30c8-09d5c94d253d
# ╠═0d9db176-ed85-11ea-356a-69e4705ecf7a
# ╟─8d446ef6-ed80-11ea-286a-47054161c512
# ╠═e5bbb648-ed76-11ea-070e-57bd022543a0
# ╠═edf7ea5c-ed76-11ea-3fbd-dd7047146439
# ╠═ad47ed0c-ed78-11ea-1fad-a33acab92643
# ╠═fd1092ac-ed74-11ea-3747-17492bfbd01c
# ╠═0bf8a9a6-ed77-11ea-334c-2ba8c5a24c46
# ╠═00201032-ed7d-11ea-06a6-1dfff1bb0532
# ╠═a5b9b59c-ed7e-11ea-1cdd-893d5bf2fbda
# ╟─dfdb96d4-ed8b-11ea-0ea3-511e3f7fbf51
# ╠═3e93b328-ed8c-11ea-3fde-c94b476c5d41
# ╠═38448132-ed8c-11ea-3dbf-9976b36e4920
# ╠═4d348682-ed8c-11ea-3a4c-f1ccd5370956
