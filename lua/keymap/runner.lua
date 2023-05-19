local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback
require("keymap.helpers")

local _code_runner_command = {
  ["c"] = "clang % -O2 -o %:r; ./%:r",
  ["cpp"] = "clang++ % -O2 -o %:r; ./%:r",
  ["python"] = "python3 %",
}

function _G:RunCode()
  vim.cmd("write")
  local cmd = _code_runner_command[vim.bo.filetype]
  if cmd == nil then
    cmd = string.format("\\# Filetype %s is not supported", vim.bo.filetype)
  else
    cmd = vim.fn.expandcmd(cmd)
  end
  vim.cmd(string.format(
    [[
      ToggleTerm direction="vertical"
      TermExec direction="vertical" cmd="%s" go_back=0
    ]],
    cmd
  ))
end

local plug_map = {
  ["n|<S-F5>"] = map_cr([[execute v:count . "lua RunCode()"]])
    :with_noremap()
    :with_silent()
    :with_desc("Run code in vertical terminal"),
  ["i|<S-F5>"] = map_cmd("<Esc><Cmd>lua RunCode()<CR>")
    :with_noremap()
    :with_silent()
    :with_desc("Run code in vertical terminal"),
}

bind.nvim_load_mapping(plug_map)
