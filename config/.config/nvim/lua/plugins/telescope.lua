return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mollerhoj/telescope-recent-files.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("recent-files")

      local builtin = require("telescope.builtin")

      vim.keymap.set("n", "<D-f>", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>fw", builtin.grep_string, {}) -- For file names
      vim.keymap.set("n", "<leader>h", builtin.help_tags, {})

      -- LSP options
      vim.keymap.set("n", "<leader>r", builtin.lsp_references, {})
      vim.keymap.set("n", "<leader>ds", builtin.lsp_document_symbols, {})
      vim.keymap.set("n", "<leader>ws", require("telescope.builtin").lsp_workspace_symbols, {})

      vim.keymap.set("n", "<C-Space>", function()
        require("telescope").extensions["recent-files"].recent_files({})
      end, { noremap = true, silent = true })

      vim.keymap.set("n", "<leader>fa", function()
        builtin.find_files({
          hidden = true,
        })
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
