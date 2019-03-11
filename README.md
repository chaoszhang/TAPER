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

### Showing help message

``` bash
JULIA_FOLDER/bin/julia correction.jl -h
```

### Running on one single .fasta/.fa file

``` bash
JULIA_FOLDER/bin/julia correction.jl INPUTNAME > OUTPUTNAME
```

For example, cd to the directory containing `correction.jl`

``` bash
JULIA_FOLDER/bin/julia correction.jl sample_inputs/3.fasta > sample_inputs/3.out.fasta
```

### Running on a list of files

You need a `LIST` file that includes the name of input and output files. Run:

``` bash
JULIA_FOLDER/bin/julia correction.jl -l LIST
```

`LIST` should look like this:

```
path_to_input_file_1
path_to_output_of_input_file_1
path_to_input_file_2
path_to_output_of_input_file_2
...
```

For every two lines in `LIST`:

- The first line should be the path to the input
- The second line should be the path to the output of the previous input

For example, cd to the directory containing correction.jl

``` bash
JULIA_FOLDER/bin/julia correction.jl -l sample_inputs/files2run.txt
```

### Running on DNA/RNA

You may want to mask erroneous regions with N instead of X.

``` bash
JULIA_FOLDER/bin/julia correction.jl -m N INPUTNAME > OUTPUTNAME
```
