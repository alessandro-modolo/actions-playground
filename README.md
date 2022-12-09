# Actions playground
Playground project to define a CI/CD pipeline using the GitHub actions.

## How it works
This is a spring-boot application that uses maven as a build tool.
The pom version follows the [semantic versioning](https://semver.org) format; snapshots have this format `1.0.0-SNAPSHOT` and stable versions are composed of
the canonical three numbers like `1.0.0`.

The `CHANGELOG.md` file follows the [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format. All the changing stuff must be reported inside the
`Unreleased` section.

Once you are ready to create a release, you have to:
1. open a terminal and move into the project root
2. run this command: `.devops/prepare-release.sh` (be sure if that script has execute grants)

The script will:
1. bump to the next release version
2. convert the `CHANGELOG.md`  Unreleased section with the reference to the next stable release
3. commit changes and create a version's tag
4. bump to the next development version
5. add the next Unreleased section at the beginning of the `CHANGELOG.md`
6. commit changes
