local clipboard = require("nvim_copy.clipboard")
local file_utils = require("nvim_copy.file_utils")

local M = {}

-- Helper: merge opts with defaults.
-- Default preserve_folds is true and default recursive is true.
local function default_opts(opts)
  opts = opts or {}
  if opts.preserve_folds == nil then
    opts.preserve_folds = true
  end
  if opts.recursive == nil then
    opts.recursive = true
  end
  opts.ignore = opts.ignore or {} -- Ensure ignore is always present
  return opts
end

local function parse_flags(args)
  local opts = {}
  for _, arg in ipairs(args) do
    local flag = arg:lower()
    if flag == "nofolds" then
      opts.preserve_folds = false
    elseif flag == "norecurse" then
      opts.recursive = false
    end
  end
  return opts
end

function M.setup(global_opts)
  M.global_opts = global_opts or {}

  local function wrap_command(fn)
    return function(opts)
      local flags = parse_flags(opts.fargs or {})
      flags.ignore = M.global_opts.ignore                  -- Pass ignore option
      print("Ignore patterns:", vim.inspect(flags.ignore)) -- Debug print
      fn(flags)
    end
  end

  vim.api.nvim_create_user_command('CopyBuffersToClipboard', wrap_command(M.copy_buffers_to_clipboard), { nargs = "*" })
  vim.api.nvim_create_user_command('CopyGitFilesToClipboard', wrap_command(M.copy_git_files_to_clipboard),
    { nargs = "*" })
  vim.api.nvim_create_user_command('CopyQuickfixFilesToClipboard', wrap_command(M.copy_quickfix_files_to_clipboard),
    { nargs = "*" })
  vim.api.nvim_create_user_command('CopyHarpoonFilesToClipboard', wrap_command(M.copy_harpoon_files_to_clipboard),
    { nargs = "*" })
  vim.api.nvim_create_user_command('CopyDirectoryFilesToClipboard', function(opts)
    local dir = nil
    local flags = {}

    if #opts.fargs > 0 then
      if vim.fn.isdirectory(opts.fargs[1]) == 1 then
        dir = opts.fargs[1]
        for i = 2, #opts.fargs do
          table.insert(flags, opts.fargs[i])
        end
      else
        flags = opts.fargs
      end
    else
      dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
    end

    local flags_opts = parse_flags(flags)
    flags_opts.ignore = M.global_opts.ignore
    print("Ignore patterns:", vim.inspect(flags_opts.ignore)) -- Debug print
    M.copy_directory_files_to_clipboard(dir, flags_opts)
  end, { nargs = "*" })

  vim.api.nvim_create_user_command('CopyCurrentBufferToClipboard', wrap_command(M.copy_current_buffer_to_clipboard),
    { nargs = "*" })
end

function M.copy_buffers_to_clipboard(opts)
  opts = default_opts(opts)
  local files = {}
  local seen_files = {}

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_get_option(bufnr, 'buflisted') then
      local file_path = vim.api.nvim_buf_get_name(bufnr)
      if file_path ~= "" and not seen_files[file_path] then
        seen_files[file_path] = true
        table.insert(files, file_path)
      end
    end
  end

  clipboard.copy_to_clipboard_from_files(files, "Buffer", opts)
end

function M.copy_current_buffer_to_clipboard(opts)
  opts = default_opts(opts)
  local bufnr = vim.api.nvim_get_current_buf()
  local file_path = vim.api.nvim_buf_get_name(bufnr)

  if file_path == "" then
    print("Current buffer is not associated with a file.")
    return
  end

  clipboard.copy_to_clipboard_from_files({ file_path }, "Current buffer", opts)
end

function M.copy_git_files_to_clipboard(opts)
  opts = default_opts(opts)
  local git_files = vim.fn.systemlist("git diff --name-only HEAD")

  if #git_files == 0 then
    print("No modified files in Git.")
    return
  end

  clipboard.copy_to_clipboard_from_files(git_files, "Git-modified file", opts)
end

function M.copy_quickfix_files_to_clipboard(opts)
  opts = default_opts(opts)
  local qf_list = vim.fn.getqflist()

  if #qf_list == 0 then
    print("Quickfix list is empty.")
    return
  end

  local files = {}
  local seen_files = {}

  for _, entry in ipairs(qf_list) do
    local file_path = entry.filename or vim.api.nvim_buf_get_name(entry.bufnr)
    if file_path and file_path ~= "" and not seen_files[file_path] then
      seen_files[file_path] = true
      table.insert(files, file_path)
    end
  end

  if #files == 0 then
    print("No valid files found in the quickfix list.")
    return
  end

  clipboard.copy_to_clipboard_from_files(files, "Quickfix file", opts)
end

function M.copy_harpoon_files_to_clipboard(opts)
  opts = default_opts(opts)
  local harpoon = require("harpoon")
  local marks = harpoon.get_mark_config().marks

  if #marks == 0 then
    print("No files marked in Harpoon.")
    return
  end

  local paths = {}

  for _, mark in ipairs(marks) do
    if mark.filename then
      table.insert(paths, mark.filename)
    end
  end

  local all_files = file_utils.process_paths(paths, opts.recursive)

  if #all_files == 0 then
    print("No valid files found in Harpoon marks.")
    return
  end

  clipboard.copy_to_clipboard_from_files(all_files, "Harpoon", opts)
end

function M.copy_directory_files_to_clipboard(directory, opts)
  opts = default_opts(opts)
  local recursive = opts.recursive

  if not directory or directory == "" then
    local current_file = vim.api.nvim_buf_get_name(0)

    if current_file == "" then
      print("No directory specified and no file in current buffer.")
      return
    end

    directory = vim.fn.fnamemodify(current_file, ":h")
  end

  if vim.fn.isdirectory(directory) == 0 then
    print("Invalid directory: " .. directory)
    return
  end

  local all_files = file_utils.process_paths({ directory }, recursive)

  if #all_files == 0 then
    print("No files found in directory: " .. directory)
    return
  end

  clipboard.copy_to_clipboard_from_files(all_files, "Directory", opts)
end

return M
