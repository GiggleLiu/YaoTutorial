### A Pluto.jl notebook ###
# v0.19.29

using Markdown
using InteractiveUtils

# ╔═╡ 98d9b19c-5e0f-11ee-3910-a1fe8e7322f2
using Yao, PlutoUI

# ╔═╡ bd12b40f-cc40-4228-be36-fd14ba432e7d
begin
	function highlight(str)
	    HTML("""<span style="background-color:yellow">$(str)</span>""")
	end
	# livecoding
	function livecoding(src)
		HTML("""
	<div></div>
	<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/asciinema-player@3.0.1/dist/bundle/asciinema-player.css" />
	<script src="https://cdn.jsdelivr.net/npm/asciinema-player@3.0.1/dist/bundle/asciinema-player.min.js"></script>
	<script>
	var target = currentScript.parentElement.firstElementChild;
	AsciinemaPlayer.create('$src', target);
	target.firstChild.firstChild.firstChild.style.background = "#000000";
	target.firstChild.firstChild.firstChild.style.color = "#FFFFFF";
	</script>
	""")
	end
end;

# ╔═╡ d0dd4e6b-5a48-47bc-80ef-fa994781ec1f
md"# The link to this notebook: 
[https://raw.githubusercontent.com/GiggleLiu/YaoTutorial/master/notebooks/munich.jl](https://raw.githubusercontent.com/GiggleLiu/YaoTutorial/master/notebooks/munich.jl)"

# ╔═╡ fdc43a5a-0d79-45d3-b2c7-283278901a7e
md"""
# Simulating quantum systems: The curse of dimensionality
"""

# ╔═╡ 0f4e74f2-0b9f-4c1b-99c2-7c044e023d47
LocalResource("images/coin.jpg", :width=>400)

# ╔═╡ 60bbb6a6-7f67-4755-93c2-9c82f4368e9c
md"""
Our world is probabilistic, the probability turns out to be complex valued.

1. If a computational system (or simulation) is deterministic, we say it is equivalent to a Turing Machine (TM).
2. If a computational system is parameterized by a classical real valued probability, we say it is a equivalent to a Probabilistic Turing Machine (PTM). Although we need $2^{\# ~of ~bits}$ numbers to parameterize such system, we believe they can be easily simulated with pseudo-random numbers on a TM.
3. If a computational system is parameterized by a complex valued probability, we say it is a equivalent to a Quantum Turing Machine (QTM). Simulating a QTM is NP-hard, and you need to store all $2^{\# ~of ~qubits}$ complex numbers.
"""

# ╔═╡ 8850540a-3ace-4d6e-817c-dbfc3e55f4dd
md"""
# Julia Quantum Ecosystem
"""

# ╔═╡ ed769b45-1712-4309-8ddd-120b31ca3568
md"""
A general truth about quantum simulation: general purposed v.s. larger scale

* Open quantum systems (a few subsystems)
    1. [QuantumOptics.jl](https://github.com/qojulia/QuantumOptics.jl): Library for the numerical simulation of closed as well as open quantum systems.
* Circuit-based quantum simulation (~40 qubits)
    1. [Yao.jl](https://github.com/QuantumBFS/Yao.jl)
    2. [Bloqade.jl](https://github.com/QuEraComputing/Bloqade.jl): Package for the quantum computation and quantum simulation based on the neutral-atom architecture.
    3. [Braket.jl](https://github.com/awslabs/Braket.jl): a Julia implementation of the Amazon Braket SDK allowing customers to access Quantum Hardware and Simulators.
    4. [PastaQ.jl](https://github.com/GTorlai/PastaQ.jl): Package for Simulation, Tomography and Analysis of Quantum Computers
* Quantum many-body system ($100$ to $\infty$ spins)
    1. [ITensors.jl](https://github.com/ITensor/ITensors.jl): A Julia library for efficient tensor computations and tensor network calculations.
    2. [QuantumLattices.jl](https://github.com/Quantum-Many-Body/QuantumLattices.jl): Julia package for the construction of quantum lattice systems.
"""

# ╔═╡ d935b67a-2e77-4837-9cef-175dcd84040f
md"""
# 幺（Yao）
Yao Extensible, Efficient Quantum Algorithm Design for Humans.

Yao is an open source framework that aims to empower quantum information research with software tools. It is designed with following in mind:

* quantum algorithm design;
* quantum software 2.0;
* quantum computation education.

## Reference
[Luo X Z, Liu J G, Zhang P, et al. Yao. jl: Extensible, efficient framework for quantum algorithm design. Quantum, 2020, 4: 341.](http://quantum-journal.org/papers/q-2020-10-11-341/)
"""

# ╔═╡ 415a253a-a976-4d66-800b-98c1ca3e860e
LocalResource("images/YaoLogo.png")

# ╔═╡ 9c651a0f-be52-46c4-803b-756d7d00a406
md"""
# Efficient full amplitude quantum simulation

ProjectQ: simulate up to 45 qubits, with 0.5 Petabyte memory (Steiger et al, 2018).
"""

# ╔═╡ fdfb1ca6-e830-4c5c-8672-b42d0cb91a87
LocalResource("images/qubitlimit.png")

# ╔═╡ 86fd00e8-289d-48ca-8904-980fc1e8dc18
md"""
# Different circuit simulation tracks
1. Low entangled state
    * Markov, Igor L., and Yaoyun Shi. “Simulating Quantum Computation by Contracting Tensor Networks.” SIAM Journal on Computing 38, no. 3 (January 2008): 963–81. https://doi.org/10.1137/050644756.
    * Kalachev, Gleb, Pavel Panteleev, and Man-Hong Yung. “Recursive Multi-Tensor Contraction for XEB Verification of Quantum Circuits,” 2021, 1–9.
    * Pan, Feng, and Pan Zhang. “Simulation of Quantum Circuits Using the Big-Batch Tensor Network Method.” Physical Review Letters 128, no. 3 (January 19, 2022): 030501. https://doi.org/10.1103/PhysRevLett.128.030501.
2. Noisy limit
    * Gao, Xun, and Luming Duan. “Efficient Classical Simulation of Noisy Quantum Computation.” October 7, 2018. arXiv.1810.03176.
    * Shao, Yuguo, Fuchuan Wei, Song Cheng, and Zhengwei Liu. “Simulating Quantum Mean Values in Noisy Variational Quantum Algorithms: A Polynomial-Scale Approach.” July 20, 2023. arXiv.2306.05804.
"""

# ╔═╡ b517c6b9-2897-418f-b056-a256acdeffe4
md"""
Where to learn quantum algorithms:
https://github.com/QuantumBFS/QuAlgorithmZoo.jl
"""

# ╔═╡ cc312d0b-a5f6-4fa7-ae06-50c43a05b157
md"arXiv:1812.09167"

# ╔═╡ 9935877e-3cb0-46d8-a6bd-baa8efcaa5b7
md"# Why Yao?"

# ╔═╡ 8da7a6c0-087c-4815-8011-4ef96ba971e1
md"""
# Variational Quantum Algorithms, e.g. Quantum Machine Learning
arXiv:1906.07682
"""

# ╔═╡ 7290b6ee-fca8-4ad9-b9bd-d2833f04a21f
LocalResource("images/valg.png")

# ╔═╡ 9a068de5-b3dd-491b-826d-4922a68924d2
md"""
# Challenges to softwares
* Gradient based training
* Parameter management
* **Small to intermediate size circuit performance**
"""

# ╔═╡ 72c3f5d4-a645-46ad-86b8-114df24ffb12
md"""
# The complexity of obtaining the gradient is $O(M^2)$

Here, $M$ is the number of parameters.

In paper: "Variational quantum eigensolver with fewer qubits" (arXiv:1902.02663)
"""

# ╔═╡ a61a214c-0a43-4a15-a5c8-72716fbf3111
md"""
# Performance
A parameterized quantum circuit with single qubit rotation and CNOT gates.
Please refer the Yao paper for details about the benchmark targets.

* Note: [CuYao.jl](https://github.com/QuantumBFS/CuYao.jl) is implemented with <600 lines of Julia code.
"""

# ╔═╡ 0b4877e8-4378-428d-8913-024473b3d9e5
LocalResource("images/benchmark.png")

# ╔═╡ f4e496bc-4f34-4b28-bbfc-0f4709129b0e
md"""
# YaoToEinsum
"""

# ╔═╡ bf7643c4-bae0-4d77-9903-29943f2efe5a
md"Julia slack > yao-dev"

# ╔═╡ 182b6520-d423-4aa5-8ef0-5e16f28960f6
LocalResource("images/yaotoeinsum-question.png")

# ╔═╡ d1449d83-02ce-45d0-adfe-db86a5ece921
md"""
# Live coding:

summarized in "handson.jl"

**Example 1**: construct a random wave function, apply QFT algorithm on qubits "4,5,6,7".

**Example 2**: construct a 20 qubit Heisenberg chain hamiltonian, apply imaginary time evolution and VQE.
"""

# ╔═╡ 4f6b0937-46f2-49d7-884a-b4922fcc967e
md"""
# Construct a Hamiltonian
"""

# ╔═╡ 947fc8bf-bfcf-478c-b7c5-b235e71c4119
nbit = 8  # how many qubits do you expect?

# ╔═╡ b3ad824e-92f8-4921-9e05-0d9737137e24
sx(i) = put(nbit, i=>X)

# ╔═╡ a56869c2-76c1-4d9b-af01-5df46a08422c
sy(i) = put(nbit, i=>Y)

# ╔═╡ 9f902bd4-2264-4608-bb89-9893ca90566f
sz(i) = put(nbit, i=>Z)

# ╔═╡ d625d532-28e0-4069-908a-53cd5b9aa829
hami = sum([sx(i)*sx(i+1)+sy(i) *sy(i+1)+sz(i)*sz(i+1) for i=1:nbit-1])

# ╔═╡ 9c4fcb8e-d448-42b3-8f1c-9a088eb46029
md"# Wave function ansatz"

# ╔═╡ eff80f11-01d4-4ea2-9660-de7e662ef459
dispatch!(dc, :random)

# get wave function

# ╔═╡ 7be6419a-9820-46a0-b703-48c45e82aebb
out = zero_state(nbit) |> dc

# get the expectation values of hamiltonian

# ╔═╡ f4851ba6-e770-443a-b759-af5c50160608
expect(hami, out)

# ╔═╡ ad191b6f-8300-43e2-92f1-0259931d658c
# The training

# ╔═╡ 13e8a14e-955d-450b-9340-ae2600eac2c2
# get the gradient
∇out = copy(out) |> hami

# ╔═╡ b2033952-3bfe-41c3-815d-2d1fbd437bfe
backward!((copy(out), ∇out), dc)

# ╔═╡ 77a520fa-0ced-45cb-aa3e-2cffe42ede55
grad = gradient(dc)

# gradient descent

# ╔═╡ fefea162-942a-401b-994d-4eae89f9a631
dispatch!(-, dc, grad*0.1);

# ╔═╡ b7a39903-5dab-4cd8-9bc3-16832ad7ca7f
expect(hami, zero_state(nbit) |> dc)

# ╔═╡ 45d8a950-a5e4-4122-9005-7b51786e9dc0
md"""
# **Performance**
Solving two language problem

* **ProjectQ**: C++ (pybind) python
* **Quest**: Pure C
* **Qulacs**: C++ (and) python
"""

# ╔═╡ 63a39252-5cb7-4e93-aeb1-c1e2799c99ee
md"# Back propagation in QC"

# ╔═╡ caa496b8-06c0-4268-98d3-780ee7b91f8e
md"![image.png](images/wavebp.png)"

# ╔═╡ 9052a48f-5610-4177-8aa4-8829796b86cd
md"# differentiate over matrix representation"

# ╔═╡ cfc950b1-d24a-461f-a139-90419e98c0db
md"![image.png](images/zygote-yao.png)"

# ╔═╡ 5857a52c-631b-4868-bd5f-2d0fc4c53cc2
md"""
# How to Learn Yao.jl
### Read the documentation

https://quantumbfs.github.io/Yao.jl/latest

### 关注我的知乎专栏 “和Leo一起学量子编程”
https://zhuanlan.zhihu.com/quantumcoding

### Quantum Algorithm Zoo
https://github.com/QuantumBFS/QuAlgorithmZoo.jl
"""

# ╔═╡ 82fed728-8b23-4fce-991b-8a427141b81b
md"""
# How to contribute to an open source project
### File an issue
* https://github.com/QuantumBFS/Yao.jl/issues/new

### Give us pull requests
* Documentation
* Writing tests
* ...
"""

# ╔═╡ 58a636fe-39c4-49aa-a0da-e2777aba489e
dc = dc |> autodiff(:BP)

# parameter management

# ╔═╡ 7744f8de-2880-4e46-ac6c-42e98daa3e4c
dc = random_diff_circuit(nbit)

# tag differentiable nodes

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Yao = "5872b779-8223-5990-8dd0-5abbb0748c8c"

[compat]
PlutoUI = "~0.7.52"
Yao = "~0.8.10"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0-beta2"
manifest_format = "2.0"
project_hash = "591fa14551724455a7e10a90844c674c3915d5c2"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "76289dc51920fdc6e0013c872ba9551d54961c24"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.6.2"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra", "Requires", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "f83ec24f76d4c8f525099b2ac475fc098138ec31"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.4.11"

    [deps.ArrayInterface.extensions]
    ArrayInterfaceBandedMatricesExt = "BandedMatrices"
    ArrayInterfaceBlockBandedMatricesExt = "BlockBandedMatrices"
    ArrayInterfaceCUDAExt = "CUDA"
    ArrayInterfaceGPUArraysCoreExt = "GPUArraysCore"
    ArrayInterfaceStaticArraysCoreExt = "StaticArraysCore"
    ArrayInterfaceTrackerExt = "Tracker"

    [deps.ArrayInterface.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitBasis]]
