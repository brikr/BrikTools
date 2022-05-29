function dump(t, indent, done)
  done = done or {}
  indent = indent or 0

  done[t] = true

  for key, value in pairs(t) do
    print(string.rep("\t", indent))

    if type(value) == "table" and not done[value] then
      done[value] = true
      print(key, ":\n")

      dump(value, indent + 2, done)
      done[value] = nil
    else
      print(key, "\t=\t", value, "\n")
    end
  end
end

_G["DumpTable"] = dump
