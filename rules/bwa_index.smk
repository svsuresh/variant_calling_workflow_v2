rule bwa_index:
    input: config['ref_fa'],
    output:
        idx=multiext("{input}", ".amb", ".ann", ".bwt", ".pac", ".sa"),
    
    shell: '''
            bwa index {input}
        ''' 
