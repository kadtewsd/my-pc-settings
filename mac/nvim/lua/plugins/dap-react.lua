return {
  "mfussenegger/nvim-dap",
  opts = function()
    local dap = require("dap")
    for _, lang in ipairs({ "typescriptreact", "javascriptreact", "typescript", "javascript" }) do
      dap.configurations[lang] = dap.configurations[lang] or {}
      vim.list_extend(dap.configurations[lang], {
        {
          type = "pwa-chrome",
          request = "launch",
          name = "React: Launch Chrome (localhost:5173)",
          url = "http://localhost:5173", -- Vite は 5173、CRA は 3000
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
        },
        {
          type = "pwa-chrome",
          request = "attach",
          name = "React: Attach to Chrome (9222)",
          port = 9222,
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
        },
      })
    end
  end,
}
