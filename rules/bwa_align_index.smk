rule bwa_align_index:
    input: rules.bwa_align.output
    output: "{sample}/aligned/{sample}.bwa.sorted.bam.bai"
    shell:"""
        samtools index {input}
    """