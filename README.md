# AlignmentErrorRemoval
Removing misaligned regions

## Getting Started

### Prerequisites

Please download Julia [here](https://julialang.org/downloads/) and unzip the file using the following command.

```
tar -xvzf julia.tar.gz
```

## Running this tool

### Running on one single .fasta/.fa file

Make sure the file name ends with .fasta / .fa

```
JULIA_FOLDER/bin/julia correction.jl INPUTNAME > OUTPUTNAME
```

For example, cd to the directory containing correction.jl
```
JULIA_FOLDER/bin/julia correction.jl sample_inputs/3.fasta > sample_inputs/3.out.fasta
```

### Running on a list of files

Make sure the list name DOES NOT end with .fasta / .fa  

```
JULIA_FOLDER/bin/julia correction.jl LIST
```

LIST it should look like this:

```
path_to_input_file_1
path_to_output_of_input_file_1
path_to_input_file_2
path_to_output_of_input_file_2
...
```
For every two lines:

The first line should be the path to the input

The second line should be the path to the output of such input

For example, cd to the directory containing correction.jl
```
JULIA_FOLDER/bin/julia correction.jl sample_inputs/files2run.txt
```
