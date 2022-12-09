#!/bin/bash

# prepare next release version
mvn build-helper:parse-version versions:set \
  -DskipTests \
  -DnewVersion=\${parsedVersion.majorVersion}.\${parsedVersion.minorVersion}.\${parsedVersion.incrementalVersion} \
  versions:commit

RELEASE_VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)
TOKENS=(${RELEASE_VERSION//./ })
CURRENT_DATE=$(date +"%Y-%m-%d")

# add a new patch version section inside CHANGELOG.md
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' -e "s/.*## ${TOKENS[0]}.${TOKENS[1]} Unreleased.*/## [${RELEASE_VERSION}] - ${CURRENT_DATE}/" CHANGELOG.md
else
  sed -i -e "s/.*## ${TOKENS[0]}.${TOKENS[1]} Unreleased.*/## [${RELEASE_VERSION}] - ${CURRENT_DATE}/" CHANGELOG.md
fi

printf "[%s]: https://github.com/alessandro-modolo/releases/tag/v%s\n" ${RELEASE_VERSION} ${RELEASE_VERSION} >> CHANGELOG.md

# commit new version
git commit -am "version v${RELEASE_VERSION}" --

# create a tag for the release
git tag -a "v${RELEASE_VERSION}" -m "" --

# prepare next development version
mvn build-helper:parse-version versions:set \
  -DskipTests \
  -DnewVersion=\${parsedVersion.majorVersion}.\${parsedVersion.minorVersion}.\${parsedVersion.nextIncrementalVersion}-SNAPSHOT \
  versions:commit

RELEASE_VERSION=${{ env.release_name }}
TOKENS=(${RELEASE_VERSION//./ })

# add a new SNAPSHOT version section inside CHANGELOG.md
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' -e "s/# Changelog.*/& \n\n## ${TOKENS[0]}.${TOKENS[1]} Unreleased/" CHANGELOG.md
else
  sed -i -e "s/# Changelog.*/& \n\n## ${TOKENS[0]}.${TOKENS[1]} Unreleased/" CHANGELOG.md
fi

# commit and push new development version
git commit -am "prepare next development version" --

echo "Release ${RELEASE_VERSION} has been prepared. Review git log before push commits and tag"
