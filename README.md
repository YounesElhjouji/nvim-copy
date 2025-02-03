# nvim-copy

**nvim-copy** is a Neovim plugin written in Lua that allows you to copy the content of files—from visible buffers, Git-modified files, quickfix lists, Harpoon marks, or entire directories—to the clipboard. The plugin supports preserving code folds, making it easier to view folded sections in the copied output.  
It is also highly configurable:

- **Folding:** All commands support the `nofolds` flag to disable preserving fold information.
- **Recursion:** The copy directory and copy Harpoon commands support the `norecurse` flag to disable recursive file search.

## Features

- **Copy Visible Buffers:** Copy the content of all visible buffers.
- **Copy Current Buffer:** Copy the current buffer’s content.
- **Copy Git Files:** Copy files modified in Git.
- **Copy Quickfix Files:** Copy files listed in the quickfix list.
- **Copy Harpoon Files:** Copy files marked with [Harpoon](https://github.com/ThePrimeagen/harpoon).
- **Copy Directory Files:** Copy all files in a directory (supports recursive search).

## Installation

### Using packer.nvim

```lua
use {
'YounesElhjouji/nvim-copy',
lazy = false, -- ensures the plugin is loaded on startup, even when using lazy.nvim
config = function()
-- nvim-copy automatically registers its commands on load.
-- Optionally, you can map commands to keybindings:
vim.api.nvim_set_keymap('n', '<leader>cb', ':CopyBuffersToClipboard<CR>', { noremap = true, silent = true })
end
}
```

### Using lazy.nvim

If you're using lazy.nvim, add the following to your lazy configuration to ensure that the plugin is auto-loaded:

```lua
{
"YounesElhjouji/nvim-copy",
lazy = false, -- disables lazy-loading so the plugin is loaded on startup
config = function()
-- Optional: additional configuration or key mappings
vim.api.nvim_set_keymap('n', '<leader>cb', ':CopyBuffersToClipboard<CR>', { noremap = true, silent = true })
end,
}
```

> **Note:** Ensure that the Lua module directory is named `nvim_copy` (with an underscore) to match the module requires in the code.

## Usage

After installation, the following commands become available:

- `:CopyBuffersToClipboard`  
  Copies the content of all visible buffers to the clipboard.  
  _Supports the flag:_ `nofolds` (to disable fold preservation).

- `:CopyCurrentBufferToClipboard`  
  Copies the current buffer’s content to the clipboard.  
  _Supports the flag:_ `nofolds`.

- `:CopyGitFilesToClipboard`  
  Copies the content of files modified in Git to the clipboard.  
  _Supports the flag:_ `nofolds`.

- `:CopyQuickfixFilesToClipboard`  
  Copies the content of files from the quickfix list to the clipboard.  
  _Supports the flag:_ `nofolds`.

- `:CopyHarpoonFilesToClipboard`  
  Copies the content of files marked in Harpoon to the clipboard.  
  _Supports the flags:_

  - `nofolds` (to disable fold preservation)
  - `norecurse` (to disable recursive search)

- `:CopyDirectoryFilesToClipboard [directory] [flags]`  
  Copies the content of all files in the given directory (or the current buffer’s directory if omitted) to the clipboard.  
  _Flags (optional):_
  - `nofolds`: Do not preserve fold information.
  - `norecurse`: Do not traverse directories recursively.

### Flags Example

```
:CopyDirectoryFilesToClipboard /path/to/dir nofolds norecurse
```

## How It Works

1. **File Reading:**  
   The plugin reads file content from loaded buffers (or directly from disk if the buffer is not loaded). If the buffer is visible, it uses a window context to preserve folding information.

2. **Content Aggregation:**  
   Files are processed and concatenated with a header (showing the file path relative to the project root), then the aggregated content is set to the clipboard.

3. **Command Registration:**  
   Commands are registered automatically when the plugin is loaded via the `plugin/nvim-copy.vim` loader file.

## Contributing

Contributions and feedback are welcome! Please open an issue or submit a pull request on GitHub.

## License

[MIT](LICENSE)
