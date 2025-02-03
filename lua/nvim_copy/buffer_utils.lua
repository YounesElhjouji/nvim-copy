local M = {}

-- Function to read visible file content with preserved folds.
function M.read_visible_file_content_with_folds(file_path)
  local lines = {}

  -- Check if there's a loaded buffer for this file.
  local bufnr = nil
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) == file_path then
      bufnr = buf
      break
    end
  end

  -- Define a helper that uses the fold API to process lines.
  local function process_lines()
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    local current_line = 1

    while current_line <= line_count do
      local fold_start = vim.fn.foldclosed(current_line)
      if fold_start == current_line then
        -- We are at the start of a closed fold.
        local fold_end = vim.fn.foldclosedend(current_line)
        local header_line = vim.api.nvim_buf_get_lines(bufnr, current_line - 1, current_line, false)[1]
        local folded_lines = fold_end - current_line
        -- Append a note about the number of folded lines.
        header_line = header_line .. " ... (" .. folded_lines .. " folded lines)"
        table.insert(lines, header_line)
        current_line = fold_end + 1
      else
        table.insert(lines, vim.api.nvim_buf_get_lines(bufnr, current_line - 1, current_line, false)[1])
        current_line = current_line + 1
      end
    end
  end

  if bufnr then
    -- Check if the buffer is currently displayed in any window.
    local win_id = nil
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == bufnr then
        win_id = win
        break
      end
    end

    if win_id then
      -- If visible, process lines within that window's context.
      vim.api.nvim_win_call(win_id, process_lines)
    else
      -- If not visible, create a temporary hidden window so that fold info is computed.
      local width = math.floor(vim.o.columns * 0.8)
      local height = math.floor(vim.o.lines * 0.8)
      local opts = {
        relative = 'editor',
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = 'minimal',
        focusable = false, -- keep it out of focus
        border = 'none',
      }
      local temp_win = vim.api.nvim_open_win(bufnr, false, opts)
      -- Ensure that folding is enabled.
      vim.api.nvim_buf_set_option(bufnr, "foldenable", true)
      -- Process lines in the temporary window context.
      vim.api.nvim_win_call(temp_win, process_lines)
      vim.api.nvim_win_close(temp_win, true)
    end
  else
    -- Fallback: read from file if the buffer is not loaded.
    local file = io.open(file_path, "r")
    if file then
      for line in file:lines() do
        table.insert(lines, line)
      end
      file:close()
    else
      table.insert(lines, "-- File could not be read --")
    end
  end

  return table.concat(lines, "\n")
end

-- Function to read visible file content without preserving folds.
function M.read_visible_file_content_without_folds(file_path)
  local lines = {}

  -- Check if there's a loaded buffer for this file.
  local bufnr = nil
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) == file_path then
      bufnr = buf
      break
    end
  end

  if bufnr then
    -- Simply retrieve all lines.
    lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  else
    -- Fallback: read directly from the file.
    local file = io.open(file_path, "r")
    if file then
      for line in file:lines() do
        table.insert(lines, line)
      end
      file:close()
    else
      table.insert(lines, "-- File could not be read --")
    end
  end

  return table.concat(lines, "\n")
end

return M
