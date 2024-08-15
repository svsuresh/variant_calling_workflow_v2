rule bamstats:
    input: 
        "{sample}/aligned/{sample}.{aligner}.sorted.bam",
    output:
         "{sample}/aligned/bamstats/{sample}.{aligner}.flagstats",
    shell: """
    samtools flagstat {input} > {output}
    """