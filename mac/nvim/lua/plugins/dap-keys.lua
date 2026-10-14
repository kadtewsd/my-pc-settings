return {
  "mfussenegger/nvim-dap",
  keys = {
    { "<F9>",    function() require("dap").continue() end,         desc = "Resume (IntelliJ F9)" },
    { "<F8>",    function() require("dap").step_over() end,        desc = "Step Over (F8)" },
    { "<F7>",    function() require("dap").step_into() end,        desc = "Step Into (F7)" },
    { "<S-F8>",  function() require("dap").step_out() end,         desc = "Step Out (Shift+F8)" },
    { "<A-F9>",  function() require("dap").run_to_cursor() end,    desc = "Run to Cursor (Alt+F9)" },
    { "<C-F8>",  function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint (Ctrl+F8)" },
    { "<C-F2>",  function() require("dap").terminate() end,        desc = "Stop (Ctrl+F2)" },
    { "<A-F8>",  function() require("dapui").eval() end, mode = { "n", "v" }, desc = "Evaluate (Alt+F8)" },
  },
}
