### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ f178d9fe-49f4-11eb-0863-21e2e3934592
using Yao, YaoPlots

# ╔═╡ d59b39ec-49f5-11eb-3d4a-fb69f2505d3c
using SymEngine

# ╔═╡ 036bc3dc-49f6-11eb-17d6-c18fb583d95b
using CuYao

# ╔═╡ fb76a530-4a01-11eb-372d-1fc9e0fb9543
using LuxurySparse

# ╔═╡ 24195e6a-49f5-11eb-2a5f-3da8bb6dbf75
md"## Visualization"

# ╔═╡ adaf6746-49f5-11eb-1fc2-d1e8ded784cd
cphase(i, j) = control(i, j=> shift(2π/(2^(i-j+1))));

# ╔═╡ b2daa884-49f5-11eb-10cc-ab4774630c38
hcphases(n, i) = chain(n, i==j ? put(i=>H) : cphase(j, i) for j in i:n);

# ╔═╡ b9659114-49f5-11eb-1ce3-f96780ae663c
qft_circuit(n::Int) = chain(n, hcphases(n, i) for i = 1:n)

# ╔═╡ faa2de26-49f4-11eb-3387-2193a51fa9a7
c1 = qft_circuit(5)

# ╔═╡ 30c12de6-49f5-11eb-3d1c-59586c7bd3d3
vizcircuit(c1)

# ╔═╡ 6320b1c6-49f5-11eb-0262-63278ebb0f57
md"## Basic"

# ╔═╡ 69cda57e-49f5-11eb-2c85-296a886165a0
md"obtaining matrix"

# ╔═╡ 1ed8ea9a-49f7-11eb-18eb-27315cb06151
X |> vizcircuit

# ╔═╡ 25527d96-49f7-11eb-1192-2926cf3e392c
mat(X)

# ╔═╡ 27a63e84-49f7-11eb-336b-419711e6b8d7
a1 = put(5, 2=>X)

# ╔═╡ 3de7311c-49f7-11eb-074b-fd3d46c43dde
vizcircuit(a1)

# ╔═╡ 4add0112-49f7-11eb-06d8-ff57b319f344
mat(a1)

# ╔═╡ 7b3a4e64-49f9-11eb-3e63-719d972e6de1
md"#### Rotation gate

Definition: rot(G, $\theta$) = $e^{-\frac{i\theta}{2}G}$,
the first parameter `G^2 = 1`"

# ╔═╡ 705e9df4-49f9-11eb-00e1-5b56512ba687
rot(X, 0.5)

# ╔═╡ 8afdc374-49f9-11eb-0c56-75e6eb17fd3d
rot(SWAP, 0.5)

# ╔═╡ e5e874be-49f9-11eb-2bb4-2f7a1e5fd93b
md"#### Time evolution
Definition: time_evolve(H, t) = $e^{-iHt}$
"

# ╔═╡ 176c38a4-49fa-11eb-2585-cdec9048f96b
kron(X, X) + kron(Y, Y) + kron(Z, Z)

# ╔═╡ 0cf79dc2-49f6-11eb-26e6-d11070ec8539
function heisenberg(nbit::Int; periodic::Bool=true)
    map(1:(periodic ? nbit : nbit-1)) do i
        j=i%nbit+1
        repeat(nbit,X,(i,j)) + repeat(nbit, Y, (i,j)) + repeat(nbit, Z, (i,j))
    end |> sum
end

# ╔═╡ da33b2aa-49f9-11eb-06c0-3bb6766d5872
heisenberg(5)

# ╔═╡ 2ec10abe-49f7-11eb-1cd8-7b69b03569ad
cc = chain(5, put(5, 2=>X), put(5, 2=>Y))

# ╔═╡ 7742dea4-49fa-11eb-1043-63c54dabb852
cc |> vizcircuit

# ╔═╡ 5fc06e98-49f5-11eb-0f05-234d3e13c8a3
mat(cc)

# ╔═╡ 932a3d2e-49fa-11eb-0070-a5be7aafee01
pc = put(5, 2=>chain(X, Y))

# ╔═╡ 9c6e3476-49fa-11eb-2a2a-5d380866fc50
vizcircuit(pc)

# ╔═╡ ad52ee80-49fa-11eb-33a9-dfedc6184e57
pk = put(5, (2,4)=>kron(X,X))

# ╔═╡ bba116ce-49fa-11eb-0eed-e1fe0461fc8e
pk |> vizcircuit

# ╔═╡ 77f99e00-49f5-11eb-1c37-f943c400f2a0
md"apply the gate on a register"

