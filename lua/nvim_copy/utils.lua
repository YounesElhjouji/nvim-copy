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

return M
