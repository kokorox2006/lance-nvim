local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
keymap.set(
  'n',
  '<leader>q',
  vim.diagnostic.setloclist,
  { desc = 'Open diagnostic [Q]uickfix list' }
)

-- Exit terminal mode in the builtin terminal with a shortcut
keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Split windows
keymap.set('n', 'ss', ':vsplit<Return>', opts)
keymap.set('n', 'sv', ':split<Return>', opts)

-- Tabs
keymap.set('n', 'te', ':tabedit', opts)
keymap.set('n', '<tab>', ':tabnext<Return>', opts)
keymap.set('n', '<s-tab>', ':tabprev<Return>', opts)

-- IncRename
vim.keymap.set('n', '<leader>cr', function()
  return ':IncRename ' .. vim.fn.expand '<cword>'
end, { desc = 'LSP Rename', expr = true })

-- Borderless lazygit
-- keymap.set('n', '<leader>gg', function()
--   Snacks.terminal.get(
--     'lazygit',
--     { esc_esc = false, ctrl_hjkl = false, border = 'none' }
--   )
-- end, { desc = 'Lazygit (root dir)' })

-- Show notifications history
keymap.set('n', '<leader>n', function()
  Snacks.notifier.show_history()
end, { desc = '[N]otifications' })

-- Buffers
keymap.set('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
keymap.set('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
keymap.set('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
keymap.set(
  'n',
  '<leader>bb',
  '<cmd>e #<cr>',
  { desc = 'Switch to Other Buffer' }
)
keymap.set(
  'n',
  '<leader>`',
  '<cmd>e #<cr>',
  { desc = 'Switch to Other Buffer' }
)
keymap.set('n', '<leader>bd', function()
  Snacks.bufdelete()
end, { desc = 'Delete Buffer' })
keymap.set('n', '<leader>bo', function()
  Snacks.bufdelete.other()
end, { desc = 'Delete Other Buffers' })
keymap.set(
  'n',
  '<leader>bD',
  '<cmd>:bd<cr>',
  { desc = 'Delete Buffer and Window' }
)

-- Save file(s)
keymap.set('n', '<leader>w', '<cmd>w<cr>', { desc = 'Save file' })
keymap.set('n', '<C-s>', '<cmd>w<cr>', { desc = 'Save file' })
keymap.set('i', '<C-s>', '<esc><cmd>w<cr>a', { desc = 'Save file' })
keymap.set('n', '<leader>W', '<cmd>wa<cr>', { desc = 'Save all files' })
keymap.set('n', '<C-S>', '<cmd>wa<cr>', { desc = 'Save all files' })
keymap.set('i', '<C-S>', '<esc><cmd>wa<cr>a', { desc = 'Save all files' })

-- Function to recursively remove a directory
local function remove_directory(dir)
  local handle = vim.loop.fs_scandir(dir)
  if type(handle) == "userdata" then
    local name = vim.loop.fs_scandir_next(handle)
    while name do
      local path = dir .. '/' .. name
      local stat = vim.loop.fs_stat(path)
      if stat.type == "directory" then
        remove_directory(path)
      else
        vim.loop.fs_unlink(path)
      end
      name = vim.loop.fs_scandir_next(handle)
    end
  end
  vim.loop.fs_rmdir(dir)
end

-- Helper function for confirmations
local function confirm(prompt)
  local response = vim.fn.input(prompt .. " (press ENTER to confirm, any other key to cancel): ")
  vim.cmd('echo ""')  -- Clear the prompt
  return response == ""
end

-- File operations (create/delete/rename)
keymap.set('n', '<leader>fn', function()
  -- Get the directory of the current file
  local current_dir = vim.fn.expand('%:p:h')
  -- Prompt for the new file path (relative to current directory)
  local input = vim.fn.input({
    prompt = 'Create new file: ',
    default = current_dir .. '/',
    completion = 'file'
  })
  vim.cmd('echo ""')  -- Clear the prompt
  
  if input ~= '' then
    -- Create any missing directories in the path
    local dir = vim.fn.fnamemodify(input, ':h')
    if vim.fn.isdirectory(dir) == 0 then
      if confirm("Create directory: " .. dir) then
        vim.fn.mkdir(dir, 'p')
      else
        return
      end
    end
    
    -- Check if file already exists
    if vim.fn.filereadable(input) == 1 then
      vim.notify("File already exists!", vim.log.levels.WARN)
      return
    end
    
    -- Create and edit the new file
    vim.cmd('edit ' .. vim.fn.fnameescape(input))
    vim.notify("Created new file: " .. input, vim.log.levels.INFO)
  end
end, { desc = 'Create new file' })

keymap.set('n', '<leader>fd', function()
  local path = vim.fn.expand('%:p')
  local is_directory = vim.fn.isdirectory(path) == 1
  local type_str = is_directory and "directory" or "file"
  
  if confirm("Delete " .. type_str .. ": " .. path) then
    if is_directory then
      -- Handle directory deletion
      local is_empty = #vim.fn.glob(path .. '/*') == 0
      if not is_empty then
        if not confirm("Directory not empty. Delete recursively: " .. path) then
          return
        end
      end
      vim.cmd('bdelete!')
      remove_directory(path)
      local success = not vim.fn.isdirectory(path)
      if success then
        vim.notify("Deleted directory: " .. path, vim.log.levels.INFO)
      else
        vim.notify("Error deleting directory: " .. path, vim.log.levels.ERROR)
      end
    else
      -- Handle file deletion
      vim.cmd('bdelete!')
      local success, err = os.remove(path)
      if success then
        vim.notify("Deleted file: " .. path, vim.log.levels.INFO)
      else
        vim.notify("Error deleting file: " .. err, vim.log.levels.ERROR)
      end
    end
  end
end, { desc = 'Delete current file or directory' })

keymap.set('n', '<leader>fr', function()
  local old_name = vim.fn.expand('%:p')
  local new_name = vim.fn.input('New name: ', old_name, 'file')
  vim.cmd('echo ""')  -- Clear the prompt
  
  if new_name ~= '' and new_name ~= old_name then
    -- Create any missing directories in the path
    local new_dir = vim.fn.fnamemodify(new_name, ':h')
    if vim.fn.isdirectory(new_dir) == 0 then
      if confirm("Create directory: " .. new_dir) then
        vim.fn.mkdir(new_dir, 'p')
      else
        return
      end
    end
    
    local success, err = os.rename(old_name, new_name)
    if success then
      vim.cmd('saveas ' .. vim.fn.fnameescape(new_name))
      vim.cmd('bdelete ' .. vim.fn.fnameescape(old_name))
      vim.notify("Renamed to " .. new_name, vim.log.levels.INFO)
    else
      vim.notify("Error renaming file: " .. err, vim.log.levels.ERROR)
    end
  end
end, { desc = 'Rename current file' })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup(
    'kickstart-highlight-yank',
    { clear = true }
  ),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Better indenting
keymap.set('v', '<', '<gv')
keymap.set('v', '>', '>gv')
