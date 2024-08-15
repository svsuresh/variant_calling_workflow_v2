rule before_fastqc:
    input:
        r1= rules.deinterlace.output.R1, 
        r2= rules.deinterlace.output.R2,
    output:
        "{sample}/processed_reads/{sample}_R1_fastqc.html",
        "{sample}/processed_reads/{sample}_R2_fastqc.html",
        "{sample}/processed_reads/{sample}_R1_fastqc.zip",
        "{sample}/processed_reads/{sample}_R2_fastqc.zip"
    params:
        extra = "-q"
    threads: 4
    shell: """
        fastqc -t {threads} --nogroup {params.extra} -f fastq {input.r1} 
        fastqc -t {threads} --nogroup {params.extra} -f fastq {input.r2} 
    """


rule after_fastqc:
    input:
        r1= rules.cutadapt.output.R1, 
        r2= rules.cutadapt.output.R2,
    output:
        "{sample}/trimmed/{sample}_R1_fastqc.html",
        "{sample}/trimmed/{sample}_R2_fastqc.html",
        "{sample}/trimmed/{sample}_R1_fastqc.zip",
        "{sample}/trimmed/{sample}_R2_fastqc.zip"
    params:
        extra = "-q"
    threads: 6
    shell: """
        fastqc -t {threads} --nogroup {params.extra} -f fastq {input.r1} 
        fastqc -t {threads} --nogroup {params.extra} -f fastq {input.r2}
    """


# rule after_fastqc:
#     input: 
#     output: 
#     shell: 
