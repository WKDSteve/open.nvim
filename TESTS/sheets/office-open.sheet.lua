-- Editing an Office document goes through open.nvim's `BufReadCmd`: the file goes to the system application through
-- `lib.nvim.cross.open_default` (`explorer.exe` / `open` / `xdg-open`) and the empty placeholder buffer is wiped. The
-- openers are recording stand-ins (TESTS/sheets/fixtures/openers.lua).
return {
  id = "open.office-open",
  feature = "open.office-open",
  task = "open.nvim/abnahme-system-oeffner-von-hand-fenster-gehen-wirklich-auf",
  title = "open.nvim: :edit report.docx hands the document to the system application and leaves no buffer behind",
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
      _G.O.write("report.docx", "PK\3\4")
      require("open").setup({})]],
      note = "the real setup (office_open is on by default) in a folder with report.docx",
    },
    { keys = ":edit report.docx<CR>", note = ":edit report.docx" },
    { wait = "#_G.O.calls() == 1", note = "one opener was started" },
    {
      expect = [[_G.O.last_arg():match("report%.docx$") ~= nil]],
      note = "the opener got the document",
    },
    {
      wait = [[vim.fn.bufnr("report.docx") == -1]],
      note = "the placeholder buffer is wiped",
    },
    { expect = [[_G.O.said("Opened externally")]], note = "the user is told it opened outside" },
  },
  judge = {},
  manual = {
    "Once in the real editor: :e on a .docx opens Word (or the registered app), the editor keeps its buffers",
  },
}
