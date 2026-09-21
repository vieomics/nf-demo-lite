/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
include { FASTQC } from '../modules/nf-core/fastqc/main'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    E2E lite variant: only the FASTQC process runs, so platform end-to-end tests
    exercise the real nextflow + apptainer runner path without paying for the
    full demo pipeline.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow DEMO {
    take:
    ch_samplesheet // channel: samplesheet read in from --input
    multiqc_config // unused in the lite variant, kept for a stable call signature
    multiqc_logo // unused in the lite variant
    multiqc_methods_description // unused in the lite variant
    outdir // unused in the lite variant

    main:

    def ch_versions = channel.empty()

    //
    // MODULE: Run FASTQC
    //
    FASTQC(
        ch_samplesheet
    )
    ch_versions = ch_versions.mix(FASTQC.out.zip.map { _meta, file -> file })

    emit:
    versions = ch_versions // channel: [ path(versions.yml) ]
}
