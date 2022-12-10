#!/bin/bash

# prepare next release version
mvn build-helper:parse-version versions:set \
  -DskipTests \
  -DnewVersion=\${parsedVersion.nextMajorVersion}.\0.\0-SNAPSHOT \
  versions:commit

RELEASE_VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)
TOKENS=(${RELEASE_VERSION//./ })

# add a new SNAPSHOT version section inside CHANGELOG.md
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' -e "s/# Changelog.*/& \n\n## ${TOKENS[0]}.${TOKENS[1]} Unreleased/" CHANGELOG.md
else
  sed -i -e "s/# Changelog.*/& \n\n## ${TOKENS[0]}.${TOKENS[1]} Unreleased/" CHANGELOG.md
fi

# commit and push new development version
git commit -am "prepare next minor development version" --
