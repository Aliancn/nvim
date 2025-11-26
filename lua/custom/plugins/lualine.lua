return {
  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    config = function()
      local lualine = require 'lualine'

      -- 修复点 1：使用 ANSI 颜色码 (0-15) 代替字符串
      -- 这些数字在任何终端下都代表标准颜色
      local colors = {
        bg = '#ffffffff', -- 状态栏背景
        fg = '#000000ff', -- 前景文字
        yellow = '#e5c07b',
        cyan = '#56b6c2',
        darkblue = '#61afef',
        green = '#98c379',
        orange = '#d19a66',
        violet = '#c678dd',
        magenta = '#c678dd',
        blue = '#61afef',
        red = '#e06c75',
      }

      local conditions = {
        buffer_not_empty = function()
          return vim.fn.empty(vim.fn.expand '%:t') ~= 1
        end,
        hide_in_width = function()
          return vim.fn.winwidth(0) > 80
        end,
      }

      -- Config
      local config = {
        options = {
          icons_enabled = false,
          component_separators = '|',
          section_separators = '',

          -- 开启全局状态栏 (解决 NvimTree 分割问题)
          globalstatus = true,

          theme = {
            normal = { c = { fg = colors.fg, bg = colors.bg } },
            inactive = { c = { fg = colors.fg, bg = colors.bg } },
          },
        },
        sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          lualine_c = {},
          lualine_x = {},
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
        },
      }

      -- 插入函数
      local function ins_left(component)
        table.insert(config.sections.lualine_c, component)
      end

      local function ins_right(component)
        table.insert(config.sections.lualine_x, component)
      end

      -- --- 左侧组件 ---

      ins_left {
        'mode',
        color = function()
          -- 根据模式改变颜色
          local mode_color = {
            n = colors.red,
            i = colors.green,
            v = colors.blue,
            [''] = colors.blue,
            V = colors.blue,
            c = colors.magenta,
            no = colors.red,
            s = colors.orange,
            S = colors.orange,
            [''] = colors.orange,
            ic = colors.yellow,
            R = colors.violet,
            Rv = colors.violet,
            cv = colors.red,
            ce = colors.red,
            r = colors.cyan,
            rm = colors.cyan,
            ['r?'] = colors.cyan,
            ['!'] = colors.red,
            t = colors.red,
          }
          return { fg = mode_color[vim.fn.mode()], gui = 'bold', cterm = 'bold' }
        end,
        padding = { left = 1, right = 1 }, -- 左右留白
      }

      ins_left {
        'filesize',
        cond = conditions.buffer_not_empty,
      }

      ins_left {
        'filename',
        cond = conditions.buffer_not_empty,
        color = { fg = colors.magenta, gui = 'bold' },
      }

      ins_left { 'location' }

      ins_left { 'progress', color = { fg = colors.fg, gui = 'bold' } }

      ins_left {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        symbols = { error = 'E:', warn = 'W:', info = 'I:' },
        diagnostics_color = {
          error = { fg = colors.red },
          warn = { fg = colors.yellow },
          info = { fg = colors.cyan },
        },
      }

      ins_left {
        function()
          return '%='
        end,
      }

      ins_left {
        function()
          local msg = 'No LSP'
          local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
          local clients = vim.lsp.get_clients()
          if next(clients) == nil then
            return msg
          end
          for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
              return client.name
            end
          end
          return msg
        end,
        icon = 'LSP:',
        color = { fg = colors.fg, gui = 'bold' },
      }

      -- --- 右侧组件 ---

      ins_right {
        'o:encoding',
        fmt = string.upper,
        cond = conditions.hide_in_width,
        color = { fg = colors.green, gui = 'bold' },
      }

      ins_right {
        'fileformat',
        fmt = string.upper,
        icons_enabled = false,
        color = { fg = colors.green, gui = 'bold' },
      }

      ins_right {
        'branch',
        icon = 'Br:',
        color = { fg = colors.violet, gui = 'bold' },
      }

      ins_right {
        'diff',
        symbols = { added = '+', modified = '~', removed = '-' },
        diff_color = {
          added = { fg = colors.green },
          modified = { fg = colors.orange },
          removed = { fg = colors.red },
        },
        cond = conditions.hide_in_width,
      }

      lualine.setup(config)
    end,
  },
}
