# Hiccup-cli

Command line tool / Emacs plugin to convert HTML to Hiccup syntax.

## Installation

### Install hiccup-cli

Download hiccup-cli from the [releases page](https://github.com/kwrooijen/hiccup-cli/releases).

### Emacs 

The Emacs package can be installed through [melpa](https://melpa.org/):

```
M-x package-install hiccup-cli
```

## Usage

| Function                    |
|-----------------------------|
| hiccup-cli-paste-as-hiccup  |
| hiccup-cli-region-as-hiccup |
| hiccup-cli-yank-as-hiccup   |


Use `hiccup-cli--region-as-hiccup` to transform the selected HTML to Hiccup syntax

![hiccup region replace](https://raw.githubusercontent.com/kwrooijen/hiccup-cli/master/assets/hiccup-region-replace.gif)


Use `hiccup-cli--yank-as-hiccup` or `hiccup-cli--paste-as-hiccup` to paste HTML as Hiccup from either your kill-ring or clipboard

![hiccup yank](https://raw.githubusercontent.com/kwrooijen/hiccup-cli/master/assets/hiccup-yank.gif)


## Development

### Building hiccup-cli

Make sure you have GraalVM installed.

```bash
git clone git@github.com:kwrooije/hiccup-cli
cd hiccup-cli
lein native-image
sudo cp target/hiccup-cli-0.1.0-SNAPSHOT /usr/local/bin/hiccup-cli
```


## Author / License

Released under the [MIT License] by [Kevin William van Rooijen].

[Kevin William van Rooijen]: https://twitter.com/kwrooijen

[MIT License]: https://github.com/kwrooijen/gungnir/blob/master/LICENSE
