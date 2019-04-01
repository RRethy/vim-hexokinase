# vim-hexokinase

(Neo)Vim plugin for displaying the colour of 6-digit hex codes, 3-digit hex codes, rgb, and rgba functions

> let g:Hexokinase_highlighters = ['virtual']

![gif](https://media.giphy.com/media/PikQiakj2NYxFDmcdl/giphy.gif)

> let g:Hexokinase_highlighters = ['sign_column']

![gif](https://media.giphy.com/media/5kFmgYX1mF7l25BnYe/giphy.gif)

## Rationale

[Colorizer](https://github.com/chrisbra/Colorizer) and [Colorizer](https://github.com/lilydjwg/colorizer) are plugins which also display the colour of text. However, it does so by changing the background of the text which is not pleasing to look at. Most IDEs and modern editors will display the colour in the gutter (in Vim known as the sign column) or as virtual text. This plugin aims to bring that now to Vim, as well as make it easy for the user to add new highlighters.

## About

This plugin will display the colour of hex codes (both 6 and 3 digit), and rgb/rgba functions.

It has currently two methods for displaying the colours, either in the sign column or as virtual text (Neovim exclusive).

The plugin was built with extensibility in mind ([it can be configured to colour variables](https://github.com/RRethy/vim-hexokinase/issues/16)), almost everything can be customized or extended.

## Requirements

- `:h 'termguicolors'` must be turned on and your terminal must support it
- For *virtual text*: Neovim 0.3.2
- For *sign_column*: Vim compiled with `+signs` or any Neovim version

## Commands

| Command           | Description           |
|-------------------|-----------------------|
| HexokinaseToggle  | Toggle the colouring  |
| HexokinaseRefresh | Refresh the colouring |

## Configuration

Which highlighters to use can be see with the following:

```vim
" Default for Vim
let g:Hexokinase_highlighters = ['sign_column']

" Default for Neovim
let g:Hexokinase_highlighters = ['virtual']

" All available highlighters
let g:Hexokinase_highlighters = ['virtual', 'sign_column', 'background', 'foreground', 'foregroundfull']
```

The icon/text to display the highlighting can also be customized:

```vim
" Default virtual text
let g:Hexokinase_virtualText = '■'

" This is my personal setting
let g:Hexokinase_virtualText = '██████'

" Default sign column icon
let g:Hexokinase_signIcon = '■'
```

You can customized which autocmd-events will trigger the highlighting to be refreshed.

```vim
" Default event to trigger and update
let g:Hexokinase_refreshEvents = ['BufWritePost']

" To make it almost live
" This may cause some lag if there are a lot of colours in the file
let g:Hexokinase_refreshEvents = ['TextChanged', 'TextChangedI']
```

The following will customize which filetypes will automatically enable the colouring

```vim
" Default is to not auto-enable for any filetype
let g:Hexokinase_ftAutoload = []

" Enable for all filetypes
let g:Hexokinase_ftAutoload = ['*']

" Enable for css and xml
let g:Hexokinase_ftAutoload = ['css', 'xml']
```

For advanced customization, check the help docs for `hexokinase-highlighters` and `hexokinase-patterns`.

## Installation

This assumes you have the packages feature. If not, any plugin manager will suffice.

### Neovim

```
mkdir -p ~/.config/nvim/pack/plugins/start
cd ~/.config/nvim/pack/plugins/start
git clone https://github.com/RRethy/vim-hexokinase.git
```

### Vim

```
mkdir -p ~/.vim/pack/plugins/start
cd ~/.vim/pack/plugins/start
git clone https://github.com/RRethy/vim-hexokinase.git
```
