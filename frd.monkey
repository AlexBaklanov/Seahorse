Strict

Import imp

Global friendDistance:Int = 10000
Global isFriendShown:Bool
Global isFriendWindowShown:Bool
Global friendName:String
Global isFriendDisable:Bool
Global friendImg:Image
Global friendX:Float
Global friendY:Float

Global friendFramesCount:Int = 3
Global friendFrame:Float
Global friendAnimSpeed:Float = .2

Global friendGreetingImg:Image

Global friendHeroPositionX:Float
Global friendHeroPositionY:Float

	'd888888b d8b   db d888888b d888888b 
	'  `88'   888o  88   `88'   `~~88~~' 
	'   88    88V8o 88    88       88    
	'   88    88 V8o88    88       88    
	'  .88.   88  V888   .88.      88    
	'Y888888P VP   V8P Y888888P    YP   

Function FriendInit:Void()
	
	If CurrentLevel = 1 friendFramesCount = 3
	If CurrentLevel = 2 friendFramesCount = 4
	If CurrentLevel = 3 friendFramesCount = 7

	friendImg = LoadImage( "friend/friend0" + CurrentLevel + "" + loadadd + ".png", friendFramesCount, Image.MidHandle )

	If isFriendWindowShown = False

		friendGreetingImg = LoadImage( "friend/hello" + CurrentLevel + "" + loadadd + ".png", 1, Image.MidHandle )

	End

	friendX = -1000

	'not to reset X when friend is activated
	If isFriendShown = False
		friendX = dw + friendImg.Width()
	End
	friendY = dh/2

	Select CurrentLevel
		Case 1
			friendHeroPositionX = 10 * Retina
			friendHeroPositionY = 10 * Retina
			curFriendAnimSpd = .4
		Case 2
			friendHeroPositionX = 10 * Retina 
			friendHeroPositionY = 10 * Retina
			curFriendAnimSpd = .2
		Case 3
			friendHeroPositionX = 20 * Retina
			friendHeroPositionY = 30 * Retina
			curFriendAnimSpd = .2
	End

	If upgradeThe[3] > 0
		friendMode = True
	End

	globalFriend = upgradeThe[3]

	friendName = textID[CurrentLevel]

End

	'd8888b. d8888b.  .d8b.  db   d8b   db 
	'88  `8D 88  `8D d8' `8b 88   I8I   88 
	'88   88 88oobY' 88ooo88 88   I8I   88 
	'88   88 88`8b   88~~~88 Y8   I8I   88 
	'88  .8D 88 `88. 88   88 `8b d8'8b d8' 
	'Y8888D' 88   YD YP   YP  `8b8' `8d8'  

Function FriendMeetingDraw:Void()

	If isFriendShown And friendX > -friendImg.Width()

		DrawImage( friendImg, friendX, friendY, friendFrame )
		DrawImage( friendGreetingImg, friendX + friendGreetingImg.Width()/1.5, friendY - friendGreetingImg.Height()/1.5, 0, .8, .8 )

	End

End

	'db    db d8888b. d8888b.  .d8b.  d888888b d88888b 
	'88    88 88  `8D 88  `8D d8' `8b `~~88~~' 88'     
	'88    88 88oodD' 88   88 88ooo88    88    88ooooo 
	'88    88 88~~~   88   88 88~~~88    88    88~~~~~ 
	'88b  d88 88      88  .8D 88   88    88    88.     
	'~Y8888P' 88      Y8888D' YP   YP    YP    Y88888P

Global curFriendFrame:Float
Global curFriendAnimSpd:Float

Global startFriendAnim:Bool

Function FriendUpdate:Void()
	
	' First show
	If isFriendShown And friendX > -friendImg.Width() friendX -= speed * globalSpeed / 2 * Retina
	AnimateFirstShowFriend()
	
	' Friend update (anim)
	If startFriendAnim
		
		curFriendFrame += curFriendAnimSpd
		
		If curFriendFrame > Float(friendFramesCount) - curFriendAnimSpd curFriendAnimSpd = -curFriendAnimSpd
		
		If curFriendFrame < 0
			startFriendAnim = False
			curFriendFrame = 0
			curFriendAnimSpd = -curFriendAnimSpd
		End
		
	End
	
End

' .d8b.  d8b   db d888888b .88b  d88.  .d8b.  d888888b d88888b 
'd8' `8b 888o  88   `88'   88'YbdP`88 d8' `8b `~~88~~' 88'     
'88ooo88 88V8o 88    88    88  88  88 88ooo88    88    88ooooo 
'88~~~88 88 V8o88    88    88  88  88 88~~~88    88    88~~~~~ 
'88   88 88  V888   .88.   88  88  88 88   88    88    88.     
'YP   YP VP   V8P Y888888P YP  YP  YP YP   YP    YP    Y88888P 

Function AnimateFriend:Void()
	
	startFriendAnim = True
	curFriendFrame = 0
	If curFriendAnimSpd < 0 curFriendAnimSpd = -curFriendAnimSpd
	
End

Function AnimateFirstShowFriend:Void()

	friendFrame += friendAnimSpeed
	If friendFrame < 0 friendAnimSpeed = -friendAnimSpeed friendFrame = 0
	If friendFrame > friendFramesCount - friendAnimSpeed friendAnimSpeed = -friendAnimSpeed friendFrame = friendFramesCount + friendAnimSpeed

End

	'd8888b. d88888b d888888b d8b   db d888888b d888888b 
	'88  `8D 88'       `88'   888o  88   `88'   `~~88~~' 
	'88   88 88ooooo    88    88V8o 88    88       88    
	'88   88 88~~~~~    88    88 V8o88    88       88    
	'88  .8D 88.       .88.   88  V888   .88.      88    
	'Y8888D' Y88888P Y888888P VP   V8P Y888888P    YP    

Function DeinitFriend:Void()

	friendImg.Discard()

End

#Rem

Function ShowFriendWindow:Void()

	If isFriendShown = False And distance > friendDistance

		isFriendShown = True
		upgradeThe[3] = 3000
		SaveGame()

	End

	'If isFriendWindowShown = False And distance > friendDistance
	''	window.Init( ["Ok"], friendName + " unlocked! ", "With " + friendName + " you can swim longer! " )
	''	isFriendWindowShown = True
	''	isFriendShown = True
	''	SaveGame()
	'End

	'If winResult = 1 winResult = 0

End

#End


