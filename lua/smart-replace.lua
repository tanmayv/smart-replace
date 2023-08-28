local M = {}
local MIXED_CASE = "MIXED_CASE"
local SNAKE_CASE = "SNAKE_CASE" 

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
  MIXED_CASE = function(words)
    local str = table.concat(words, "=")
    return str:gsub("(%l)(%w*)", function(a, b) return a:upper()..b end):gsub("=", "")
  end,
  SNAKE_CASE = function(words)
    return table.concat(words, "_")
  end,
}

local FindCase = function(str)
  local snake_case = str:match("%l+[_%l*]*")
  if snake_case and #snake_case == #str then return SNAKE_CASE end
  local mixed_case = str:match("[%u%l*]+")
  if mixed_case and #mixed_case == #str then return MIXED_CASE end
  return nil
end

GetCurrentMatch = function(to_list)
  local match_start = vim.fn.searchpos("", "")
  local match_end = vim.fn.searchpos("", "ce")
  local line = vim.fn.getline(match_start[1])
  local match = vim.fn.strpart(line, match_start[2] - 1, match_end[2] - match_start[2] + 1)
  local case = FindCase(match)
  if action[case] then
    local replacement = action[case](to_list)
    line = line:gsub(match, replacement, 1)
    vim.fn.setline(match_start[1], line)
  end
end

local SearchPattern = function(pattern)
  vim.cmd("Abolish -search " .. pattern)
end

local NextMatch = function()
  local res = vim.fn.searchcount()
  return res.total > 0
end

M.setup = function(opts)

end

-- TanmayVijayvargiya tanmay_vijayvargiya
-- TanmayVijayvargiya tanmay_vijayvargiya
-- TanmayVijayvargiya tanmay_vijayvargiya

local R = function(range, from, to, del, supported_cases) 
  del = del or " "
  supported_cases = supported_cases or ",_"
  local from_list = strsplit(from, del)
  local to_list = strsplit(to, del)
  local search_pattern = table.concat(from_list, "{,_}")
  vim.cmd(range.."Abolish -search "..search_pattern)
  local limit = vim.fn.searchcount().total 
  while limit > 0 do
    local match = GetCurrentMatch(to_list)
    limit = limit - 1
  end
end

M.ReplaceVisual = function(from, to)
  R("'<'>", from, to)
end

M.ReplaceFile = function(from, to)
  R("%", from, to)
end

return M

