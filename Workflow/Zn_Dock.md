## Molecular Docking Workflow (with Zn Coordination)

- This guide walks through how to prepare the receptor and ligand, generate grid maps, perform docking using AutoDock Vina, and visualize the results.

### Before Starting

1. Download scripts

- Clone or download the scripts found in the `scripts/` directory of the GitHub repository.

2. Download Required Files

- `Protein`: Download the target protein structure from the [Protein Data Bank](https://www.rcsb.org/).
- `Ligand`: Sketch your ligand using tools like `ChemDraw` or download it from databases like `PubChem`.

## 1. Receptor Preparation

a. Clean the Protein in `PyMOL`

1. Open the protein `.pdb` file in PyMOL.
2. Remove:

- All water molecules (`HOH`).
- Unnecessary chains (keep only the desired chain).
- Unwanted HETATM entries (except for metal ions like `Zn²⁺` and the `co-crystallized` ligand).

3. Save the cleaned protein structure as a new `.pdb` file (e.g., `protein_clean.pdb`).

```bash
# Example in PyMOL command line:
remove solvent
remove not chain A 
remove resn K
save protein_clean.pdb
```

4. Reload the saved file, then remove the co-crystallized ligand.
5. Add hydrogens to the macromolecule:

- PyMOL > Action > Hydrogens > Add
- Save the final receptor as protein.pdb.

b. Prepare the Receptor for Docking

- Using MGLTools 1.5.6 (Python2-based):

```bash
python2 prepare_receptor4.py -r protein.pdb -o protein.pdbqt
```

- `Note`: You may encounter the following error because of the presence of a Zn²⁺ ion.
- `Sorry, there are no Gasteiger parameters available for atom 5edu_cleaned:A: ZN901:ZN`

- To fix

```bash
python2 zinc_pseudo.py -r protein.pdbqt -o protein_tz.pdbqt
```

- This script adjusts the Zn ion for proper treatment in AutoDock calculations.

c. Determine the Active Site Coordinates

- Use either MGLTools (`AutoGrid`) or visually inspect the protein in PyMOL to determine:
- Grid center coordinates (`x, y, z`)
- Grid box dimensions (`npts`)

## 2. Ligand Preparation

1. Using `open babel` minimize and protonate the ligand (neutralize or ionize the ligand).
2. Save the ligand as an .sdf file (e.g., ligand.sdf).

```bash
obabel ligand.pdb -O ligand.sdf -h
```

- Then, prepare the ligand for docking:

```bash
mk_prepare_ligand.py -i ligand_H.sdf -o ligand.pdbqt
```

## 3. Generate Affinity Maps Using AutoGrid4

- Prepare the `.gpf` (grid parameter file) using a script designed for Zn coordination:

```bash
python2 prepare_gp4zn.py -l ligand.pdbqt -r protein_tz.pdbqt -o protein_tz.gpf -p npts=40,50,40 -p gridcenter=17,-45,102.5 -p parameter_file=AD4Zn.dat
```
- Then

```bash
autogrid4 -p protein_tz.gpf
```

Where:

- npts defines the number of grid points along X, Y, Z (adjust based on binding site size).
- gridcenter defines the center of the grid box.

## 4. Perform Docking with AutoDock Vina

- Use Vina's AutoDock4 scoring function with the generated maps:

```bash
vina --ligand ligand.pdbqt --maps protein_tz --scoring ad4 --out prot-lig.pdbqt --exhaustiveness 32
```

Options explained:

- `--ligand`: the prepared ligand `.pdbqt`.

- `--maps`: prefix of the pre-calculated grid maps.

- `--scoring ad4`: use AutoDock4 scoring function.

- `--out`: output docked complex.

- `--exhaustiveness`: controls the search thoroughness (higher = slower but better).

## 5. Visualization and Analysis

1. Open the output file (prot-lig.pdbqt) in PyMOL or Chimera
2. Load both:

- The original receptor (protein_clean.pdb).
- The docked ligand (prot-lig.pdbqt).

3. Analyze:

- Binding mode.
- Hydrogen bonds.
- Coordination to Zn²⁺.
- Hydrophobic interactions.

4. Optional:

- Superimpose the co-crystalized ligand with the docked pose for comparison.
- Measure RMSD if needed.

## Requirements

- Python 2.7 (for MGLTools scripts)
- MGLTools 1.5.7 (prepare_receptor4.py, etc.)
- AutoDock4
- AutoDock Vina
- PyMOL
- Open Babel

## Notes

- Ensure Zn ion is correctly treated. AutoDock Vina requires manual adjustment.
- Grid box size must fully encompass the binding site.
- Always validate docking poses by visual inspection and, if possible, experimental comparison.