# ╔═╡ 51e4e26e-49fb-11eb-10c2-8d4239e4b0a9
matblock(rand_unitary(2))

# ╔═╡ 5ffed2c4-49fb-11eb-3ea7-0733bb7c540c
@const_gate XY = mat(X * Y)

# ╔═╡ 6feab568-49fb-11eb-350f-55e0248f0a99
mat(XY)

# ╔═╡ cc4ae36e-49fb-11eb-0bf7-05de6ee2d20b
rot(X, 0.5) |> iparameters

# ╔═╡ f2ef2a7a-49fb-11eb-1cd6-0fcaf3d4fb25
setiparams!(rot(X, 0.5), 0.6)

# ╔═╡ e2ee907a-49fb-11eb-28a8-3393425fddc4
parameters(rot(X, 0.5))

# ╔═╡ 855d285a-49f5-11eb-2231-2d01d965db6f
reg = rand_state(5)

# ╔═╡ 8bfbb92e-49f5-11eb-3f71-a7c6fefb9c4c
reg2 = copy(reg) |> c1

# ╔═╡ 334ce004-49f6-11eb-12d5-013def55488b
measure!(reg2)

# ╔═╡ 6e3b22ce-49fc-11eb-15da-1bd8c7a3f410
reg3 = rand_state(10)

# ╔═╡ 63606c92-49fc-11eb-2349-91849e73fb24
copy(reg3) |> focus!(1:5...) |> c1 |> relax!(1:5...)

# ╔═╡ f3f1652c-49fc-11eb-21e7-17c08b91042b
dm = copy(reg3) |> focus!(3,4) |> ρ

# ╔═╡ 0b23714a-49fd-11eb-1144-970c83b24da3
dropdims(state(dm), dims=3)

# ╔═╡ 06a9aca0-49fe-11eb-372c-afd2b9b746a5
reg4 = rand_state(2)

# ╔═╡ 0e7cb738-49fe-11eb-0da7-91b0da8b054d
measure(reg4, nshots=10)

# ╔═╡ 138d3d88-49fe-11eb-1102-6dfec64f04bd
measure(reg4; nshots=10)

# ╔═╡ 1e70beb2-49fe-11eb-189f-9b80e400083f
measure!(reg4)

# ╔═╡ 2b24b5b6-49fe-11eb-0309-35e1126ec443
measure(reg4; nshots=10)

# ╔═╡ 3e9cf4be-49fe-11eb-29e2-73b2f41a196b
measure(kron(X,X), reg4; nshots=10)

# ╔═╡ 4fbb9e3a-49fe-11eb-1a2a-3bf0e46673ae
expect(kron(X,X), reg4)

# ╔═╡ 5682fa9a-49fe-11eb-1eb1-6d0bc541eb49
E, U = YaoBlocks.eigenbasis(kron(X,X))

# ╔═╡ 455570c8-49fd-11eb-3569-b539acfae0d0
md"## Implementations"

# ╔═╡ 4e3ab114-49fd-11eb-0ace-1d84065f4a70
instruct!(randn(ComplexF64, 1024), Val(:X), (5,))

# ╔═╡ 6e4eda48-49fd-11eb-3125-33debeb5202e
instruct!(randn(ComplexF64, 1024, 5), rand_unitary(4), (5,3), (1,2), (0, 1))

# ╔═╡ e040046e-49fe-11eb-0f7d-b588f7aa68bc
typeof(Val(:X))

# ╔═╡ 12eea65c-49f5-11eb-06a2-1bfa3e6a48ff
md"## Symbolics"

# ╔═╡ 122dcfa4-49f5-11eb-0291-dbc3d93e93d8
rg = rot(X, Basic(:θ))

# ╔═╡ df653734-49f5-11eb-3543-ddb4871e7846
mat(rg)

# ╔═╡ a6dba3ee-49ff-11eb-0e62-0b983d53ad59
reg5 = zero_state(Basic, 5)

# ╔═╡ b69fd1c4-49ff-11eb-0a28-bb9cd0e5d142
expect(put(5, 2=>X), reg5 => put(5, 2=>time_evolve(X, Basic(:θ))))

# ╔═╡ 1a56e614-4a03-11eb-10c8-4552de256e42
put(5, 2=>time_evolve(X, Basic(:θ)))

# ╔═╡ e8080eac-49f5-11eb-0d8a-d786df9dbeab
md"## CUDA programming"

# ╔═╡ f94141ac-49f5-11eb-2507-e1e62d3a75c6
creg = reg |> cu

