local M = {}

-- Utility function to compute relative paths
function M.get_relative_path(file_path)
  local project_root = vim.loop.cwd()
  local relative_path = vim.fn.fnamemodify(file_path, ":.")
  return vim.fn.substitute(relative_path, "^" .. vim.fn.escape(project_root, "/"), "", "")
end

-- Utility function to read file content
function M.read_file_content(file_path)
  local lines = {}
  local file = io.open(file_path, "r")
  if file then
    for line in file:lines() do
      table.insert(lines, line)
    end
    file:close()
  else
    table.insert(lines, "-- File could not be read --")
  end
  return table.concat(lines, "\n")
end

-- Convert a glob (e.g. "*.log") into a Lua pattern.
-- This is a simple conversion: it escapes Lua magic characters and
-- replaces '*' with '.*'. (Gitignore matching can be more complex.)
function M.glob_to_pattern(glob)
  local pattern = "^" .. glob:gsub("([%^%$%(%)%%%.%+%-%[%]$])", "%%%1")
      :gsub("%*", ".*") .. "$"
  return pattern
end

-- Check if a file/directory path matches any of the ignore patterns.
-- `ignore_patterns` should be a table of glob strings.
function M.is_ignored(file_path, ignore_patterns)
  ignore_patterns = ignore_patterns or {}
  for _, pattern in ipairs(ignore_patterns) do
    local lua_pattern = M.glob_to_pattern(pattern)
    if file_path:match(lua_pattern) then
      return true
    end
  end
  return false
end

return M