deps = ["LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "f51ef0fdfa5d8643fb1c12df3899940fc8cf2bf4"
uuid = "50ba71b6-fa0f-514d-ae9a-0916efc90dcf"
version = "0.8.1"

[[deps.CacheServers]]
deps = ["Distributed", "Test"]
git-tree-sha1 = "b584b04f236d3677b4334fab095796a128445bf8"
uuid = "a921213e-d44a-5460-ac04-5d720a99ba71"
version = "0.2.0"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e30f2f4e20f7f186dc36529910beaedc60cfa644"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.16.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "8a62af3e248a8c4bad6b32cbbe663ae02275e32c"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.10.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+1"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.ExponentialUtilities]]
deps = ["Adapt", "ArrayInterface", "GPUArraysCore", "GenericSchur", "LinearAlgebra", "PrecompileTools", "Printf", "SparseArrays", "libblastrampoline_jll"]
git-tree-sha1 = "602e4585bcbd5a25bc06f514724593d13ff9e862"
uuid = "d4d017d3-3776-5f7e-afef-a10c40355c18"
version = "1.25.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "2d6ca471a6c7b536127afccfa7564b5b39227fe0"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.5"

[[deps.GenericSchur]]
deps = ["LinearAlgebra", "Printf"]
git-tree-sha1 = "fb69b2a645fa69ba5f474af09221b9308b160ce6"
uuid = "c145ed77-6b09-5dd9-b285-bf645a82121e"
version = "0.5.3"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LegibleLambdas]]
deps = ["MacroTools"]
git-tree-sha1 = "7946db4829eb8de47c399f92c19790f9cc0bbd07"
uuid = "f1f30506-32fe-5131-bd72-7c197988f9e5"
version = "0.3.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.0.1+1"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LuxurySparse]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "84ce2a2a25c8a4561ef19a1a8be3c9305661fa08"
uuid = "d05aeea4-b7d4-55ac-b691-9e7fabb07ba2"
version = "0.7.4"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MLStyle]]
git-tree-sha1 = "bc38dff0548128765760c79eb7388a4b37fae2c8"
uuid = "d8e11817-5142-5d16-987a-aa16d5891078"
version = "0.4.17"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+2"

