local M = {}

-- Recursively (if recursive is true) or non-recursively collect files from a directory.
function M.get_all_files(path, recursive)
  local files = {}
  if vim.fn.isdirectory(path) == 1 then
    local items = vim.fn.glob(path .. "/*", true, true)
    for _, item in ipairs(items) do
      if vim.fn.isdirectory(item) == 1 then
        if recursive then
          for _, f in ipairs(M.get_all_files(item, recursive)) do
            table.insert(files, f)
          end
        end
        -- If not recursive, skip subdirectories.
      else
        table.insert(files, item)
      end
    end
  else
    table.insert(files, path)
  end
  return files
end

-- Process a list of paths (files and/or directories) into a flat list of files.
-- Pass the recursive flag here.
function M.process_paths(paths, recursive)
  local all_files = {}
  for _, path in ipairs(paths) do
    for _, f in ipairs(M.get_all_files(path, recursive)) do
      table.insert(all_files, f)
    end
  end
  return all_files
end

return M
