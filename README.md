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

Only files whose `hooks.style` Git attribute includes `clangformat` are checked, so the repository
needs a *.gitattributes* file that marks its C and C++ sources, as ITK's does:

```
[attr]our-c-style  whitespace=tab-in-indent,no-lf-at-eof  hooks.style=KWStyle,clangformat

*.c    our-c-style
*.h    our-c-style
*.cxx  our-c-style
*.hxx  our-c-style
```

The check fails if no tracked file has this attribute, since there would be nothing to check.

## See Also

When used with
[ITKApplyClangFormatAction](https://github.com/InsightSoftwareConsortium/ITKApplyClangFormatAction),
a custom error can be provided,

```yml
    - uses: InsightSoftwareConsortium/ITKClangFormatLinterAction@main
      with:
        error-message: 'Code is inconsistent with ITK Coding Style. Add the *action:ApplyClangFormat* PR label to correct.'
```
