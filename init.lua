-- SY's nvim config

-- Utils
local function kmap(mode, bind, action, opts)
	vim.keymap.set(mode, bind, action, opts)
end

local function nmap(bind, action, opts)
	kmap("n", bind, action, opts)
end

local function imap(bind, action, opts)
	kmap("i", bind, action, opts)
end

-- Colors
vim.o.background = "dark"

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.cursorline = false
vim.opt.expandtab = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.numberwidth = 6
vim.opt.preserveindent = true
vim.opt.scrolloff = 8
vim.opt.shiftwidth = 4
vim.opt.showbreak = "->"
vim.opt.smartcase = false
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.signcolumn = "no"
vim.opt.softtabstop = 4
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.visualbell = true
vim.opt.window = 4
vim.opt.inccommand = "split"

-- Keymaps

-- Keymaps:Splits
nmap("<leader>v", "<cmd>vsplit<CR>")
nmap("<leader>s", "<cmd>split<CR>")

-- Keymaps:Buffers
nmap("<s-h>", "<cmd>bprevious<CR>")
-- nmap("<s-l>", "<cmd>bnext<CR>")

-- Keymaps:Base
nmap("<leader>q", "<cmd>quit<CR>", { desc = "[Q]uit current window/pane/tab" })
nmap("<leader>w", "<cmd>write<CR>", { desc = "[W]rite current changes" })
nmap("<leader>c", "<cmd>bd<CR>", { desc = "[C]lose current buffer" })
nmap("<leader>l", "<cmd>Lazy<CR>", { desc = "Open [L]azy" })
imap("jj", "<Esc>")
nmap("<Esc>", "<cmd>nohlsearch<CR>")
nmap("<leader>e", "<cmd>Neotree toggle<CR>")

-- Keymaps:Disable arrows
nmap("<left>", "<cmd>echo 'Use h to go left!'<CR>")
nmap("<right>", "<cmd>echo 'Use l to go right!'<CR>")
nmap("<up>", "<cmd>echo 'Use k to go up!'<CR>")
nmap("<down>", "<cmd>echo 'Use j to go down!'<CR>")

