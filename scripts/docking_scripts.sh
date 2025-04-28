#!/bin/bash
set -e

# Step 0: Activate Conda Environment
echo "Activating Conda environment..."
source /home/mostafa/miniconda3/etc/profile.d/conda.sh
conda activate docking

# Show logo
figlet "                    ZnDock"

# ==========================================
# Molecular Docking Workflow
# ==========================================
echo "                     Author: Mostafa S. Abd El-Maksoud"
echo "-------------------------------------------------------------------------------"
echo "This script automates the molecular docking workflow using AutoDock Vina"
echo "It includes receptor and ligand preparation, grid generation, docking, and visualization steps."
echo "-------------------------------------------------------------------------------"
echo "Usage: Run this script in a terminal." 
echo "Ensure you have the required software installed and the conda environment activated."
echo "-------------------------------------------------------------------------------"
echo "Note: This script is designed for Linux systems." 
echo "Ensure you have the required software installed and the conda environment activated."
echo "-------------------------------------------------------------------------------"

# ==========================================
# Step 1: User Inputs
# ==========================================

# Ask user for input
read -p "Enter protein PDB file (e.g., protein.pdb): " PROTEIN_FILE
read -p "Enter ligand PDB file (e.g., ligand.pdb): " LIGAND_FILE

# Automatically derive filenames
LIGAND_SDF="ligand.sdf"
PROTEIN_PDBQT="protein.pdbqt"
PROTEIN_TZ_PDBQT="protein_tz.pdbqt"
LIGAND_PDBQT="ligand.pdbqt"

# Sleep time between steps (in seconds)
SLEEP_TIME=3

# ==========================================
# Step 2: Receptor Preparation
# ==========================================
echo "Preparing receptor..."
python2 prepare_receptor4.py -r "$PROTEIN_FILE" -o "$PROTEIN_PDBQT"
sleep $SLEEP_TIME

# Handle Zinc pseudo atom correction
echo "Correcting Zinc pseudo atoms..."
python2 zinc_pseudo.py -r "$PROTEIN_PDBQT" -o "$PROTEIN_TZ_PDBQT"
sleep $SLEEP_TIME

# ==========================================
# Step 3: Ligand Preparation
# ==========================================
echo "Preparing ligand..."
mk_prepare_ligand.py -i "$LIGAND_SDF" -o "$LIGAND_PDBQT"
sleep $SLEEP_TIME

read -p "Enter grid center (format: x,y,z): " GRID_CENTER
read -p "Enter grid size npts (format: x,y,z) [default 40,40,40]: " GRID_NPTS
read -p "Enter parameter file (e.g., protein.gpf): " PARAMETER_FILE

GRID_NPTS=${GRID_NPTS:-40,40,40}
# ==========================================
# Step 4: Generate Affinity Maps
# ==========================================
echo "Generating affinity maps..."
python2 prepare_gpf4zn.py -l "$LIGAND_PDBQT" -r "$PROTEIN_TZ_PDBQT" -o "$PARAMETER_FILE" \
-p npts="$GRID_NPTS" \
-p gridcenter="$GRID_CENTER" \
-p parameter_file=AD4Zn.dat
sleep $SLEEP_TIME

autogrid4 -p "$PARAMETER_FILE"
sleep $SLEEP_TIME

# ==========================================
# Step 5: Docking with AutoDock Vina
# ==========================================
# Modify --maps to use the parameter file name without extension

read -p "Enter scoring method (e.g., ad4): " SCORING_METHOD
read -p "Enter docking output file name (e.g., prot-lig.pdbqt): " DOCKING_OUTPUT

MAPS_BASENAME=$(basename "$PARAMETER_FILE" .gpf)

echo "Starting docking..."
vina --ligand "$LIGAND_PDBQT" --maps "$MAPS_BASENAME" --scoring "$SCORING_METHOD" --out "$DOCKING_OUTPUT"
sleep $SLEEP_TIME

# ==========================================
# Step 6: Visualization (Manual Step)
# ==========================================
echo "-------------------------------------------------------------------------------"


echo "Open PROTEIN_FILE and DOCKING_OUTPUT in PyMOL to analyze binding mode, H-bonds, 
Zn coordination, and RMSD."

