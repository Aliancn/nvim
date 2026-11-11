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
        -- netrw 已在 init.lua 里通过 vim.g.loaded_netrw 禁用，无需 hijack。
        -- 且 nvim 0.12 中 `autocmd! FileExplorer *` 会报 E216（该 augroup 不存在），
        -- 导致启动时刷出错误。
        hijack_netrw = false,
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