[[deps.OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "e47cd150dbe0443c3a3651bc5b9cbd5576ab75b7"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.52"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "c60ec5c62180f27efea3ba2908480f8055e17cee"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore"]
git-tree-sha1 = "d5fb407ec3179063214bc6277712928ba78459e2"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.6.4"
weakdeps = ["Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "1d77abd07f617c4868c33d4f5b9e1dbb2643c9cf"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.2"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.0+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.TupleTools]]
git-tree-sha1 = "155515ed4c4236db30049ac1495e2969cc06be9d"
uuid = "9d95972d-f1c8-5527-a6e0-b4b365fa01f6"
version = "1.4.3"

[[deps.URIs]]
git-tree-sha1 = "b7a5e99f24892b6824a954199a45e9ffcc1c70f0"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Yao]]
deps = ["BitBasis", "LinearAlgebra", "LuxurySparse", "Reexport", "YaoAPI", "YaoArrayRegister", "YaoBlocks", "YaoSym"]
git-tree-sha1 = "8e01e459915ba93873867193520d5da1fef50805"
uuid = "5872b779-8223-5990-8dd0-5abbb0748c8c"
version = "0.8.10"

[[deps.YaoAPI]]
git-tree-sha1 = "7c26671b9f9b3ad45aadedd3500b5ce15485931e"
uuid = "0843a435-28de-4971-9e8b-a9641b2983a8"
version = "0.4.6"

