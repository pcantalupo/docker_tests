#!/bin/bash

docker run -it --rm -v$(pwd)/results:/results onion $@
