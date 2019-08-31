FollowMe = {}
FollowMe.Globals = {}
FollowMe.Globals.PLAYER_NAME = UnitName("player")

FollowMe.i13n = {}

FollowMe.StringTableDE = {}
FollowMe.StringTableDE.Title = "Folge Mir!"
FollowMe.StringTableDE.Description = "Sage Folge Mir! zu einem Freund, um  ihn dir in schwierigen Situationen oder ... folgen zu lassen "
FollowMe.StringTableDE.ControlsSubTitle = "Steuerung"
FollowMe.StringTableDE.ControlsText = "Lorem Ipsy"

FollowMe.StringTableEN = {}
FollowMe.StringTableEN.Title = "Follow Me!"
FollowMe.StringTableEN.Description = "This Addon implements the '/followme' command. This command is used to tell a charachter they must follow you. Perfect for the case you realise that a team member is away for a few minutes because his IRL baby is crying... As long as the team member and you have this addon, you can prevent either waiting ten minutes, or leaving your friend behind.\n\nThe command of course only works within active groups, so you cannot just be terrorised by randomers!"
FollowMe.StringTableEN.ControlsSubTitle = "Controls"
FollowMe.StringTableEN.ControlsText = "Regardless of your clients interface language, any of the following commands can be used to instruct another 'Follow Me!' user to follow you:\n\n/followme [PLAYER_NAME]\n/folgemir [PLAYER_NAME]"

function FollowMe.OnLoad(self)
	self:RegisterEvent('ADDON_LOADED')
	self:RegisterEvent('CHAT_MSG_ADDON')
	
	localInUse = GetLocale()
	
	if localInUse == deDE then
		FollowMe.i13n = FollowMe.StringTableDE
	else
		FollowMe.i13n = FollowMe.StringTableEN
	end
end

function FollowMe.OnEvent(self, event, ...) 
	if event == "CHAT_MSG_ADDON" then FollowMe.OnAddonMessage(self, unpack({...})) 
	elseif(event == "ADDON_LOADED") then FollowMe.OnAddonLoaded(self, unpack({...})) 
	end
end



function FollowMe.OnAddonMessage(self, prefix, message, channel, sender)
	FollowUnit(message)
end

function FollowMe.OnAddonLoaded(self, name, ...)
	if name == "FollowMe" then

		-- The "Main" panel is also the settings UI
		self.name = FollowMe.i13n.Title	
		self.refresh = function (self) FollowMe.OnOptionRefresh(self); end;
		self.okay = function (self) FollowMe.OK_Clicked(self); end;
		self.cancel = function (self) FollowMe.Cancel_Clicked(self); end;
		self.default = function (self) FollowMe.Default_Clicked(self); end;
		
		InterfaceOptions_AddCategory(self)
		
		SLASH_FOLLOWME1 = "/followme"
		SLASH_FOLLOWME2 = "/folgemir"
		
		SlashCmdList["FOLLOWME"] = function(msg)
			FollowMe.SlashCommand(self, msg, editbox)
		end
		
		 C_ChatInfo.RegisterAddonMessagePrefix("TTFM")
		
		self:UnregisterEvent("ADDON_LOADED")
	end	
end

function FollowMe.SlashCommand(self, msg, editbox)
	C_ChatInfo.SendAddonMessage("TTFM", FollowMe.Globals.PLAYER_NAME, "WHISPER", msg)
end


-- Options UI Functions
function FollowMe.OK_Clicked(self)

end

function FollowMe.Cancel_Clicked(self)
  
end

function FollowMe.Default_Clicked(self)

end

function FollowMe.OnOptionRefresh(self)
	
end