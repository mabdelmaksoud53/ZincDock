<!-- Author : Mostafa S. Abd El-Maksoud -->
# Setting up the Environment for Zinc Metalloproteins Docking using AutoDock Vina

Welcome! In this guide, we'll set up a complete environment for docking zinc metalloproteins using **AutoDock Vina**, **AutoDock Tools**, **AutoDock4**, **PyMOL**, and more.  
Let’s dive right in!

---

## Used programs

1. [AutoDock Tools 1.5.6](https://ccsb.scripps.edu/download/546/)
2. [AutoDock Tools 1.5.7](https://ccsb.scripps.edu/download/292/)
3. [AutoDock vina 1.2.3](https://vina.scripps.edu/wp-content/uploads/sites/55/2020/12/autodock_vina_1_1_2_linux_x86.tgz)
4. [AutoDock4](https://autodock.scripps.edu/wp-content/uploads/sites/56/2021/10/autodocksuite-4.2.6-x86_64Linux2.tar)
5. [Anaconda](https://www.anaconda.com/download)
6. [PyMOL](https://storage.googleapis.com/pymol-storage/installers/PyMOL-3.1.4.1-Linux-x86_64-py310.tar.bz2)

## Step-by-step Installation

## 1. Setup AutoDock Tools 1.5.6

- MGLTools 1.5.6 is mainly needed when specific plugins behave differently compared to 1.5.7.

```bash
chmod +x mgltools_Linux-x86_64_1.5.6_Install
./mgltools_Linux-x86_64_1.5.6_Install
```

## 2. Setup AutoDock Tools 1.5.7

- Use 1.5.7 if you need better support for newer file formats and smoother AutoGrid integration.

```bash
chmod +x mgltools_Linux-x86_64_1.5.7_Install
./mgltools_Linux-x86_64_1.5.7_Install
```

## 3. Setup autodock4.2

- This unpacks executables like `autodock4`, `autogrid4` necessary for traditional docking protocols.

```bash
tar -xzvf autodocksuite-4.2.6-x86_64Linux2.tar
```

## 4. Setup PyMOL

```bash
tar xvf PyMOL-2.3.4_121-Linux-x86_64-py37.tar.bz2
```

- `Create an alias (optional but recommended for convenience)`
- Open the bashrc file

```bash
sudo gedit ~/.bashrc
```

- Add the following line at the end of ~/.bashrc:

```bash
export PATH='/home/user/Downloads/pymol/pymol':$PATH
```

- Then reload the bash configuration:

```bash
source ~/.bashrc
```

- `NOTE` Adjust '/home/user/Downloads/pymol/pymol' to the actual extracted path if different.

## 5. Setup Anaconda

- Why Anaconda?
- Installing Anaconda provides an easy way to manage Python environments without messing up your system Python.

```bash
chmod +x Anaconda3-2021.05-Linux-x86_64.sh
./Anaconda3-2021.05-Linux-x86_64.sh
```

- `Add Anaconda to your system PATH (if not added automatically):`
- Open the bashrc file

```bash
gedit ~/.bashrc
```

- Add the following line at the end of ~/.bashrc:

```bash
export PATH='/home/user/anaconda3/bin':$PATH
```

- Then reload the bash configuration:

```bash
source ~/.bashrc
```

## 6. Install Python2 and NumPy (for MGLTools Compatibility)

- Python2 is deprecated. Only install it because AutoDock Tools internally depends on it.

```bash
sudo apt update
sudo add-apt-repository universe
sudo apt install python2
sudo apt update
```

## 7. Install pip for Python2

```bash
wget https://bootstrap.pypa.io/pip/2.7/get-pip.py
sudo python2 get-pip.py
pip2 install numpy
```

## 8. Add MGLToolsPckgs to the system path

- This step is important to allow external Python scripts to find MGLTools modules properly.
- Open the bashrc file

```bash
gedit ~/.bashrc
```

- Add the following line at the end of ~/.bashrc:

```bash
export PYTHONPATH="/home/user/MGLTools-1.5.7/MGLToolsPckgs":$PYTHONPATH
```

- Then reload the bash configuration:

```bash
source ~/.bashrc
```

## 9. Create a Conda Environment for Docking

```bash
conda create -n docking python=3.6
conda init
conda activate docking
```

## 10. Configure Conda channels and install required packages

```bash
conda config --env --add channels conda-forge
conda install -c conda-forge numpy openbabel rdkit scipy
pip install meeko vina autodock4
```

## 11. Final Checks

- Run these commands to confirm installations:

```bash
vina --version
pymol --version
python2 --version
python --version    # (inside docking environment)
```

- Always activate the environment before running docking tasks:

```bash
conda activate docking
```
