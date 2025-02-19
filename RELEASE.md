# nvim-copy Release Notes

This document tracks changes and improvements made to **nvim-copy**.

---

## **v1.1.0 - Added Ignore Patterns Support** (Latest)

### **New Features**

- **Added `ignore` option** to allow users to specify files and directories to be excluded when copying.
- **Supports Gitignore-style patterns**, making it easy to ignore `node_modules`, logs, and other unwanted files.
- **Patterns can match directories (`*dir/*`) and file types (`*.log`).**

### **Recommended Ignore Configuration**

Although no files are ignored by default, we recommend the following:

```lua
require("nvim_copy").setup({
  ignore = {
    "*node_modules/*",  -- Ignore any node_modules directory
    "*__pycache__/*",   -- Ignore Python cache directories
    "*.git/*",          -- Ignore Git repository metadata
    "*dist/*",          -- Ignore compiled distribution files
    "*build/*",         -- Ignore build artifacts
    "*.log"             -- Ignore log files
  }
})
```

- Ignore patterns now work **before** directory traversal, improving efficiency.
- `"*dir/*"` ignores any instance of `dir/`, while `"*.log"` ignores all `.log` files.

---

## **v1.0.0 - Initial Release**

### **Features**

- **Copy Visible Buffers**: Copy the content of all open buffers.
- **Copy Current Buffer**: Copy only the currently focused buffer.
- **Copy Git Files**: Copy all modified files in the current Git repository.
- **Copy Quickfix Files**: Copy all files listed in the quickfix list.
- **Copy Harpoon Files**: Copy files saved in Harpoon marks.
- **Copy Directory Files**: Copy all files from a directory, with optional recursive traversal.
- **Folding Support**: Preserve folds when copying buffer content.
- **Recursive & Non-Recursive Copying**: Toggle recursion for directory-based copy operations.

### **Commands Available**

- `:CopyBuffersToClipboard`
- `:CopyCurrentBufferToClipboard`
- `:CopyGitFilesToClipboard`
- `:CopyQuickfixFilesToClipboard`
- `:CopyHarpoonFilesToClipboard`
- `:CopyDirectoryFilesToClipboard`

---

## **Upcoming Features**

- **Optional Project Tree in Clipboard**:
  - Add an option to **include the project tree** as text in the clipboard.
  - Users can choose to copy **only** the project tree or append it alongside copied files.
  - This helps provide an **overview of the project structure** when sharing code.

---

## **How to Update**

To get the latest version, update via your package manager:

#### **For Packer:**

```lua
:PackerSync
```

#### **For Lazy.nvim:**

```lua
:Lazy sync
```

---

## **Contributing**

Have suggestions or found a bug? Open an issue or submit a pull request on GitHub.
