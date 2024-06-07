return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("todo-comments").setup {
      signs = true,
      keywords = {
        FIX = { icon = " ", color = "error" },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning" },
        PERF = { icon = " ", color = "hint" },
        NOTE = { icon = " ", color = "hint" },
      },
      colors = {
        error = { "LspDiagnosticsDefaultError", "ErrorMsg" },
        warning = { "LspDiagnosticsDefaultWarning", "WarningMsg" },
        info = { "LspDiagnosticsDefaultInformation", "Normal" },
        hint = { "LspDiagnosticsDefaultHint", "Comment" },
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        pattern = [[\b(KEYWORDS):]],
      },
    }
  end,
}
