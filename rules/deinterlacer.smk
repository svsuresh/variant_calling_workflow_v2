rule deinterlace:
    input:
        config['source_dir'] + "/{sample}.fastq",
    output:
        R1='{sample}/processed_reads/{sample}_R1.fastq',
        R2='{sample}/processed_reads/{sample}_R2.fastq'    
    
    shell: '''
        seqtk seq -1 {input} > {output.R1}
        seqtk seq -2 {input} > {output.R2}
    '''
