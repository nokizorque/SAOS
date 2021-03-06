Accounts = {
	Login = {},
	Register = {}
}

function Accounts.Initialize()
	if not localPlayer:getData("account") then
		Accounts.Login.Window = guiCreateWindow(Core.ResX/2-200,Core.ResY/2-140,400,280,Utils.GetL10N("ACCOUNTS_TITLE"),false)
		guiWindowSetSizable(Accounts.Login.Window,false)
		Accounts.Login.UsernameLabel = guiCreateLabel(0,50,100,20,Utils.GetL10N("ACCOUNTS_USERNAME"),false,Accounts.Login.Window)
		guiLabelSetHorizontalAlign(Accounts.Login.UsernameLabel,"right")
		Accounts.Login.PasswordLabel = guiCreateLabel(0,100,100,20,Utils.GetL10N("ACCOUNTS_PASSWORD"),false,Accounts.Login.Window)
		guiLabelSetHorizontalAlign(Accounts.Login.PasswordLabel,"right")
		Accounts.Login.UsernameEdit = guiCreateEdit(110,45,250,30,"",false,Accounts.Login.Window)
		guiEditSetMaxLength(Accounts.Login.UsernameEdit,32)
		addEventHandler("onClientGUIAccepted",Accounts.Login.UsernameEdit,Accounts.ProcessLogin,false)
		Accounts.Login.PasswordEdit = guiCreateEdit(110,95,250,30,"",false,Accounts.Login.Window)
		guiEditSetMasked(Accounts.Login.PasswordEdit,true)
		addEventHandler("onClientGUIAccepted",Accounts.Login.PasswordEdit,Accounts.ProcessLogin,false)
		local username,password = Accounts.LoadCache()
		guiSetText(Accounts.Login.UsernameEdit,username)
		guiSetText(Accounts.Login.PasswordEdit,password)
		Accounts.Login.RememberPassword = guiCreateCheckBox(110,135,250,30,Utils.GetL10N("ACCOUNTS_REMEMBER"),false,false,Accounts.Login.Window)
		guiCheckBoxSetSelected(Accounts.Login.RememberPassword,password ~= "")
		Accounts.Login.LoginButton = guiCreateButton(20,175,175,30,Utils.GetL10N("ACCOUNTS_LOGIN"),false,Accounts.Login.Window)
		addEventHandler("onClientGUIClick",Accounts.Login.LoginButton,Accounts.ProcessLogin,false)
		Accounts.Login.RegisterButton = guiCreateButton(205,175,175,30,Utils.GetL10N("ACCOUNTS_REGISTER"),false,Accounts.Login.Window)
		addEventHandler("onClientGUIClick",Accounts.Login.RegisterButton,function()
			guiSetVisible(Accounts.Login.Window,false)
			guiSetVisible(Accounts.Register.Window,true)
			guiBringToFront(Accounts.Register.UsernameEdit)
		end,false)
		Accounts.Login.RecoveryButton = guiCreateButton(20,225,360,30,Utils.GetL10N("ACCOUNTS_RECOVERY"),false,Accounts.Login.Window)
		guiSetEnabled(Accounts.Login.RecoveryButton,false)
		showCursor(true)
		showChat(false)
		addEventHandler("onClientRender",root,Accounts.RenderBackground)
		guiBringToFront(username ~= "" and Accounts.Login.PasswordEdit or Accounts.Login.UsernameEdit)
		
		Accounts.Register.Window = guiCreateWindow(Core.ResX/2-200,Core.ResY/2-150,400,300,Utils.GetL10N("ACCOUNTS_REGISTER_TITLE"),false)
		guiSetVisible(Accounts.Register.Window,false)
		guiWindowSetSizable(Accounts.Register.Window,false)
		Accounts.Register.UsernameLabel = guiCreateLabel(0,50,100,20,Utils.GetL10N("ACCOUNTS_USERNAME"),false,Accounts.Register.Window)
		guiLabelSetHorizontalAlign(Accounts.Register.UsernameLabel,"right")
		Accounts.Register.PasswordLabel = guiCreateLabel(0,100,100,20,Utils.GetL10N("ACCOUNTS_PASSWORD"),false,Accounts.Register.Window)
		guiLabelSetHorizontalAlign(Accounts.Register.PasswordLabel,"right")
		Accounts.Register.PasswordConfirmLabel = guiCreateLabel(0,150,100,20,Utils.GetL10N("ACCOUNTS_PASSWORD_CONFIRM"),false,Accounts.Register.Window)
		guiLabelSetHorizontalAlign(Accounts.Register.PasswordConfirmLabel,"right")
		Accounts.Register.EmailLabel = guiCreateLabel(0,200,100,20,Utils.GetL10N("ACCOUNTS_EMAIL"),false,Accounts.Register.Window)
		guiLabelSetHorizontalAlign(Accounts.Register.EmailLabel,"right")
		Accounts.Register.UsernameEdit = guiCreateEdit(110,45,250,30,"",false,Accounts.Register.Window)
		guiEditSetMaxLength(Accounts.Login.UsernameEdit,32)
		Accounts.Register.PasswordEdit = guiCreateEdit(110,95,250,30,"",false,Accounts.Register.Window)
		guiEditSetMasked(Accounts.Register.PasswordEdit,true)
		Accounts.Register.PasswordConfirmEdit = guiCreateEdit(110,145,250,30,"",false,Accounts.Register.Window)
		guiEditSetMasked(Accounts.Register.PasswordConfirmEdit,true)
		Accounts.Register.EmailEdit = guiCreateEdit(110,195,250,30,"",false,Accounts.Register.Window)
		guiEditSetMaxLength(Accounts.Register.EmailEdit,64)
		Accounts.Register.RegisterButton = guiCreateButton(20,245,175,30,Utils.GetL10N("ACCOUNTS_REGISTER"),false,Accounts.Register.Window)
		addEventHandler("onClientGUIClick",Accounts.Register.RegisterButton,Accounts.ProcessRegistration,false)
		for k, v in ipairs({Accounts.Register.UsernameEdit,Accounts.Register.PasswordEdit,Accounts.Register.PasswordConfirmEdit,Accounts.Register.EmailEdit}) do
			addEventHandler("onClientGUIAccepted",v,Accounts.ProcessRegistration,false)
		end
		Accounts.Register.CancelButton = guiCreateButton(205,245,175,30,Utils.GetL10N("ACCOUNTS_CANCEL"),false,Accounts.Register.Window)
		addEventHandler("onClientGUIClick",Accounts.Register.CancelButton,function()
			guiSetVisible(Accounts.Register.Window,false)
			local username,password = Accounts.LoadCache()
			guiSetText(Accounts.Login.UsernameEdit,username)
			guiSetText(Accounts.Login.PasswordEdit,password)
			if username ~= "" then
				guiBringToFront(Accounts.Login.PasswordEdit)
			end
			guiCheckBoxSetSelected(Accounts.Login.RememberPassword,password ~= "")
			guiSetVisible(Accounts.Login.Window,true)
			for k, v in ipairs({Accounts.Register.UsernameEdit,Accounts.Register.PasswordEdit,Accounts.Register.PasswordConfirmEdit,Accounts.Register.EmailEdit}) do
				guiSetText(v,"")
			end
		end,false)
	end
