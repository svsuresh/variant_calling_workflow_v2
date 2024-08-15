rule bt2_variant_calling:
    input: 
        index=config["ref_fa"],
        bam=rules.bowtie2_align.output
    output:
        "{sample}/variant_calling/{sample}.bt2.vcf"  
    log:
        "{sample}/logs/variant_calling/{sample}_bt2.log",
    shell: """
        bcftools mpileup -Q 30 -I -Ou -d 40000 -f {input.index} {input.bam} | bcftools call -m -Ov -o {output}
    """ 