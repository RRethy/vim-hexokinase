# vim-hexokinase

(Neo)Vim plugin for displaying the colour of 6-digit hex codes, 3-digit hex codes, rgb, and rgba functions, and optionally web colours

> let g:Hexokinase_highlighters = ['virtual']

![gif](https://media.giphy.com/media/PikQiakj2NYxFDmcdl/giphy.gif)

> let g:Hexokinase_highlighters = ['sign_column']

![gif](https://media.giphy.com/media/5kFmgYX1mF7l25BnYe/giphy.gif)

> let g:Hexokinase_highlighters = ['foreground']

![pic](https://user-images.githubusercontent.com/21000943/64053823-2c26ae00-cb52-11e9-869a-f8ddfe797196.png)

> let g:Hexokinase_highlighters = ['foregroundfull']

![pic](https://user-images.githubusercontent.com/21000943/64053892-6e4fef80-cb52-11e9-8c81-31a785c7503e.png)

> let g:Hexokinase_highlighters = ['background']

![pic](https://user-images.githubusercontent.com/21000943/64057174-bb8a8c00-cb67-11e9-99b9-66f8eba00c65.png)

> let g:Hexokinase_highlighters = ['backgroundfull']

![pic](https://user-images.githubusercontent.com/21000943/64057161-91d16500-cb67-11e9-83ab-535ad2489c5a.png)

## Rationale

**Problem:** [Colorizer](https://github.com/chrisbra/Colorizer) and [Colorizer](https://github.com/lilydjwg/colorizer) are plugins which also display the colour of text. However, they do so by changing the background of the text which is not pleasing to look at. On top of that, they all scrape the file synchronously.

**Solution:** Have 6 different options for displaying colour, including as virtual text or in the sign column. As well, do all scraping asynchronously.

## About

This plugin can display the colour of 6 digit hex codes, 3 digit hex codes, rgb functions, rgba functions, hsl functions, hsla functions, and custom patterns.

Colour can be displayed in each of the 6 six ways shown above, or can be customized to display colour any way the user chooses.

**Note:** By default all filetypes are scraped and highlighted on `BufWrite` and `BufCreate`, see `:h g:Hexokinase_refreshEvents` for more info.

## Requirements

- `:h 'termguicolors'` must be turned on and your terminal must support it
- For *virtual text*: Neovim 0.3.2
- For *sign_column*: Vim compiled with `+signs` or any Neovim version
- Golang must be installed, for more information visit https://golang.org/doc/install.
    * Without Golang, a synchronous version of the plugin will still work, documentation can be found at `:h deprecated-hexokinase.txt`.
- Currently, untested on Windows, help is welcomed.

## Installation

1. Install Golang https://golang.org/doc/install
2. Install the plugin with the plugin manager of choice and ensure `make hexokinase` is executed in the project root:

```vim
" vim-plug
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }

" minpac
call minpac#add('rrethy/vim-hexokinase', { 'do': 'make hexokinase' })

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
let g:Hexokinase_optInPatterns = ['full_hex', 'rgb', 'rgba', 'colour_names']

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

## FAQ

> I'm seeing grey colours when I toggle vim-hexokinase

You need `termguicolors` to be turned on. Verify `:set termguicolors?` outputs `termguicolors`. For more info, see https://github.com/RRethy/vim-hexokinase/issues/10.