end

function Accounts.ProcessLogin()
	if guiGetEnabled(Accounts.Login.LoginButton) then
		guiSetEnabled(Accounts.Login.LoginButton,false)
		guiSetEnabled(Accounts.Login.RegisterButton,false)
		triggerServerEvent("SAOS.Login",localPlayer,guiGetText(Accounts.Login.UsernameEdit),hash("sha512",guiGetText(Accounts.Login.PasswordEdit)))
		Accounts.UpdateCache()
	end
end

function Accounts.ProcessRegistration()
	if guiGetEnabled(Accounts.Register.RegisterButton) then
		for k, v in ipairs({Accounts.Register.UsernameEdit,Accounts.Register.PasswordEdit,Accounts.Register.PasswordConfirmEdit,Accounts.Register.EmailEdit}) do
			if guiGetText(v):gsub("[%s]",""):len() == 0 then
				Accounts.Error = Utils.GetL10N("ACCOUNTS_ERROR_FIELDS")
				Accounts.ErrorTick = getTickCount()
				return
			end
		end
		if guiGetText(Accounts.Register.PasswordEdit) ~= guiGetText(Accounts.Register.PasswordConfirmEdit) then
			Accounts.Error = Utils.GetL10N("ACCOUNTS_ERROR_PASSWORD_MATCH")
			Accounts.ErrorTick = getTickCount()
			return
		end
		if not guiGetText(Accounts.Register.EmailEdit):match("[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?") then
			Accounts.Error = Utils.GetL10N("ACCOUNTS_ERROR_EMAIL")
			Accounts.ErrorTick = getTickCount()
			return
		end
		guiSetEnabled(Accounts.Register.RegisterButton,false)
		guiSetEnabled(Accounts.Register.CancelButton,false)
		triggerServerEvent("SAOS.Register",localPlayer,guiGetText(Accounts.Register.UsernameEdit),hash("sha512",guiGetText(Accounts.Register.PasswordEdit)),guiGetText(Accounts.Register.EmailEdit))
	end
end

