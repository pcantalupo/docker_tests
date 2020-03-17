#!/bin/bash

docker run -it --rm -v$(pwd)/results:/results onion2 /onion_pipeline.sh $@
