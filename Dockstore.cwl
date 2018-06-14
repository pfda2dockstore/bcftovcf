baseCommand: []
class: CommandLineTool
cwlVersion: v1.0
id: bcftovcf
inputs:
  bcf_input:
    doc: File to convert to VCF
    inputBinding:
      position: 1
      prefix: --bcf_input
    type: File
  bgzip_compress:
    default: true
    doc: If selected, VCF output will be bgzip compressed and indexed
    inputBinding:
      position: 2
      prefix: --bgzip_compress
    type: boolean
label: Convert BCF files to VCF
outputs:
  vcf_output:
    doc: Resulting VCF output, same basename as input
    outputBinding:
      glob: vcf_output/*
    type: File
  vcf_output_index:
    doc: Index for VCF output. Index for input not required
    outputBinding:
      glob: vcf_output_index/*
    type: File
requirements:
- class: DockerRequirement
  dockerOutputDirectory: /data/out
  dockerPull: pfda2dockstore/bcftovcf:8
s:author:
  class: s:Person
  s:name: Mark Wright
