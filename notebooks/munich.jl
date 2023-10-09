### A Pluto.jl notebook ###
# v0.19.29

using Markdown
using InteractiveUtils

# ╔═╡ 98d9b19c-5e0f-11ee-3910-a1fe8e7322f2
using PlutoUI

# ╔═╡ 78811601-76bf-44df-8a5f-8c9d1f3a87f2
using Yao, YaoPlots; YaoPlots.darktheme!();

# ╔═╡ 869332bd-b70e-4812-83b4-6f3bc8b1d458
using SymEngine

# ╔═╡ 46aa38fa-47ab-4c44-8bcb-655bd5ca70a6
using KrylovKit

# ╔═╡ bd12b40f-cc40-4228-be36-fd14ba432e7d
begin
	function highlight(str)
	    HTML("""<span style="background-color:green">$(str)</span>""")
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
md"""# About This notebook
This is a notebook about the quantum simulator [Yao@v0.8](https://github.com/QuantumBFS/Yao.jl), which could be download with the following link:
[https://raw.githubusercontent.com/GiggleLiu/YaoTutorial/master/notebooks/munich.jl](https://raw.githubusercontent.com/GiggleLiu/YaoTutorial/master/notebooks/munich.jl)

### Contents
1. Overview of quantum simulation.
2. Why we create Yao.
3. A report on the current status of Yao.
4. A tutorial, covering latest Yao features.
5. Outlook.
"""

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

# ╔═╡ 9c651a0f-be52-46c4-803b-756d7d00a406
md"""
# Efficient circuit based simulation

ProjectQ: simulate up to 45 qubits, with 0.5 Petabyte memory (Steiger et al, 2018).
"""

# ╔═╡ fdfb1ca6-e830-4c5c-8672-b42d0cb91a87
LocalResource("images/qubitlimit.png")

