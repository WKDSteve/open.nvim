-- The browser key on an https link hands the URL to the system default browser: `explorer.exe <url>` on Windows,
-- `open <url>` on macOS, `xdg-open <url>` on Linux, spawned detached through lib.nvim's `run_detached`. The openers
-- are recording stand-ins (TESTS/sheets/fixtures/openers.lua): the sheet proves which program got which URL.
return {
  id = "open.browser",
  feature = "open.browser",
  title = "open.nvim: <leader>ob on an https link starts the default browser with that URL",
  engine = "rpc",
  sizes = { { rows = 12, cols = 100 } },
  fakes = { "explorer", "notepad", "powershell", "xdg-open", "open" },
  steps = {
    {
      lua = [[_G.O = dofile(vim.fn.getcwd() .. "/TESTS/sheets/fixtures/openers.lua")
      _G.O.prepare()
      vim.g.mapleader = " "
      require("open").setup({ keymaps = { open_browser = "<leader>ob" } })]],
      note = "the real setup with a browser key, the openers are stand-ins",
    },
    {
      lua = [[_G.O.cursor_on("The guide is at https://example.test/guide for now.", "https://")]],
      note = "a line with an https link, the cursor on it",
    },
    { keys = " ob", note = "<leader>ob" },
    { wait = "#_G.O.calls() == 1", note = "one opener was started" },
    {
      expect = [[_G.O.last_arg() == "https://example.test/guide"]],
      note = "the opener got the URL under the cursor",
    },
    {
      expect = [[_G.O.said("https://example.test/guide")]],
      note = "the user is told what was opened",
    },
  },
  judge = {},
  manual = {
    "Once in the real editor: <leader>ob on an https link opens the page in the default browser",
  },
}
