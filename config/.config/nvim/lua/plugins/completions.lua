return {
	{
		"onsails/lspkind.nvim",
		config = function()
			require("lspkind").init({
				-- defines how annotations are shown
				-- default: symbol
				-- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
				mode = "symbol",

				-- default symbol map
				-- can be either 'default' (requires nerd-fonts font) or
				-- 'codicons' for codicon preset (requires vscode-codicons font)
				--
				-- default: 'default'
				preset = "codicons",

				-- override preset symbols
				--
				-- default: {}
				-- symbol_map = {
				--   Text = "󰉿",
				--   Method = "󰆧",
				--   Function = "󰊕",
				--   Constructor = "",
				--   Field = "󰜢",
				--   Variable = "󰀫",
				--   Class = "󰠱",
				--   Interface = "",
				--   Module = "",
				--   Property = "󰜢",
				--   Unit = "󰑭",
				--   Value = "󰎠",
				--   Enum = "",
				--   Keyword = "󰌋",

				--   Color = "󰏘",
				--   File = "󰈙",
				--   Reference = "󰈇",
				--   Folder = "󰉋",
				--   EnumMember = "",
				--   Constant = "󰏿",
				--   Struct = "󰙅",
				--   Event = "",
				--   Operator = "󰆕",
				--   TypeParameter = "",
				-- },
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			local luasnip = require("luasnip")

			require("luasnip.loaders.from_vscode").lazy_load()
			luasnip.filetype_extend("java", { "javadoc" })

			cmp.setup({
				--Snippet support
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				--How completion should be displayed
				completion = {
					competeopt = "menu,menuone,preview,noselect",
				},
				--How looks the menu
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				--Keymaps
				mapping = cmp.mapping.preset.insert({
					["<D-Space>"] = function(fallback)
						if cmp.visible() then
							cmp.close()
						else
							cmp.complete()
						end
					end,
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-e>"] = cmp.mapping.abort(),
				}),
				-- Where and how should cmp rank and find completions
				-- Order matters, cmp will provide lsp suggestions above all else
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "render-markdown" },
				}),
				--Format menu displayed
				formatting = {
					format = lspkind.cmp_format({
						ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
						show_labelDetails = true, -- show labelDetails in menu. Disabled by default
					}),
				},
			})

			--For completion when you press "/ or ?"
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			--For completion when you press ":"
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
					{ name = "cmdline" },
				}),
			})
		end,
	},
}
