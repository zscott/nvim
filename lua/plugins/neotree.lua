return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', { desc = 'NeoTree reveal' } },
  },
  init = function()
    if vim.fn.argc(-1) == 1 then
      local stat = vim.loop.fs_stat(vim.fn.argv(0))
      if stat and stat.type == 'directory' then
        vim.cmd('cd ' .. vim.fn.argv(0))
        require 'neo-tree'
      end
    end
  end,
  opts = {
    filesystem = {
      hijack_netrw_behavior = 'open_current',
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
