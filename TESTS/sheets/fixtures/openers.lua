-- TESTS/sheets/fixtures/openers.lua -- shared setup of the feature sheets that hand something to the system.
--
-- The system openers of every platform are recording stand-ins (`fakes`): explorer and notepad (Windows), powershell
-- (the Windows file-manager raise of lib.nvim), xdg-open (Linux), open (macOS). A sheet proves which program got which
-- argument, never that a window came up; that stays a `manual` line.
--
-- Loaded by a `lua` step with `dofile`. Nothing here starts a process: the starts come from the plugin's own lines,
-- which `testing perf` then names as the callers.
local M = {}

M.programs = { "explorer", "notepad", "powershell", "xdg-open", "open" }

---Quiet messages, the Windows stand-in workaround, and a fresh folder as the working directory.
---@return string dir
function M.prepare()
  vim.opt.shortmess:append("I")
  vim.o.ruler = false
  vim.o.showcmd = false
  vim.o.swapfile = false
  if vim.fn.exists("+messagesopt") == 1 then vim.o.messagesopt = "wait:0,history:500" end
  if vim.fn.has("win32") == 1 then
    local path = vim.fn.getcwd() .. "/TESTS/sheets/fixtures/windows_stand_in_argv.lua"
    assert(load(table.concat(vim.fn.readfile(path), "\n"), "=windows stand-in argv"))(M.programs)
  end
  local dir = vim.fs.normalize(vim.fn.tempname())
  vim.fn.mkdir(dir, "p")
  vim.cmd.cd(vim.fn.fnameescape(dir))
  return dir
end

---Write `text` to `name` below the working directory.
---@param name string
---@param text string
function M.write(name, text)
  local f = assert(io.open(name, "wb"))
  f:write(text)
  f:close()
end

---One line in the current buffer, the cursor on `word`.
---@param line string
---@param word string
function M.cursor_on(line, word)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { line })
  vim.bo.modified = false
  vim.api.nvim_win_set_cursor(0, { 1, (line:find(word, 1, true)) - 1 })
end

---Every recorded call of the stand-ins, in program order.
---@return { program: string, argv: string[] }[]
function M.calls()
  local fp, out = require("testing.fake_programs"), {}
  for _, p in ipairs(M.programs) do
    for _, call in ipairs(fp.read(vim.env.TESTING_FAKES, p)) do
      out[#out + 1] = { program = p, argv = call.argv }
    end
  end
  return out
end

---The last argument of the one call, or an error naming what was called.
---@return string
function M.last_arg()
  local calls = M.calls()
  if #calls ~= 1 then error(#calls .. " calls: " .. vim.inspect(calls), 0) end
  local argv = calls[1].argv
  return argv[#argv] or ""
end

---Whether `:messages` holds `text`.
---@param text string
---@return boolean
function M.said(text)
  return vim.fn.execute("messages"):find(text, 1, true) ~= nil
end

return M
