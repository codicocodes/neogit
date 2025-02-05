local M = {}

local function array_wrap(lines)
  local array = "[" .. table.concat(lines, "\\n") .. "]"

  -- Remove trailing comma from last object in array
  array, _ = array:gsub(",]", "]")

  -- Remove escaped newlines from in-between objects
  array, _ = array:gsub("},\\n{", "},{")

  return array
end

---Escape any double-quote characters, or escape codes, in the body
---@param json_str string unparsed json
---@param field string The json key to escape the body for
local function escape_field(json_str, field)
  local pattern = ([[("%s":")(.-)(",")]]):format(field)

  json_str, _ = json_str:gsub(pattern, function(before, value, after)
    return table.concat({ before, vim.fn.escape(value, [[\"]]), after }, "")
  end)

  return json_str
end

local function raise_error(result, input)
  local msg = vim.split(result, " ")
  local char_index = tonumber(msg[#msg])

  error(
    "Failed to parse log json!: "
      .. result
      .. "\n"
      .. input:sub(char_index - 30, char_index - 1)
      .. "<"
      .. input:sub(char_index, char_index)
      .. ">"
      .. input:sub(char_index + 1, char_index + 30)
  )
end

---Decode a list of json formatted lines into a lua table
---@param lines table
---@param opts? table
---@return table
function M.decode(lines, opts)
  opts = opts or {}

  local json_array = array_wrap(lines)

  if opts.escaped_fields then
    for _, field in ipairs(opts.escaped_fields) do
      json_array = escape_field(json_array, field)
    end
  end

  local ok, result = pcall(vim.json.decode, json_array, { luanil = { object = true, array = true } })
  if not ok then
    raise_error(result, json_array)
  end

  return result
end

---Convert a lua table to json string. Trailing comma is added because the expectation
---is to use json.decode from this same module to parse the result.
---@param tbl table Key/value pairs to encode as json
---@return string
function M.encode(tbl)
  return string.format("%s,", vim.json.encode(tbl))
end

return M
