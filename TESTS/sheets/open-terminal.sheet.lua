-- The terminal key opens a terminal split (`:terminal`, the user's shell, a real process) in the directory of the
-- file under the cursor. Paths are compared resolved: on macOS `tempname()` lies under `/var`, `getcwd()` under
-- `/private/var`.
return {
  id = "open.terminal",
  feature = "open.terminal",
  task = "open.nvim/abnahme-system-oeffner-von-hand-fenster-gehen-wirklich-auf",
  title = "open.nvim: <leader>ot on a file name opens a terminal split in that file's folder",
  engine = "rpc",
  sizes = { { rows = 16, cols = 100 } },
  steps = {
    {
      lua = [[vim.opt.shortmess:append("I")
      vim.o.swapfile = false
      _G.dir = vim.fs.normalize(vim.fn.tempname())
      vim.fn.mkdir(_G.dir .. "/sub", "p")
      vim.fn.writefile({ "x" }, _G.dir .. "/sub/main.c")
      vim.cmd.cd(vim.fn.fnameescape(_G.dir))
      vim.g.mapleader = " "
      require("open").setup({ keymaps = { open_terminal = "<leader>ot" } })]],
      note = "the real setup with a terminal key, a folder with sub/main.c",
    },
    {
      lua = [[vim.api.nvim_buf_set_lines(0, 0, -1, false, { "Build sub/main.c first." })
      vim.bo.modified = false
      vim.api.nvim_win_set_cursor(0, { 1, 7 })]],
      note = "a line naming the file, the cursor on it",
    },
    { keys = " ot", note = "<leader>ot" },
    { wait = [[vim.bo.buftype == "terminal"]], note = "a terminal buffer is current" },
    { expect = [[#vim.api.nvim_list_wins() == 2]], note = "in a split" },
    {
      expect = [[vim.fn.jobpid(vim.bo.channel) > 0]],
      note = "the shell runs",
    },
    {
      expect = [[vim.uv.fs_realpath(vim.fn.getcwd(0)) == vim.uv.fs_realpath(_G.dir .. "/sub")]],
      note = "in the file's folder",
    },
    { input = "<C-\\><C-n>", note = "back to normal mode" },
  },
  judge = {},
  manual = {},
}
