#!/bin/bash
cd ..

# prepare next release version
mvn build-helper:parse-version versions:set \
  -DskipTests \
  -DnewVersion=\${parsedVersion.majorVersion}.\${parsedVersion.minorVersion}.\${parsedVersion.incrementalVersion} \
  versions:commit

RELEASE_VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)
TOKENS=(${RELEASE_VERSION//./ })
CURRENT_DATE=$(date +"%Y-%m-%d")

# add a new patch version section inside CHANGELOG.md
sed -i '' "s/.*## ${TOKENS[0]}.${TOKENS[1]} Unreleased.*/& \n\n## ${RELEASE_VERSION} - ${CURRENT_DATE}/" CHANGELOG.md

# commit new version
git add -A -- .
git commit -m "version v${RELEASE_VERSION}" --

# create a tag for the release
git tag -a "v${RELEASE_VERSION}" -m "" --

# prepare next development version
mvn build-helper:parse-version versions:set \
  -DskipTests \
  -DnewVersion=\${parsedVersion.majorVersion}.\${parsedVersion.minorVersion}.\${parsedVersion.nextIncrementalVersion}-SNAPSHOT \
  versions:commit

# commit and push new development version
git add -A -- .
git commit -m "prepare next development version" --
