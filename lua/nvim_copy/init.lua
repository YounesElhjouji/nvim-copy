local commands = require("nvim_copy.commands")

local M = {}

-- Default options
M.options = {
  ignore = {} -- Default empty list
}

-- Setup function to allow users to configure options
function M.setup(opts)
  -- Ensure the options are updated globally
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})

  -- Register commands with updated options
  commands.setup(M.options)
end

return M
