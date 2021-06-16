#!/bin/bash
set -o nounset
set -o errexit

/usr/local/buildkit/bin/buildkitd --oci-worker=false --containerd-worker=true &
