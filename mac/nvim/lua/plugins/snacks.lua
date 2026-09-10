return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          win = {
            list = {
              keys = {
                -- <C-f>/<C-b> でツリーの展開・折りたたみ
                ["<C-f>"] = { "confirm", mode = { "n" } },
                ["<C-b>"] = { "explorer_close", mode = { "n" } },
              },
            },
          },
        },
      },
    },
  },
}
