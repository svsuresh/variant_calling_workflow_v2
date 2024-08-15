
rule cutadapt:
    input:
        R1= rules.deinterlace.output.R1, 
        R2= rules.deinterlace.output.R2,
    output:
        R1="{sample}/trimmed/{sample}_R1.fastq",
        R2="{sample}/trimmed/{sample}_R2.fastq",
    params:
        adapters= "--rc -g CGTATAATGTATGCTATACGAAGTTATCTCGAGCCAC -a GGAGATCGTGATCCGGAGCGAGAACTTC -G GAAGTTCTCGCTCCGGATCACGATCTCC -B CGTATAATGTATGCTATACGAAGTTATCTCGAGCCACCATGGATGCAATG -b CGTATAATGTATGCTATACGAAGTTATCTCGAGCCACCATGGATGCAATG -B GAAGTTCTCGCTCCGGATCACGATCTCCTCCTCGGCCAGGCTGCCGTTCA -b GAAGTTCTCGCTCCGGATCACGATCTCCTCCTCGGCCAGGCTGCCGTTCA -A GTGGCTCGAGATAACTTCGTATAGCATACATTATACG -b CATGGATGCAATGAAGAGAGGGCTCTGCTGTGTGCTGCTGCTGTGTGGAG -B CATGGATGCAATGAAGAGAGGGCTCTGCTGTGTGCTGCTGCTGTGTGGAG",
        extra="-m 20",
    log:
        "{sample}/logs/cutadapt/{sample}.log",
    threads: 4  
    shell:'''
        cutadapt --quiet -j {threads} -n 4  {params.extra} {params.adapters} -o {output.R1} -p {output.R2} {input.R1} {input.R2}
    '''
