local gui = LibStub("AceGUI-3.0")

local frame
local old_CloseSpecialWindows

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

local function frameOnClose()
  gui:Release(frame)
  frame = nil
end

local function hideFrame()
  if frame then
    frame:Hide()
    return true
  end
  return false
end

local layouts = {
  abilityWithCooldown={
    label="Ability with cooldown/charges",
    controls={
      {
        label="Spell ID",
        key="spellId"
      }
    }
  },
  abilityWithCooldownAndAura={
    label="Ability with cooldown/charges and aura",
    controls={
      {
        label="Spell ID",
        key="spellId"
      },
      {
        label="Aura ID",
        key="auraId"
      }
    }
  }
}

local config = {}

local function redrawFrame(group, selectedGroup)
  print("selectedGroup", selectedGroup)

  group:ReleaseChildren()

  config.type = selectedGroup

  for _, control in ipairs(layouts[selectedGroup].controls) do
    local editBox = gui:Create("EditBox")
    editBox:SetLabel(control.label)
    editBox:SetCallback("OnEnterPressed", function(_, _, id) config[control.key] = id end)
    group:AddChild(editBox)
  end
end

function ShowCreateWAFrame()
  if not old_CloseSpecialWindows then
    old_CloseSpecialWindows = CloseSpecialWindows
    CloseSpecialWindows = function()
      local found = old_CloseSpecialWindows()
      return hideFrame() or found
    end
  end

  if not frame then
    frame = gui:Create("Frame")
    frame:ReleaseChildren()
    frame:SetTitle("Create WeakAura")
    frame:SetLayout("Fill")
    frame:SetCallback("OnClose", frameOnClose)
    frame:EnableResize(false)
    frame:SetWidth(300)

    local waTypeDropdownGroup = gui:Create("DropdownGroup")
    local list = {}
    for key, val in pairs(layouts) do
      list[key] = val.label
    end
    waTypeDropdownGroup:SetGroupList(list)
    waTypeDropdownGroup:SetGroup("abilityWithCooldown")
    waTypeDropdownGroup:SetFullWidth(true)
    waTypeDropdownGroup:SetDropdownWidth(272)
    frame:AddChild(waTypeDropdownGroup)

    waTypeDropdownGroup:SetCallback("OnGroupSelected", function(widget, _, key) redrawFrame(widget, key) end)
    redrawFrame(waTypeDropdownGroup, "abilityWithCooldown")
  end

  frame:Show()
end