# ╔═╡ 0712bd08-49f6-11eb-20ad-5bd4df6e7533
creg |> c1

# ╔═╡ 19a550aa-49f6-11eb-1056-79719005e8fb
md"## Autodiff"

# ╔═╡ 5f8ced44-49f6-11eb-0fde-33edc476a2cf
h = heisenberg(5)

# ╔═╡ 4492f374-49fa-11eb-0fb3-274a5e42384b
time_evolve(h, 0.5)

# ╔═╡ bb42f94e-49f6-11eb-2c52-8960836c6adc
c2 = put(5, 3=>Rx(0.5))

# ╔═╡ f01a70f2-49f6-11eb-0714-21bdde924764
md"expectation value"

# ╔═╡ 66eac714-49f6-11eb-0d37-09578c3aa9cb
expect(h, zero_state(5)=>c2)

# ╔═╡ 1afd4574-4a01-11eb-20df-e988e78ae857
expect(h, zero_state(5)|>c2)

# ╔═╡ 81a60bb8-49f6-11eb-0c75-131c968c7926
parameters(c2)

# ╔═╡ f4e97236-4a00-11eb-12ac-7b90504cd112
(2=>3) |> typeof

# ╔═╡ 7812f4bc-49f6-11eb-01d0-17ea50bf6c6e
greg, gparams = (expect')(h, zero_state(5)=>c2)

# ╔═╡ 7a3678c6-4a01-11eb-0221-2d6347cda041
greg.state

# ╔═╡ 4683706a-4a01-11eb-1a9f-757a563dc34e
(expect') |> typeof

# ╔═╡ 8ce5ab00-49f6-11eb-1407-23ba770ecea7
gparams

# ╔═╡ e3540b76-49f6-11eb-0413-83e5772828a3
md"operator fidelity"

# ╔═╡ c571eaec-49f6-11eb-0f48-357b45fb76d6
operator_fidelity(c1, c2)

# ╔═╡ c3fca86e-49f6-11eb-1bac-d181707ad8a0
g1, g2 = operator_fidelity'(c1, c2)

# ╔═╡ e0d4fe98-4a01-11eb-37aa-2d7d13dd2738
mat(c1 * c1') ≈ IMatrix(32)

# ╔═╡ Cell order:
# ╠═f178d9fe-49f4-11eb-0863-21e2e3934592
# ╟─24195e6a-49f5-11eb-2a5f-3da8bb6dbf75
# ╠═adaf6746-49f5-11eb-1fc2-d1e8ded784cd
# ╠═b2daa884-49f5-11eb-10cc-ab4774630c38
# ╠═b9659114-49f5-11eb-1ce3-f96780ae663c
# ╠═faa2de26-49f4-11eb-3387-2193a51fa9a7
# ╠═30c12de6-49f5-11eb-3d1c-59586c7bd3d3
# ╟─6320b1c6-49f5-11eb-0262-63278ebb0f57
# ╟─69cda57e-49f5-11eb-2c85-296a886165a0
# ╠═1ed8ea9a-49f7-11eb-18eb-27315cb06151
# ╠═25527d96-49f7-11eb-1192-2926cf3e392c
# ╠═27a63e84-49f7-11eb-336b-419711e6b8d7
# ╠═3de7311c-49f7-11eb-074b-fd3d46c43dde
# ╠═4add0112-49f7-11eb-06d8-ff57b319f344
# ╟─7b3a4e64-49f9-11eb-3e63-719d972e6de1
# ╠═705e9df4-49f9-11eb-00e1-5b56512ba687
# ╠═8afdc374-49f9-11eb-0c56-75e6eb17fd3d
# ╟─e5e874be-49f9-11eb-2bb4-2f7a1e5fd93b
# ╠═176c38a4-49fa-11eb-2585-cdec9048f96b
# ╠═0cf79dc2-49f6-11eb-26e6-d11070ec8539
# ╠═da33b2aa-49f9-11eb-06c0-3bb6766d5872
# ╠═4492f374-49fa-11eb-0fb3-274a5e42384b
# ╠═2ec10abe-49f7-11eb-1cd8-7b69b03569ad
# ╠═7742dea4-49fa-11eb-1043-63c54dabb852
# ╠═5fc06e98-49f5-11eb-0f05-234d3e13c8a3
# ╠═932a3d2e-49fa-11eb-0070-a5be7aafee01
# ╠═9c6e3476-49fa-11eb-2a2a-5d380866fc50
# ╠═ad52ee80-49fa-11eb-33a9-dfedc6184e57
# ╠═bba116ce-49fa-11eb-0eed-e1fe0461fc8e
# ╟─77f99e00-49f5-11eb-1c37-f943c400f2a0
# ╠═51e4e26e-49fb-11eb-10c2-8d4239e4b0a9
# ╠═5ffed2c4-49fb-11eb-3ea7-0733bb7c540c
# ╠═6feab568-49fb-11eb-350f-55e0248f0a99
# ╠═cc4ae36e-49fb-11eb-0bf7-05de6ee2d20b
# ╠═f2ef2a7a-49fb-11eb-1cd6-0fcaf3d4fb25
# ╠═e2ee907a-49fb-11eb-28a8-3393425fddc4
# ╠═855d285a-49f5-11eb-2231-2d01d965db6f
# ╠═8bfbb92e-49f5-11eb-3f71-a7c6fefb9c4c
# ╠═334ce004-49f6-11eb-12d5-013def55488b
# ╠═6e3b22ce-49fc-11eb-15da-1bd8c7a3f410
# ╠═63606c92-49fc-11eb-2349-91849e73fb24
# ╠═f3f1652c-49fc-11eb-21e7-17c08b91042b
# ╠═0b23714a-49fd-11eb-1144-970c83b24da3
# ╠═06a9aca0-49fe-11eb-372c-afd2b9b746a5
# ╠═0e7cb738-49fe-11eb-0da7-91b0da8b054d
# ╠═138d3d88-49fe-11eb-1102-6dfec64f04bd
# ╠═1e70beb2-49fe-11eb-189f-9b80e400083f
# ╠═2b24b5b6-49fe-11eb-0309-35e1126ec443
# ╠═3e9cf4be-49fe-11eb-29e2-73b2f41a196b
# ╠═4fbb9e3a-49fe-11eb-1a2a-3bf0e46673ae
# ╠═5682fa9a-49fe-11eb-1eb1-6d0bc541eb49
# ╟─455570c8-49fd-11eb-3569-b539acfae0d0
# ╠═4e3ab114-49fd-11eb-0ace-1d84065f4a70
# ╠═6e4eda48-49fd-11eb-3125-33debeb5202e
# ╠═e040046e-49fe-11eb-0f7d-b588f7aa68bc
# ╟─12eea65c-49f5-11eb-06a2-1bfa3e6a48ff
# ╠═d59b39ec-49f5-11eb-3d4a-fb69f2505d3c
# ╠═122dcfa4-49f5-11eb-0291-dbc3d93e93d8
# ╠═df653734-49f5-11eb-3543-ddb4871e7846
# ╠═a6dba3ee-49ff-11eb-0e62-0b983d53ad59
# ╠═b69fd1c4-49ff-11eb-0a28-bb9cd0e5d142
# ╠═1a56e614-4a03-11eb-10c8-4552de256e42
# ╟─e8080eac-49f5-11eb-0d8a-d786df9dbeab
# ╠═036bc3dc-49f6-11eb-17d6-c18fb583d95b
# ╠═f94141ac-49f5-11eb-2507-e1e62d3a75c6
# ╠═0712bd08-49f6-11eb-20ad-5bd4df6e7533
# ╟─19a550aa-49f6-11eb-1056-79719005e8fb
# ╠═5f8ced44-49f6-11eb-0fde-33edc476a2cf
# ╠═bb42f94e-49f6-11eb-2c52-8960836c6adc
# ╟─f01a70f2-49f6-11eb-0714-21bdde924764
# ╠═66eac714-49f6-11eb-0d37-09578c3aa9cb
# ╠═1afd4574-4a01-11eb-20df-e988e78ae857
# ╠═81a60bb8-49f6-11eb-0c75-131c968c7926
# ╠═f4e97236-4a00-11eb-12ac-7b90504cd112
# ╠═7812f4bc-49f6-11eb-01d0-17ea50bf6c6e
# ╠═7a3678c6-4a01-11eb-0221-2d6347cda041
# ╠═4683706a-4a01-11eb-1a9f-757a563dc34e
# ╠═8ce5ab00-49f6-11eb-1407-23ba770ecea7
# ╟─e3540b76-49f6-11eb-0413-83e5772828a3
# ╠═c571eaec-49f6-11eb-0f48-357b45fb76d6
# ╠═c3fca86e-49f6-11eb-1bac-d181707ad8a0
# ╠═fb76a530-4a01-11eb-372d-1fc9e0fb9543
# ╠═e0d4fe98-4a01-11eb-37aa-2d7d13dd2738
