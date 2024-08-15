rule dedup:
    input:  
        R1=rules.cutadapt.output.R1,
        R2=rules.cutadapt.output.R2
    output: 
        R1="{sample}/deduped/{sample}_R1.fastq",
        R2="{sample}/deduped/{sample}_R2.fastq"
    shell: """
        czid-dedup -i {input.R1} -i {input.R2} -o {output.R1} -o {output.R2}
    """
