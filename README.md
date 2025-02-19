# nvim-copy

**nvim-copy** is a Neovim plugin written in Lua that allows you to copy the content of files—from visible buffers, Git-modified files, quickfix lists, Harpoon marks, or entire directories—to the clipboard. The plugin supports preserving code folds, making it easier to view folded sections in the copied output.  
It is also highly configurable:

- **Folding:** All commands support the `nofolds` flag to disable preserving fold information.
- **Recursion:** The copy directory and copy Harpoon commands support the `norecurse` flag to disable recursive file search.
- **Ignore Patterns:** Configure which files or directories should be ignored using Gitignore-style patterns.

## Features

- **Copy Visible Buffers:** Copy the content of all visible buffers.
- **Copy Current Buffer:** Copy the current buffer’s content.
- **Copy Git Files:** Copy files modified in Git.
- **Copy Quickfix Files:** Copy files listed in the quickfix list.
- **Copy Harpoon Files:** Copy files marked with [Harpoon](https://github.com/ThePrimeagen/harpoon).
- **Copy Directory Files:** Copy all files in a directory (supports recursive search).
- **Ignore Patterns:** Automatically exclude files and directories using `ignore` settings.

## Installation

### Using packer.nvim

```lua
use {
  'YounesElhjouji/nvim-copy',
  config = function()
    require("nvim_copy").setup({
      ignore = {
        "*node_modules/*",
        "*__pycache__/*",
        "*.git/*",
        "*dist/*",
        "*build/*",
        "*.log"
      }
    })

    -- Optional key mappings:
    vim.api.nvim_set_keymap('n', '<leader>cb', ':CopyBuffersToClipboard<CR>', { noremap = true, silent = true })
  end
}
```

### Using lazy.nvim

If you're using lazy.nvim, add the following to your lazy configuration:

```lua
{
  "YounesElhjouji/nvim-copy",
  lazy = false, -- ensures the plugin is loaded on startup
  config = function()
    require("nvim_copy").setup({
      ignore = {
        "*node_modules/*",
        "*__pycache__/*",
        "*.git/*",
        "*dist/*",
        "*build/*",
        "*.log"
      }
    })

    -- Optional key mappings:
    vim.api.nvim_set_keymap('n', '<leader>cb', ':CopyBuffersToClipboard<CR>', { noremap = true, silent = true })
  end,
}
```

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

## Ignore Patterns

`nvim-copy` allows you to configure files and directories that should be ignored when copying directory contents. This is done using `ignore` patterns, which follow a simple glob-like convention.

### Custom Ignore Configuration

You can customize ignore patterns via `setup()`:

```lua
require("nvim_copy").setup({
  ignore = { "*tmp/*", "*logs/*.log", "*backup/*" }
})
```

This ensures that:

- `tmp/` and its contents are ignored.
- Any `.log` file inside `logs/` is ignored.
- `backup/` and all its files are ignored.

### Behavior of Ignore Patterns

| Pattern             | What It Ignores                                        |
| ------------------- | ------------------------------------------------------ |
| `"*node_modules/*"` | Any `node_modules/` directory, regardless of depth.    |
| `"*.log"`           | All files ending in `.log` anywhere in the project.    |
| `"*dist/*"`         | Any `dist/` directory and all its contents.            |
| `"*.git/*"`         | Any `.git/` directory and all its contents.            |
| `"*configs/*"`      | Any `configs/` directory **and everything inside it**. |

> **Note:** Since patterns start with `"*"`, they match paths **anywhere** in the project.
> This ensures that all instances of `node_modules/` or `dist/`—even deeply nested ones—are ignored.

## How It Works

1. **File Reading:**
   The plugin reads file content from loaded buffers (or directly from disk if the buffer is not loaded). If the buffer is visible, it uses a window context to preserve folding information.

2. **Content Aggregation:**
   Files are processed and concatenated with a header (showing the file path relative to the project root), then the aggregated content is set to the clipboard.

3. **Command Registration:**
   Commands are registered automatically when the plugin is loaded via the `plugin/nvim-copy.vim` loader file.

4. **Ignore Handling:**
   - The plugin filters files and directories **before** reading them.
   - Patterns with `"*dir/*"` ignore **all instances** of the directory `dir/` anywhere in the project.
   - File-based ignores (`"*.log"`) are applied at the file level.

## Contributing

Contributions and feedback are welcome! Please open an issue or submit a pull request on GitHub.

## License

[MIT](LICENSE)
