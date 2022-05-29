local function tableToString(t, indent, done)
  if not t then
    return "nil"
  end

  done = done or {}
  indent = indent or 0
  local s = ""

  done[t] = true

  for key, value in pairs(t) do
    s = s .. string.rep("  ", indent)

    if type(value) == "table" and not done[value] then
      done[value] = true
      s = s .. key .. ":\n"

      s = s .. tableToString(value, indent + 2, done)
      done[value] = nil
    else
      s = s .. key .. "  =  " .. tostring(value) .. "\n"
    end
  end

  return s
end

function getfield(f)
  local v = _G    -- start with the table of globals
  for w in string.gmatch(f, "[%w_]+") do
    v = v[w]
  end
  return v
end

function Dumpy(inputBox, outputBox)
  local name = inputBox:GetText()
  local val = getfield(name)

  local s = ""
  if type(val) == "table" then
    s = tableToString(val)
  else
    s = tostring(val)
  end

  outputBox:SetText(s)
end

function DumpKeys(inputBox, outputBox)
  local name = inputBox:GetText()
  local val = getfield(name)

  local s = ""

  if type(val) == "table" then
    for key, _ in pairs(val) do
      s = s .. key .. "\n"
    end
  else
    s = tostring(val)
  end

  outputBox:SetText(s)
end
