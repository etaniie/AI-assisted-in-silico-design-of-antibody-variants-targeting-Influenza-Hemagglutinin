# AI-Assisted In Silico Antibody Design Targeting Influenza Hemagglutinin
Computational pipeline for optimizing antibody binding affinity through structure-based design and machine learning approaches.

## Overview

This project implements an 8-step computational workflow to improve antibody variants targeting influenza hemagglutinin. The pipeline combines structural biology analysis with AI-guided mutation design to achieve enhanced binding properties.

## Results

The optimized antibody variant YGSTGDRH demonstrates 5-fold improved binding affinity (205.8 nM) compared to the original sequence (1038.8 nM), achieved through systematic CDR3 region optimization.

## Methodology

The pipeline consists of eight sequential analysis phases:

1. **Dataset exploration** - PDB structure collection and characterization
2. **Structure preprocessing** - Molecular cleaning and interface identification  
3. **CDR mapping** - Complementarity-determining region analysis and hotspot identification
4. **AI mutation design** - Machine learning-guided variant generation using ESM-2 and ProteinMPNN
5. **Binding affinity scoring** - Molecular docking and energy calculations
6. **Filtering and selection** - Multi-criteria evaluation and candidate ranking
7. **Visualization and reporting** - Comprehensive results analysis
8. **Documentation** - Repository organization and methodology documentation

## Requirements
```
biopython>=1.79
pandas>=1.5.0
matplotlib>=3.5.0
numpy>=1.21.0
torch>=1.12.0
transformers>=4.20.0
seaborn>=0.11.0
```

## Usage

Execute notebooks sequentially (part1 through part8). Each notebook contains complete documentation and can be run independently with appropriate input data.

## Repository Structure
```
part1_HA_dataset/           # Initial data collection
part2_structure_preprocessing/  # Molecular structure preparation
part3_CDR_mapping/          # Binding site identification
part4_ai_mutation_design/   # Variant generation
part5_binding_affinity/     # Binding strength evaluation
part6_filtering_selection/  # Candidate optimization
part7_visualization_report/ # Results presentation
part8_github_pipeline/      # Documentation
```

## Key Findings

The G1Y mutation (YGSTGDRH) was identified as the optimal variant through systematic evaluation of binding affinity, structural compatibility, and drug-like properties.

## Author

**Ecenur Karagöl**  
B.Sc. Molecular Biology and Genetics  
Specialization: Computational Biology, Structural Bioinformatics  
Contact: karagollece@gmail.com
