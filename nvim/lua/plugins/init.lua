return {
    "f-person/git-blame.nvim",
    "tpope/vim-surround",
    "jiangmiao/auto-pairs",
    "tpope/vim-repeat",
    "easymotion/vim-easymotion",
    "unblevable/quick-scope",
    "MunifTanjim/nui.nvim",
    "folke/noice.nvim",
    "rakr/vim-one",
    "EdenEast/nightfox.nvim",
    "nvim-lualine/lualine.nvim",
    "akinsho/bufferline.nvim",
    "lambdalisue/nerdfont.vim",
    "lambdalisue/glyph-palette.vim",
    "simeji/winresizer",
    "neovim/nvim-lspconfig",
    { "williamboman/mason.nvim"},
    { "williamboman/mason-lspconfig.nvim"},
    "nvim-tree/nvim-web-devicons",
    "folke/trouble.nvim",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "onsails/lspkind.nvim",
    "j-hui/fidget.nvim",
    "kkharji/lspsaga.nvim",
    "hrsh7th/cmp-vsnip",
    "hrsh7th/vim-vsnip",
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
    "leoluz/nvim-dap-go",
    "nvim-neotest/nvim-nio",
    "numToStr/Comment.nvim",
    "lewis6991/gitsigns.nvim",
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function () 
          local configs = require("nvim-treesitter.configs")

          configs.setup({
              sync_install = false,
              highlight = { enable = true },
              indent = { enable = true },  
            })
        end
    },
    {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
        -- calling `setup` is optional for customization
        require("fzf-lua").setup({})
        end
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
        vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
    {'akinsho/toggleterm.nvim', version = "*", config = true},
    -- Fern
    "lambdalisue/fern.vim",
    {
        "lambdalisue/fern-hijack.vim",
        dependencies = {  "lambdalisue/fern.vim" }
    },
    {
        "lambdalisue/fern-git-status.vim",
        dependencies = {  "lambdalisue/fern.vim" }
    },
    {
        "lambdalisue/fern-renderer-nerdfont.vim",
        dependencies = {  "lambdalisue/fern.vim" }
    },
    { "shortcuts/no-neck-pain.nvim", version = "*" },
    {
        "tversteeg/registers.nvim",
        cmd = "Registers",
        config = true,
        keys = {
            { "\"",    mode = { "n", "v" } },
            { "<C-R>", mode = "i" }
        },
        name = "registers",
    }
}

