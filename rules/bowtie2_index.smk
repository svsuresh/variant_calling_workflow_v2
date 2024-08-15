rule bowtie2_index:
    input: config['ref_fa'],
    output:
        idx=multiext("{input}", ".1.bt2", ".rev.1.bt2"),
    shell: '''
            bowtie2-build {input} {input}
        ''' 
