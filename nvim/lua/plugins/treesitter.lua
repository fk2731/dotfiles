return {
  'nvim-treesitter/nvim-treesitter',
  build = ":TSUpdate",
  conifg = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      auto_install = true,
      highligth = { enable = true },
      indent = { enable = true },
    })
  end
}
