#!/bin/sh

# Run the CIFuzz run_fuzzers container the way the GitHub action does, but
# from a plain step, so that a monitor can wrap it and stream into the job log.

set -e

IMAGE="${CIFUZZ_IMAGE:-cifuzz-run-fuzzers}"
CONTAINER="${CI_MONITOR_CONTAINER:-cifuzz-run-fuzzers}"
EVENT_DIR="$(dirname "${GITHUB_EVENT_PATH}")"
EVENT_FILE="$(basename "${GITHUB_EVENT_PATH}")"

exec docker run --name "${CONTAINER}" --rm --workdir /github/workspace \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "${GITHUB_WORKSPACE}":/github/workspace \
  -v "${EVENT_DIR}":/github/workflow \
  -e GITHUB_WORKSPACE=/github/workspace \
  -e GITHUB_EVENT_PATH="/github/workflow/${EVENT_FILE}" \
  -e GITHUB_EVENT_NAME -e GITHUB_SHA -e GITHUB_REF -e GITHUB_BASE_REF \
  -e GITHUB_HEAD_REF -e GITHUB_REPOSITORY -e GITHUB_SERVER_URL \
  -e GITHUB_ACTOR -e GITHUB_ACTIONS=true -e CI=true \
  -e OSS_FUZZ_PROJECT_NAME -e LANGUAGE -e FUZZ_SECONDS -e DRY_RUN \
  -e SANITIZER -e MODE -e LOW_DISK_SPACE -e REPORT_UNREPRODUCIBLE_CRASHES \
  -e MINIMIZE_CRASHES -e CIFUZZ_DEBUG -e CFL_PLATFORM -e PARALLEL_FUZZING \
  -e OUTPUT_SARIF -e REPORT_TIMEOUTS -e REPORT_OOMS -e OF_SANITIZER \
  "${IMAGE}"
