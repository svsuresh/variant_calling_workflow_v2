rule combine_counts:
    input: 
        "{sample}/counts/{sample}_bwa_all.wig",
        "{sample}/counts/{sample}_bt2_all.wig",
        reference=expand("{ref_fa}", ref_fa=config["ref_fa"]),
    output:
        "{sample}/counts/{sample}.xlsx" 

    shell: """
        Rscript scripts/counts.R {wildcards.sample} {input.reference}
    """ 
