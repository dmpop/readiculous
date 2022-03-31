# Readiculous


Readiculuos is a Bash shell script that transform web pages into readable EPUB files.


# Dependencies

Readiculuos requires the [Pandoc](https://pandoc.org), [ImageMagick](https://imagemagick.org), [jq](https://stedolan.github.io/jq/), `wget`, and [Go-Readability](https://github.com/go-shiori/go-readability) tools. 

# Installation and usage

1. Install Pandoc, ImageMagick, jq, and wget. To do this on Ubuntu and Linux Mint, run the `sudo apt install pandoc imagemagick jq wget` command.
2. Readiculous comes bundled with the x86_64 precompiled binary of Go-Readability. For other platform, you have to compile it yourself.
3. Clone the project's Git repository: `git clone https://github.com/dmpop/readiculuos`

## Usage

    readiculuos.sh -u <URL> -d <dir>

Example: `./readiculuos.sh -u https://aeon.co/essays/forget-plato-aristotle-and-the-stoics-try-being-epicurean -d "Philosophy"`

## Problems?

Please report bugs and issues in the [Issues](https://github.com/dmpop/readiculuos/issues) section.

## Contribute

If you've found a bug or have a suggestion for improvement, open an issue in the [Issues](https://github.com/dmpop/readiculuos/issues) section.

To add a new feature or fix issues yourself, follow the following steps.

1. Fork the project's repository.
2. Create a feature branch using the `git checkout -b new-feature` command.
3. Add your new feature or fix bugs and run the `git commit -am 'Add a new feature'` command to commit changes.
4. Push changes using the `git push origin new-feature` command.
5. Submit a pull request.

## Author

Dmitri Popov [dmpop@linux.com](mailto:dmpop@linux.com)

## License

The [GNU General Public License version 3](http://www.gnu.org/licenses/gpl-3.0.en.html)

