return {
  {
    'elixir-tools/elixir-tools.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    version = '*',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local elixir = require 'elixir'
      local elixirls = require 'elixir.elixirls'

      elixir.setup {
        nextls = {
          enable = true,
          init_options = {
            mix_env = 'dev',
            mix_target = 'host',
            experimental = {
              completions = {
                enable = false, -- control if completions are enabled. defaults to false
              },
            },
          },
          on_attach = function(client, _bufnr)
            require('which-key').add {
              { '<leader>x', group = 'Eli[x]ir' },
            }
            vim.keymap.set('n', '<space>xa', ':Elixir nextls alias-refactor<cr>', { desc = '[a]lias refactor', buffer = true, noremap = true })
            vim.keymap.set('n', '<space>xf', ':Elixir nextls from-pipe<cr>', { desc = '[f]rom pipe', buffer = true, noremap = true })
            vim.keymap.set('n', '<space>xt', ':Elixir nextls to-pipe<cr>', { desc = '[t]o pipe', buffer = true, noremap = true })
          end,
        },
        credo = {},
        elixirls = {
          enable = false,
          -- specify a repository and branch
          -- repo = 'mhanberg/elixir-ls', -- defaults to elixir-lsp/elixir-ls
          -- branch = 'mh/all-workspace-symbols', -- defaults to nil, just checkouts out the default branch, mutually exclusive with the `tag` option
          -- tag = 'v0.14.6', -- defaults to nil, mutually exclusive with the `branch` option

          -- alternatively, point to an existing elixir-ls installation (optional)
          -- not currently supported by elixirls, but can be a table if you wish to pass other args `{"path/to/elixirls", "--foo"}`
          -- cmd = '/usr/local/bin/elixir-ls.sh',

          -- default settings, use the `settings` function to override settings
          settings = elixirls.settings {
            dialyzerEnabled = true,
            fetchDeps = false,
            enableTestLenses = true,
            suggestSpecs = false,
          },
          on_attach = function(client, bufnr)
            require('which-key').add {
              { '<leader>x', group = 'Eli[x]ir' },
            }
            vim.keymap.set('n', '<space>xp', ':ElixirFromPipe<cr>', { buffer = true, noremap = true })
            vim.keymap.set('n', '<space>xt', ':ElixirToPipe<cr>', { buffer = true, noremap = true })
            vim.keymap.set('n', '<space>xr', ':ElixirRestart<cr>', { buffer = true, noremap = true })
            vim.keymap.set('n', '<space>xo', ':ElixirOutputPanel<cr>', { buffer = true, noremap = true })
            vim.keymap.set('v', '<space>xm', ':ElixirExpandMacro<cr>', { buffer = true, noremap = true })
          end,
        },
        projectionist = {
          enable = true,
        },
      }
    end,
  },
  {
    'jfpedroza/neotest-elixir',
  },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      local neotest = require 'neotest'
      neotest.setup {
        log_level = vim.log.levels.DEBUG,
        adapters = {
          require 'neotest-elixir',
        },
      }
      -- Keymaps
      vim.keymap.set('n', '<leader>tt', function()
        neotest.run.run()
      end, { desc = 'Run nearest test' })

      vim.keymap.set('n', '<leader>tf', function()
        neotest.run.run(vim.fn.expand '%')
      end, { desc = 'Run current file' })

      vim.keymap.set('n', '<leader>ta', function()
        neotest.run.run(vim.fn.getcwd())
      end, { desc = 'Run all tests' })

      vim.keymap.set('n', '<leader>ts', function()
        neotest.summary.toggle()
      end, { desc = 'Toggle test summary' })

      vim.keymap.set('n', '<leader>to', function()
        neotest.output.open { enter = true }
      end, { desc = 'Show test output' })

      vim.keymap.set('n', '<leader>tO', function()
        neotest.output.open { enter = true, short = true }
      end, { desc = 'Show test output (short)' })

      vim.keymap.set('n', '<leader>tS', function()
        neotest.run.stop()
      end, { desc = 'Stop test run' })

      vim.keymap.set('n', '<leader>tl', function()
        neotest.run.run_last()
      end, { desc = 'Run last test' })

      vim.keymap.set('n', '[t', function()
        neotest.jump.prev { status = 'failed' }
      end, { desc = 'Jump to previous failed test' })

      vim.keymap.set('n', ']t', function()
        neotest.jump.next { status = 'failed' }
      end, { desc = 'Jump to next failed test' })

      vim.keymap.set('n', '<leader>tw', function()
        neotest.watch.toggle(vim.fn.expand '%')
      end, { desc = 'Watch current file' })

      vim.keymap.set('n', '<leader>tW', function()
        neotest.watch.toggle(vim.fn.getcwd())
      end, { desc = 'Watch all tests' })

      vim.keymap.set('n', '<leader>td', function()
        neotest.run.run { strategy = 'dap' }
      end, { desc = 'Debug nearest test' })
    end,
  },
}