[[deps.YaoArrayRegister]]
deps = ["Adapt", "BitBasis", "DocStringExtensions", "LegibleLambdas", "LinearAlgebra", "LuxurySparse", "MLStyle", "Random", "SparseArrays", "StaticArrays", "StatsBase", "TupleTools", "YaoAPI"]
git-tree-sha1 = "9497f0e4c5624882cffc1dd9c0a10b7816ecc078"
uuid = "e600142f-9330-5003-8abb-0ebd767abc51"
version = "0.9.7"

[[deps.YaoBlocks]]
deps = ["BitBasis", "CacheServers", "ChainRulesCore", "DocStringExtensions", "ExponentialUtilities", "InteractiveUtils", "LegibleLambdas", "LinearAlgebra", "LuxurySparse", "MLStyle", "Random", "SparseArrays", "StaticArrays", "StatsBase", "TupleTools", "YaoAPI", "YaoArrayRegister"]
git-tree-sha1 = "342b227e10d12e3f6e21923411a88bfdb09fbf32"
uuid = "418bc28f-b43b-5e0b-a6e7-61bbc1a2c1df"
version = "0.13.9"

[[deps.YaoSym]]
deps = ["BitBasis", "LinearAlgebra", "LuxurySparse", "Requires", "SparseArrays", "YaoArrayRegister", "YaoBlocks"]
git-tree-sha1 = "5f4e557b3bac0f8433013ab543fe1251a83c12c9"
uuid = "3b27209a-d3d6-11e9-3c0f-41eb92b2cb9d"
version = "0.6.6"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╠═98d9b19c-5e0f-11ee-3910-a1fe8e7322f2
# ╟─bd12b40f-cc40-4228-be36-fd14ba432e7d
# ╟─d0dd4e6b-5a48-47bc-80ef-fa994781ec1f
# ╟─fdc43a5a-0d79-45d3-b2c7-283278901a7e
# ╟─0f4e74f2-0b9f-4c1b-99c2-7c044e023d47
# ╟─60bbb6a6-7f67-4755-93c2-9c82f4368e9c
# ╟─8850540a-3ace-4d6e-817c-dbfc3e55f4dd
# ╟─ed769b45-1712-4309-8ddd-120b31ca3568
# ╟─d935b67a-2e77-4837-9cef-175dcd84040f
# ╟─415a253a-a976-4d66-800b-98c1ca3e860e
# ╟─9c651a0f-be52-46c4-803b-756d7d00a406
# ╟─fdfb1ca6-e830-4c5c-8672-b42d0cb91a87
# ╠═b517c6b9-2897-418f-b056-a256acdeffe4
# ╟─cc312d0b-a5f6-4fa7-ae06-50c43a05b157
# ╟─9935877e-3cb0-46d8-a6bd-baa8efcaa5b7
# ╟─8da7a6c0-087c-4815-8011-4ef96ba971e1
# ╟─7290b6ee-fca8-4ad9-b9bd-d2833f04a21f
# ╟─9a068de5-b3dd-491b-826d-4922a68924d2
# ╟─72c3f5d4-a645-46ad-86b8-114df24ffb12
# ╟─a61a214c-0a43-4a15-a5c8-72716fbf3111
# ╟─0b4877e8-4378-428d-8913-024473b3d9e5
# ╟─f4e496bc-4f34-4b28-bbfc-0f4709129b0e
# ╟─86fd00e8-289d-48ca-8904-980fc1e8dc18
# ╟─bf7643c4-bae0-4d77-9903-29943f2efe5a
# ╟─182b6520-d423-4aa5-8ef0-5e16f28960f6
# ╟─d1449d83-02ce-45d0-adfe-db86a5ece921
# ╟─4f6b0937-46f2-49d7-884a-b4922fcc967e
# ╠═947fc8bf-bfcf-478c-b7c5-b235e71c4119
# ╠═b3ad824e-92f8-4921-9e05-0d9737137e24
# ╠═a56869c2-76c1-4d9b-af01-5df46a08422c
# ╠═9f902bd4-2264-4608-bb89-9893ca90566f
# ╠═d625d532-28e0-4069-908a-53cd5b9aa829
# ╠═9c4fcb8e-d448-42b3-8f1c-9a088eb46029
# ╠═7744f8de-2880-4e46-ac6c-42e98daa3e4c
# ╠═58a636fe-39c4-49aa-a0da-e2777aba489e
# ╠═eff80f11-01d4-4ea2-9660-de7e662ef459
# ╠═7be6419a-9820-46a0-b703-48c45e82aebb
# ╠═f4851ba6-e770-443a-b759-af5c50160608
# ╠═ad191b6f-8300-43e2-92f1-0259931d658c
# ╠═13e8a14e-955d-450b-9340-ae2600eac2c2
# ╠═b2033952-3bfe-41c3-815d-2d1fbd437bfe
# ╠═77a520fa-0ced-45cb-aa3e-2cffe42ede55
# ╠═fefea162-942a-401b-994d-4eae89f9a631
# ╠═b7a39903-5dab-4cd8-9bc3-16832ad7ca7f
# ╠═45d8a950-a5e4-4122-9005-7b51786e9dc0
# ╠═63a39252-5cb7-4e93-aeb1-c1e2799c99ee
# ╠═caa496b8-06c0-4268-98d3-780ee7b91f8e
# ╠═9052a48f-5610-4177-8aa4-8829796b86cd
# ╠═cfc950b1-d24a-461f-a139-90419e98c0db
# ╠═5857a52c-631b-4868-bd5f-2d0fc4c53cc2
# ╠═82fed728-8b23-4fce-991b-8a427141b81b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
