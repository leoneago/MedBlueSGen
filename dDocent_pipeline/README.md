
### commented steps of bioinformatics dDocent ddRAD tags assembly and filtering of data from:
  
### Leone et al. (2023). "Population genomics of the blue shark, *Prionace glauca*, reveals different stock units and discrete populations in the Mediterranean Sea and the North East Atlantic" *Evolutionary Applications* , 17(9): e70005. doi: https://doi.org/10.1111/eva.70005

Here is possible to find the bioinformatic steps for assembly and ddRAD loci filtering via [dDocent](http://www.ddocent.com/) used in the blue shark population genomics paper

#Filter initial Variant Calls

1. Start with raw vcf file and change all genotypes with less than 5 reads to missing data.

This inital calls can be found here.

The file needs to be unzipped before starting this workflow.

```sh
vcftools --vcf TotalRawSNPs.vcf --recode-INFO-all --minDP 5 --out BSdp5 --recode
```
> VCFtools - 0.1.14
> (C) Adam Auton and Anthony Marcketta 2009
>
> Parameters as interpreted:
>        --vcf TotalRawSNPs.vcf
>        --recode-INFO-all
>        --minDP 5
>        --out BSdp5
>        --recode
>
> After filtering, kept 210 out of 210 Individuals
> Outputting VCF file...
> After filtering, kept 56004 out of a possible 56004 Sites
> Run Time = 49.00 seconds

2. Filter out all variants that are present below a minor allele frequency of 1% and are not called in at least 50% of samples
```sh
vcftools --vcf BSdp5.recode.vcf --recode-INFO-all --maf 0.01 -–max-missing 0.5 --out BSdp5g5 –recode
```
> (C) Adam Auton and Anthony Marcketta 2009
> Parameters as interpreted:
>        --vcf BSdp5.recode.vcf
>        --recode-INFO-all
>        --maf 0.01
>        --max-missing 0.5
>        --out BSdp5g5
>        --recode
>After filtering, kept 210 out of 210 Individuals
>Outputting VCF file...
>After filtering, kept 27863 out of a possible 56004 Sites
>Run Time = 26.00 seconds

3. Use of a custom script called [filter_missing_ind.sh](https://github.com/jpuritz/dDocent/blob/master/scripts/filter_missing_ind.sh) to filter out bad individuals.
```sh
bash filter_missing_ind.sh BSdp5g5.recode.vcf BSdp5MI
```
At the prompt, enter `yes` and a custom cutoff of `0.60`
```sh
yes
0.60
```
> VCFtools - 0.1.14
> (C) Adam Auton and Anthony Marcketta 2009
>
> Parameters as interpreted:
>        --vcf BSdp5g5.recode.vcf
>        --exclude lowDP.indv
>        --recode-INFO-all
>        --out BSdp5MI
>        --recode
>
> Excluding individuals in 'exclude' list
> After filtering, kept 210 out of 210 Individuals
> Outputting VCF file...
> After filtering, kept 27863 out of a possible 27863 Sites
> Run Time = 23.00 seconds

4. Use of another custom script called [pop_missing_filter.sh](https://github.com/jpuritz/dDocent/blob/master/scripts/pop_missing_filter.sh) to filter loci that have high missing data values in a single population. You will need a file that maps individuals to populations popmap

```sh
./pop_missing_filter.sh BSdp5MI.recode.vcf popmap 0.25 0 BSdp5MIp25
```
> VCFtools - 0.1.14
> (C) Adam Auton and Anthony Marcketta 2009
>
> Parameters as interpreted:
>        --vcf BSdp5MI.recode.vcf
>        --keep keep.EATL
>        --out EATL
>        --missing-site
>
> Keeping individuals in 'keep' list
> After filtering, kept 35 out of 210 Individuals
> Outputting Site Missingness
> After filtering, kept 27863 out of a possible 27863 Sites
> Run Time = 1.00 seconds
>
> VCFtools - 0.1.14
> (C) Adam Auton and Anthony Marcketta 2009
>
> Parameters as interpreted:
>        --vcf BSdp5MI.recode.vcf
>        --keep keep.EMED
>        --out EMED
>        --missing-site
>
> Keeping individuals in 'keep' list
> After filtering, kept 57 out of 210 Individuals
> Outputting Site Missingness
> After filtering, kept 27863 out of a possible 27863 Sites
> Run Time = 1.00 seconds
>
> VCFtools - 0.1.14
> (C) Adam Auton and Anthony Marcketta 2009
>
> Parameters as interpreted:
>        --vcf BSdp5MI.recode.vcf
>        --keep keep.NATL
>        --out NATL
>        --missing-site
>
> Keeping individuals in 'keep' list
> After filtering, kept 30 out of 210 Individuals
> Outputting Site Missingness
> After filtering, kept 27863 out of a possible 27863 Sites
> Run Time = 1.00 seconds
>
> VCFtools - 0.1.14
> (C) Adam Auton and Anthony Marcketta 2009
>
> Parameters as interpreted:
>        --vcf BSdp5MI.recode.vcf
>        --keep keep.WMED
>        --out WMED
>        --missing-site
>
> Keeping individuals in 'keep' list
> After filtering, kept 88 out of 210 Individuals
> Outputting Site Missingness
> After filtering, kept 27863 out of a possible 27863 Sites
> Run Time = 1.00 seconds
>
> VCFtools - 0.1.14
> (C) Adam Auton and Anthony Marcketta 2009
>
> Parameters as interpreted:
>        --vcf BSdp5MI.recode.vcf
>        --exclude-positions loci.to.remove
>        --recode-INFO-all
>        --out BSdp5MIp25
>        --recode
>
> After filtering, kept 210 out of 210 Individuals
> Outputting VCF file...
> After filtering, kept 23638 out of a possible 27863 Sites

5. Next, filter sites again by 1% MAF, and filter out any sites with less than 90% overall call rate
```sh
vcftools --vcf BSdp5MIp25.recode.vcf --recode-INFO-all --maf 0.01 --max-missing 0.9 --out BSdp5MIp25g9 --recode
```
> VCFtools - 0.1.14
> (C) Adam Auton and Anthony Marcketta 2009
>
> Parameters as interpreted:
>        --vcf BSdp5MIp25.recode.vcf
>        --recode-INFO-all
>        --maf 0.01
>        --max-missing 0.9
>        --out BSdp5MIp25g9
>        --recode
>
> After filtering, kept 210 out of 210 Individuals
> Outputting VCF file...
> After filtering, kept 22660 out of a possible 23638 Sites
> Run Time = 19.00 seconds

6. Use a third custom filter script [dDocent_filters](https://github.com/jpuritz/dDocent/blob/master/scripts/dDocent_filters) that use FreeBayes info criteria and depth. Specifically:
* Loci with average allele balance at heterozygous genotypes less than 25% (the alternate allele in all heterozygous genotypes should have at least 25 or more reads). In addition, all loci with a quality sum of the reference or alternate allele equal to 0 were removed. This additionally filtering remove sites having large portion of spurious heterozygous genotype calls.
* Loci with a quality score less than half of the total depth, since FreeBayes can inflates quality scores in case of excessive depth, were removed.
* Loci with ratio between the mean mapping quality of alternate and reference allele less than 0.9 or more than 1.05 were removed.
* Loci coming from the majority of reads that did not come from only one read orientation were removed, since the insert size is larger than paired-end read lengths, so true RAD loci should not have forward and reverse reads that overlap.
* Loci were filtered on the base of properly paired-end reads status, since in the de novo assembly some loci will only have unpaired reads mapping to them. This is not a problem unless all the reads supporting the reference allele are paired but not support the alternate allele, suggesting a problem in the call.  In fact, true variants, ideally, should have reads coming from all properly paired reads, or only from not properly paired reads (some RAD loci do not assemble well paired-end reads, leaving only the forward ones).  Despite this, false variants tend to have properly paired reference reads and not properly paired alternate reads.  Loci were retained if more than 0.05% of reference reads were properly paired and less than 0.05% of alternate reads were properly paired and vice versa.
* Loci with a lower than the average depth plus on standard deviation were removed if the quality score was less than 2 times the depth. See Li (2014), doi: 10.1093/bioinformatics/btp324.
* Only loci in the bottom 90% of mean depth were kept in order to remove any potential bias due to paralogs or repetitive regions in the genome (expected in sharks).

```sh
./dDocent_filters.sh BSdp5MIp25g9.recode.vcf BSdp5MIp25g9
```
Below is the included output:
> This script will automatically filter a FreeBayes generated VCF file using criteria related to site depth, quality versus depth, strand representation, allelic balance at heterzygous individuals, and paired read representation.
> 
> The script assumes that loci and individuals with low call rates (or depth) have already been removed.
> Contact Jon Puritz (jpuritz@gmail.com) for questions and see script comments for more details on particular filters.
> 
> Number of sites filtered based on allele balance at heterozygous loci, locus quality, and mapping quality / Depth:
> 2535 of 22660.
> 
> Number of additional sites filtered based on overlapping forward and reverse reads:
> 1855 of 20125.
> 
> Is this from a mixture of SE and PE libraries? Enter yes or no:
>`no`.
>
> Number of additional sites filtered based on properly paired status:
> 211 of 18270.
> 
> Number of sites filtered based on high depth and lower than 2*DEPTH quality score:
> 976 of 18059.

                                            Adjusted Histogram of mean depth per site
  ![image](https://user-images.githubusercontent.com/51339439/224539627-187e3e94-5c80-412e-9153-edc5212733f0.png)

> If distrubtion looks normal, a 1.645 sigma cutoff (~90% of the data) would be 310348.2065.
> 
> The 95% cutoff would be 1255.
> 
> Would you like to use a different maximum mean depth cutoff than 1255, yes or no:
>`no`.
> Number of sites filtered based on maximum mean depth:
> 975 of 18059.
> 
> Total number of sites filtered:
> 5578 of 22660.
> 
> Remaining sites:
> 17082
> 
> Filtered VCF file is called Output_prefix.FIL.recode.vcf
> Filter stats stored in BSdp5MIp25g9.filterstats

7. Then, complex mutational events (combinations of SNPs and INDELs) were broken into separate SNP and INDEL calls, and the INDELs removed.
```sh
vcfallelicprimitives -k -g BSdp5MIp25g9.FIL.recode.vcf | sed 's:\.|\.:\.\/\.:g' > BSdp5MIp25g9.prim
```
```sh
vcftools --vcf BSdp5MIp25g9.prim --recode-INFO-all --recode --out SNP.BSdp5MIp25g9 --remove-indels
```
> VCFtools - 0.1.14
> (C) Adam Auton and Anthony Marcketta 2009
>
> Parameters as interpreted:
>        --vcf BSdp5MIp25g9.prim
>        --recode-INFO-all
>        --out SNP.BSdp5MIp25g9
>        --recode
>        --remove-indels
>
> After filtering, kept 210 out of 210 Individuals
> Outputting VCF file...
> After filtering, kept 16964 out of a possible 18102 Sites
> Run Time = 15.00 seconds

8. The loci that are out of HWE in more than half the populations were filtered out using [filter_hwe_by_pop.pl](https://github.com/jpuritz/dDocent/blob/master/scripts/filter_hwe_by_pop.pl) written by Chris Hollenbeck
```sh
perl filter_hwe_by_pop.pl -v SNP.BSdp5MIp25g9.recode.vcf -p popmap -c 0.5 -o SNP.BSdp5MIp25g9HWE
```
> Processing population: EATL (35 inds)
> Processing population: EMED (57 inds)
> Processing population: NATL (30 inds)
> Processing population: WMED (88 inds)
> Outputting results of HWE test for filtered loci to 'filtered.hwe'
> Kept 16872 of a possible 16964 loci (filtered 92 loci)

9. Restrict SNPs to loci only with 2 alleles.
```sh
vcftools --vcf SNP.BSdp5MIp25g9HWE.recode.vcf --recode-INFO-all --out SNP.BSdp5MIp25g9HWE2a --recode --max-alleles 2
```
> VCFtools - 0.1.14
> (C) Adam Auton and Anthony Marcketta 2009
>
> Parameters as interpreted:
>        --vcf SNP.BSdp5MIp25g9HWE.recode.vcf
>        --recode-INFO-all
>        --max-alleles 2
>        --out SNP.BSdp5MIp25g9HWE2a
>        --recode
>
> After filtering, kept 210 out of 210 Individuals
> Outputting VCF file...
> After filtering, kept 16775 out of a possible 16872 Sites

10. The resulting SNPs were transformed into haplotypes using the custom script [rad_haplotyper.pl](https://github.com/chollenbeck/rad_haplotyper) by Chris Hollenbeck from [Willis et al. (2017)](https://onlinelibrary.wiley.com/doi/abs/10.1111/1755-0998.12647), in order to mark any potential paralogs or genotype errors.  
```sh
perl rad_haplotyper.pl -v SNP.BSdp5MIp25g9HWE2a.recode.vcf -p popmap -r reference.fasta -x 10 -mp 5
```
> Filtered 1635 loci below missing data cutoff
> Filtered 192 possible paralogs
> Filtered 0 loci with low coverage or genotyping errors
> Filtered 0 loci with an excess of haplotypes
> This script uses called genotypes and aligned reads to make haplotype calls across RAD loci using both F and R reads.

11. Move output and create a list of files that had high levels of missing data and potential paralogs
```sh
cp stats.out stats.out.HF
mawk '/Missi/' stats.out.HF | mawk '$9 > 30' > HF.missing
mawk '/para/' stats.out.HF > HF.para
cat HF.para HF.missing > HF.loci.tofilter
```
12. Loci with more than 5 individuals marked as paralogous and more than 30 individuals marked for genotype errors were then removed from the dataset using the custom script [remove.bad.hap,loci.sh](https://github.com/jpuritz/dDocent/blob/master/scripts/remove.bad.hap.loci.sh).
```sh
./remove.bad.hap.loci.sh HF.loci.tofilter SNP.BSdp5MIp25g9HWE2a.recode.vcf
```
To see how many loci were retained:
```sh
mawk '!/#/' SNP.BSdp5MIp25g9HWE2a.filtered.vcf | wc -l
```
> 14729

A relatedness analysis has been done with VCFtools
```sh
vcftools --vcf SNP.BSdp5MIp25g9HWE2a.filtered.vcf --relatedness
```
