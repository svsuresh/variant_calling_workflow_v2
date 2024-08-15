rule bowtie2_align:
    input:
        index=config["ref_fa"],
        R1=rules.cutadapt.output.R1,
        R2=rules.cutadapt.output.R2
    output:
        "{sample}/aligned/{sample}.bt2.sorted.bam"
    log:
        "{sample}/logs/aligned/{sample}_bt2.log"
    threads:
        4
    shell: """
	bowtie2 --fr --local -p {threads} -x {input.index} -1 {input.R1} -2 {input.R2} --rg-id 'SM:{wildcards.sample}' --rg 'SM:{wildcards.sample}' 2> {log} | samtools sort -@ {threads} -o {output} -
    """