-- Keymaps:Focus
nmap("<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
nmap("<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
nmap("<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
nmap("<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Keymaps:Diagnostics
nmap("[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
nmap("]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
nmap("ge", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
nmap("<leader>d", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Keymaps:Tabs
nmap("]b", "<cmd>tabnext<CR>")
nmap("[b", "<cmd>tabprev<CR>")

-- Keymaps:Transparency
nmap("<leader>tt", "<cmd>TransparentToggle<CR>")

-- Autocommands
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Lazy installation
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	"tpope/vim-sleuth",
	{ "numToStr/Comment.nvim", opts = {} },
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = true,
		opts = {
			terminal_colors = true, -- add neovim terminal colors
			undercurl = true,
			underline = true,
			bold = true,
			italic = {
				strings = true,
				emphasis = true,
				comments = true,
				operators = false,
				folds = true,
			},
			strikethrough = true,
			invert_selection = false,
			invert_signs = false,
			invert_tabline = false,
			invert_intend_guides = false,
			inverse = true, -- invert background for search, diffs, statuslines and errors
			contrast = "", -- can be "hard", "soft" or empty string
			palette_overrides = {},
			overrides = {},
			dim_inactive = false,
			transparent_mode = true,
		},
	},
	{
		"xiyaowong/transparent.nvim",
		opts = {
			groups = {
				"Normal",
				"NormalNC",
				"Comment",
				"Constant",
				"Special",
				"Identifier",
				"Statement",
				"PreProc",
				"Type",
				"Underlined",
				"Todo",
				"String",
				"Function",
				"Conditional",
				"Repeat",
				"Operator",
				"Structure",
				"LineNr",
				"NonText",
				"SignColumn",
				"CursorLine",
				"CursorLineNr",
				"StatusLine",
				"StatusLineNC",
				"EndOfBuffer",
			},
			extra_groups = {},
			exclude_groups = {},
		},
	},
	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			--  :Telescope help_tags
			-- Two important keymaps to use while in Telescope are:
			--  - Insert mode: <c-/>
			--  - Normal mode: ?
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      local function open_all_selected(prompt_bufnr)
        local picker = action_state.get_current_picker(prompt_bufnr)
        local selections = picker:get_multi_selection()

        actions.close(prompt_bufnr)

        if #selections == 0 then
          vim.cmd("edit " .. action_state.get_selected_entry().path)
          return
        end

        for _, entry in ipairs(selections) do
          vim.cmd("edit " .. entry.path)
        end
      end

			require("telescope").setup({
				defaults = {
					mappings = {
			      i = {
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
              ["<CR>"] = open_all_selected,
            },
            n = {
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
              ["<CR>"] = open_all_selected,
              ["q"] = actions.close,
            },
          },
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			-- See `:help telescope.builtin`
			local builtin = require("telescope.builtin")
			local actions = require("telescope.actions")

			vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live [G]rep" })
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			-- It's also possible to pass additional configuration options.
			--  See `:help telescope.builtin.live_grep()` for information about particular keys
			vim.keymap.set("n", "<leader>f/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			-- Shortcut for searching your Neovim configuration files
			vim.keymap.set("n", "<leader>fn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
			{ "j-hui/fidget.nvim", opts = {} },
			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					local builtin = require("telescope.builtin")
					map("gd", builtin.lsp_definitions, "Go to definition")
					map("gr", builtin.lsp_references, "Go to references")
					map("gI", builtin.lsp_implementations, "Go to implementation")
					map("<leader>rn", vim.lsp.buf.rename, "Rename")
					map("K", vim.lsp.buf.hover, "Rename")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
			local servers = {
				-- clangd = {},
				-- pyright = {},
				-- tsserver = {},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
			}
			require("mason").setup()
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
			},
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },
				mapping = cmp.mapping.preset.insert({

					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),

					["<C-y>"] = cmp.mapping.confirm({ select = true }),

					-- If you prefer more traditional completion keymaps,
					-- you can uncomment the following lines
					["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = false })
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
				},
			})
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{ -- Autoformat
		"stevearc/conform.nvim",
		lazy = false,
		opts = {
			notify_on_error = false,
			format_on_save = false,
			-- format_on_save = function(bufnr)
			-- 	local disable_filetypes = { c = true, cpp = true }
			-- 	return {
			-- 		timeout_ms = 500,
			-- 		lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
			-- 	}
			-- end,
			formatters_by_ft = {
				lua = { "stylua" },
			},
		},
	},
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.surround").setup()
			require("mini.statusline").setup({
				use_icons = vim.g.have_nerd_font,
			})
			require("mini.statusline").section_location = function()
				return "%2l:%-2v"
			end
		end,
	},
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {"html", "lua", "luadoc", "vim", "vimdoc"},
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = {endble = true},
    },
    config = function (_, opts)
      require("nvim-treesitter.install").prefer_git = true
      require("nvim-treesitter.configs").setup(opts)
    end
  },
  {
      "kdheepak/lazygit.nvim",
    	cmd = {
    		"LazyGit",
    		"LazyGitConfig",
    		"LazyGitCurrentFile",
    		"LazyGitFilter",
    		"LazyGitFilterCurrentFile",
    	},
      dependencies = {
          "nvim-lua/plenary.nvim",
      },
      keys = {
         { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
      },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
  },
  {"folke/tokyonight.nvim"},
  {
    "ojroques/nvim-osc52",
    opts = {
      max_length = 0,
      silent = false,
      trim=false,
    }
  },
})

local function yank_to_clipboard()
  if vim.v.event.operator == 'y' and vim.v.event.regname == '' then
    require('osc52').copy_register('"')
  end
end

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = yank_to_clipboard,
})


vim.cmd("colorscheme tokyonight")
-- vim: ts=2 sts=2 sw=2 et
