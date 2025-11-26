return {
  'akinsho/bufferline.nvim',
  version = '*',
  lazy = false,
  -- dependencies = 'nvim-tree/nvim-web-devicons',
  keys = {
    { '<leader>bp', '<cmd>BufferLinePick<cr>', desc = 'Pick Buffer' },
    { '<leader>bc', '<cmd>BufferLineCloseOthers<cr>', desc = 'Close Other Buffers' },
    -- Tab 切换到下一个标签
    { "<Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
        -- Shift + Tab 切换到上一个标签
        { "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
  },
  opts = {
    options = {
      -- 基础配置
      show_buffer_icons = false,
      show_buffer_close_icons = true,
      buffer_close_icon = 'x',
      show_close_icon = false,
      show_tab_indicators = false,
      separator_style = 'thick',
      numbers = 'ordinal',
      enforce_regular_tabs = true,

      -- [核心修复] 自定义点击关闭按钮的逻辑
      close_command = function(n)
        -- 1. 如果要关闭的是当前显示的 buffer，先切换到别的
        if n == vim.api.nvim_get_current_buf() then
          require('bufferline').cycle(-1) -- 尝试切到上一个
          -- 如果切完发现还是原来那个（说明只剩这一个了），就新建个空白页占位
          if n == vim.api.nvim_get_current_buf() then
            vim.cmd 'enew'
          end
        end
        -- 2. 此时光标已经移走了，或者有了占位页，安全删除原来的 buffer
        vim.cmd('bdelete! ' .. n)
      end,

      -- 右键点击标签也可以用同样的逻辑
      right_mouse_command = function(n)
        if n == vim.api.nvim_get_current_buf() then
          require('bufferline').cycle(-1)
          if n == vim.api.nvim_get_current_buf() then
            vim.cmd 'enew'
          end
        end
        vim.cmd('bdelete! ' .. n)
      end,

      -- [修复2]：配置侧边栏避让
      -- 这里的 filetype 必须和你使用的插件的文件类型一致
      offsets = {
        {
          filetype = 'neo-tree', -- 如果你用 Neo-tree
          text = 'File Explorer',
          text_align = 'left',
          separator = true,
        },
        {
          filetype = 'NvimTree', -- 如果你用 Nvim-tree
          text = 'File Explorer',
          text_align = 'left',
          separator = true,
        },
        {
          filetype = 'netrw', -- Neovim 自带的文件浏览器
          text = 'File Explorer',
          highlight = 'Directory',
          text_align = 'left',
          separator = true,
        },
      },

      indicator = { style = 'none' },
    },

    -- [修复1 & 3]：自定义高亮
    -- 针对你的浅色背景进行了高对比度调整
    highlights = {
      -- 1. 整个栏的填充背景 (浅灰)
      fill = {
        ctermbg = 254, -- 浅灰
        ctermfg = 235,
      },

      -- 2. 未选中的标签 (浅灰底，深灰字)
      background = {
        ctermbg = 254,
        ctermfg = 240, -- 深灰字
      },

      -- 3. 选中的标签 (黑底，白字 -> 强凸显)
      buffer_selected = {
        ctermbg = 0, -- 黑色背景
        ctermfg = 15, -- 白色文字
        bold = true,
        italic = false,
      },

      -- 4. 数字编号
      numbers = {
        ctermbg = 254,
        ctermfg = 240,
        italic = false,
      },
      numbers_selected = {
        ctermbg = 0, -- 跟随选中背景
        ctermfg = 15,
        bold = true,
        italic = false,
      },

      -- 5. 分割线 (隐形处理)
      separator = {
        ctermbg = 254,
        ctermfg = 254,
      },
      separator_selected = {
        ctermbg = 0, -- 必须和 buffer_selected 背景一致
        ctermfg = 254, -- 连接处的颜色
      },

      -- 6. 侧边栏标题区域
      offset_separator = {
        ctermbg = 254,
        ctermfg = 254,
      },
    },
  },
}

