-- `:Open notepad` on a word writes it to a temp file and starts the GUI text editor of the platform on it, through
-- `open.util.run_detached`: `notepad.exe <file>` on Windows, `open -e <file>` on macOS, the first of xdg-open, gedit,
-- kate ... on Linux. The editors are recording stand-ins (TESTS/sheets/fixtures/openers.lua).
return {
  id = "open.notepad",
  feature = "open.notepad",
  task = "open.nvim/abnahme-system-oeffner-von-hand-fenster-gehen-wirklich-auf",
  title = "open.nvim: :Open notepad on a word starts the GUI text editor on a temp file holding that word",
  engine = "rpc",
  sizes = { { rows = 12, cols = 100 } },
  -- the starters this sheet can reach: Windows notepad, macOS open -e, Linux xdg-open; WSL (safety net,
  -- fixtures/openers.lua) notepad.exe
  fakes = {
    "notepad",
    "open",
    "xdg-open",
    "notepad.exe",
  },
  steps = {
    {
      lua = [[_G.O = dofile(vim.fn.getcwd() .. "/TESTS/sheets/fixtures/openers.lua")
      _G.O.prepare()
      require("open").setup({})]],
      note = "the real setup, the editors are stand-ins",
    },
    {
      lua = [[_G.O.cursor_on("Copy the token Zebra42 into the form.", "Zebra42")]],
      note = "a line, the cursor on a word",
    },
    { keys = ":Open notepad<CR>", note = ":Open notepad" },
    { wait = "#_G.O.calls() == 1", note = "one editor was started" },
    {
      expect = [[_G.O.last_arg():match("%.txt$") ~= nil]],
      note = "the editor got a .txt temp file",
    },
    {
      expect = [[vim.fn.readfile(_G.O.last_arg())[1] == "Zebra42"]],
      note = "the temp file holds the word under the cursor",
    },
    { expect = [[_G.O.said("Opened temp file")]], note = "the user is told where the text went" },
  },
  judge = {},
  manual = {
    "Once in the real editor: :Open notepad on a word opens Notepad / TextEdit / the desktop editor with that word",
  },
}
