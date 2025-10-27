# ITK clang-format linter action

This GitHub Action checks consistent of the pushed source code with ITK's Coding Style as
specified by its .clang-format style configuration file.

## Usage

Add the following configuration to your project's repository at, e.g.,  *.github/workflows/clang-format-linter.yml*.

```yml
on: [push,pull_request]

jobs:
  lint:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v4
    - uses: InsightSoftwareConsortium/ITKClangFormatLinterAction@main
```

The linter check will fail on a pull request if style changes are required.

## See Also

When used with
[ITKApplyClangFormatAction](https://github.com/InsightSoftwareConsortium/ITKApplyClangFormatAction),
a custom error can be provided,

```yml
    - uses: InsightSoftwareConsortium/ITKClangFormatLinterAction@main
      with:
        error-message: 'Code is inconsistent with ITK Coding Style. Add the *action:ApplyClangFormat* PR label to correct.'
```
