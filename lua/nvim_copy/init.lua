local commands = require("nvim_copy.commands")

-- Immediately register all commands on plugin load.
commands.setup()

-- Expose public API functions if needed.
return {
  copy_buffers_to_clipboard         = commands.copy_buffers_to_clipboard,
  copy_git_files_to_clipboard       = commands.copy_git_files_to_clipboard,
  copy_quickfix_files_to_clipboard  = commands.copy_quickfix_files_to_clipboard,
  copy_harpoon_files_to_clipboard   = commands.copy_harpoon_files_to_clipboard,
  copy_directory_files_to_clipboard = commands.copy_directory_files_to_clipboard,
  copy_current_buffer_to_clipboard  = commands.copy_current_buffer_to_clipboard,
}
