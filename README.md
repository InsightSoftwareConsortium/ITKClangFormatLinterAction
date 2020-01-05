# ITK clang-format linter action

This GitHub Action checks consistent of the pushed source code with ITK's Coding Style as
specified by its .clang-format style configuration file.

## Usage

Add the following configuration to your project's repository at, e.g.,  *.github/workflows/clang-format-linter.yml*.

```yml
on: [push]

jobs:
  lint:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v1
      with:
        fetch-depth: 1
    - uses: InsightSoftwareConsortium/ITKClangFormatLinterAction@master
```

The linter check will fail on a pull request if style changes are required.
