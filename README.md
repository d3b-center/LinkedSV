# Linked-Sv
This is d3b CWL implementation of https://github.com/WGLab/LinkedSV. It follows as closely as possible input params as the actual tool itself with minor deviations to fit the workflow environment.

## Tools

### Linked SV 
Location `./tools/linked_sv.cwl`
#### inputs:
```yaml
  output_basename: string # REQUIRED
  bam: {type: File, doc: "phased_possorted_bam.bam"} # REQUIRED
  cpus: {type: int?, doc: "number of cpus, default is 16"}
  ref: {type: File, secondaryFiles: [.fai], doc: "reference FASTA file"} # REQUIRED
  ref_version: {type: ['null', string], doc: "version of reference fasta file. Current supported versions are: hg19, b37, hg38"}
  detect_mode: {type: string, doc: "detection mode, accepted values are germline_mode, somatic_mode"} # REQUIRED
  input_type: {type: ['null', string], doc: "accepted values wgs, targeted"}
  gap_region_bed: {type: ['null', File], doc: "reference gap region in bed format"}
  black_region_bed: {type: ['null', File], doc: "black region in bed format"}
  target_region: {type: ['null', File], doc: "bed file of target regions (required if --targeted is specified)"}
  min_fragment_length: {type: ['null', int], doc: "minimal fragment length considered for SV calling"}
  min_reads_in_fragment: {type: ['null', int], doc: "minimal number of confidently mapped reads in one fragment"}
  min_supp_barcodes: {type: ['null', int], doc: "minimal number of shared barcodes between two SV breakpoints (default: 10)"}
  ap_distance_cut_off: {type: ['null', int], doc: "max distance between two reads in a HMW DNA molecule (default: automatically determined)"}
```
#### outputs:
```yaml
  results_tarball: # tar gzipped results folder named using output_basename
    type: File
    outputBinding:
      glob: '*.tar.gz'
```

Note only `output_basename`, `bam`, `ref` and `detect_mode` are required.

### Untar bam
Location: ./tools/ubuntu_untar_bam.cwl
Utility to extract the bam file from longranger output
#### inputs:
```yaml
  output_basename: string
  tar_gz: {type: File, doc: "tar gzipped outputs from X10 longranger"}
```

#### outputs:
```yaml
  extracted_bam:
    type: File
    outputBinding:
      glob: '*.bam'
```

## Workflow
### Linked SV Workflow
Location: ./workflows/linkd_sv_wf.cwl
This workflow ties together Untar bam utility with the linked sv tool.
#### inputs:
```yaml
inputs:
  output_basename: string # REQUIRED
  cpus: {type: int?, doc: "number of cpus, default is 16"}
  tar_gz: {type: File, doc: "tar gzipped outputs from X10 longranger"} # REQUIRED
  ref: {type: File, secondaryFiles: [.fai], doc: "reference FASTA file"} # REQUIRED
  ref_version: {type: ['null', string], doc: "version of reference fasta file. Current supported versions are: hg19, b37, hg38"}
  detect_mode: {type: string, doc: "detection mode, accepted values are germline_mode, somatic_mode"} # REQUIRED
  input_type: {type: ['null', string], doc: "accepted values wgs, targeted"}
  gap_region_bed: {type: ['null', File], doc: "reference gap region in bed format"}
  black_region_bed: {type: ['null', File], doc: "black region in bed format"}
  target_region: {type: ['null', File], doc: "bed file of target regions (required if --targeted is specified)"}
  min_fragment_length: {type: ['null', int], doc: "minimal fragment length considered for SV calling"}
  min_reads_in_fragment: {type: ['null', int], doc: "minimal number of confidently mapped reads in one fragment"}
  min_supp_barcodes: {type: ['null', int], doc: "minimal number of shared barcodes between two SV breakpoints (default: 10)"}
  ap_distance_cut_off: {type: ['null', int], doc: "max distance between two reads in a HMW DNA molecule (default: automatically determined)"}
```

#### outputs:
```yaml
  extracted_bam:
    type: File
    outputBinding:
      glob: '*.bam'
```
