# DMLabInstall

This is code for installing DeepMind Lab on OSX for the LOST Project.

## Installation

To install, run:
```bash
curl https://raw.githubusercontent.com/DavidMChan/DMLabInstall/master/install_lab.sh | bash
```
in the directory that you want to install DMLab.

If you want to change the name of the lab folder, use the command:
```bash
export LAB_DIRNAME=mylab 
curl https://raw.githubusercontent.com/DavidMChan/DMLabInstall/master/install_lab.sh | bash
```

## Instructions for running experiments


#### Condition: SPARSE rewards (no apples)

- `bazel run -c opt --define graphics=sdl //:game -- --level_script demos/map_generation/naren_manual_eliza_TR --observation DEBUG.POS.TRANS --observation DEBUG.POS.ROT --observation VEL.TRANS --observation VEL.ROT > kid1_A.txt`

- `bazel run -c opt --define graphics=sdl //:game -- --level_script demos/map_generation/naren_manual_eliza_NEWno --observation DEBUG.POS.TRANS --observation DEBUG.POS.ROT --observation VEL.TRANS --observation VEL.ROT > kid1_B.txt`

- `bazel run -c opt --define graphics=sdl //:game -- --level_script demos/map_generation/naren_manual_eliza_NEW --observation DEBUG.POS.TRANS --observation DEBUG.POS.ROT --observation VEL.TRANS --observation VEL.ROT > kid1_C.txt`

- `bazel run -c opt --define graphics=sdl //:game -- --level_script demos/map_generation/naren_manual_eliza_NEWb --observation DEBUG.POS.TRANS --observation DEBUG.POS.ROT --observation VEL.TRANS --observation VEL.ROT > kid1_D.txt`

- `bazel run -c opt --define graphics=sdl //:game -- --level_script demos/map_generation/naren_manual_eliza_NEW4 --observation DEBUG.POS.TRANS --observation DEBUG.POS.ROT --observation VEL.TRANS --observation VEL.ROT > kid1_E.txt`

- `bazel run -c opt --define graphics=sdl //:game -- --level_script demos/map_generation/naren_manual_eliza_NEW4 --observation DEBUG.POS.TRANS --observation DEBUG.POS.ROT --observation VEL.TRANS --observation VEL.ROT > kid1_F.txt`

- `bazel run -c opt --define graphics=sdl //:game -- --level_script demos/map_generation/naren_manual_eliza_NEW4b --observation DEBUG.POS.TRANS --observation DEBUG.POS.ROT --observation VEL.TRANS --observation VEL.ROT > kid1_G.txt`



#### Condition: DENSE rewards (apples)

- `bazel run -c opt --define graphics=sdl //:game -- --level_script demos/map_generation/naren_manual_eliza_TR --observation DEBUG.POS.TRANS --observation DEBUG.POS.ROT --observation VEL.TRANS --observation VEL.ROT > kid1_A.txt`

- `bazel run -c opt --define graphics=sdl //:game -- --level_script demos/map_generation/naren_manual_eliza_NEWA --observation DEBUG.POS.TRANS --observation DEBUG.POS.ROT --observation VEL.TRANS --observation VEL.ROT > kid1_B.txt`

- `bazel run -c opt --define graphics=sdl //:game -- --level_script demos/map_generation/naren_manual_eliza_NEW --observation DEBUG.POS.TRANS --observation DEBUG.POS.ROT --observation VEL.TRANS --observation VEL.ROT > kid1_C.txt`

- `bazel run -c opt --define graphics=sdl //:game -- --level_script demos/map_generation/naren_manual_eliza_NEWb --observation DEBUG.POS.TRANS --observation DEBUG.POS.ROT --observation VEL.TRANS --observation VEL.ROT > kid1_D.txt`

- `bazel run -c opt --define graphics=sdl //:game -- --level_script demos/map_generation/naren_manual_eliza_NEW4A --observation DEBUG.POS.TRANS --observation DEBUG.POS.ROT --observation VEL.TRANS --observation VEL.ROT > kid1_E.txt`

- `bazel run -c opt --define graphics=sdl //:game -- --level_script demos/map_generation/naren_manual_eliza_NEW4 --observation DEBUG.POS.TRANS --observation DEBUG.POS.ROT --observation VEL.TRANS --observation VEL.ROT > kid1_F.txt`

- `bazel run -c opt --define graphics=sdl //:game -- --level_script demos/map_generation/naren_manual_eliza_NEW4b --observation DEBUG.POS.TRANS --observation DEBUG.POS.ROT --observation VEL.TRANS --observation VEL.ROT > kid1_G.txt`
