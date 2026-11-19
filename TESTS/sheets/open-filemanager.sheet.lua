-- The file-manager key on a folder name reveals it through `lib.nvim.cross.reveal_in_fm`: on Windows PowerShell runs
-- the raise script (`win_reveal.ps1 -Path <folder>`), on macOS `open <folder>`, on Linux the first manager on PATH
-- (`xdg-open <folder>`). A folder, not a file, so every platform takes its first launcher. The launchers are recording
-- stand-ins (TESTS/sheets/fixtures/openers.lua).
return {
  id = "open.filemanager",
  feature = "open.filemanager",
  title = "open.nvim: <leader>of on a folder name starts the system file manager on that folder",
  engine = "rpc",
  sizes = { { rows = 12, cols = 100 } },
  fakes = { "explorer", "notepad", "powershell", "xdg-open", "open" },
  steps = {
    {
      lua = [[_G.O = dofile(vim.fn.getcwd() .. "/TESTS/sheets/fixtures/openers.lua")
      _G.O.prepare()
      vim.fn.mkdir("notes-dir", "p")
      vim.g.mapleader = " "
      require("open").setup({ keymaps = { open_filemanager = "<leader>of" } })]],
      note = "the real setup with a file-manager key in a folder with notes-dir/",
    },
    {
      lua = [[_G.O.cursor_on("Drafts live in notes-dir until review.", "notes-dir")]],
      note = "a line naming the folder, the cursor on it",
    },
    { keys = " of", note = "<leader>of" },
    { wait = "#_G.O.calls() == 1", note = "one launcher was started" },
    {
      expect = [[_G.O.last_arg():match("notes%-dir[/\\]?$") ~= nil]],
      note = "the launcher got the folder under the cursor",
    },
    { expect = [[_G.O.said("notes-dir")]], note = "the user is told what was revealed" },
  },
  judge = {},
  manual = {
    "Once in the real editor: <leader>of on a file selects it in Explorer / Finder / the file manager, in front of the terminal",
  },
}
