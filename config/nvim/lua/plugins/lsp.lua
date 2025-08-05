return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        intelephense = {
          settings = {
            intelephense = {
              files = {
                exclude = {
                  "html/wp-content/plugins/**",
                },
                maxSize = 500000,
              },
            },
          },
        },
      },
    },
  },
}
