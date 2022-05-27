local gui = LibStub("AceGUI-3.0")

BrikTools = LibStub("AceAddon-3.0"):NewAddon("BrikTools", "AceConsole-3.0")
local BrikTools = BrikTools

local frame

local function frameOnClose()
  gui:Release(frame)
  frame = nil
end

local old_CloseSpecialWindows

function BrikTools:Open()
  if not old_CloseSpecialWindows then
    old_CloseSpecialWindows = CloseSpecialWindows
    CloseSpecialWindows = function()
      local found = old_CloseSpecialWindows()
      if frame then
        frame:Hide()
        return true
      end
      return found
    end
  end

  if not frame then
    frame = gui:Create("Frame")
    frame:ReleaseChildren()
    frame:SetTitle("Brik Tools")
    frame:SetLayout("Flow")
    frame:SetCallback("OnClose", frameOnClose)
    frame:EnableResize(false)
    frame:SetWidth(200)
    frame:SetHeight(400)
    -- Create a button
    local btn = gui:Create("Button")
    -- btn:SetWidth(150)
    btn:SetText("Test")
    btn:SetCallback("OnClick", Test)
    -- Add the button to the container
    frame:AddChild(btn)
  end

  frame:Show()
end

function BrikTools:OnInitialize()
  self:RegisterChatCommand("brik", function() self:Open() end)
end
