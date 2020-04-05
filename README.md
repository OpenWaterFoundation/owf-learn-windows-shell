# owf-learn-linux-shell #

This repository contains the [Open Water Foundation (OWF)](http://openwaterfoundation.org/) Windows shell learning resources,
which provide guidance for creating and using Windows shell and batch files.
The documentation is written for the layperson in order to encourage effective use of Widows shell and  batch files.

See the deployed [OWF / Learn Windows Shell](http://learn.openwaterfoundation.org/owf-learn-windows-shell/) documentation.

## Repository Contents ##

The repository contains the following:

```text
.github/              Files specific to GitHub such as issue template.
.gitattributes        Typical Git configuration file.
.gitignore            Typical Git configuration file.
README.md             This file.
build-util/           Useful scripts to view, build, and deploy documentation.
mkdocs-project/       Typical MkDocs project for this documentation.
  mkdocs.yml          MkDocs configuration file for website.
  docs/               Folder containing source Markdown and other files for website.
  site/               Folder created by MkDocs containing the static website - ignored using .gitignore.

```

## Development Environment ##

The development environment for contributing to this project requires installation of Python, MkDocs, and Material MkDocs theme.
Python 3 has been used for development.
See the [`OWF Learn MkDocs`](http://learn.openwaterfoundation.org/owf-learn-mkdocs/)
documentation for information about installing these tools.

This documentation has been prepared using Windows 10, but should apply to other Windows versions.
Git Bash is used to run the MkDocs documentation server.

## Editing and Viewing Content ##

If the development environment is properly configured, edit and view content as follows:

1. Edit content in the `mkdocs-project/docs` folder and update `mkdocs-project/mkdocs.yml` as appropriate.
2. Run the `build-util/run-mkdocs-serve-8000.sh` script (Git Bash, Linux) or equivalent.
3. View content in a web browser using URL `http://localhost:8000`.

## License ##

The OWF Learn Windows Shell website content and examples are licensed under the
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-nc-sa/4.0).

## Contributing ##

Contribute to the documentation as follows:

1. Use GitHub repository issues to report minor issues.
2. Use GitHub pull requests.

## Style Guide ##

The following are general style guide recommendations for this documentation,
with the goal of keeping formatting simple in favor of focusing on useful content:

* Use the Material MkDocs theme - it looks nice, provides good navigation features, and enables search.
* Follow MkDocs Markdown standards - use extensions beyond basic Markdown when useful.
* Show files and program names as `code (tick-surrounded)` formatting.
* Where a source file can be linked to in GitHub, provide a link so that the most current file can be viewed.
* Use triple-tick formatting for code blocks, with language specifier.
* Use ***bold italics*** when referencing UI components such as menus.
* Use slashes to indicate ***Menu / SubMenu***.
* Place images in a folder with the same name as the content file and include `-images` at the end of the folder name.
* Minimize the use of inlined HTML, but use it where Markdown formatting is limited.
* Although the Material them provides site and page navigation sidebars,
provide in-line table of contents on pages, where appropriate, to facilitate review of page content.

## Maintainers ##

This repository is maintained by the [Open Water Foundation](http://openwaterfoundation.org/).
