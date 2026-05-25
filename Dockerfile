# Set the base image to micromamba
FROM mambaorg/micromamba:latest

# File Author / Maintainer
LABEL org.opencontainers.image.authors="ManuelTgn"

# Set the variables for version control during installation
ARG crisprhawk_version=0.2.2
ARG crispritz_version=2.6.6

# set the shell to bash
ENV SHELL bash
# set user as root
USER root

# update packages of the docker image
RUN apt-get update && \
    apt-get install -y \
        gsl-bin \
        libgsl0-dev \
        libgomp1 && \
    apt-get clean

# -----------------------------------------------------------------------------
# install CRISPR-HAWK in base environment
# -----------------------------------------------------------------------------
RUN micromamba install -y -n base \
    -c conda-forge \
    -c bioconda \
    python=3.8 \
    crisprhawk=${crisprhawk_version} && \
    micromamba clean --all --yes

# -----------------------------------------------------------------------------
# create dedicated CRISPRitz environment
# -----------------------------------------------------------------------------
RUN micromamba create -y -n crisprhawk-crispritz \
    -c conda-forge \
    -c bioconda \
    python=3.8 \
    crispritz=${crispritz_version} && \
    micromamba clean --all --yes

# Needed for micromamba activation
ARG MAMBA_DOCKERFILE_ACTIVATE=1

# Default command
CMD ["/bin/bash"]