function Accounts.RenderBackground()
	dxDrawImage(0,0,Core.ResX,Core.ResY,"Accounts/Background.jpg")
	dxDrawRectangle(0,0,Core.ResX,Core.ResY,tocolor(0,0,0,100))
	dxDrawText("SAOS RPG",4,0,Core.ResX,Core.ResY/4+4,tocolor(0,0,0),2,"bankgothic","center","center")
	dxDrawText("SAOS RPG",0,0,Core.ResX,Core.ResY/4,tocolor(255,255,255),2,"bankgothic","center","center")
	if Accounts.Error then
		local timeDiff = getTickCount()-Accounts.ErrorTick
		dxDrawText(Accounts.Error,14,Core.ResY/4*3,Core.ResX-10,Core.ResY+4,tocolor(0,0,0,255-timeDiff/20),1.5,"bankgothic","center","center",false,true)
		dxDrawText(Accounts.Error,10,Core.ResY/4*3,Core.ResX-14,Core.ResY,tocolor(255,0,0,255-timeDiff/20),1.5,"bankgothic","center","center",false,true)
		if timeDiff >= 5000 then
			Accounts.Error = nil
			Accounts.ErrorTick = nil
		end
	else
		local playersText = string.format(Utils.GetL10N("ACCOUNTS_PLAYERS"),#getElementsByType("player"))
		dxDrawText(playersText,4,Core.ResY/4*3,Core.ResX,Core.ResY+4,tocolor(0,0,0),1.5,"bankgothic","center","center")
		dxDrawText(playersText,0,Core.ResY/4*3,Core.ResX,Core.ResY,tocolor(255,255,255),1.5,"bankgothic","center","center")
	end
end

function Accounts.LoginResult(result)
	if result == 1 then
		guiSetVisible(Accounts.Login.Window,false)
		showCursor(false)
		showChat(true)
		removeEventHandler("onClientRender",root,Accounts.RenderBackground)
	else
		Accounts.Error = result == 2 and Utils.GetL10N("ACCOUNTS_ERROR_CREDENTIALS") or Utils.GetL10N("ACCOUNTS_ERROR_UNKNOWN")
		Accounts.ErrorTick = getTickCount()
	end
	guiSetEnabled(Accounts.Login.LoginButton,true)
	guiSetEnabled(Accounts.Login.RegisterButton,true)
end
addEvent("SAOS.onLogin",true)
addEventHandler("SAOS.onLogin",root,Accounts.LoginResult)

function Accounts.RegistrationResult(result)
	if result == 1 then
		guiSetVisible(Accounts.Register.Window,false)
		guiSetText(Accounts.Login.UsernameEdit,guiGetText(Accounts.Register.UsernameEdit))
		Accounts.UpdateCache()
		guiSetVisible(Accounts.Login.Window,true)
		guiBringToFront(Accounts.Login.PasswordEdit)
		for k, v in ipairs({Accounts.Register.UsernameEdit,Accounts.Register.PasswordEdit,Accounts.Register.PasswordConfirmEdit,Accounts.Register.EmailEdit}) do
			guiSetText(v,"")
		end
	else
		Accounts.Error = result == 2 and Utils.GetL10N("ACCOUNTS_ERROR_EXISTS") or Utils.GetL10N("ACCOUNTS_ERROR_UNKNOWN")
		Accounts.ErrorTick = getTickCount()
	end
	guiSetEnabled(Accounts.Register.RegisterButton,true)
	guiSetEnabled(Accounts.Register.CancelButton,true)
end
addEvent("SAOS.onRegister",true)
addEventHandler("SAOS.onRegister",root,Accounts.RegistrationResult)

function Accounts.LoadCache()
	local file = XML.load("@cache.xml")
	if file then
		local usernameXML = xmlFindChild(file,"username",0)
		local passwordXML = xmlFindChild(file,"password",0)
		return usernameXML and xmlNodeGetValue(usernameXML) or "",passwordXML and xmlNodeGetValue(passwordXML) or ""
	end
	return "",""
end

function Accounts.UpdateCache()
	local file = XML.load("@cache.xml") or XML.create("@cache.xml","cache")
	if file then
		local usernameXML = xmlFindChild(file,"username",0) or xmlCreateChild(file,"username")
		xmlNodeSetValue(usernameXML,guiGetText(Accounts.Login.UsernameEdit))
		local passwordXML = xmlFindChild(file,"password",0)
		if guiCheckBoxGetSelected(Accounts.Login.RememberPassword) then
			if not passwordXML then
				passwordXML = xmlCreateChild(file,"password")
			end
			xmlNodeSetValue(passwordXML,guiGetText(Accounts.Login.PasswordEdit))
		else
			if passwordXML then
				xmlDestroyNode(passwordXML)
			end
		end
	end
	xmlSaveFile(file)
	file:destroy()
end