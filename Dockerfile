# Generated by precisionFDA exporter (v1.0.3) on 2018-06-14 02:15:30 +0000
# The asset download links in this file are valid only for 24h.

# Exported app: bcftovcf, revision: 8, authored by: mark.wright
# https://precision.fda.gov/apps/app-BzyXvQ00gXF11jZ3p9VVKQQF

# For more information please consult the app export section in the precisionFDA docs

# Start with Ubuntu 14.04 base image
FROM ubuntu:14.04

# Install default precisionFDA Ubuntu packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
	aria2 \
	byobu \
	cmake \
	cpanminus \
	curl \
	dstat \
	g++ \
	git \
	htop \
	libboost-all-dev \
	libcurl4-openssl-dev \
	libncurses5-dev \
	make \
	perl \
	pypy \
	python-dev \
	python-pip \
	r-base \
	ruby1.9.3 \
	wget \
	xz-utils

# Install default precisionFDA python packages
RUN pip install \
	requests==2.5.0 \
	futures==2.2.0 \
	setuptools==10.2

# Add DNAnexus repo to apt-get
RUN /bin/bash -c "echo 'deb http://dnanexus-apt-prod.s3.amazonaws.com/ubuntu trusty/amd64/' > /etc/apt/sources.list.d/dnanexus.list"
RUN /bin/bash -c "echo 'deb http://dnanexus-apt-prod.s3.amazonaws.com/ubuntu trusty/all/' >> /etc/apt/sources.list.d/dnanexus.list"
RUN curl https://wiki.dnanexus.com/images/files/ubuntu-signing-key.gpg | apt-key add -

# Update apt-get
RUN DEBIAN_FRONTEND=noninteractive apt-get update

# Download app assets
RUN curl https://dl.dnanex.us/F/D/9V4P7x85KYPXB720ZGf3gVBF24vbvgP5Fv1PVgQ7/bcftools-1.3.tar.gz | tar xzf - -C / --no-same-owner --no-same-permissions

# Download helper executables
RUN curl https://dl.dnanex.us/F/D/0K8P4zZvjq9vQ6qV0b6QqY1z2zvfZ0QKQP4gjBXp/emit-1.0.tar.gz | tar xzf - -C /usr/bin/ --no-same-owner --no-same-permissions
RUN curl https://dl.dnanex.us/F/D/bByKQvv1F7BFP3xXPgYXZPZjkXj9V684VPz8gb7p/run-1.2.tar.gz | tar xzf - -C /usr/bin/ --no-same-owner --no-same-permissions

# Write app spec and code to root folder
RUN ["/bin/bash","-c","echo -E \\{\\\"spec\\\":\\{\\\"input_spec\\\":\\[\\{\\\"name\\\":\\\"bcf_input\\\",\\\"class\\\":\\\"file\\\",\\\"optional\\\":false,\\\"label\\\":\\\"BCF\\ input\\ file\\\",\\\"help\\\":\\\"File\\ to\\ convert\\ to\\ VCF\\\"\\},\\{\\\"name\\\":\\\"bgzip_compress\\\",\\\"class\\\":\\\"boolean\\\",\\\"optional\\\":false,\\\"label\\\":\\\"compress\\ and\\ index\\ output\\?\\\",\\\"help\\\":\\\"If\\ selected,\\ VCF\\ output\\ will\\ be\\ bgzip\\ compressed\\ and\\ indexed\\\",\\\"default\\\":true\\}\\],\\\"output_spec\\\":\\[\\{\\\"name\\\":\\\"vcf_output\\\",\\\"class\\\":\\\"file\\\",\\\"optional\\\":false,\\\"label\\\":\\\"VCF\\ output\\ file\\\",\\\"help\\\":\\\"Resulting\\ VCF\\ output,\\ same\\ basename\\ as\\ input\\\"\\},\\{\\\"name\\\":\\\"vcf_output_index\\\",\\\"class\\\":\\\"file\\\",\\\"optional\\\":true,\\\"label\\\":\\\"CSI\\ Index\\ for\\ VCF\\ output\\ file\\\",\\\"help\\\":\\\"Index\\ for\\ VCF\\ output.\\ Index\\ for\\ input\\ not\\ required\\\"\\}\\],\\\"internet_access\\\":false,\\\"instance_type\\\":\\\"baseline-2\\\"\\},\\\"assets\\\":\\[\\\"file-BpBpxqQ0qVb1bYP12Q804g81\\\"\\],\\\"packages\\\":\\[\\]\\} \u003e /spec.json"]
RUN ["/bin/bash","-c","echo -E \\{\\\"code\\\":\\\"mkdir\\ -p\\ /work/out\\\\nTMP\\=\\`basename\\ \\$bcf_input_path\\ .gz\\`\\\\nOUTPUT_BASENAME\\=/work/out/\\`basename\\ \\$TMP\\ .bcf\\`\\\\n\\\\nif\\ \\[\\ \\\\\\\"\\$bgzip_compress\\\\\\\"\\ \\=\\=\\ \\\\\\\"true\\\\\\\"\\ \\]\\;\\ then\\\\n\\ \\ bcftools\\ view\\ --output-type\\ z\\ \\$bcf_input_path\\ \\\\u003e\\ \\$OUTPUT_BASENAME.vcf.gz\\\\n\\ \\ bcftools\\ index\\ --csi\\ \\$OUTPUT_BASENAME.vcf.gz\\\\n\\ \\ emit\\ vcf_output\\ \\$OUTPUT_BASENAME.vcf.gz\\\\n\\ \\ emit\\ vcf_output_index\\ \\$OUTPUT_BASENAME.vcf.gz.csi\\\\nelse\\\\n\\ \\ bcftools\\ view\\ \\$bcf_input_path\\ \\\\u003e\\ \\$OUTPUT_BASENAME.vcf\\\\n\\ \\ emit\\ vcf_output\\ \\$OUTPUT_BASENAME.vcf\\\\nfi\\\\n\\\"\\} | python -c 'import sys,json; print json.load(sys.stdin)[\"code\"]' \u003e /script.sh"]

# Create directory /work and set it to $HOME and CWD
RUN mkdir -p /work
ENV HOME="/work"
WORKDIR /work

# Set entry point to container
ENTRYPOINT ["/usr/bin/run"]

VOLUME /data
VOLUME /work