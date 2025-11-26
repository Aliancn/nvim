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
        filters = { dotfiles = true },
      }
    end,
  },
}

