# vim-hexokinase

(Neo)Vim plugin for displaying the colour of 6-digit hex codes, 3-digit hex codes, rgb, and rgba functions

![gif](https://media.giphy.com/media/2aMaIalAsmwHqOPs0T/giphy.gif)

## Rational

[Colorizer](https://github.com/lilydjwg/colorizer) is a plugin which also displays the colour of text. However, it does so by changing the background of the text which is not pleasing to look at. Most IDEs and modern editors will display the colour in the gutter (in Vim known as the sign column) or as virtual text. This plugin aims to bring that now to Vim, as well as make it easy for the user to add new highlighters.

## About

This plugin will display the colour of hex codes (both 6 and 3 digit), and rgb/rgba functions.

It has currently two methods for displaying the colours, either in the sign column or as virtual text (Neovim exclusive).

The plugin was built with extensibility in mind, almost everything can be customized or extended.

## Commands

| Command           | Description           |
|-------------------|-----------------------|
| HexokinaseToggle  | Toggle the colouring  |
| HexokinaseRefresh | Refresh the colouring |

## Configuration

Which highlighters to use can be see with the following:

```vim
" Default for Vim
let g:hexokinase_highlighters = ['sign_column']

" Default for Neovim
let g:hexokinase_highlighters = ['virtual']
```

The icon/text to display the highlighting can also be customized:

```vim
" Default virtual text
let g:hexokinase.virtual_text = '■'

" Default sign column icon
let g:hexokinase.sign_icon = '■'
```

You can customized which autocmd-events will trigger the highlighting to be refreshed.

```vim
" Default event to trigger and update
let g:hexokinase.refresh_events = ['BufWritePost']

" To make it almost live
" This may cause some lag if there are a lot of colours in the file
let g:hexokinase.refresh_events = ['TextChanged', 'TextChangedI']
```

The following will customize which filetypes will automatically enable the colouring

```vim
" Default is to not auto-enable for any filetype
let g:hexokinase.ft_autoload = ['']

" Enable for all filetypes
let g:hexokinase.ft_autoload = ['*']

" Enable for css and xml
let g:hexokinase.ft_autoload = ['css', 'xml']
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
