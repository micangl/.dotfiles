set incsearch
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set autoindent
set number
set relativenumber
set cc=80
set noswapfile
set wildmode=longest,list
set signcolumn=yes:1
set termguicolors

lua <<EOF
  vim.g.mapleader = " "
  --Remaps stolen from ThePrimeagen
  vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
  vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
  vim.keymap.set("n", "<leader>Y", [["+Y]])
  --vim.keymap.set("i", "<C-s>", function() print(dump(require('cmp').get_selected_entry():get_word())) end)
  --vim.keymap.set("i", "<C-s>", require('cmp_vimtex').search.perform_search())
EOF

filetype plugin on
let g:vimtex_view_method = 'zathura'
"Disable buffer which shows warnings when compiling.
let g:vimtex_quickfix_enabled = 0

let g:srcery_bg = ['#000000', 0]
let g:srcery_undercurl = 1

call plug#begin()

Plug 'nvim-lualine/lualine.nvim'

Plug 'srcery-colors/srcery-vim'
"Plug '~/software/srcery-vim'
Plug 'folke/tokyonight.nvim'
Plug 'rebelot/kanagawa.nvim'
Plug 'NLKNguyen/papercolor-theme'

"Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }

Plug 'ThePrimeagen/vim-be-good'

Plug 'neovim/nvim-lspconfig'

"Plug '~/software/lspkind.nvim'
Plug 'onsails/lspkind.nvim'
Plug 'hrsh7th/nvim-cmp'
" Sources
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
"Plug '~/software/cmp-buffer'
"Plug 'hrsh7th/cmp-omni'
Plug '~/software/cmp-vimtex'

Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
"Plug 'SirVer/ultisnips'
"Plug 'quangnguyen30192/cmp-nvim-ultisnips'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.2' }
Plug 'nvim-telescope/telescope-fzf-native.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

"Plug 'lervag/vimtex', { 'commit': 'c67547f2269d55f7758e312bc5aba8dd85330f32' }
Plug 'lervag/vimtex'

call plug#end()

lua <<EOF
    --vim.keymap.set("i", "<C-s>", function() require('cmp_vimtex.search').perform_search({ engine = "arxiv", }) end)
    vim.keymap.set("i", "<C-s>", function() require('cmp_vimtex.search').search_menu() end)
EOF


"UltiSnips mappings
"let g:UltiSnipsExpandTrigger = "<tab>"
"let g:UltiSnipsJumpForwardTrigger = "<tab>"
"let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

"LuaSnip mappings
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>

set completeopt=menu,preview,menuone,noselect

lua <<EOF

  require('kanagawa').setup({
    overrides = function(colors)
        return {
            -- update kanagawa to handle new treesitter highlight captures
            ["@string.regexp"] = { link = "@string.regex" },
            ["@variable.parameter"] = { link = "@parameter" },
            ["@exception"] = { link = "@exception" },
            ["@string.special.symbol"] = { link = "@symbol" },
            ["@markup.strong"] = { link = "@text.strong" },
            ["@markup.italic"] = { link = "@text.emphasis" },
            ["@markup.heading"] = { link = "@text.title" },
            ["@markup.raw"] = { link = "@text.literal" },
            ["@markup.quote"] = { link = "@text.quote" },
            ["@markup.math"] = { link = "@text.math" },
            ["@markup.environment"] = { link = "@text.environment" },
            ["@markup.environment.name"] = { link = "@text.environment.name" },
            ["@markup.link.url"] = { link = "Special" },
            ["@markup.link.label"] = { link = "Identifier" },
            ["@comment.note"] = { link = "@text.note" },
            ["@comment.warning"] = { link = "@text.warning" },
            ["@comment.danger"] = { link = "@text.danger" },
            ["@diff.plus"] = { link = "@text.diff.add" },
            ["@diff.minus"] = { link = "@text.diff.delete" },
        }
    end,
    undercurl = true, -- enable undercurls
    colors = {
      theme = {
        all = {
          ui = {
            bg = 'black',
            bg_gutter = 'none',
            --fg = 'wheat',
          },
          syn = {
            --identifier = 'wheat',
          },
        },
      },
    },
  })

EOF

"colorscheme srcery
"colorscheme tokyonight-night
colorscheme kanagawa
"colorscheme PaperColor

highlight Normal guibg=black guifg=wheat

lua <<EOF

  require("tokyonight").setup({
    style = "night", -- "night" or "storm"
    on_highlight = function(highlights, colors)
    	highlights.DiagnosticUnderlineError.undercurl = true
    	highlights.DiagnosticUnderlineError.underline = false
    end,
  })

  require('lualine').setup {
    options = {
      icons_enabled = false,
      theme = 'kanagawa',
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = false,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      }
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {'filename'},
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
  }

  -- Diagnostic keymaps
  local opts = { noremap=true, silent=true }
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

  -- Lsp-specific keymaps
  local on_attach = function(client, bufnr)
    --To disable semantic tokens.
    --client.server_capabilities.semanticTokensProvider = nil
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    --vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
  end

  -- Add additional capabilities supported by nvim_cmp
  local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

  -- Setup nvim-cmp.
  local cmp = require'cmp'
  local lspkind = require('lspkind')

  local kind_icons = {
    Text = "",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰇽",
    Variable = "󰂡",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰅲",
  }  

  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
        --vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    formatting = {
      --format = lspkind.cmp_format({
      --  --mode = "symbol_text",
      --  mode = "symbol",
      --  menu = ({
      --    buffer = "[Buffer]",
      --    nvim_lsp = "[LSP]",
      --    luasnip = "[LuaSnip]",
      --    nvim_lua = "[Lua]",
      --    path = "[Path]",
      --    vimtex = "[Vimtex]",
      --  })
      --  --before = function(entry, vim_item)
      --  --  return vim_item
      --  --end
      --}),
      format = function(entry, vim_item)
        -- Truncate entries longer than MAX_LABEL_WIDTH characters.
        -- From https://github.com/hrsh7th/nvim-cmp/discussions/609#discussioncomment-1844480
        local MAX_LABEL_WIDTH = 80
        local label = vim_item.abbr
        local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
        if truncated_label ~= label then
          vim_item.abbr = truncated_label .. "…" 
        end

        vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)

        --if entry.source.name == "vimtex" then
        --    return vim_item
        --end
        vim_item.menu = ({
          buffer = "[Buffer]",
          nvim_lsp = "[LSP]",
          luasnip = "[LuaSnip]",
          nvim_lua = "[Nvim lua]",
          --vimtex = "[Vimtex]" .. (vim_item.menu ~= nil and vim_item.menu or ""),
          vimtex = vim_item.menu,
        })[entry.source.name]

        return vim_item
      end
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
      ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      --{ name = 'luasnip' },
      { name = 'nvim_lua' },
      { name = 'buffer' },
    }, {
      { name = 'path' },
    })
  })

  cmp.setup.cmdline({ '/', '?' }, {
    completion = {
      keyword_length = 5,
    },
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' },
    }
  })

  cmp.setup.cmdline(':', {
    completion = {
      keyword_length = 3,
    },
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' },
    }, {
      { name = 'cmdline' }
    })
  })

  require('cmp_vimtex').setup({
    --additional_information = {
    --  info_in_window = true,
    --},
    --bibtex_parser = {
    --  enabled = false,
    --},
    additional_information = {
        highlight_colors = {
            default_group = "RedrawDebugClear",
        },
    },
    search = {
      search_engines = {
        google = {
            name = "Google",
            get_url = require('cmp_vimtex').url_default_format("https://www.google.com/search?q=%s"),
        },
      },
    }
  })

  local servers = { 'clangd', 'pyright', 'lua_ls'}
  --local servers = { 'ccls', }
  for _, lsp in ipairs(servers) do
  require('lspconfig')[lsp].setup {
    -- The on_init function has been taken from https://github.com/neovim/nvim-lspconfig/issues/2542#issuecomment-1547019213
    -- Unfortunately, disabling semantic_tokens in the on_attach function causes errors when editing multiple files.
    --on_init = function(client, initialization_result)
    --  if client.server_capabilities then
    --    --client.server_capabilities.documentFormattingProvider = false
    --    --client.server_capabilities.semanticTokensProvider = false  -- turn off semantic tokens
    --  end
    --end,
    on_attach = on_attach,
    capabilities = capabilities,
  }
  end

  local builtin = require('telescope.builtin')
  vim.keymap.set('n','<leader>ff', builtin.find_files, {})
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
  vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
  vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

  require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "cpp", "lua", "markdown", "markdown_inline", "python", "vim" },
    sync_install = false,
    highlight = {
      enable = true,
      --disable = { "latex", "cmp_docs", "markdown"},
      disable = { "latex", "markdown"},
      --additional_vim_regex_highlighting = { "cmpvimtex", "markdown", },
      --additional_vim_regex_highlighting = { "markdown", },
      additional_vim_regex_highlighting = false,
      --additional_vim_regex_highlighting = true,
    },
  }

  --vim.g.markdown_fenced_languages = { "cmpvimtex", "c", "cpp"}
  --vim.g.markdown_fenced_languages = { "cmpvimtex", }

--require("luasnip.loaders.from_snipmate").lazy_load({paths = "./snippets"})

EOF
