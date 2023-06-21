#!/bin/sh -e
export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

TEMP_PATH="$(mktemp -d)"
PATH="${TEMP_PATH}:$PATH"

echo '::group::🐶 Installing reviewdog ... https://github.com/reviewdog/reviewdog'
curl -sfL https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b "${TEMP_PATH}" 2>&1
echo '::endgroup::'

if [ "${INPUT_USE_BUNDLER}" = "true" ]; then
  echo '::group:: Installing steep via bundler'
  bundle install
  echo '::endgroup::'
fi

if [ "${INPUT_USE_BUNDLER}" = "false" ]; then
  BUNDLE_EXEC=""
else
  BUNDLE_EXEC="bundle exec "
fi

if [ "${INPUT_USE_BUNDLER}" = "true" ]; then
  echo '::group:: Installing rbs collection'
  ${BUNDLE_EXEC}rbs collection install --frozen
  echo '::endgroup::'
fi

echo '::group:: Running steep with reviewdog 🐶 ...'
${BUNDLE_EXEC}steep check ${INPUT_STEEP_OPTIONS} | ${BUNDLE_EXEC}ruby ${GITHUB_ACTION_PATH}/rdjson_filter.rb \
  | reviewdog \
      -f=rdjson \
      -reporter="${INPUT_REPORTER}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -level="${INPUT_LEVEL}"
echo '::endgroup::'
