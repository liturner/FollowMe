

local addonName, addon = ...;

FollowMe = {}
FollowMe.Globals = {}
FollowMe.Globals.CommsPrefix = addonName;
--FollowMe.Globals.PLAYER_NAME = UnitName("player") --removed this to protect against data not being ready on login

FollowMe.i13n = {}

local Locales = {
	deDE = {
		Command = "/folgemir",
		Title = "Folge Mir!",
		Description = "Dieses Addon ermöglicht das '/folgemir' Kommando. Es wird verwendet, um einem anderen Charakter zu sagen, dass er dir folgen soll. Der Befehl eignet sich perfekt für den Fall, dass ein Mitglied deines Teams für einige Minuten im echten Leben weg muss. Solange das Teammitglied und du dieses Addon besitzen, kannst du die Wartezeit verhindern oder auch, dass du deinen Freund zurücklassen musst.\n\nSelbstverständlich funktioniert das Kommando nur in aktiven Gruppen, sodass du nicht von Fremden genervt werden kannst.",
		ControlsSubTitle = "Steuerung",
		ControlsText = "Unabhängig von der Sprache, die du verwendest, kann jedes der folgenden Kommandos einen anderen 'Folge Mir!' Benutzer instruieren, dir zu folgen:\n\n/folgemir [SPIELER_NAME]\n/followme [SPIELER_NAME]",
		
		TargetFrameMenuStartFollow = "Start following",
		TargetFrameMenuEndFollow = "End following",
	},
	enUS = {
		Command = "/followme",
		Title = "Follow Me!",
		Description = "This Addon implements the '/followme' command. This command is used to tell a charachter they must follow you. Perfect for the case you realise that a team member is away for a few minutes because his IRL baby is crying... As long as the team member and you have this addon, you can prevent either waiting ten minutes, or leaving your friend behind.\n\nThe command of course only works within active groups, so you cannot just be terrorised by randomers!",
		ControlsSubTitle = "Controls",
		ControlsText = "Regardless of your clients interface language, any of the following commands can be used to instruct another 'Follow Me!' user to follow you:\n\n/followme [PLAYER_NAME]\n/folgemir [PLAYER_NAME]",

		TargetFrameMenuStartFollow = "Start following",
		TargetFrameMenuEndFollow = "End following",
	},
}


FollowMeMixin = {}
function FollowMeMixin:OnLoad()

	self:RegisterEvent('CHAT_MSG_ADDON')

	FollowMe.i13n = Locales[GetLocale()] or Locales.enUS;

	self.header.title:SetText(FollowMe.i13n.Title)
	self.content.subTitle:SetText(FollowMe.i13n.ControlsSubTitle)
	self.content.description:SetText(FollowMe.i13n.Description)
	self.content.controlsText:SetText(FollowMe.i13n.ControlsText)

	local category, layout = Settings.RegisterCanvasLayoutCategory(self, addonName, addonName);
	category.ID = addonName;
	Settings.RegisterAddOnCategory(category)

	SLASH_FOLLOWME1 = "/followme"
	SLASH_FOLLOWME2 = "/folgemir"
	
	SlashCmdList["FOLLOWME"] = function(msg)
		self:SlashCommand(msg, editbox)
	end
	
	C_ChatInfo.RegisterAddonMessagePrefix(FollowMe.Globals.CommsPrefix)

	Menu.ModifyMenu("MENU_UNIT_PLAYER", function(owner, rootDescription, contextData)
        rootDescription:CreateDivider();
        rootDescription:CreateTitle(addonName);
        rootDescription:CreateButton(FollowMe.i13n.TargetFrameMenuStartFollow, function()
			C_ChatInfo.SendAddonMessage(FollowMe.Globals.CommsPrefix, UnitName("player"), "WHISPER", contextData.name)
		end);
    end);
	
end

function FollowMeMixin:SlashCommand(msg, editbox)
	C_ChatInfo.SendAddonMessage(FollowMe.Globals.CommsPrefix, UnitName("player"), "WHISPER", msg)
end

function FollowMeMixin:OnEvent(event, ...)
	if self[event] then
		self[event](self, ...)
	end
end

function FollowMeMixin:CHAT_MSG_ADDON(...)
	local prefix, message, channel, sender, target = ...;
	if prefix == FollowMe.Globals.CommsPrefix then
		if IsInGroup(message) then
			FollowUnit(message)
		end
	end
end