# nvim-copy

**nvim-copy** is a Neovim plugin written in Lua that allows you to copy the content of files—from visible buffers, Git-modified files, quickfix lists, Harpoon marks, or entire directories—to the clipboard. The plugin supports preserving code folds, making it easier to view folded sections in the copied output.

## Features

- **Copy Visible Buffers:** Copy the content of all visible buffers.
- **Copy Current Buffer:** Copy the current buffer’s content.
- **Copy Git Files:** Copy files modified in Git.
- **Copy Quickfix Files:** Copy files listed in the quickfix list.
- **Copy Harpoon Files:** Copy files marked with [Harpoon](https://github.com/ThePrimeagen/harpoon).
- **Copy Directory Files:** Copy all files in a directory (supports recursive search).

## Installation

Use your favorite plugin manager. For example, with [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
    'your-github-username/nvim-copy',
    config = function()
        -- nvim-copy automatically registers its commands on load.
        -- Optionally, you can map commands to keybindings:
        vim.api.nvim_set_keymap('n', '<leader>cb', ':CopyBuffersToClipboard<CR>', { noremap = true, silent = true })
    end
}
```

> **Note:** Ensure that the Lua module directory is named `nvim_copy` (with an underscore) to match the module requires in the code.

## Usage

After installation, the following commands become available:

- `:CopyBuffersToClipboard`  
  Copies the content of all visible buffers to the clipboard.

- `:CopyCurrentBufferToClipboard`  
  Copies the current buffer’s content to the clipboard.

- `:CopyGitFilesToClipboard`  
  Copies the content of files modified in Git to the clipboard.

- `:CopyQuickfixFilesToClipboard`  
  Copies the content of files from the quickfix list to the clipboard.

- `:CopyHarpoonFilesToClipboard`  
  Copies the content of files marked in Harpoon to the clipboard.

- `:CopyDirectoryFilesToClipboard [directory] [flags]`  
  Copies the content of all files in the given directory (or the current buffer’s directory if omitted) to the clipboard.  
  Flags (optional):
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
