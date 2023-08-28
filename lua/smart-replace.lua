local M = {}
local MIXED_CASE = 1
local SNAKE_CASE = 2

local strsplit = function(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end

local action = {
  MIXED_CASE = function() end,
  SNAKE_CASE = function() end,
}

local FindCase = function(str)
  return MIXED_CASE
end

GetCurrentMatch = function()
  local match_start = vim.api.nvim_call_function("searchpos", {"", "n"})
  local match_end = vim.api.nvim_call_function("searchpos", {"", "neW"})
  local line = vim.api.nvim_call_function("getline", {match_start[1]})
  print(vim.inspect(match_start))
  print(vim.inspect(match_end))
  return vim.api.nvim_call_function("strpart", {line, match_start[2] - 1, match_end[2] - match_start[2] + 1})
end

local SearchPattern = function(pattern)
  vim.cmd("Abolish -search " .. pattern)
end

local NextMatch = function()
  local res = vim.api.nvim_call_function("searchcount", {})
  return res.total > 0
end

M.setup = function(opts)

end

replace = function(from, to, del, supported_cases) 
  del = del or ","
  supported_cases = supported_cases or ",_"
  local from_list = strsplit(from, del or ",")
  local to_list = strsplit(from, del or ",")

  local limit = 100
  while NextMatch() and limit > 0 do
    limit = limit - 1
  end
  
end

return M

