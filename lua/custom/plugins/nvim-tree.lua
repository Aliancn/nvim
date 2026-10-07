return {
  { -- Nvim Tree
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    keys = {
      { '<C-n>', '<cmd>NvimTreeToggle<cr>', desc = 'NvimTree' },
    },
    config = function()
      require('nvim-tree').setup {
        renderer = {
          icons = {
            show = {
              file = false,
              folder = false,
              folder_arrow = false,
              git = false,
              modified = false,
              hidden = false,
              diagnostics = false,
              bookmarks = false,
            },
          },
        },
        sort = { sorter = 'filetype' },
        view = { width = 30 },
        filters = { dotfiles = false },
      }
      -- H toggles hidden (dotfile) visibility inside the tree
      vim.api.nvim_create_autocmd('User', {
        pattern = 'NvimTreeSetup',
        callback = function()
          local api = require 'nvim-tree.api'
          vim.keymap.set('n', 'H', api.tree.toggle_hidden_filter, { desc = 'NvimTree toggle hidden', buffer = 0 })
        end,
      })
    end,
  },
}

