# Two-dimensional Algorithm for Pinpointing ERrors

TAPER is a tool that looks for errors in small species-specific stretches of the multiple sequence alignments. TAPER uses a two-dimensional outlier detection algorithm that seeks to find what parts of a sequence are outliers given the overall level of divergence of the sequence to others and the level of the divergence of the region in the alignment. Importantly, TAPER adjusts its null expectations per site and species, and in doing so, it attempts to distinguish the real heterogeneity (signal) from errors (noise).

A preprint of the method is available here: https://www.biorxiv.org/content/10.1101/2020.11.30.405589v1

* Zhang, C., Zhao, Y., Braun, E. L., & Mirarab, S. (2020). TAPER: Pinpointing errors in multiple sequence alignments despite varying rates of evolution. bioRxiv.

## Getting Started

### Prerequisites

Please download Julia [here](https://julialang.org/downloads/) and unzip the file using the following command.

```
tar -xvzf julia*.tar.gz
```

Luckily, Julia doesn't require installation on most platforms. You just download it and you have the tool. 

In the following, we use `JULIA_FOLDER` for the place you have copied the julia package. Change it to the actual place you used. 

## Running TAPER

### Showing help message

``` bash
JULIA_FOLDER/bin/julia correction_multi.jl -h
```

### Running on a single `.fasta`/`.fa` file

* For AA input, you can use the default version for all flags:

    ``` bash
    JULIA_FOLDER/bin/julia correction_multi.jl INPUTNAME > OUTPUTNAME
    ```
  * This will detect erronous sequences and will replace them with `X` in the output. 
  * Note that an `X` character in the input is treated the same way as dash (see `-m`)
  * For example, `cd` to the directory containing `correction_multi.jl`

    ``` bash
    JULIA_FOLDER/bin/julia correction_multi.jl sample_inputs/3.fasta > sample_inputs/3.out.fasta
    ```

* For DNA input, you (probably) want to mask erroneous regions with `N` instead of `X` and also treat `N` (instead of `X`) as a dash. To do this,  you can use `-m` (to set the output masking letter) and  `-a` (to set the ANY character). Thus, you would run:

    ``` bash
    JULIA_FOLDER/bin/julia correction_multi.jl -m N -a N INPUTNAME > OUTPUTNAME
    ```    
  * For example, `cd` to the directory containing `correction_multi.jl`

    ``` bash
    JULIA_FOLDER/bin/julia correction_multi.jl -m N -a N sample_inputs/dna.fasta > sample_inputs/dna.out.fasta
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

- The first line should be the path to an input file
- The second line should be the path to the output of the previous input file

For example, `cd` to the directory containing `correction_multi.jl` and run

``` bash
JULIA_FOLDER/bin/julia correction_multi.jl -l sample_inputs/files2run.txt
```



## Commandline arguments 

The following are all the available commands of `correction_multi`. 

``` bash
JULIA_FOLDER/bin/julia correction_multi.jl [-l] [-m MASK] [-a ANY] [-c CUTOFF] input
```

### `-l` 

`-l` tells the program to run multiple files together. 
*  By default, without `-l` command, your `input` should be a file in FASTA format and the program prints the output onto the standard output. 
*  You can try 
  ``` bash
  JULIA_FOLDER/bin/julia correction_multi.jl sample_inputs/3.fasta
  ```
  Also, you can redirect your output to a file. Try:
  ``` bash
  JULIA_FOLDER/bin/julia correction_multi.jl sample_inputs/3.fasta > sample_inputs/3.out.fasta
  ```
* To run multiple files at a time, you need a `LIST` file that includes the name of input and output files. 
  * The `LIST` file should look like this:
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
  - You can refer to `sample_inputs/files2run.txt` for formating.
  - To run multiple FASTA files, your `input` should be the `LIST` and you should add `-l` command. For example, to run the three FASTA files in `sample_inputs/files2run.txt`, try:
    ``` bash
    JULIA_FOLDER/bin/julia correction_multi.jl -l sample_inputs/files2run.txt
    ```

### `-m`

TAPER will mask each position that it believed to be erroneous with a specific MASK character. By default, it uses `X`, which makes sense for amino acid sequences. You can change the MASK character to most characters (including `-` and `*`). For example, if your input file contains DNA reads, it makes sense to mask with `N`. For example, try:

``` bash
JULIA_FOLDER/bin/julia correction_multi.jl -m N sample_inputs/dna.fasta
```

### `-a`

You may want TAPER to ignore a specific ANY character in the input file and treat it as if it is a `-`. By default, the ANY character is `X` which makes sense for amino acid sequences. You can change the ANY character to most characters (including `-` and `*`). For example, if your input file contains DNA reads, it makes sense to ignore `N`. For example, try:

``` bash
JULIA_FOLDER/bin/julia correction_multi.jl -a N sample_inputs/dna.fasta
```

### `-c`

A cutoff (make sense to > 1) to control aggressiveness of error detection. The ***lower*** the cutoff is, the more aggressive the TAPER becomes. Values below 1 are allowed but discouraged. The default cutoff is 3. For example, if you want TAPER be more precautious, you can try:

``` bash
JULIA_FOLDER/bin/julia correction_multi.jl -c 10 sample_inputs/3.fasta > sample_inputs/3.out.fasta
```

### (Advanced) `-p`

Load the list of `k`, `p`, `q`, and `L` from the input parameter file. Please refer to the paper for usage for the meaning of these parameters and multi-k setting. Very roughly speaking,
* `k` is the size of the kmer. 
* `p` is the maximum proportion of a site that could be removed. 
* `q` is the maximum proportion of a sequence that could be removed. 
* `L` is a hard upper bound on the length of sequences that will be removed. 
The input parameter file should contain a list of dictonaries with key words k, p, q, and L (in Julia format, see below). TAPER removes the union of all the parameters described in the list. 

By default, the input parameter is set to be:

```
[Dict("k"=>5, "p"=>0.25, "q"=>0.1, "L"=>30),
Dict("k"=>9, "p"=>0.25, "q"=>0.25, "L"=>54),
Dict("k"=>17, "p"=>0.1, "q"=>0.5, "L"=>Inf)]
```

This means that TAPER is run with k equals to 5, 9, and 17, each with a different p and q. Smaller k values are only used to catch short errors (<=30 and <=54, respectively for `k=5` and `k=9`). You can change these settings. 
* To get more aggresive filtering, you can increase `p` (to allow removal of more than 1/4 of a column) or `q` (to allow removal of more than half of a sequence). 
* To make the filtering less aggressive, you can lower `p` or `q` or lower `L` values. 
* 
However, it does seem a bit hard to optimize all these parameters. Thus, we suggest that most users simply use the defaults or use `-c` to adjust aggressiveness. If you adjust these parameters, some experimentation is needed. 

#### Single-k version. 

While we recommend the default multi-k version, you can have a single-k version by having only one k value in the `-p` parameter. 

For example, you can run:

``` bash
JULIA_FOLDER/bin/julia correction_multi.jl -p sample_inputs/parameter.txt sample_inputs/3.fasta
```
