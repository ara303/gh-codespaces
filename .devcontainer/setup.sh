#!/bin/bash

# Run the post-create script inside the container
/usr/local/bin/post-create.sh

# Keep container running
tail -f /dev/null