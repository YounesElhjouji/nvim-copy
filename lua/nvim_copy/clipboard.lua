local utils = require("nvim-copy.utils")
local file_utils = require("nvim-copy.file_utils")
local buffer_utils = require("nvim-copy.buffer_utils")

local M = {}

function M.build_content_buffer(files, opts)
  opts = opts or {}
  local result = {}
  local seen_files = {}
  for _, file_path in ipairs(files) do
    if file_path and not seen_files[file_path] then
      seen_files[file_path] = true
      local relative_path = utils.get_relative_path(file_path)
      table.insert(result, "File: " .. relative_path .. "\n")
      if opts.preserve_folds == false then
        table.insert(result, buffer_utils.read_visible_file_content_without_folds(file_path) .. "\n\n")
      else
        table.insert(result, buffer_utils.read_visible_file_content_with_folds(file_path) .. "\n\n")
      end
    end
  end
  return result
end

function M.copy_to_clipboard_from_files(files, source, opts)
  local content_buffer = M.build_content_buffer(files, opts)
  if #content_buffer == 0 then
    print("No valid files found for " .. source .. ".")
    return
  end

  local aggregated_content = table.concat(content_buffer)
  if vim.fn.has('clipboard') == 1 then
    vim.fn.setreg('+', aggregated_content)
    local file_count = #content_buffer / 2
    print(string.format("%s contents of %d files copied to clipboard!", source, file_count))
  else
    print("Clipboard support not available.")
  end
end

return M
