# A tutorial for Yao@v0.6

For `Yao@v0.5` tutorial, click [here](https://github.com/GiggleLiu/YaoTutorial/tree/v0.5.0).

Setup Julia and Jupyter notebook environment following the instructions in
https://datatofish.com/add-julia-to-jupyter/,

Then open a shell and type

```bash
$ jupyter notebook YaoTutorial.ipynb
```

## live coding

##### Notes on Clip
* Quantum Block Intermediate Representation (QBIR) of QFT
* get matrix representation of a block
* analyze properties
* dagger a block
* apply a blocks to a register
* measure a register
* using GPU
* Constructing a hamiltonian
* get the expectation value
* solve the ground state through
    * exact diagonalization (with KrylovKit)
    * variational quantum eigensolver approach
    * imaginary time evolution


[![asciicast](https://asciinema.org/a/R3v3xcdp7M38CGWWxS0YH4mLG.svg)](https://asciinema.org/a/R3v3xcdp7M38CGWWxS0YH4mLG?speed=2)

## References
##### Find Yao
https://github.com/QuantumBFS/Yao.jl

##### Find Quantum algorihtms
https://github.com/QuantumBFS/QuAlgorithmZoo.jl

## How To contribute
* submit an issue to report a bug, or ask for a feature request,
* help us polish documentations, write more tests
