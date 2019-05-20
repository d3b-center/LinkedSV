cwlVersion: v1.0
class: Workflow
id: linked_sv_wf
requirements:
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  output_basename: string
  cpus: {type: int?, doc: "number of cpus, default is 16"}
  tar_gz: {type: File, doc: "tar gzipped outputs from X10 longranger"}
  ref: {type: File, secondaryFiles: [.fai], doc: "reference FASTA file"}
  ref_version: {type: ['null', string], doc: "version of reference fasta file. Current supported versions are: hg19, b37, hg38"}
  detect_mode: {type: string, doc: "detection mode, accepted values are germline_mode, somatic_mode"}
  input_type: {type: ['null', string], doc: "accepted values wgs, targeted"}
  gap_region_bed: {type: ['null', File], doc: "reference gap region in bed format"}
  black_region_bed: {type: ['null', File], doc: "black region in bed format"}
  target_region: {type: ['null', File], doc: "bed file of target regions (required if --targeted is specified)"}
  min_fragment_length: {type: ['null', int], doc: "minimal fragment length considered for SV calling"}
  min_reads_in_fragment: {type: ['null', int], doc: "minimal number of confidently mapped reads in one fragment"}
  min_supp_barcodes: {type: ['null', int], doc: "minimal number of shared barcodes between two SV breakpoints (default: 10)"}
  ap_distance_cut_off: {type: ['null', int], doc: "max distance between two reads in a HMW DNA molecule (default: automatically determined)"}

outputs:
  results_tarball: {type: File, outputSource: linked_sv/results_tarball}

steps:
  untar_bam:
    run: ../tools/ubuntu_untar_bam.cwl
    in:
      output_basename: output_basename
      tar_gz: tar_gz
    out: [extracted_bam]
  linked_sv:
    run: ../tools/linked_sv.cwl
    in:
      output_basename: output_basename
      cpus: cpus
      bam: untar_bam/extracted_bam
      ref: ref
      ref_version: ref_version
      detect_mode: detect_mode
      input_type: input_type
      gap_region_bed: gap_region_bed
      black_region_bed: black_region_bed
      target_region: target_region
      min_fragment_length: min_fragment_length
      min_reads_in_fragment: min_reads_in_fragment
      min_supp_barcodes: min_supp_barcodes
      ap_distance_cut_off: ap_distance_cut_off
    out: [results_tarball]

$namespaces:
  sbg: https://sevenbridges.com