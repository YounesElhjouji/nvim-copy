local utils = require("nvim_copy.utils")
local M = {}

function M.get_all_files(path, recursive, ignore)
  local files = {}
  ignore = ignore or {}

  -- Determine if this is a directory
  local is_directory = vim.fn.isdirectory(path) == 1

  -- Skip this path entirely if it should be ignored.
  if utils.is_ignored(path, ignore, is_directory) then
    return files
  end

  if is_directory then
    local items = vim.fn.glob(path .. "/*", true, true)
    for _, item in ipairs(items) do
      local item_is_directory = vim.fn.isdirectory(item) == 1

      -- Check if this file or directory should be ignored.
      if not utils.is_ignored(item, ignore, item_is_directory) then
        if item_is_directory then
          if recursive then
            for _, f in ipairs(M.get_all_files(item, recursive, ignore)) do
              table.insert(files, f)
            end
          end
        else
          table.insert(files, item)
        end
      end
    end
  else
    table.insert(files, path)
  end
  return files
end

-- Process a list of paths (files and/or directories) into a flat list of files.
-- `ignore` is passed along to `get_all_files`.
function M.process_paths(paths, recursive, ignore)
  local all_files = {}
  for _, path in ipairs(paths) do
    for _, f in ipairs(M.get_all_files(path, recursive, ignore)) do
      table.insert(all_files, f)
    end
  end
  return all_files
end

return M
