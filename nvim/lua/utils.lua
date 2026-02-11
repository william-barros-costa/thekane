local M = {}

function M.Split(string, regex)
  print(string, regex)
  local result = {}
  for word in string.gmatch(string, regex) do
    table.insert(result, word)
  end
  return result
end

return M
