# vim-hexokinase

The fastest (Neo)Vim plugin for asynchronously displaying the colours in the file (#rrggbb, #rgb, rgb(a)? functions, hsl(a)? functions, web colours, custom patterns)

> let g:Hexokinase_highlighters = ['virtual']

![gif](https://media.giphy.com/media/PikQiakj2NYxFDmcdl/giphy.gif)

> let g:Hexokinase_highlighters = ['sign_column']

![gif](https://media.giphy.com/media/5kFmgYX1mF7l25BnYe/giphy.gif)

> set signcolumn=yes:9 " Neovim only

<img src="https://user-images.githubusercontent.com/21000943/69205914-4e104b00-0b19-11ea-8c36-4037d798810d.png" width="520" height="342">

> let g:Hexokinase_highlighters = ['foreground']

<img src="https://user-images.githubusercontent.com/21000943/64053823-2c26ae00-cb52-11e9-869a-f8ddfe797196.png" width="520" height="342">

> let g:Hexokinase_highlighters = ['foregroundfull']

<img src="https://user-images.githubusercontent.com/21000943/64053892-6e4fef80-cb52-11e9-8c81-31a785c7503e.png" width="520" height="342">

> let g:Hexokinase_highlighters = ['background']

<img src="https://user-images.githubusercontent.com/21000943/64057174-bb8a8c00-cb67-11e9-99b9-66f8eba00c65.png" width="520" height="342">

> let g:Hexokinase_highlighters = ['backgroundfull']

<img src="https://user-images.githubusercontent.com/21000943/64057161-91d16500-cb67-11e9-83ab-535ad2489c5a.png" width="520" height="342">

## Rationale

**Problem:** [Colorizer](https://github.com/chrisbra/Colorizer) and [Colorizer](https://github.com/lilydjwg/colorizer) are plugins which also display the colour of text. However, they do so by changing the background of the text which is not pleasing to look at. On top of that, they all scrape the file synchronously.

**Solution:** Have 6 different options for displaying colour, including as virtual text or in the sign column. As well, do all scraping asynchronously.

## About

This plugin can display the colour of 6 digit hex codes, 3 digit hex codes, rgb functions, rgba functions, hsl functions, hsla functions, and custom patterns.

Colour can be displayed in each of the 6 six ways shown above, or can be customized to display colour any way the user chooses.

**Note:** By default all filetypes are scraped and highlighted on `['TextChanged', 'InsertLeave', 'BufRead']`, see `:h g:Hexokinase_refreshEvents` for more info.

## Requirements

- `:h 'termguicolors'` must be turned on and your terminal must support it
- **Golang must be installed, for more information visit https://golang.org/doc/install.**
- For *virtual text*: Neovim 0.3.2
- For *sign_column*: Vim compiled with `+signs` or any Neovim version
- Currently, untested on Windows, help is welcomed.

## Installation

1. Install Golang https://golang.org/doc/install
2. Install the plugin with the plugin manager of choice and ensure `make hexokinase` is executed in the project root:

```vim
" vim-plug
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }

" minpac
call minpac#add('rrethy/vim-hexokinase', { 'do': 'make hexokinase' })

" dein
call dein#add('rrethy/vim-hexokinase', { 'build': 'make hexokinase' })

" etc.
```

3. `:set termguicolors`

## Quick Start

Choose your method of highlighting:

```vim
" Neovim default
let g:Hexokinase_highlighters = [ 'virtual' ]

" Vim default
let g:Hexokinase_highlighters = [ 'sign_column' ]

" All possible highlighters
let g:Hexokinase_highlighters = [
\   'virtual',
\   'sign_column',
\   'background',
\   'backgroundfull',
\   'foreground',
\   'foregroundfull'
\ ]
```

Choose which patterns are matched:

```vim
" Patterns to match for all filetypes
" Can be a comma separated string or a list of strings
" Default value:
let g:Hexokinase_optInPatterns = 'full_hex,rgb,rgba,hsl,hsla,colour_names'

" All possible values
let g:Hexokinase_optInPatterns = [
\     'full_hex',
\     'triple_hex',
\     'rgb',
\     'rgba',
\     'hsl',
\     'hsla',
\     'colour_names'
\ ]

" Filetype specific patterns to match
" entry value must be comma seperated list
let g:Hexokinase_ftOptInPatterns = {
\     'css': 'full_hex,rgb,rgba,hsl,hsla,colour_names',
\     'html': 'full_hex,rgb,rgba,hsl,hsla,colour_names'
\ }
```

Choose which filetypes to scrape automatically (by default ALL filetypes are scraped):

```vim
" Sample value, to keep default behaviour don't define this variable
let g:Hexokinase_ftEnabled = ['css', 'html', 'javascript']
```

## Commands

| Command  | Description  |
|---|---|
| **HexokinaseToggle**  | Toggle the colouring  |
| **HexokinaseTurnOn**  | Turn on colouring (refresh if already turned on) |
| **HexokinaseTurnOff**  | Turn off colouring  |

## Full Configuration

See `:help hexokinase.txt`

## Custom Patterns

See `:help g:Hexokinase_palettes`.

This can be used to colour specific variables.

## FAQ

> I'm seeing grey colours when I toggle vim-hexokinase

You need `termguicolors` to be turned on. Verify `:set termguicolors?` outputs `termguicolors`. For more info, see https://github.com/RRethy/vim-hexokinase/issues/10.
