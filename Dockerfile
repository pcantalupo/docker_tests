FROM ubuntu

# Cutadapt
# biocontainser RUN copmmand failed
# pegi3s:
RUN apt-get -qq update && apt-get -y upgrade && \
	apt-get install -y python3-pip python3-dev build-essential
RUN pip3 install --upgrade pip==9.0.1 && \
	pip3 install --upgrade virtualenv
RUN pip3 install --user --upgrade cutadapt==1.16 && \
	ln -s /root/.local/bin/cutadapt /usr/bin/

# Fastqc
# biocontainer RUN command probably wouldn't work
# pegi3s
RUN apt-get update && apt-get install -y software-properties-common

RUN apt-get update && \
	apt-get install -y openjdk-8-jre && \
	rm -rf /var/lib/apt/lists/*

RUN JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

RUN apt-get -qq update && apt-get -y upgrade && \
	apt install -y wget libfindbin-libs-perl software-properties-common unzip

RUN wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.7.zip -O /tmp/fastqc.zip && \ 
    unzip /tmp/fastqc.zip -d /opt/ && \
    rm /tmp/fastqc.zip && \
    chmod 777 /opt/FastQC/fastqc

RUN PATH="/opt/FastQC/:${PATH}"


# Abyss
# ok using Biocontainewrs RUN command
RUN apt-get update && apt-get install -y abyss && apt-get clean && apt-get purge && rm -rf /var/lib/apt/lists/* /tmp/*


# Set environment variables
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
ENV PATH "/opt/FastQC/:${PATH}"

COPY test-data.tar.gz .
RUN tar xvzf test-data.tar.gz

COPY scripts/onion_pipeline.sh .

ENTRYPOINT ["/onion_pipeline.sh"]
