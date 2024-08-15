rule bwa_align:
    input:
        index=config["ref_fa"],
        R1=rules.dedup.output.R1,
        R2=rules.dedup.output.R2
    output:
        "{sample}/aligned/{sample}.bwa.sorted.bam" 
    
    log:
        "{sample}/logs/aligned/{sample}_bwa.log"

    params:
        extra=r"-R '@RG\tID:{sample}\tSM:{sample}'"

    threads:
        4
        
    shell:"""
        bwa mem -t {threads} {params.extra} {input.index} {input.R1} {input.R2} | samtools sort -@ {threads} -o {output} -
        """
