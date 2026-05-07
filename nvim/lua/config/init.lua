-- noice
local function myMiniView(pattern, kind)
	kind = kind or ""
	return {
		view = "mini",
		filter = {
			event = "msg_show",
			kind = kind,
			find = pattern,
		},
	}
end

require("noice").setup({
    messages = {
        view_search = "mini",
    },
    routes = {
        myMiniView("written"),
        {
            -- view = "notify",
            view = "virtualtext",
            filter = { event = "msg_showmode" },
        },
    },
})

-- fzf
require("fzf-lua").setup({ "fzf-vim" })

-- lualine
require("lualine").setup()

-- bufferline
require("bufferline").setup()

-- gitsigns
require('gitsigns').setup()

-- Language Server 
require('mason').setup()
require('mason-lspconfig').setup()

vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, bufopts)
vim.keymap.set('n', '<leader>in', vim.lsp.buf.incoming_calls, bufopts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)

-- Set up nvim-cmp.
local cmp = require'cmp'
local lspkind = require('lspkind')
cmp.setup({
formatting = {
  format = lspkind.cmp_format({
    mode = 'symbol', -- show only symbol annotations
    maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
    ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

    -- The function below will be called before any actual modifications from lspkind
    -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
    before = function (entry, vim_item)
      return vim_item
    end
  })
},
snippet = {
   -- REQUIRED - you must specify a snippet engine
   expand = function(args)
     vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
   end,
 },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    -- { name = 'vsnip' },
  }, {
    { name = 'buffer' },
      }, {
          { name = 'path' },
      })
})

require("trouble").setup()

require("fidget").setup{}
local lspsaga = require 'lspsaga'
lspsaga.setup { -- defaults ...
  debug = false,
  use_saga_diagnostic_sign = true,
  -- diagnostic sign
  error_sign = "",
  warn_sign = "",
  hint_sign = "",
  infor_sign = "",
  diagnostic_header_icon = "   ",
  -- code action title icon
  code_action_icon = " ",
  code_action_prompt = {
    enable = true,
    sign = true,
    sign_priority = 40,
    virtual_text = true,
  },
  finder_definition_icon = "  ",
  finder_reference_icon = "  ",
  max_preview_lines = 10,
  finder_action_keys = {
    open = "o",
    vsplit = "s",
    split = "i",
    quit = "q",
    scroll_down = "<C-f>",
    scroll_up = "<C-b>",
  },
  code_action_keys = {
    quit = "q",
    exec = "<CR>",
  },
  rename_action_keys = {
    quit = "<C-c>",
    exec = "<CR>",
  },
  definition_preview_icon = "  ",
  border_style = "single",
  rename_prompt_prefix = "➤",
  rename_output_qflist = {
    enable = false,
    auto_open_qflist = false,
  },
  server_filetype_map = {},
  diagnostic_prefix_format = "%d. ",
  diagnostic_message_format = "%m %c",
  highlight_prefix = false,
}

local map = vim.api.nvim_buf_set_keymap
map(0, "n", "gr", "<cmd>Lspsaga rename<cr>", {silent = true, noremap = true})
map(0, "n", "<leader>pd", "<cmd>Lspsaga preview_definition<cr>", {silent = true, noremap = true})
map(0, "n", "K",  "<cmd>Lspsaga hover_doc<cr>", {silent = true, noremap = true})
map(0, "n", "<leader>lf",  "<cmd>Lspsaga lsp_finder<cr>", {silent = true, noremap = true})
vim.keymap.set("n", "<leader>rr", vim.lsp.buf.rename)

---- DAP
  require'dapui'.setup()
  require'dap-go'.setup()
  require'dap'.listeners.before['event_initialized']['custom'] = function(session, body)
    require'dapui'.open()
  end
  require'dap'.listeners.before['event_terminated']['custom'] = function(session, body)
    require'dapui'.close()
