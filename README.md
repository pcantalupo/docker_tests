# docker_tests

## Run Onion by doing the following

```
docker build -t onion .
onion.sh
```

This will build a docker image called `onion`. Then the `onion.sh` script
is a wrapper around `docker run` which runs the `onion` image.  In the
container, cutadapt, fastqc and abyss are installed as well as the
`scripts/onion_pipeline.sh` script.  The results are copied from the
container to a folder called `results` in the current working directory.

You can add rudimentary command line options like so `onion.sh 20 10`. This will change default cutadapt min length to 20 and min qual to 10.

You can test this on [Play-with-Docker](https://labs.play-with-docker.com/). It will take about 5 minutes to build the image.


## Run the Cutadapt -> Fastqc -> Abyss pipeline

`./docker_run_cutadapt_test.sh && ./docker_run_fastqc_test.sh 0.11.7 && ./docker_run_abyss_test.sh 2.0.2-3`


