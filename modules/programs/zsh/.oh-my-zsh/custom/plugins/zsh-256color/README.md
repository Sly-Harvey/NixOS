# 256color ZSH Plugin

This ZSH plugin enhances the terminal environment with 256 colors. It looks at
the chosen `TERM` environment variable and sees if there is respective
(n-)curses' termcap/terminfo descriptors for 256 colors available. The result
is a multicolor terminal, if available.

## Plugin Installation

### Antigen

If you use [Antigen](http://antigen.sharats.me/ "Antigen plugin manager for ZSH"),
add the following line to your plugins list:

`antigen bundle chrissicool/zsh-256color`

### Oh My Zsh

If you use [Oh-My-Zsh](https://github.com/robbyrussell/oh-my-zsh "OMZ manager for ZSH"),
add `zsh-256color` to your `plugins` list and clone this repository to your
`$ZSH_CUSTOM/plugins` directory:

`$ ( cd $ZSH_CUSTOM/plugins && git clone https://github.com/chrissicool/zsh-256color )`

### Zgen

If you're using [Zgen](https://github.com/tarjoilija/zgen), add

`zgen load chrissicool/zsh-256color`

to your `.zshrc` with your other zgen plugin load commands.

### Zplugin

If you're using [Zplugin](https://github.com/zdharma/zplugin), add

`zplugin light "chrissicool/zsh-256color"`

to your `.zshrc` with your other zplugin load commands.

## Debugging

If the environment variable `$ZSH_256COLOR_DEBUG` is set to any value when the
plugin loads, some debugging information is printed to stderr. This is useful
to find out which strategy was successful to set a 256 colors terminal.
