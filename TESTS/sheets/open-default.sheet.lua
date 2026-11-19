-- `:Open default` on a file name hands the file to the system default application through
-- `lib.nvim.cross.open_default`: `explorer.exe <absolute path>` on Windows, `open <path>` on macOS, `xdg-open <path>` on
-- Linux. The openers are recording stand-ins (TESTS/sheets/fixtures/openers.lua).
return {
  id = "open.default",
  feature = "open.default",
  task = "open.nvim/abnahme-system-oeffner-von-hand-fenster-gehen-wirklich-auf",
  title = "open.nvim: :Open default on a file name starts the system default application with that file",
  engine = "rpc",
  sizes = { { rows = 12, cols = 100 } },
  -- the starters this sheet can reach: Windows, macOS and Linux open through explorer / open / xdg-open; WSL
  -- (safety net, fixtures/openers.lua) through explorer.exe or rundll32.exe
  fakes = {
    "explorer",
    "open",
    "xdg-open",
    "explorer.exe",
    "rundll32.exe",
  },
  steps = {
    {
      lua = [[_G.O = dofile(vim.fn.getcwd() .. "/TESTS/sheets/fixtures/openers.lua")
      _G.O.prepare()
      _G.O.write("report.pdf", "%PDF-1.4\n")
      require("open").setup({})]],
      note = "the real setup in a folder with report.pdf, the openers are stand-ins",
    },
    {
      lua = [[_G.O.cursor_on("See report.pdf for the numbers.", "report.pdf")]],
      note = "a line naming the file, the cursor on it",
    },
    { keys = ":Open default<CR>", note = ":Open default" },
    { wait = "#_G.O.calls() == 1", note = "one opener was started" },
    {
      expect = [[_G.O.last_arg():match("report%.pdf$") ~= nil]],
      note = "the opener got the file under the cursor",
    },
    { expect = [[_G.O.said("report.pdf")]], note = "the user is told what was opened" },
  },
  judge = {},
  manual = {
    "Once in the real editor: :Open default on a PDF opens it in the registered PDF viewer",
  },
}
