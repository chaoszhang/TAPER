# Two-dimensional Algorithm for Pinpointing ERrors
Removing misaligned regions. The algorithm is unpublished for now. 

## Getting Started

### Prerequisites

Please download Julia [here](https://julialang.org/downloads/) and unzip the file using the following command.

```
tar -xvzf julia*.tar.gz
```

Luckily, Julia doesn't require installation on most platforms. You just download it and you have the tool. 

In the following, we use `JULIA_FOLDER` for the place you have copied the julia package. Change it to the actual place you used. 

## Running this tool

### Showing help message

``` bash
JULIA_FOLDER/bin/julia correction_multi.jl -h
```

### Running on one single .fasta/.fa file

``` bash
JULIA_FOLDER/bin/julia correction_multi.jl INPUTNAME > OUTPUTNAME
```

For example, cd to the directory containing `correction_multi.jl`

``` bash
JULIA_FOLDER/bin/julia correction_multi.jl sample_inputs/3.fasta > sample_inputs/3.out.fasta
```

### Running on a list of files

You need a `LIST` file that includes the name of input and output files. Run:

``` bash
JULIA_FOLDER/bin/julia correction_multi.jl -l LIST
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

- The first line should be the path to a input file
- The second line should be the path to the output of the previous input file

For example, cd to the directory containing correction.jl

``` bash
JULIA_FOLDER/bin/julia correction_multi.jl -l sample_inputs/files2run.txt
```

### Running on DNA/RNA

You probably want to mask erroneous regions with `N` using `-m` and set "ANY" character to `N` instead of `X` to treat `N` as a missing value using `-a`. 

``` bash
JULIA_FOLDER/bin/julia correction_multi.jl -m N -a N INPUTNAME > OUTPUTNAME
```


### Running single-k version

While we recommend the default multi-k version, the single k version is also available. 


``` bash
JULIA_FOLDER/bin/julia correction.jl INPUTNAME > OUTPUTNAME
```

You can adjust `-k`. For example, for DNA, you may want a larger k than default.

``` bash
JULIA_FOLDER/bin/julia correction.jl -k 11 -a N -m N INPUTNAME > OUTPUTNAME
```

## Commandline arguments explained in detail

You can `cd` to the TAPER directory and use the following command to run TAPER.

``` bash
JULIA_FOLDER/bin/julia correction_multi.jl [-l] [-m MASK] [-a ANY] [-c CUTOFF] input
```

### `-l`

`-l` command tells the program to run multiple files together. By default, without `-l` command, your `input` should be a file in FASTA format and the program prints the output onto the screen. Try

``` bash
JULIA_FOLDER/bin/julia correction_multi.jl sample_inputs/3.fasta
```

Also, you can redirect your output to an file. Try:

``` bash
JULIA_FOLDER/bin/julia correction_multi.jl sample_inputs/3.fasta > sample_inputs/3.out.fasta
```

To run multiple files at a time, you need a `LIST` file that includes the name of input and output files.

`LIST` should look like this:

```
path_to_input_file_1
path_to_output_of_input_file_1
path_to_input_file_2
path_to_output_of_input_file_2
...
```

For every two lines in `LIST`:

- The first line should be the path to a input file
- The second line should be the path to the output of the previous input file


You can refer to `sample_inputs/files2run.txt` for formating.

To run multiple FASTA files, your `input` should be the `LIST` and you should add `-l` command. For example, to run the three FASTA files in `sample_inputs/files2run.txt`, try:

``` bash
JULIA_FOLDER/bin/julia correction_multi.jl -l sample_inputs/files2run.txt
```

### `-m`

TAPER will mask each position that it believed to be erroneous with a specific MASK character. By default, it is `X` which makes sense for amino acid sequences. You can change the MASK character to any legal characters (including `-` and `*`). For example, if your input file contains DNA reads, it makes sense to mask with `N`. For example, try:

``` bash
JULIA_FOLDER/bin/julia correction_multi.jl -m N sample_inputs/dna.fasta
```

### `-a`

You may want TAPER to ignore a specific ANY character in the input file and treat it as if it is a `-`. By default, the ANY character is `X` which makes sense for amino acid sequences. You can change the ANY character to any legal characters (including `-` and `*`). For example, if your input file contains DNA reads, it makes sense to ignore `N`. For example, try:

``` bash
JULIA_FOLDER/bin/julia correction_multi.jl -a N sample_inputs/dna.fasta
```

### `-c`

A cutoff (must be > 1) to control aggressiveness of error detection. The ***lower*** the cutoff is, the more aggressive the TAPER becomes. The default cutoff is 3. For example, if you want TAPER be more precautious, you can try:

``` bash
JULIA_FOLDER/bin/julia correction_multi.jl -c 10 sample_inputs/3.fasta > sample_inputs/3.out.fasta
```
