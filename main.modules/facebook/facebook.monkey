'Copyright (c) <2012>, <Adam Fryman>
'All rights reserved.

'Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

'Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
'Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
'THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
'THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS 
'BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
'GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
'LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Import diddy
Global varAppID:String
Global varAppName:String
Global varAppURL:String
Global varAppLogo:String


Function FBWallPost(Caption:String,Message:String,Popup:Bool)

If varAppID <> "" Then 
Local lvarDisplayType:String
Local lvarMessage:String = Message.Replace(" ","%20")
If Popup = True Then lvarDisplayType="popup" Else lvarDisplayType = "page"
	LaunchBrowser("https://www.facebook.com/dialog/feed?app_id="+varAppID+"&link="+varAppURL+"&picture="+varAppLogo+"&name="+ varAppName + "&caption="+Caption+"&description="+lvarMessage+"&redirect_uri="+ varAppURL+"&display="+lvarDisplayType,Popup)
Else
	Error("FACEBOOK MODULE ERROR: Cannot send message, the fb application settings are incorrect")
EndIf
End Function

Function TwPost(twMessage:String, twURL:String, twPopup:Bool)
	
	Local fullURL:String = "http://www.addtoany.com/add_to/twitter?linkurl="+twURL+"&linkname="+twMessage+"&linknote="+twMessage+""
	fullURL.Replace(" ","%20")
	LaunchBrowser(fullURL, twPopup)
	
End

Function FBSetUpApp:int(AppID:String,AppName:String,AppLogoURL:String,AppURL:String)


'Sanitise AppID
If AppID.Length > 30 Then 
	Error("FACEBOOK MODULE WARNING: AppID is incorrect")
	Return 0
Else
	varAppID = AppID
EndIf

'Sanitise AppName
If AppName.Length > 60 Then
	Error("FACEBOOK MODULE WARNING: App name is too long")
	Return 0
Else
	varAppName = AppName.Replace(" ","%20")
	
EndIf
 'Sanitise Logo
if AppLogoURL.Contains(".gif") = True or AppLogoURL.ToLower.Contains(".png") = True or AppLogoURL.ToLower.Contains(".jpg") = True or AppLogoURL.ToLower.Contains(".jpeg") Then
	varAppLogo=AppLogoURL 
Else
	Error("FACEBOOK MODULE WARNING: The app logo must be a link to gif/jpg/png stored on the internet, all in lower case, it cannot be an image embedded in the app")
	Return 0
EndIf
' Sanitise App Url
if AppURL.ToLower.Contains("http://") = True or AppURL.ToLower.Contains("https://")Then
	varAppURL = AppURL
Else
	Error("FACEBOOK MODULE WARNING: The App url needs to be a web address, it also needs to be registered to your app on the facebook developers site")
	Return 0
EndIf



End Function

Function FBRequestPost(Message:String,Popup:Bool)
Local lvarDisplayType:String

If Popup = True Then lvarDisplayType="popup" Else lvarDisplayType = "page"
	LaunchBrowser("http://www.facebook.com/dialog/apprequests?app_id="+varAppID+"&message="+Message+"&redirect_uri="+varAppURL+"&display="+lvarDisplayType,Popup)
End Function

Function FBFriendRequest(FacebookID:String,Popup:Bool)
Local lvarDisplayType:String

If Popup = True Then lvarDisplayType="popup" Else lvarDisplayType = "page"
	LaunchBrowser("http://www.facebook.com/dialog/friends/?id="+FacebookID+"&app_id="+varAppID+"&redirect_uri="+varAppURL+"display="+lvarDisplayType,Popup)
End
Function FBLike()
  LaunchBrowser("http://www.facebook.com/plugins/like.php?href="+varAppUrl,True)
End
