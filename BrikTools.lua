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
    frame:SetWidth(500)
    -- frame:SetHeight(400)

    -- Test - Run a function in the test file
    local testBtn = gui:Create("Button")
    testBtn:SetText("Test")
    testBtn:SetCallback("OnClick", Test)
    testBtn:SetFullWidth(true)
    -- Add the button to the container
    frame:AddChild(testBtn)

    -- Dump - dump a table's contents into an edit box in this GUI
    local dumpBtn = gui:Create("Button")
    dumpBtn:SetText("Dump global variable")
    local dumpKeysBtn = gui:Create("Button")
    dumpKeysBtn:SetText("Dump global variable keys")
    local dumpInput = gui:Create("EditBox")
    dumpInput:SetText('BrikToolsDump')
    dumpInput:SetFullWidth(true)

    local dumpOutput = gui:Create("MultiLineEditBox")
    dumpOutput:SetLabel("Output")
    dumpOutput:SetFullWidth(true)
    dumpOutput:SetNumLines(10)

    dumpBtn:SetCallback("OnClick", function() Dumpy(dumpInput, dumpOutput) end)
    dumpKeysBtn:SetCallback("OnClick", function() DumpKeys(dumpInput, dumpOutput) end)
    frame:AddChild(dumpBtn)
    frame:AddChild(dumpKeysBtn)
    frame:AddChild(dumpInput)
    frame:AddChild(dumpOutput)
  end

  frame:Show()
end

function BrikTools:OnInitialize()
  self:RegisterChatCommand("brik", function() self:Open() end)
end
