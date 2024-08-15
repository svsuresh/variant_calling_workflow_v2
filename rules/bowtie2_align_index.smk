rule bt2_align_index:
    input: rules.bowtie2_align.output
    output: "{sample}/aligned/{sample}.bt2.sorted.bam.bai"
    shell:"""
        samtools index {input}
    """
