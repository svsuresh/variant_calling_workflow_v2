rule counts:
    input: 
        bams= "{sample}/aligned/{sample}.{aligners}.sorted.bam",
        reference=expand("{ref_fa}", ref_fa=config["ref_fa"]),

    output:
        counts_both="{sample}/counts/{sample}_{aligners}_both_strands.wig",
        counts_nostrand="{sample}/counts/{sample}_{aligners}_no_strand.wig",
        counts_all="{sample}/counts/{sample}_{aligners}_all.wig",

    shell:"""
        sh /Users/suresh/.local/lib/IGV_2.17.4/igvtools count -w 1 --bases --strands read {input.bams} {output.counts_both} {input.reference} && 
        sh /Users/suresh/.local/lib/IGV_2.17.4/igvtools count -w 1 --bases {input.bams} {output.counts_nostrand} {input.reference} && 
        sh /Users/suresh/.local/lib/IGV_2.17.4/igvtools count -w 1 {input.bams} {output.counts_all} {input.reference}
        """ 
