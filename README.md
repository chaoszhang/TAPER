# AlignmentErrorRemoval

Removing misaligned regions. The algorithm is unpublished for now. 

## Getting Started

### Prerequisites

Please download Julia [here](https://julialang.org/downloads/) and unzip the file using the following command.

```
tar -xvzf julia*.tar.gz
```

Luckily, Julia doesn't requrie installation on most platforms. You just download it and you have the tool. 

In the following, we use `JULIA_FOLDER` for the place you have copied the julia package. Change it to the actual place you used. 

## Running this tool

### Running on one single .fasta/.fa file

Make sure the file name ends with `.fasta` or `.fa`

``` bash
JULIA_FOLDER/bin/julia correction.jl INPUTNAME > OUTPUTNAME
```

For example, cd to the directory containing `correction.jl`

``` bash
JULIA_FOLDER/bin/julia correction.jl sample_inputs/3.fasta > sample_inputs/3.out.fasta
```

### Running on a list of files

You need a LIST file that includes the name of input and output files. Make sure the list name DOES NOT end with `.fasta` or `.fa`. Run:

``` bash
JULIA_FOLDER/bin/julia correction.jl LIST
```

`LIST` should look like this:

```
path_to_input_file_1
path_to_output_of_input_file_1
path_to_input_file_2
path_to_output_of_input_file_2
...
```

Thus, For every two lines:

- The first line should be the path to the input
- The second line should be the path to the output of the previous input

For example, cd to the directory containing correction.jl

``` bash
JULIA_FOLDER/bin/julia correction.jl sample_inputs/files2run.txt
```