# ╔═╡ cc312d0b-a5f6-4fa7-ae06-50c43a05b157
md"### References:
* [Steiger D S, Häner T, Troyer M. ProjectQ: an open source software framework for quantum computing[J]. Quantum, 2018, 2: 49.](https://quantum-journal.org/papers/q-2018-01-31-49/?wp_statistics_opt_out=1)
* [De Raedt, Hans, Fengping Jin, Dennis Willsch, Madita Nocon, Naoki Yoshioka, Nobuyasu Ito, Shengjun Yuan, and Kristel Michielsen. “Massively Parallel Quantum Computer Simulator, Eleven Years Later.” Computer Physics Communications 237 (April 2019): 47–61.](https://doi.org/10.1016/j.cpc.2018.11.005)"

# ╔═╡ d935b67a-2e77-4837-9cef-175dcd84040f
md"""
# Yao.jl
An Extensible, Efficient Quantum Algorithm Design for Humans.

Yao is an open source framework that aims to empower quantum information research with software tools. It is designed with following in mind:

* quantum algorithm design;
* quantum software 2.0;
* quantum computation education.

### Reference
* [Xiu-Zhe Luo, Jin-Guo Liu, Pan Zhang and Lei Wang. Yao. jl: Extensible, efficient framework for quantum algorithm design. Quantum, 2020, 4: 341.](http://quantum-journal.org/papers/q-2020-10-11-341/)
"""

# ╔═╡ 415a253a-a976-4d66-800b-98c1ca3e860e
LocalResource("images/YaoLogo.png")

# ╔═╡ a12aa313-f051-4f83-ac89-e3ab5685c5c8
md"The Chinese character 幺 (Yāo) mean unitary."

# ╔═╡ 9935877e-3cb0-46d8-a6bd-baa8efcaa5b7
md"# Why yet another quantum simulator?"

# ╔═╡ 61c3c643-dae3-4563-a85d-9daf07ff6060
dispatch!(EasyBuild.variational_circuit(5, 1), :random) |> vizcircuit

# ╔═╡ a01484e7-0710-4de1-aa81-92e083884902
md"""Differential programming a quantum circuit
* Variational quantum algorithms
* Inverse engineering, such as quantum optimal control
"""

# ╔═╡ 8da7a6c0-087c-4815-8011-4ef96ba971e1
md"""
# Variational Quantum Algorithms
1. Quantum Circuit Born Machine: Using a quantum circuit as a probabilistic model $p(x) = |\langle x|\psi\rangle|^2$.
    - **Loss function**: maximum mean discrepancy between $|\langle x|\psi\rangle|^2$ and the target probability. 
2. Variational Quantum Eigensolver: Solving the ground state of a quantum system.
    - **Loss function**: The energy expectation value.
3. Variational quantum optimization algorithms: Solving computational hard problems through variationally optimizing the annealing process.
    - **Loss function**: The success probability of finding an optimal solution.

### References
- [Kandala A, Mezzacapo A, Temme K, et al. Hardware-efficient variational quantum eigensolver for small molecules and quantum magnets. nature, 2017, 549(7671): 242-246.](https://www.nature.com/articles/nature23879)
- [Liu, Jin-Guo, and Lei Wang. “Differentiable Learning of Quantum Circuit Born Machines.” Physical Review A 98, no. 6 (December 19, 2018): 062324.](https://doi.org/10.1103/PhysRevA.98.062324)
- [Liu, Jin-Guo, Yi-Hong Zhang, Yuan Wan, and Lei Wang. “Variational Quantum Eigensolver with Fewer Qubits.” Physical Review Research 1, no.](https://journals.aps.org/prresearch/abstract/10.1103/PhysRevResearch.1.023025) 
- [Ebadi, S., A. Keesling, M. Cain, T. T. Wang, H. Levine, D. Bluvstein, G. Semeghini, et al. “Quantum Optimization of Maximum Independent Set Using Rydberg Atom Arrays.” Science 376, no. 6598 (June 10, 2022): 1209–15.](https://doi.org/10.1126/science.abo6587)

"""

# ╔═╡ e2d493c4-0060-46f3-a689-613058f6e293
md"""
# Quantum Control
"""

# ╔═╡ 2a6695b0-8e17-45f2-8656-7046dacaa349
md"""
* **Loss function**: the distance with the target gate.
* **Parameters**: the evolution times of each pulse.
"""

# ╔═╡ c46a0e9c-729d-4a8a-b70c-78b53fbab597
LocalResource("images/levine.png")

# ╔═╡ f7d01385-f32a-4fcd-bbea-7789674106a7
md"""
### References
- [Levine, Harry, Alexander Keesling, Giulia Semeghini, Ahmed Omran, Tout T. Wang, Sepehr Ebadi, Hannes Bernien, et al. “Parallel Implementation of High-Fidelity Multiqubit Gates with Neutral Atoms.” Physical Review Letters 123, no. 17 (2019): 1–16.](https://doi.org/10.1103/PhysRevLett.123.170503)
"""

# ╔═╡ 4457c6b8-a8e9-4853-a07a-1829d95be92e
md"""
# Challenges to differentiable programming quantum circuits

The memory wall problem.
* The back propagation technique requires knowing intermediate state for computing gradients.
* A quantum algorithm is memory consuming, caching all intermediate states is impossible.

We notice:
* quantum circuit simulation is reversible.
"""

# ╔═╡ 5642d4d4-767e-4395-a01e-79487fb39fc5
LocalResource("images/yaoad.png")

# ╔═╡ a61a214c-0a43-4a15-a5c8-72716fbf3111
md"""
# Performance
We benchmarked the simulation of a parameterized quantum circuit with single qubit rotation and CNOT gates.
Please refer the Yao paper for details about the benchmark targets.

* Note: [CuYao.jl](https://github.com/QuantumBFS/CuYao.jl) is implemented with <600 lines of Julia code with [CUDA.jl](https://github.com/JuliaGPU/CUDA.jl).
"""

# ╔═╡ 0b4877e8-4378-428d-8913-024473b3d9e5
LocalResource("images/benchmark.png")

# ╔═╡ 283ea80f-c749-4e59-a4f1-e73cfa32ad0d
md"""
# Overview of Yao features
"""

# ╔═╡ b8cd9d6f-934f-4053-9d32-2535ce9d9f2c
md"""
### Yao@v0.6
* Quantum simulation
* Matrix representation of quantum operators
    - Generate the sparse matrix representation of Hamiltonians with > 25 spins.
* Arithematic operations
* Parameter management and automatic differentiation
    - Differentiate a quantum circuit with depth > 10,000
* GPU backend
"""

# ╔═╡ b2b16731-9410-4be1-ae6e-6467547c3e81
LocalResource("images/yaofeature.png")

# ╔═╡ e5312611-6c4c-4f51-aea0-9eb61cbb217a
md"# Current status of Yao.jl"

# ╔═╡ ef06e741-fe88-42b5-9063-1306b00f3915
md"""
###  Extra features in Yao@v0.8
* qudits: natively supported
    - 3-level Rydberg atom simulation is possible
* density matrix based simulation
    - only basic noisy channels supported
* operator indexing

### Packages derived from Yao
* [Bloqade.jl](https://github.com/QuEraComputing/Bloqade.jl): Package for the quantum computation and quantum simulation based on the neutral-atom architecture (Roger Luo, [QuEra Computing Inc.](https://www.quera.com/) et al.)
![](https://github.com/QuEraComputing/Bloqade.jl/raw/master/docs/src/assets/logo-dark.png)
* [YaoToEinsum.jl](https://github.com/QuantumBFS/YaoToEinsum.jl): Convert Yao circuit to OMEinsum (tensor network) contraction (GiggleLiu et al.)
* [YaoPlots.jl](https://github.com/QuantumBFS/YaoPlots.jl): plotting Yao circuit (GiggleLiu et al.)
* [ZXCalculus.jl](https://github.com/QuantumBFS/ZXCalculus.jl): An implementation of ZX-calculus in Julia (Chen Zhao, Roger Luo, Yusheng Zhao (through [OSPP project](https://summer-ospp.ac.cn/)) et al.)
* [FLOYao.jl](https://github.com/QuantumBFS/FLOYao.jl): A fermionic linear optics simulator backend for Yao.jl (Jan Lukas Bosse et al)
* [QAOA.jl](https://github.com/FZJ-PGI-12/QAOA.jl): This package implements the Quantum Approximate Optimization Algorithm and the Mean-Field Approximate Optimization Algorithm.
* [QuantumNLDiffEq.jl](https://github.com/SciML/QuantumNLDiffEq.jl)
"""

# ╔═╡ 8b1915e3-63f8-461e-bdb1-4c257aa4d438
md"""# Papers citing Yao
Google scholar: up to Oct 7, 2023, Yao paper has $(highlight("127")) citations in total 🎉.
### Related quantum simulators
- Pennylane: Automatic differentiation of hybrid quantum-classical computations
- Tensorflow quantum: A software framework for quantum machine learning
- Qulacs: a fast and versatile quantum circuit simulator for research purpose
- Qibo: a framework for quantum simulation with hardware acceleration
- Tequila: A platform for rapid development of quantum algorithms
- Qdnn: deep neural networks with quantum layers
- TenCirChem: An Efficient Quantum Computational Chemistry Package for the NISQ Era
- QuantumCumulants.jl: A Julia framework for generalized mean-field equations in open quantum systems
- Q$^2$Chemistry: A quantum computation platform for quantum chemistry
- QNet: A scalable and noise-resilient quantum neural network architecture for noisy intermediate-scale quantum computers
- Qforte: an efficient state simulator and quantum algorithms library for molecular electronic structure
- QuantNBody: a Python package for quantum chemistry and physics to build and manipulate many-body operators and wave functions.
- UniQ: a unified programming model for efficient quantum circuit simulation
- tqix.pis: A toolbox for quantum dynamics simulation of spin ensembles in Dicke basis
- BosonSampling.jl: A Julia package for quantum multi-photon interferometry
- QDNN: DNN with quantum neural network layers
- TeD-Q: a tensor network enhanced distributed hybrid quantum machine learning framework
- QXTools: A Julia framework for distributed quantum circuit simulation
- Heom.jl: An efficient Julia framework for hierarchical equations of motion in open quantum systems
- QUBO. jl: A Julia Ecosystem for Quadratic Unconstrained Binary Optimization
- HiQ-ProjectQ: Towards user-friendly and high-performance quantum computing on GPUs
- HyQuas: hybrid partitioner based quantum circuit simulation system on GPU
### How do people use Yao?
- Variational quantum algorithms
    - Variational Quantum Eigensolvers, Quantum Neural networks, Quantum Approximate Optimization Algorithm, Solving differential equation, Quantum kernel method
- $(highlight("Fermionic simulation"))
    - [Sketching phase diagrams using low-depth variational quantum algorithms](https://arxiv.org/abs/2301.09369)
- $(highlight("Combinatorial optimization"))
    - [Tropical Tensor Network for Ground States of Spin Glasses](https://journals.aps.org/prl/abstract/10.1103/PhysRevLett.126.090506)
- Measurement induced phase transition
    - [Simulating a measurement-induced phase transition for trapped ion circuits](measurement-induced phase transition)
- Imaginary time evolution
    - [Probabilistic nonunitary gate in imaginary time evolution](https://link.springer.com/article/10.1007/s11128-021-03145-6)
    - [Efficient quantum imaginary time evolution by drifting real time evolution: an approach with low gate and measurement complexity](https://arxiv.org/abs/2203.11112)
- $(highlight("Tensor network based simulation"))
    - [Efficient and Portable Einstein Summation in SQL](https://dl.acm.org/doi/pdf/10.1145/3589266)
    - [Contracting Arbitrary Tensor Networks: General Approximate Algorithm and Applications in Graphical Models and Quantum Circuit Simulations](https://journals.aps.org/prl/abstract/10.1103/PhysRevLett.125.060503)
- Quantum Chebyshev Transform
    - [Quantum Chebyshev Transform: Mapping, Embedding, Learning and Sampling Distributions](https://arxiv.org/abs/2306.17026)
- Geologic fracture networks
    - [Quantum algorithms for geologic fracture networks](https://www.nature.com/articles/s41598-023-29643-4) 
- $(highlight("Teaching"))
    - [Using the Julia framework to teach quantum entanglement](https://arxiv.org/abs/2302.12889)
- Hamiltonian Operator Approximation
    - [Hamiltonian Operator Approximation for Energy Measurement and Ground-State Preparation](https://journals.aps.org/prxquantum/abstract/10.1103/PRXQuantum.2.030318)
"""

# ╔═╡ a5eeccdc-73cc-4e99-884b-a04e827cc4bf
md"""
# Learn Yao
"""

# ╔═╡ 6281b968-b4bb-4ec7-8cd6-da3e788c2287
md"# Part 1: Representing a quantum state"

# ╔═╡ b7d014b8-2c13-4ab0-8477-4d3284bc8f2d
# create a zero state |000⟩
zero_state(3)

# ╔═╡ ad652d3e-a53e-4076-a1b0-e7ca7bd0d270
# The quantum state is represented as a vector
statevec(zero_state(3))

# ╔═╡ 22966094-d97b-4d1e-8065-dc9e33fae003
print_table(zero_state(3))

# ╔═╡ 006f14ea-f730-4211-844d-8a37e460fa6b
# Similarly, we can create a random state
# The element type is also configurable
rand_state(ComplexF32, 3)

# ╔═╡ d77242c6-d693-4d01-b04b-f8945b6b8125
# A product state
product_state(bit"110")

# ╔═╡ c55f2e5e-f54c-41b8-9154-017aaf716982
# note the bit string representation is in the little endian format.
bit"110"[3]

# ╔═╡ 22c4e552-5de5-4d3c-9a5a-8fb3b6738938
# To print the elements with basis annotated
print_table(product_state(bit"110"))

# ╔═╡ f0c3aba2-7b8f-4f55-8fe0-6f6b664e73d3
# A GHZ state
ghz_state(3)

# ╔═╡ 20304d97-c166-46c0-a2e0-75d901f66d6d
print_table(ghz_state(3))

# ╔═╡ 2668cdd7-c83a-444e-9582-3d25fbdecd67
# there is a single bit entanglement entropy between qubit sets (1, 3) and (2,)
von_neumann_entropy(ghz_state(3), (1, 3)) / log(2)

# ╔═╡ c43727a2-1a31-4684-87b6-9af2f1938487
von_neumann_entropy(zero_state(3), (1, 3)) / log(2)

# ╔═╡ d04826f5-e9a2-49cd-9f07-9d0cd4029fdb
# A random qutrit state
rand_state(3, nlevel=3)

# ╔═╡ 9112230a-32bc-47b7-a23e-cd4a77bd764d
# A qudit product state, what follows ";" symbol denotes the number of levels
product_state(dit"120;3")

# ╔═╡ 277ccef5-ccd4-407c-a864-76baa83955d6
print_table(product_state(dit"120;3"))

# ╔═╡ 0e93dd67-8831-4cf0-9802-835e7b30e2f5
md"""
# Part 2: representing a quantum circuit
A quantum operators such as Hamiltonians and quantum circuits, are represented as a matrix, or a Yao block. There are two types of blocks:
* primitive blocks: the basic building blocks of a quantum circuit.
* composite blocks: composing primitive blocks into Hamiltonians and circuits
"""

# ╔═╡ 295c6f45-0d97-42bc-b677-96ecbd124f37
md"""
## Part 2.1: Primitive blocks
Primitive blocks are the basic building blocks of a quantum circuit.
"""

# ╔═╡ 4fd3761c-16fc-4833-97d4-6ef07c54a0bc
# Pauli X gate
X

# ╔═╡ f26cc2ed-cb29-43d9-a216-2ea3da27516f
# visualize a gate
vizcircuit(X)

# ╔═╡ b8924ea4-32e4-4d3a-9370-33987b8aefec
# create a symbolic variable θ
@vars θ

# ╔═╡ aa0cc0fe-fb25-4e6b-82b4-0bd70d41c36d
# Rotation X gate
rot(X, θ)

# ╔═╡ b8b7eed2-430c-401c-a026-cb6f44d2d4f6
parameters(rot(X, θ))

# ╔═╡ 3d79dc1c-082a-43fc-8037-d988eb3a81a6
vizcircuit(rot(X, θ))

# ╔═╡ 935c518b-7a7f-485c-b37b-cb165e6ee77b
# The matrix representation
mat(rot(X, θ))

# ╔═╡ ff79a542-7a68-4d74-bf10-664b7e6fe7ba
# The first argument of `rot` can be any reflexive operator, i.e. O² = 1
# Parameterized SWAP
mat(rot(SWAP, θ))

# ╔═╡ 3b543d83-f2fd-4976-a496-778baf265b75
isreflexive(SWAP)

# ╔═╡ 06373820-7687-43c3-b779-17019d520d28
isreflexive(kron(SWAP, X))

# ╔═╡ b7c14cba-31f0-4fad-9f43-f61a1028b294
# Phase gate
mat(phase(θ))

# ╔═╡ 870bd2cd-2cf8-475d-b1d9-ce6113af5efb
vizcircuit(phase(θ))

# ╔═╡ 4b9997ce-b45d-40ca-934e-ef72acea4e7d
# Shift gate
mat(shift(θ))

# ╔═╡ abfb7c6a-ac95-4a84-8dcd-c5a58af21c7e
vizcircuit(shift(θ))

# ╔═╡ 421f365a-599b-4b84-874f-4e9298721720
# random single qubit matrix block
matblock(rand_unitary(2); tag="random_gate")

# ╔═╡ 9c84936d-d678-4077-9423-dbb42629d6e2
# random 2 qutrit matrix block
matblock(rand_unitary(9); nlevel=3, tag="two 3-level")

# ╔═╡ 6ee0a7d3-0453-4426-a58e-ad27ba56e7f9
vizcircuit(matblock(rand_unitary(9); nlevel=3, tag="two 3-level"))

# ╔═╡ 6deb86e7-07de-4c2b-9ab8-8005e57582b6
# random 2 qutrit matrix block
Measure(2)

# ╔═╡ 2c4c0aac-8919-41c6-bb8f-b7bea5d2f759
vizcircuit(Measure(2))

# ╔═╡ 4768ac25-62ed-42ae-a0c6-c039dabdbdae
# Time evolution, the first argument can be any Hermitian operator
time_evolve(X, 0.3)

# ╔═╡ 27471635-a488-43e8-bba5-8b587fdd84f0
ishermitian(kron(X+Y, X))

# ╔═╡ 96192c95-da9a-42ad-8acb-d93e1f348a34
md"""
## Part 2.2: Composite blocks
"""

# ╔═╡ abe87acc-29fb-4b64-9adb-d7a9b59b1ded
# Put a block at the first qubit of a 3-qubit register
put(3, 1=>X)

# ╔═╡ 2b6622a7-f37b-4c66-b73d-3309570252e2
vizcircuit(put(3, 1=>X))

# ╔═╡ 4ed2b831-9941-42be-bcdb-4a11e82f4713
mat(put(3, 1=>X))

# ╔═╡ 2a7a0629-678c-43d7-9f84-f82e2207c192
# The target gate can be applied on any subset of qubits
put(10, (5, 2, 1) => ConstGate.Toffoli)

# ╔═╡ 9451d2e5-e592-4ccd-b081-554d29891488
vizcircuit(put(10, (5, 2, 1) => ConstGate.Toffoli))

# ╔═╡ cacfd179-1c09-4048-bf55-d95ac30a20b8
# Kronecker product of two blocks
kron(X, X)

# ╔═╡ 47d82c8b-54a7-44d1-8924-f579e96540d4
vizcircuit(kron(X, X))

# ╔═╡ 676c9ed7-1c42-42d9-84a5-9d07f7c50f3c
# A more general form can be
kron(10, 2=>X, 3=>Y)

# ╔═╡ 4171ac27-2d56-4699-b816-300a56da94ec
vizcircuit(kron(10, 2=>X, 3=>Y))

# ╔═╡ 3cfa909e-935c-4f41-9b32-fe86aef0026e
# Control the second qubit of a 3-qubit register with the first qubit
control(3, 1, 2=>X)

# ╔═╡ d1f688c1-5b01-4823-95ab-e405b826b9fc
vizcircuit(control(3, 1, 2=>X))

# ╔═╡ ef656866-203e-4963-b575-b5de53aaac1a
# Multi-control and inverse control is supported
# Example: if and only if qubit 1 is 1 and qubit 8 is 0,
# apply 2-qubit gate `kron(H, Rz(π/4))` on position (7, 6).
control(10, (1, -8), (7, 6)=>kron(H, Rz(π/4)))

# ╔═╡ b2b7db90-1d65-46f9-a171-8d7b3b48a97f
vizcircuit(control(10, (1, -8), (7, 6)=>kron(H, Rz(π/4))))

# ╔═╡ 4dfc08fd-8a10-4d25-a273-a5c0e72df78e
# Chain two blocks into a circuit
chain(3, put(3, 1=>X), control(3, 1, 2=>X))

# ╔═╡ f3bf77bc-2783-4ec4-b2ec-9fc07c73bdbb
vizcircuit(chain(3, put(3, 1=>X), control(3, 1, 2=>X)))

# ╔═╡ 337786c2-5d28-4c3c-976b-1b3bc21f32e5
# It is equivalent to inverse ordered operator multiplication.
control(3, 1, 2=>X) * put(3, 1=>X)

# ╔═╡ 7f7fc02f-8746-4313-8aa2-b1d9ed1b1dfa
# Scaling a block
im * X

# ╔═╡ 007e9da9-8810-4731-b4e4-01c91f423089
# X₁X₂ + X₂X₃
sum([kron(3, 1=>X, 2=>X), kron(3, 2=>X, 3=>X)])

# ╔═╡ 8dd52837-f6d1-4f56-b071-6a1ad4a18be7
md"""
# Example: quantum Fourier transformation simulation (QFT)
"""

# ╔═╡ 399e2661-0b84-445a-97fc-da16884ac3ae
# A QFT circuit is available in `Yao.EasyBuild` module.
EasyBuild.qft_circuit(4)

# ╔═╡ f2a372f1-06f7-46ff-a07d-9ed11fcd7a72
md"*Step by step*"

# ╔═╡ 9486139b-3587-41ab-a917-5c82bd39b1c7
# Let's first define the CPHASE gate
cphase(n, i, j) = control(n, i, j=> shift(2π/(2^(i-j+1))));

# ╔═╡ 04b50a5b-8e57-461b-9bad-103ef3ed645a
vizcircuit(cphase(5, 2, 1))

# ╔═╡ a8d42876-4a32-4eb7-9dd1-eb93d1033be2
# A cphase is defined as
mat(control(2, 2, 1=> shift(θ)))

# ╔═╡ bebc0c44-e3d5-4c36-8ed8-f132e14ab8b3
hcphases(n, i) = chain(n, i==j ? put(n, i=>H) : cphase(n, j, i) for j in i:n);

# ╔═╡ 779d209e-cdb0-4e35-adf7-e59c27bebf52
vizcircuit(hcphases(5, 2))

# ╔═╡ 342467fb-9fc5-4f8c-bc1f-6c816848b56f
# with CPHASE gate, we have the qft circuit defined as
qft_circ(n::Int) = chain(n, hcphases(n, i) for i = 1:n)

# ╔═╡ aa4370c0-f83c-469b-b1c8-beb88c56f815
qft = qft_circ(3)

# ╔═╡ 59eb71ea-023f-4ef9-81e2-f01839d60669
vizcircuit(qft)

# ╔═╡ 0087779d-8f26-49ac-81df-bb6915249d9a
# Let us check the matrix representation
mat(qft) |> Matrix

# ╔═╡ b332c418-7a90-47ab-a956-690a559a6d6d
# Matrix properties
ishermitian(qft)

# ╔═╡ 9306c669-e6eb-4279-88c3-c76ed0318a85
isunitary(qft)

# ╔═╡ 308ca39c-1b2c-4528-8565-636d6b633a1f
isreflexive(qft)

# ╔═╡ 91ca1d78-e273-47f2-8032-88dc2c7d8fff
# The dagger of qft is the inverse-qft
iqft = qft'

# ╔═╡ e7f73769-823c-4dce-af96-f5440de2667a
vizcircuit(iqft)

# ╔═╡ 77dbc06a-7a1c-4de7-9f37-cee57863c7c3
# Run the circuit
reg3 = product_state(bit"011")

# ╔═╡ 4bbf23e3-8a61-482f-853d-7fb98b8e28f5
out = copy(reg3) |> qft

# ╔═╡ 58f0c73d-bb7f-4ea3-8ec4-24413698903e
copy(out) |> iqft ≈ reg3

# ╔═╡ 5ae36501-c44f-4e37-9aa2-5a844e1d78e2
# Measure the output (without collapsing state)
resqft3 = measure(out; nshots=10)

# ╔═╡ 87e285b0-6029-4def-b47f-63472c493aa8
# Measure the output and collapsing state
resqft3_inplace = measure!(out)

# ╔═╡ 321f7104-eb8d-4682-bb8b-72ba19331c5b
# bit strings can be indexed (little endian)
resqft3_inplace[1][1]

# ╔═╡ b7be78f7-9a40-4362-8255-4c963622fa97
# Run this quantum algorithm on a 20 qubit register at qubits (4,6,7)
reg20 = rand_state(20)

# ╔═╡ c49a3d96-ed54-40fa-8be2-c38bced18636
apply(reg20, subroutine(20, qft, (4,6,7)))

# ╔═╡ b7883e83-536b-4641-817f-3a0f643b4393
md"""
# Example: Simulate a variational quantum algorithms
"""

# ╔═╡ 9a8a739e-6e5b-4fe0-b363-c56396de9914
nbit = 10

# ╔═╡ c1b1bf1d-961d-455f-89bf-461d2658731a
# the hamiltonian
hami = EasyBuild.heisenberg(nbit)

# ╔═╡ 8e1e6ba1-9b54-4bb7-89ab-7e8d2c4c87d6
# exact diagonalization
hmat = mat(hami)

# ╔═╡ 3145df67-cdf5-42f9-a2d3-fb7e3cbb6068
# If you only want to get one column, the following way is much faster
hami[:,bit"0010001110"]

# ╔═╡ 92e266c9-0bdd-4fae-b3ca-291ba13d70c4
# `eigsolve` is for solving dominant eigenvalue problem of the target Hamiltonian
# the second argument `1` means converging at least one eigenvectors.
# the thrid argument `:SR` means finding the eigenvalue with the smallest real part.
eg, vg = KrylovKit.eigsolve(hmat, 1, :SR)

# ╔═╡ 16b8b24a-aa45-482a-9e99-403d9acf3895
# variational quantum circuit
vcirc = dispatch(EasyBuild.variational_circuit(nbit), :random)

# ╔═╡ 18939877-3e04-4d54-bcf4-cadaa0f58e4b
vizcircuit(vcirc)

# ╔═╡ 4126923d-8041-4473-a7b1-179e7c09c1f1
# energy expectation value as the loss
expect(hami, zero_state(nbit) => vcirc)

# ╔═╡ 49dc13a7-e9ac-481f-8b87-2873f7f102c3
# differentiate the energy function
# the return value is a pair: (gradient of initial state, gradient of circuit parameters)
expect'(hami, zero_state(nbit) => vcirc)

# ╔═╡ 1abc7199-423b-46d0-8610-87bbbe5b36ab
function train_vcirc(vcirc; nstep)
	for i = 1:nstep
		# compute gradient
	    regδ, paramsδ = expect'(hami, zero_state(nbit)=>vcirc)
		# update parameters with gradient descent, check Optim.jl for advanced gradient based optimizers, such as BFGS.
	    vcirc = dispatch(-, vcirc, 0.1*paramsδ)
		# show the loss
		energy = real(expect(hami, zero_state(nbit) => vcirc))
	    @info "Mean energy at step $i is $energy"
	end
	return vcirc
end

# ╔═╡ b7b8219d-bf14-4508-b508-ed0b24ec5183
train_vcirc(vcirc; nstep=100)

# ╔═╡ 4697607a-5d39-4548-b5aa-ad9e2427aa02
md"""
# CuYao: Speed up your quantum simulation with GPU
"""

# ╔═╡ 28e047c7-4dba-4daf-ab0e-10c103bb6b54
md"""The following live coding simulates a QFT circuit on GPU. It requires
* A GPU with CUDA support
* Julia package [`CuYao.jl`](https://github.com/QuantumBFS/CuYao.jl)

Source code is available in file: `clips/yao-v0.8-cuda.jl`
"""

# ╔═╡ 8a8b9b55-84a8-482c-a519-20a0be664275
livecoding("https://raw.githubusercontent.com/GiggleLiu/YaoTutorial/munich/clips/yao-v0.8-cuda.cast")

# ╔═╡ 6237ef80-8efb-4df0-95c4-22197b85f248
md"""
# Different circuit simulation tracks
There are special cases that quantum systems are efficiently simulatable by a classical computing device.
"""

# ╔═╡ b92db46b-3c34-44c6-92a5-1a1d3bed3a1f
LocalResource("images/simulatable.png")

# ╔═╡ 86fd00e8-289d-48ca-8904-980fc1e8dc18
md"""

### References
1. Low entangled state
    * [Markov, Igor L., and Yaoyun Shi. “Simulating Quantum Computation by Contracting Tensor Networks.” SIAM Journal on Computing 38, no. 3 (January 2008): 963–81.](https://doi.org/10.1137/050644756)
    * [Kalachev, Gleb, Pavel Panteleev, and Man-Hong Yung. “Recursive Multi-Tensor Contraction for XEB Verification of Quantum Circuits,” 2021, 1–9.](https://arxiv.org/abs/2108.05665)
2. Noisy limit
    * [Gao, Xun, and Luming Duan. “Efficient Classical Simulation of Noisy Quantum Computation.” October 7, 2018. arXiv.1810.03176.](https://arxiv.org/abs/2003.13163)
    * [Shao, Yuguo, Fuchuan Wei, Song Cheng, and Zhengwei Liu. “Simulating Quantum Mean Values in Noisy Variational Quantum Algorithms: A Polynomial-Scale Approach.” July 20, 2023. arXiv.2306.05804.](https://arxiv.org/abs/2306.05804)
"""

# ╔═╡ 3b0c380f-3885-4b81-bef1-636a51a8e760
md"""# Tensor network backend
What is tensor network？ It is basically the same as [`einsum`](https://nextjournal.com/under-Peter/julia-summer-of-einsum) or sum-product network!
"""

# ╔═╡ fdb5f044-9ef5-4cf6-8828-59a8520023ad
md"# Tensor network is very good at simulating shallow circuit!"

# ╔═╡ cd67362c-0c60-4ed4-a165-8fca5d74f5ca
md"""Google 53-qubit Sycamore processor: "The quantum system took approximately 200 seconds to execute a task that would have taken a classical computer around $(highlight("10,000 years")) to complete." """

# ╔═╡ 03a96fbf-439c-477e-8514-573ce2e6db1c
LocalResource("images/sycamore.jpg")

# ╔═╡ 452bcc28-909e-4bbd-8dd0-3616632d52b4
md"""Feng Pan et al.: "Nope! by contracting its tensor network representation on a single A100 GPU card, it costs only $(highlight("149 Days"))."""

# ╔═╡ 522318f0-c11f-418f-a415-e0278cfc03b7
LocalResource("images/bigbatch.png")

# ╔═╡ 9e88ebf9-19fc-4212-b59d-3c063def8a01
md"""
### References
* [Arute, Frank, Kunal Arya, Ryan Babbush, Dave Bacon, Joseph C. Bardin, Rami Barends, Rupak Biswas, et al. “Quantum Supremacy Using a Programmable Superconducting Processor.” Nature 574, no. 7779 (October 2019): 505–10.](https://doi.org/10.1038/s41586-019-1666-5)
* [Pan, Feng, and Pan Zhang. “Simulation of Quantum Circuits Using the Big-Batch Tensor Network Method.” Physical Review Letters 128, no. 3 (January 19, 2022): 030501.](https://doi.org/10.1103/PhysRevLett.128.030501)
"""

# ╔═╡ 8e43d2e1-4970-4def-a4b3-9469cc4daff7
md"""
# YaoToEinsum

A state of the art tensor network backend for Yao, which supports
* Slicing (for reducing memory cost)
* GPU simulation
"""

# ╔═╡ 3cc6287d-d076-4308-8098-5478655bdc70
md"Including tests, there are 222 lines in total!"

# ╔═╡ a579eb2d-135a-448e-b769-6a68f137a004
md"""
```
(base) ➜  YaoToEinsum git:(main) cloc .
      14 text files.
      14 unique files.                              
       3 files ignored.

github.com/AlDanial/cloc v 1.90  T=0.02 s (513.3 files/s, 42217.6 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
TOML                             2            103              1            406
Julia                            5             28             35            222
YAML                             3              0              0             71
TeX                              1              3              0             58
Markdown                         1             17              0             43
-------------------------------------------------------------------------------
SUM:                            12            151             36            800
-------------------------------------------------------------------------------
```
"""

# ╔═╡ cec44a64-16d8-47a3-8cca-822d4f3c20f3
md"""
* It is based on [OMEinsum](https://github.com/under-Peter/OMEinsum.jl) (Andreas Peter, Google Summer of Code, 2019)
* `OMEinsum` is later extended with state of the art contraction order finding algorithms.
    - Recursive min-cut
    - Local search

Please check Github repo [OMEinsumContractionOrders.jl](https://github.com/TensorBFS/OMEinsumContractionOrders.jl) for more information.

### References
* Gray, Johnnie, and Stefanos Kourtis. “Hyper-Optimized Tensor Network Contraction.” ArXiv, 2020. https://doi.org/10.22331/q-2021-03-15-410.
* Kalachev, Gleb, Pavel Panteleev, and Man-Hong Yung. “Recursive Multi-Tensor Contraction for XEB Verification of Quantum Circuits,” 2021, 1–9.
"""

# ╔═╡ a8c12dbf-2a53-4fa9-bd1d-7b11cf398a0a
md"""
# A demo using case
"""

# ╔═╡ bf7643c4-bae0-4d77-9903-29943f2efe5a
md"Julia slack > yao-dev"

# ╔═╡ 182b6520-d423-4aa5-8ef0-5e16f28960f6
LocalResource("images/yaotoeinsum-question.png")

# ╔═╡ 2ddadb79-b52d-4ed8-b471-d6c8121ec798
md"""
```julia
julia> @btime get_your_question_anwsered(
		"slack > yao-dev", 
		"zulip > yao-dev", 
		"discourse > quantum category"
	)
1 hour
```
"""

# ╔═╡ 24124e48-969a-475a-b3a5-787127364960
md"Yao community call will be announced in the Julia slack."

# ╔═╡ d1449d83-02ce-45d0-adfe-db86a5ece921
md"""
# Live coding

Source code available in file: `clips/yaotoeinsum.jl`
"""

# ╔═╡ e0a259f4-6d3d-45e6-890c-35115da50328
livecoding("https://raw.githubusercontent.com/GiggleLiu/YaoTutorial/munich/clips/yaotoeinsum.cast")

# ╔═╡ 6abb5d21-6e36-46a0-8448-3231a58b6694
md"# Density matrix based simulation"

# ╔═╡ f5aa8b74-3390-4c6d-ae02-b00a907f4c4a
# create a reduced density matrix on subsystem (1, 2, 3)
dm = density_matrix(ghz_state(5), 1:3)

# ╔═╡ 7f0a9bc9-262e-4472-baf4-8a0fb832b6c3
# the density matrix is represented as a matrix - computational very inefficient
dm.state

# ╔═╡ 3e7fcf94-7bdb-420b-88cf-560a18c0c393
# the entanglement entropy
von_neumann_entropy(dm)

# ╔═╡ 0b45cd74-dd01-40ff-b4ad-97dc373780fb
# apply a quantum gate X on the first qubit
apply(dm, put(3, 1=>X))

# ╔═╡ daa162ff-1781-4244-8139-990b2b910102
# measure the density matrix
measure(dm; nshots=5)

# ╔═╡ 27c585cc-6105-48fd-9628-79b91bedc930
measure(apply(dm, put(3, 1=>X)); nshots=5)

# ╔═╡ 23df82ca-5b48-47a7-ab1a-b82c7ed47796
# the expectation value of correlation Z₁Z₂
expect(kron(3, 1=>Z, 2=>Z), dm)

# ╔═╡ 58c9045b-737e-404e-8e53-9dc524f4c66a
# noises can be defined as a quantum unitary channel
dpolarizing = single_qubit_depolarizing_channel(0.1)

# ╔═╡ c24d5c67-22bf-40fe-9736-2281a078b795
let
	dmk = dm
	# repeatedly apply depolarizing channel on the first qubit
	for i=1:100
		dmk = apply(dmk, put(3, 1=>dpolarizing))
	end
	# the first qubit becomes completely random
	measure(dmk; nshots=10)
end

# ╔═╡ b517c6b9-2897-418f-b056-a256acdeffe4
md"""
# More Examples
For more examples, please check [QuAlgorithmZoo](https://github.com/QuantumBFS/QuAlgorithmZoo.jl).
"""

# ╔═╡ 51f7b1f4-3260-4e71-b427-7e79fc64b057
md"""
# What is the next step?
"""

# ╔═╡ ebe2e897-0197-4d91-a482-220d666294f7
md"""
1. Roger's research interest is more about quantum compling, he has written packages such as [OpenQASM.jl](https://github.com/QuantumBFS/OpenQASM.jl). Roger Luo and Chen Zhao is working on [YaoExpr.jl](https://github.com/QuantumBFS/YaoExpr.jl) for the next generation of quantum compiling.
2. GiggleLiu will focus more on tensor network based simulation of density matrices.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
KrylovKit = "0b1a1467-8014-51b9-945f-bf0ae24f4b77"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"
Yao = "5872b779-8223-5990-8dd0-5abbb0748c8c"
YaoPlots = "32cfe2d9-419e-45f2-8191-2267705d8dbc"

[compat]
KrylovKit = "~0.6.0"
PlutoUI = "~0.7.52"
SymEngine = "~0.10.0"
Yao = "~0.8.10"
YaoPlots = "~0.8.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0-beta2"
manifest_format = "2.0"
project_hash = "b1b5daf77014b58fb8b586b8dbf7f9ec10690c2f"

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

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CacheServers]]
deps = ["Distributed", "Test"]
git-tree-sha1 = "b584b04f236d3677b4334fab095796a128445bf8"
uuid = "a921213e-d44a-5460-ac04-5d720a99ba71"
version = "0.2.0"

[[deps.Cairo]]
deps = ["Cairo_jll", "Colors", "Glib_jll", "Graphics", "Libdl", "Pango_jll"]
git-tree-sha1 = "d0b3f8b4ad16cb0a2988c6788646a5e6a17b6b1b"
uuid = "159f3aea-2a34-519c-b102-8c37f9878175"
version = "1.0.5"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

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

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

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

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4558ab818dcceaab612d1bb8c19cee87eda2b83c"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.5.0+0"

[[deps.ExponentialUtilities]]
deps = ["Adapt", "ArrayInterface", "GPUArraysCore", "GenericSchur", "LinearAlgebra", "PrecompileTools", "Printf", "SparseArrays", "libblastrampoline_jll"]
git-tree-sha1 = "602e4585bcbd5a25bc06f514724593d13ff9e862"
uuid = "d4d017d3-3776-5f7e-afef-a10c40355c18"
version = "1.25.0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "466d45dc38e15794ec7d5d63ec03d776a9aff36e"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.4+1"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "299dc33549f68299137e51e6d49a13b5b1da9673"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.1"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d8db6a5a2fe1381c1ea4ef2cab7c69c2de7f9ea0"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.1+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GMP_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "781609d7-10c4-51f6-84f2-b8444358ff6d"
version = "6.2.1+5"

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

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "e94c92c7bf4819685eb80186d51c43e71d4afa17"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.76.5+0"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

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

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.Juno]]
deps = ["Base64", "Logging", "Media", "Profile"]
git-tree-sha1 = "07cb43290a840908a771552911a6274bc6c072c7"
uuid = "e5e0dc1b-0480-54bc-9374-aad01c23163d"
version = "0.8.4"

[[deps.KrylovKit]]
deps = ["ChainRulesCore", "GPUArraysCore", "LinearAlgebra", "Printf"]
git-tree-sha1 = "1a5e1d9941c783b0119897d29f2eb665d876ecf3"
uuid = "0b1a1467-8014-51b9-945f-bf0ae24f4b77"
version = "0.6.0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f689897ccbe049adb19a065c495e75f372ecd42b"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.4+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

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

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Librsvg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pango_jll", "Pkg", "gdk_pixbuf_jll"]
git-tree-sha1 = "ae0923dab7324e6bc980834f709c4cd83dd797ed"
uuid = "925c91fb-5dd6-59dd-8e8c-345e74382d89"
version = "2.54.5+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

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

[[deps.Luxor]]
deps = ["Base64", "Cairo", "Colors", "DataStructures", "Dates", "FFMPEG", "FileIO", "Juno", "LaTeXStrings", "PrecompileTools", "Random", "Requires", "Rsvg"]
git-tree-sha1 = "aa3eb624552373a6204c19b00e95ce62ea932d32"
uuid = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
version = "3.8.0"

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

[[deps.MPC_jll]]
deps = ["Artifacts", "GMP_jll", "JLLWrappers", "Libdl", "MPFR_jll", "Pkg"]
git-tree-sha1 = "9618bed470dcb869f944f4fe4a9e76c4c8bf9a11"
uuid = "2ce0c516-f11f-5db3-98ad-e0e1048fbd70"
version = "1.2.1+0"

[[deps.MPFR_jll]]
deps = ["Artifacts", "GMP_jll", "Libdl"]
uuid = "3a97d323-0669-5f0c-9066-3539efd106a3"
version = "4.2.0+1"

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

[[deps.Media]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "75a54abd10709c01f1b86b84ec225d26e840ed58"
uuid = "e89f7d12-3494-54d1-8411-f7d8b9ae1f27"
version = "0.5.0"

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

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+2"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+2"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "ceeda72c9fd6bbebc4f4f598560789145a8b6c4c"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.11+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+1"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4745216e94f71cb768d58330b059c9b76f32cb66"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.50.14+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

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

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rsvg]]
deps = ["Cairo", "Glib_jll", "Librsvg_jll"]
git-tree-sha1 = "3d3dc66eb46568fb3a5259034bfc752a0eb0c686"
uuid = "c4c386cf-5103-5370-be45-f3a111cca3b8"
version = "1.0.0"

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

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e2cfc4012a19088254b3950b85c3c1d8882d864d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.1"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

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

[[deps.SymEngine]]
deps = ["Compat", "Libdl", "LinearAlgebra", "RecipesBase", "Serialization", "SpecialFunctions", "SymEngine_jll"]
git-tree-sha1 = "7ac9aa65b5906680dbee1ea9c7a4c2b8f059686d"
uuid = "123dc426-2d89-5057-bbad-38513e3affd8"
version = "0.10.0"

[[deps.SymEngine_jll]]
deps = ["Artifacts", "GMP_jll", "JLLWrappers", "Libdl", "MPC_jll", "MPFR_jll"]
git-tree-sha1 = "072553a3d376f3c33ebed0f921cacf552e45d45a"
uuid = "3428059b-622b-5399-b16f-d347a77089a4"
version = "0.10.1+0"

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

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "04a51d15436a572301b5abbb9d099713327e9fc4"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.10.4+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "b4bfde5d5b652e22b9c790ad00af08b6d042b97d"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.15.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

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

[[deps.YaoPlots]]
deps = ["Luxor", "Yao"]
git-tree-sha1 = "84bd385d25be8263f483f115e54f5a0d31108c28"
uuid = "32cfe2d9-419e-45f2-8191-2267705d8dbc"
version = "0.8.1"

[[deps.YaoSym]]
deps = ["BitBasis", "LinearAlgebra", "LuxurySparse", "Requires", "SparseArrays", "YaoArrayRegister", "YaoBlocks"]
git-tree-sha1 = "5f4e557b3bac0f8433013ab543fe1251a83c12c9"
uuid = "3b27209a-d3d6-11e9-3c0f-41eb92b2cb9d"
version = "0.6.6"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[deps.gdk_pixbuf_jll]]
deps = ["Artifacts", "Glib_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pkg", "Xorg_libX11_jll", "libpng_jll"]
git-tree-sha1 = "e9190f9fb03f9c3b15b9fb0c380b0d57a3c8ea39"
uuid = "da03df04-f53b-5353-a52f-6a8b0620ced0"
version = "2.42.8+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"
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
# ╟─9c651a0f-be52-46c4-803b-756d7d00a406
# ╟─fdfb1ca6-e830-4c5c-8672-b42d0cb91a87
# ╟─cc312d0b-a5f6-4fa7-ae06-50c43a05b157
# ╟─d935b67a-2e77-4837-9cef-175dcd84040f
# ╟─415a253a-a976-4d66-800b-98c1ca3e860e
# ╟─a12aa313-f051-4f83-ac89-e3ab5685c5c8
# ╟─9935877e-3cb0-46d8-a6bd-baa8efcaa5b7
# ╟─61c3c643-dae3-4563-a85d-9daf07ff6060
# ╟─a01484e7-0710-4de1-aa81-92e083884902
# ╟─8da7a6c0-087c-4815-8011-4ef96ba971e1
# ╟─e2d493c4-0060-46f3-a689-613058f6e293
# ╟─2a6695b0-8e17-45f2-8656-7046dacaa349
# ╟─c46a0e9c-729d-4a8a-b70c-78b53fbab597
# ╟─f7d01385-f32a-4fcd-bbea-7789674106a7
# ╟─4457c6b8-a8e9-4853-a07a-1829d95be92e
# ╟─5642d4d4-767e-4395-a01e-79487fb39fc5
# ╟─a61a214c-0a43-4a15-a5c8-72716fbf3111
# ╟─0b4877e8-4378-428d-8913-024473b3d9e5
# ╟─283ea80f-c749-4e59-a4f1-e73cfa32ad0d
# ╟─b8cd9d6f-934f-4053-9d32-2535ce9d9f2c
# ╟─b2b16731-9410-4be1-ae6e-6467547c3e81
# ╟─e5312611-6c4c-4f51-aea0-9eb61cbb217a
# ╟─ef06e741-fe88-42b5-9063-1306b00f3915
# ╟─8b1915e3-63f8-461e-bdb1-4c257aa4d438
# ╟─a5eeccdc-73cc-4e99-884b-a04e827cc4bf
# ╠═78811601-76bf-44df-8a5f-8c9d1f3a87f2
# ╟─6281b968-b4bb-4ec7-8cd6-da3e788c2287
# ╠═b7d014b8-2c13-4ab0-8477-4d3284bc8f2d
# ╠═ad652d3e-a53e-4076-a1b0-e7ca7bd0d270
# ╠═22966094-d97b-4d1e-8065-dc9e33fae003
# ╠═006f14ea-f730-4211-844d-8a37e460fa6b
# ╠═d77242c6-d693-4d01-b04b-f8945b6b8125
# ╠═c55f2e5e-f54c-41b8-9154-017aaf716982
# ╠═22c4e552-5de5-4d3c-9a5a-8fb3b6738938
# ╠═f0c3aba2-7b8f-4f55-8fe0-6f6b664e73d3
# ╠═20304d97-c166-46c0-a2e0-75d901f66d6d
# ╠═2668cdd7-c83a-444e-9582-3d25fbdecd67
# ╠═c43727a2-1a31-4684-87b6-9af2f1938487
# ╠═d04826f5-e9a2-49cd-9f07-9d0cd4029fdb
# ╠═9112230a-32bc-47b7-a23e-cd4a77bd764d
# ╠═277ccef5-ccd4-407c-a864-76baa83955d6
# ╟─0e93dd67-8831-4cf0-9802-835e7b30e2f5
# ╟─295c6f45-0d97-42bc-b677-96ecbd124f37
# ╠═4fd3761c-16fc-4833-97d4-6ef07c54a0bc
# ╠═f26cc2ed-cb29-43d9-a216-2ea3da27516f
# ╠═869332bd-b70e-4812-83b4-6f3bc8b1d458
# ╠═b8924ea4-32e4-4d3a-9370-33987b8aefec
# ╠═aa0cc0fe-fb25-4e6b-82b4-0bd70d41c36d
# ╠═b8b7eed2-430c-401c-a026-cb6f44d2d4f6
# ╠═3d79dc1c-082a-43fc-8037-d988eb3a81a6
# ╠═935c518b-7a7f-485c-b37b-cb165e6ee77b
# ╠═ff79a542-7a68-4d74-bf10-664b7e6fe7ba
# ╠═3b543d83-f2fd-4976-a496-778baf265b75
# ╠═06373820-7687-43c3-b779-17019d520d28
# ╠═b7c14cba-31f0-4fad-9f43-f61a1028b294
# ╠═870bd2cd-2cf8-475d-b1d9-ce6113af5efb
# ╠═4b9997ce-b45d-40ca-934e-ef72acea4e7d
# ╠═abfb7c6a-ac95-4a84-8dcd-c5a58af21c7e
# ╠═421f365a-599b-4b84-874f-4e9298721720
# ╠═9c84936d-d678-4077-9423-dbb42629d6e2
# ╠═6ee0a7d3-0453-4426-a58e-ad27ba56e7f9
# ╠═6deb86e7-07de-4c2b-9ab8-8005e57582b6
# ╠═2c4c0aac-8919-41c6-bb8f-b7bea5d2f759
# ╠═4768ac25-62ed-42ae-a0c6-c039dabdbdae
# ╠═27471635-a488-43e8-bba5-8b587fdd84f0
# ╟─96192c95-da9a-42ad-8acb-d93e1f348a34
# ╠═abe87acc-29fb-4b64-9adb-d7a9b59b1ded
# ╠═2b6622a7-f37b-4c66-b73d-3309570252e2
# ╠═4ed2b831-9941-42be-bcdb-4a11e82f4713
# ╠═2a7a0629-678c-43d7-9f84-f82e2207c192
# ╠═9451d2e5-e592-4ccd-b081-554d29891488
# ╠═cacfd179-1c09-4048-bf55-d95ac30a20b8
# ╠═47d82c8b-54a7-44d1-8924-f579e96540d4
# ╠═676c9ed7-1c42-42d9-84a5-9d07f7c50f3c
# ╠═4171ac27-2d56-4699-b816-300a56da94ec
# ╠═3cfa909e-935c-4f41-9b32-fe86aef0026e
# ╠═d1f688c1-5b01-4823-95ab-e405b826b9fc
# ╠═ef656866-203e-4963-b575-b5de53aaac1a
# ╠═b2b7db90-1d65-46f9-a171-8d7b3b48a97f
# ╠═4dfc08fd-8a10-4d25-a273-a5c0e72df78e
# ╠═f3bf77bc-2783-4ec4-b2ec-9fc07c73bdbb
# ╠═337786c2-5d28-4c3c-976b-1b3bc21f32e5
# ╠═7f7fc02f-8746-4313-8aa2-b1d9ed1b1dfa
# ╠═007e9da9-8810-4731-b4e4-01c91f423089
# ╟─8dd52837-f6d1-4f56-b071-6a1ad4a18be7
# ╠═399e2661-0b84-445a-97fc-da16884ac3ae
# ╟─f2a372f1-06f7-46ff-a07d-9ed11fcd7a72
# ╠═9486139b-3587-41ab-a917-5c82bd39b1c7
# ╠═04b50a5b-8e57-461b-9bad-103ef3ed645a
# ╠═a8d42876-4a32-4eb7-9dd1-eb93d1033be2
# ╠═bebc0c44-e3d5-4c36-8ed8-f132e14ab8b3
# ╠═779d209e-cdb0-4e35-adf7-e59c27bebf52
# ╠═342467fb-9fc5-4f8c-bc1f-6c816848b56f
# ╠═aa4370c0-f83c-469b-b1c8-beb88c56f815
# ╠═59eb71ea-023f-4ef9-81e2-f01839d60669
# ╠═0087779d-8f26-49ac-81df-bb6915249d9a
# ╠═b332c418-7a90-47ab-a956-690a559a6d6d
# ╠═9306c669-e6eb-4279-88c3-c76ed0318a85
# ╠═308ca39c-1b2c-4528-8565-636d6b633a1f
# ╠═91ca1d78-e273-47f2-8032-88dc2c7d8fff
# ╠═e7f73769-823c-4dce-af96-f5440de2667a
# ╠═77dbc06a-7a1c-4de7-9f37-cee57863c7c3
# ╠═4bbf23e3-8a61-482f-853d-7fb98b8e28f5
# ╠═58f0c73d-bb7f-4ea3-8ec4-24413698903e
# ╠═5ae36501-c44f-4e37-9aa2-5a844e1d78e2
# ╠═87e285b0-6029-4def-b47f-63472c493aa8
# ╠═321f7104-eb8d-4682-bb8b-72ba19331c5b
# ╠═b7be78f7-9a40-4362-8255-4c963622fa97
# ╠═c49a3d96-ed54-40fa-8be2-c38bced18636
# ╟─b7883e83-536b-4641-817f-3a0f643b4393
# ╠═9a8a739e-6e5b-4fe0-b363-c56396de9914
# ╠═c1b1bf1d-961d-455f-89bf-461d2658731a
# ╠═8e1e6ba1-9b54-4bb7-89ab-7e8d2c4c87d6
# ╠═3145df67-cdf5-42f9-a2d3-fb7e3cbb6068
# ╠═46aa38fa-47ab-4c44-8bcb-655bd5ca70a6
# ╠═92e266c9-0bdd-4fae-b3ca-291ba13d70c4
# ╠═16b8b24a-aa45-482a-9e99-403d9acf3895
# ╠═18939877-3e04-4d54-bcf4-cadaa0f58e4b
# ╠═4126923d-8041-4473-a7b1-179e7c09c1f1
# ╠═49dc13a7-e9ac-481f-8b87-2873f7f102c3
# ╠═1abc7199-423b-46d0-8610-87bbbe5b36ab
# ╠═b7b8219d-bf14-4508-b508-ed0b24ec5183
# ╟─4697607a-5d39-4548-b5aa-ad9e2427aa02
# ╟─28e047c7-4dba-4daf-ab0e-10c103bb6b54
# ╟─8a8b9b55-84a8-482c-a519-20a0be664275
# ╟─6237ef80-8efb-4df0-95c4-22197b85f248
# ╟─b92db46b-3c34-44c6-92a5-1a1d3bed3a1f
# ╟─86fd00e8-289d-48ca-8904-980fc1e8dc18
# ╟─3b0c380f-3885-4b81-bef1-636a51a8e760
# ╟─fdb5f044-9ef5-4cf6-8828-59a8520023ad
# ╟─cd67362c-0c60-4ed4-a165-8fca5d74f5ca
# ╟─03a96fbf-439c-477e-8514-573ce2e6db1c
# ╟─452bcc28-909e-4bbd-8dd0-3616632d52b4
# ╟─522318f0-c11f-418f-a415-e0278cfc03b7
# ╟─9e88ebf9-19fc-4212-b59d-3c063def8a01
# ╟─8e43d2e1-4970-4def-a4b3-9469cc4daff7
# ╟─3cc6287d-d076-4308-8098-5478655bdc70
# ╟─a579eb2d-135a-448e-b769-6a68f137a004
# ╟─cec44a64-16d8-47a3-8cca-822d4f3c20f3
# ╟─a8c12dbf-2a53-4fa9-bd1d-7b11cf398a0a
# ╟─bf7643c4-bae0-4d77-9903-29943f2efe5a
# ╟─182b6520-d423-4aa5-8ef0-5e16f28960f6
# ╟─2ddadb79-b52d-4ed8-b471-d6c8121ec798
# ╟─24124e48-969a-475a-b3a5-787127364960
# ╟─d1449d83-02ce-45d0-adfe-db86a5ece921
# ╟─e0a259f4-6d3d-45e6-890c-35115da50328
# ╟─6abb5d21-6e36-46a0-8448-3231a58b6694
# ╠═f5aa8b74-3390-4c6d-ae02-b00a907f4c4a
# ╠═7f0a9bc9-262e-4472-baf4-8a0fb832b6c3
# ╠═3e7fcf94-7bdb-420b-88cf-560a18c0c393
# ╠═0b45cd74-dd01-40ff-b4ad-97dc373780fb
# ╠═daa162ff-1781-4244-8139-990b2b910102
# ╠═27c585cc-6105-48fd-9628-79b91bedc930
# ╠═23df82ca-5b48-47a7-ab1a-b82c7ed47796
# ╠═58c9045b-737e-404e-8e53-9dc524f4c66a
# ╠═c24d5c67-22bf-40fe-9736-2281a078b795
# ╟─b517c6b9-2897-418f-b056-a256acdeffe4
# ╟─51f7b1f4-3260-4e71-b427-7e79fc64b057
# ╟─ebe2e897-0197-4d91-a482-220d666294f7
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
