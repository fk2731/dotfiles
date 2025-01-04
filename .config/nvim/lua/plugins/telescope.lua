return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"mollerhoj/telescope-recent-files.nvim", --Rename a variable
		},
		config = function()
			require("telescope").load_extension("recent-files")
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<D-f>", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>R", builtin.lsp_references, {})
			vim.keymap.set("n", "<C-Space>", function()
				require("telescope").extensions["recent-files"].recent_files({})
			end, { noremap = true, silent = true })
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			-- This is your opts table
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			-- To get ui-select loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("ui-select")
		end,
	},
}
