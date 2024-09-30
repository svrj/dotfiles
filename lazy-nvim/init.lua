-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.autoindent = true
vim.opt.colorcolumn = { 80, 99, 120 }
vim.opt.cursorline = true
vim.opt.encoding = "utf-8"
vim.opt.expandtab = true
vim.opt.hlsearch = true
vim.opt.number = true
vim.opt.shiftwidth = 4
vim.opt.showmatch = true
vim.opt.spell = true
vim.opt.spelllang = { "en_us", "de_ch" }
vim.opt.tabstop = 4

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- add LazyVim and import its plugins
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
		{
			"nvim-treesitter/nvim-treesitter",
			version = false, -- last release is way too old and doesn't work on Windows
			build = ":TSUpdate",
			event = { "LazyFile", "VeryLazy" },
			lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
			init = function(plugin)
				-- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
				-- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
				-- no longer trigger the **nvim-treesitter** module to be loaded in time.
				-- Luckily, the only things that those plugins need are the custom queries, which we make available
				-- during startup.
				require("lazy.core.loader").add_to_rtp(plugin)
				require("nvim-treesitter.query_predicates")
			end,
			cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
			keys = {
				{ "<c-space>", desc = "Increment Selection" },
				{ "<bs>", desc = "Decrement Selection", mode = "x" },
			},
			opts_extend = { "ensure_installed" },
			opts = {
				highlight = { enable = true },
				indent = { enable = true },
				ensure_installed = {
					"bash",
					"c",
					"diff",
					"html",
					"javascript",
					"jsdoc",
					"json",
					"jsonc",
					"lua",
					"luadoc",
					"luap",
					"markdown",
					"markdown_inline",
					"printf",
					"python",
					"query",
					"regex",
					"toml",
					"tsx",
					"typescript",
					"vim",
					"vimdoc",
					"xml",
					"yaml",
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},
				textobjects = {
					move = {
						enable = true,
						goto_next_start = {
							["]f"] = "@function.outer",
							["]c"] = "@class.outer",
							["]a"] = "@parameter.inner",
						},
						goto_next_end = {
							["]F"] = "@function.outer",
							["]C"] = "@class.outer",
							["]A"] = "@parameter.inner",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[c"] = "@class.outer",
							["[a"] = "@parameter.inner",
						},
						goto_previous_end = {
							["[F"] = "@function.outer",
							["[C"] = "@class.outer",
							["[A"] = "@parameter.inner",
						},
					},
				},
			},
			---@param opts TSConfig
			config = function(_, opts)
				if type(opts.ensure_installed) == "table" then
					opts.ensure_installed = LazyVim.dedup(opts.ensure_installed)
				end
				require("nvim-treesitter.configs").setup(opts)
			end,
		},
		--[[
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			config = function()
				local configs = require("nvim-treesitter.configs")
				configs.setup({
					highlight = { enable = true },
					indent = { enable = true },
					incremental_selection = { enable = true },
					--ensure_installed = { "c", "c++", "go", "lua", "python", "rust", "vim"},
				})
			end,
		},
		]]

		-- better JSON for Vim
		{ "elzr/vim-json" },

		-- fugitive.vim: A Git wrapper so awesome, it should be illegal
		{ "tpope/vim-fugitive" },

		-- The monokai color scheme.
		{ "filfirst/Monota" },

		-- The falcon theme
		{ "fenetikm/falcon" },

		-- Everforest theme
		{ "sainnhe/everforest" },

		-- material theme
		{ "marko-cerovac/material.nvim" },

		-- The project source tree browser.
		{ "scrooloose/nerdtree" },

		-- A light and configurable statusline/tabline plugin for Vim
		--     {'itchyny/lightline.vim'},

		{
			"nvim-lualine/lualine.nvim",
			options = { theme = "ayu_dark" },
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "filename" },
				lualine_c = { "branch" },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactivate_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
		},

		-- The enhanced C++ syntax highlighting.
		{ "octol/vim-cpp-enhanced-highlight" },

		--     {'neoclide/coc.nvim', {'branch':'release'}},

		-- Check Python Syntax
		{ "vim-syntastic/syntastic" },

		-- Super Searching
		{ "kien/ctrlp.vim" },

		-- tmux navigation
		{ "christoomey/vim-tmux-navigator" },

		-- Nerd Commenting
		{ "scrooloose/nerdcommenter" },

		-- VimWiki
		{ "vimwiki/vimwiki" },

		-- Auto PEP8
		--     {'tell-k/vim-autopep8'},

		-- Python Black
		{ "psf/black", branch = "stable" },

		-- PEP 8 checking
		{ "nvie/vim-flake8" },

		-- Python Autocompletion
		{ "davidhalter/jedi-vim" },

		-- Python Indent
		{ "https://github.com/vim-scripts/indentpython.vim" },

		-- Markdown Preview
		{ "shime/vim-livedown" },

		-- Markdown Pandoc
		{ "vim-pandoc/vim-pandoc" },
		{ "vim-pandoc/vim-pandoc-syntax" },

		-- Latex Support
		--     {'lervag/vimtex'},
		--     {'sirver/ultisnips'},

		-- Pylint support
		{ "gryf/pylint-vim" },

		-- Copilot Support
		{ "github/copilot.vim" },

		{ "kovetskiy/vim-bash" },

		-- Nightfox Theme
		{ "EdenEast/nightfox.nvim" },

		-- Moonfly Theme
		{ "https://github.com/bluz71/vim-moonfly-colors" },

		-- Kanagawa Theme
		{ "https://github.com/rebelot/kanagawa.nvim" },

		-- Better syntax-highlighting for filetypes in vim
		{ "sheerun/vim-polyglot" },

		-- Python Docstring
		{ "https://github.com/pixelneo/vim-python-docstring" },

		-- Semantic Highlighting
		--{ "numirias/semshi", build = ":UpdateRemotePlugins" },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	--install = { colorscheme = { "habamax" } },
	install = { colorscheme = { "kanagawa-dragon" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})
