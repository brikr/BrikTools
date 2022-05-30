BrikTools = LibStub("AceAddon-3.0"):NewAddon("BrikTools", "AceConsole-3.0")
local BrikTools = BrikTools

function BrikTools:OpenMainFrame()
  ShowMainFrame()
end

function BrikTools:OpenCreateWAFrame()
  ShowCreateWAFrame()
end

local function parseSlashCommand(arg)
  if arg == "wa" then
    ShowCreateWAFrame()
  else
    ShowMainFrame()
  end
end

function BrikTools:OnInitialize()
  self:RegisterChatCommand("brik", parseSlashCommand)
end
