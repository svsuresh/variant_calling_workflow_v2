rule bwa_variant_calling:
    input: 
        index=config["ref_fa"],
        bam=rules.bwa_align.output
    output:
        "{sample}/variant_calling/{sample}.bwa.vcf"
    log:
        "{sample}/logs/variant_calling/{sample}_bwa.log",
    shell: """
        bcftools mpileup -Q 30 -I -Ou -d 40000 -f {input.index} {input.bam} | bcftools call -m -Ov -o {output} 
    """ 