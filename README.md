# ASCON-128 VHDL Implementation

This repository contains a full VHDL implementation of the ASCON-128 authenticated encryption algorithm, developed as part of a digital systems design project at Mines Saint-Étienne (ISMIN).

## About ASCON-128

ASCON-128 is a lightweight authenticated encryption algorithm selected in the [NIST Lightweight Cryptography competition](https://csrc.nist.gov/projects/lightweight-cryptography). It offers both confidentiality and authenticity using a single symmetric 128-bit key and operates on a 320-bit internal state with permutation-based transformations.

## Project Objectives

- Understand and implement the core components of the ASCON-128 algorithm
- Model all transformations and permutation layers in VHDL
- Simulate and verify correctness using **ModelSim**
- Build a complete functional encryption pipeline with a top-level FSM

## Supported Features

- Full encryption pipeline of ASCON-128 (encryption only, not decryption)
- Implementation of all internal transformations:
  - **AddConstant** (`pC`)
  - **Substitution Layer** (`pS`) with 64 parallel 5-bit S-boxes
  - **Linear Diffusion Layer** (`pL`)
- Structural modeling of:
  - Base permutation block
  - Intermediate permutation (XOR with key/data)
  - Final permutation (ciphertext + tag extraction)
- Top-level FSM (Moore machine) with:
  - Round/block counters
  - 16-state encryption flow from initialization to final tag output
- Benchtests verifying every feature

## Project Structure
```
ASCON-128/
│
├── SRC/
│ ├── RTL/ # VHDL source files for all components
│ └── BENCH/ # VHDL testbenches for each component
│
├── Report (french, academic).pdf
│
├── README.md
```

## How to Simulate

1. Install **ModelSim** or any VHDL simulator supporting VHDL-2008.
2. Compile all source files and testbenches using:
   ```bash
   source compile_src.txt
   ```
3. Run simulations for each component:
   ```bash
   vsim LIB_BENCH.<testbench_name>
   ```
4. Observe waveform and verify outputs.

## Test Coverage
Each module is unit-tested individually and then integrated into a full simulation of the `ascon_top` module.

## Limitations & Future Work

- Encryption only: decryption not implemented
- Symmetric-only: requires key sharing
- FSM could be optimized to reduce state count
- Extension to variable key or message sizes could be explored

## References

- Jean-Max Dutertre, Olivier Potin, Guillaume Reymond, Jean-Baptiste Rigaud, "Modélisation VHDL de l’algorithme de déchiffrement ASCON," Projet PCSN EI2021, 2022

## Licence

This project is provided for academic purposes. Feel free to explore, modify, or build upon it.