end
  Dap = {}
  Dap.vim_test_strategy = {
    go = function(cmd)
      local test_func = string.match(cmd, "-run '([^ ]+)'")
      local path = string.match(cmd, "[^ ]+$")
      path = string.gsub(path, "/%.%.%.", "")
      configuration = {
        type = "go",
        name = "nvim-dap strategy",
        request = "launch",
        mode = "test",
        program = path,
        args = {},
      }
      if test_func then
        table.insert(configuration.args, "-test.run")
        table.insert(configuration.args, test_func)
      end

      if path == nil or path == "." then
        configuration.program = "./"
      end
      return configuration
    end,
  }
  function Dap.strategy()
    local cmd = vim.g.vim_test_last_command
    local filetype = vim.bo.filetype
    local f = Dap.vim_test_strategy[filetype]

    if not f then
      print("This filetype is not supported.")
      return
    end

    configuration = f(cmd)
    require'dap'.run(configuration)
  end

-- toggleterm
require("toggleterm").setup{}

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
	cmd = "lazygit",
	direction = "float",
	hidden = true
})
function _lazygit_toggle()
	lazygit:toggle()
end
vim.api.nvim_set_keymap("n", "lg", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })

-- NoNeckPain  
require("no-neck-pain").setup({
    width = 150,
})

-- -- cmp
-- `:` cmdline setup.
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
            {
                name = 'cmdline',
                option = {
                    ignore_cmds = { 'Man', '!' }
                }
            }
        },
        {
            { name = 'buffer' }
        }
    )
})

-- `/` cmdline setup.
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- appearance
vim.cmd [[ colorscheme nightfox ]]
vim.cmd [[ highlight! link WinSeparator Comment  ]]
vim.cmd [[ hi CursorLineNr guibg=none guifg=Cyan ]]
vim.opt.cursorline = true
vim.opt.laststatus = 3
vim.opt.hls = true
vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes'

-- Fern
vim.keymap.set('n', '<C-n>', '<CMD>Fern . -reveal=% -drawer -toggle -width=45<CR>')
vim.g.fern_disable_startup_warnings = 1
vim.g['fern#default_hidden'] = 1
vim.g['fern#renderer'] = "nerdfont"

-- easymotion
vim.keymap.set('n', '<Leader>w', '<Plug>(easymotion-bd-w)')
vim.keymap.set('n', '<Leader>f', '<Plug>(easymotion-bd-f)')
vim.keymap.set('n', '<Leader>l', '<Plug>(easymotion-bd-jk)')

-- common
vim.opt.clipboard = "unnamed,unnamedplus"
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}
if vim.env.TMUX ~= nil then
  local copy = {'tmux', 'load-buffer', '-w', '-'}
  local paste = {'bash', '-c', 'tmux refresh-client -l && sleep 0.05 && tmux save-buffer -'}
  vim.g.clipboard = {
    name = 'tmux',
    copy = {
      ['+'] = copy,
      ['*'] = copy,
    },
    paste = {
      ['+'] = paste,
      ['*'] = paste,
    },
    cache_enabled = 0,
  }
end
vim.opt.mouse = "a"
vim.keymap.set('i', 'jj', '<Esc>', { silent = true })

-- よくわからないファイルたち
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- case
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.infercase = true

-- split
vim.opt.splitright = true
vim.opt.splitbelow = true

-- tab
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- line number
vim.opt.relativenumber = true
vim.opt.number = true

-- markdownpreview
vim.g.mkdp_open_to_the_world = 1
vim.g.mkdp_auto_start = 0
vim.g.mkdp_port = '7777'
vim.g.mkdp_echo_preview_url = 1

-- toggleterm
vim.keymap.set('n', '<Leader>tt', '<CMD>ToggleTerm direction=float<CR>')

-- Python
vim.g.python3_host_prog = '/usr/bin/python3'

-- bufferline
vim.keymap.set('n', '<Tab>', '<CMD>BufferLineCycleNext<CR>', { silent = true })
vim.keymap.set('n', '<S-Tab>', '<CMD>BufferLineCyclePrev<CR>', { silent = true })
vim.keymap.set('n', '<Tab>', '<CMD>BufferLineCycleNext<CR>', { silent = true })
-- 
-- terminal ESC
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

-- xxd integration (binary editor)
vim.api.nvim_create_user_command('Hex', ':%!xxd', {});
vim.api.nvim_create_user_command('Bin', ':%!xxd -r', {});
