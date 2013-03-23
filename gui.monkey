Strict

Import imp

Function GUIInit:Void()

	HealthInit()
	DistanceInit()
	pause_btn.Init("", "gameGUI/pause")
	
End

Function GUIDraw:Void()

	DrawPauseBtn()
	DrawHealth()
	DrawDistance()
	DrawCoins()
	DrawCoinsIndicator()
	'DrawIndicators()
	
End

Function GUIDeinit:Void()

	HealthDeinit()
	pause_btn.Deinit()
	
End

'db   db d88888b  .d8b.  db      d888888b db   db 
'88   88 88'     d8' `8b 88      `~~88~~' 88   88 
'88ooo88 88ooooo 88ooo88 88         88    88ooo88 
'88~~~88 88~~~~~ 88~~~88 88         88    88~~~88 
'88   88 88.     88   88 88booo.    88    88   88 
'YP   YP Y88888P YP   YP Y88888P    YP    YP   YP 


Global healthImg:Image

'INIT'

Function HealthInit:Void()

	healthImg = LoadImage("gameGUI/health"+loadadd+".png")

End

'DRAW'

Function DrawHealth:Void()

	Local hlth:Float = 1.0 - Float (health/-10.0)
	Local margin:Int = 0
	Local roll:Int = 5

	If health > 0
		
		DrawImageRect( 	healthImg,
						margin*Retina,
						margin*Retina,
						
						0,
						0,
						
						roll*Retina, 
						healthImg.Height() )
		
		
		DrawImageRect( 	healthImg, 
			
						roll + 	margin*Retina, 
						margin*Retina, 
						
						roll*Retina,
						0,
						
						health * Retina,
						healthImg.Height() )
		
		
		DrawImageRect( 	healthImg, 
			
						roll + 	margin*Retina+health*Retina,
						margin*Retina,
						
						healthImg.Width() - roll*Retina,
						0,
						
						roll*Retina,
						healthImg.Height() )
	
	Elseif health >= -10

		DrawImageRect( 	healthImg,
						margin*Retina + roll * (1 - hlth)*Retina,
						margin*Retina + roll * (1 - hlth)*Retina, 
						0,
						0,
						roll*Retina,
						healthImg.Height(),
						0, 
						hlth, 
						hlth )

		DrawImageRect( 	healthImg,  
						roll + 	margin*Retina, 
						margin*Retina + roll * (1 - hlth)*Retina, 
						healthImg.Width() - roll*Retina, 
						0, 
						roll*Retina, 
						healthImg.Height(), 
						0, 
						hlth, 
						hlth )

	End

End

'DEINIT'

Function HealthDeinit:Void()

	healthImg.Discard()

End

'd8888b. d888888b .d8888. d888888b  .d8b.  d8b   db  .o88b. d88888b 
'88  `8D   `88'   88'  YP `~~88~~' d8' `8b 888o  88 d8P  Y8 88'     
'88   88    88    `8bo.      88    88ooo88 88V8o 88 8P      88ooooo 
'88   88    88      `Y8b.    88    88~~~88 88 V8o88 8b      88~~~~~ 
'88  .8D   .88.   db   8D    88    88   88 88  V888 Y8b  d8 88.     
'Y8888D' Y888888P `8888Y'    YP    YP   YP VP   V8P  `Y88P' Y88888P 

Function DistanceInit:Void()

	If distance > distanceLast distanceLast = distance

End

Function DrawDistance:Void()

	Local dist:Int = Int(distance)

	Local distStr:String = String(dist/10) + "m"

	DrawFont( distStr, 15*Retina, fontH * Retina + healthImg.Height(), False, 100, 10.0 * Retina )

End

Function DistanceDidNotBecomeBetter:Bool()

	If distance < distanceLast Return True

	Return False

End

' .o88b.  .d88b.  d888888b d8b   db .d8888. 
'd8P  Y8 .8P  Y8.   `88'   888o  88 88'  YP 
'8P      88    88    88    88V8o 88 `8bo.   
'8b      88    88    88    88 V8o88   `Y8b. 
'Y8b  d8 `8b  d8'   .88.   88  V888 db   8D 
' `Y88P'  `Y88P'  Y888888P VP   V8P `8888Y' 

Function DrawCoins:Void()

	Local coinsStr:String = "|" + coinsGame

	Yellow()
	DrawFont (coinsStr, 10*Retina, fontH*2.5  * Retina + healthImg.Height(), False, 80 )
	White()
	
End

'd8888b.  .d8b.  db    db .d8888. d88888b 
'88  `8D d8' `8b 88    88 88'  YP 88'     
'88oodD' 88ooo88 88    88 `8bo.   88ooooo 
'88~~~   88~~~88 88    88   `Y8b. 88~~~~~ 
'88      88   88 88b  d88 db   8D 88.     
'88      YP   YP ~Y8888P' `8888Y' Y88888P 

Global pause_btn:Buttons = New Buttons
Global pause_Menu_btn:Buttons = New Buttons
Global pause_Resume_btn:Buttons = New Buttons

Global pausePolyPoints:Float[]

Global pauseMode:Bool

'INIT'
Function PauseInit:Void()

	If pauseMode = False And Mode = Game And alive

		pauseMode = True

		pause_Resume_btn.Init("Resume")
		pause_Menu_btn.Init("End the game")

		pausePolyPoints = [ Float(dw)/2 - 70*Retina, 
								Float(dh)/2 - 70*Retina, 
								Float(dw)/2 + 60*Retina, 
								Float(dh)/2 - 60*Retina, 
								Float(dw)/2 + 80*Retina, 
								Float(dh)/2 + 60*Retina, 
								Float(dw)/2 - 75*Retina, 
								Float(dh)/2 + 70*Retina ]

	End

End

'DRAW'

Function DrawPauseBtn:Void()

	If alive pause_btn.Draw( dw - pause_btn.Width, 0 )

End

Function DrawPause:Void()

	SetColor(0,0,0)
	SetAlpha(.6)

	DrawPoly( pausePolyPoints )

	SetAlpha(1)
	White()

	pause_Resume_btn.Draw 	( dw/2 - pause_Resume_btn.Width/2, 		dh/6*2 )
	pause_Menu_btn.Draw 	( dw/2 - pause_Menu_btn.Width/2, 		dh/6*3 )

	DrawTime()

End

'UPDATE'

Function PauseUpdate:String()

	If pause_Resume_btn.Pressed()
		PauseDeinit()
	End

	If pause_Menu_btn.Pressed()

		window.Init( ["Yes", "No"], "", "Are you sure?" )

	End

	If winResult = 1

		winResult = 0
		Return FromGameToShop()

	End

	Return Game

End

'DEINIT'

Function PauseDeinit:Void()

	pauseMode = False

	pause_Resume_btn.Deinit()
	pause_Menu_btn.Deinit()

End

'db   d8b   db d888888b d8b   db 
'88   I8I   88   `88'   888o  88 
'88   I8I   88    88    88V8o 88 
'Y8   I8I   88    88    88 V8o88 
'`8b d8'8b d8'   .88.   88  V888 
' `8b8' `8d8'  Y888888P VP   V8P 

Global toMenuBtn:Buttons = New Buttons
Global flare:Image
Global flareRotation:Float

Global winIcon:Image

'INIT'

Function WinInit:Void() 'initializes Win images, Win Activation see below '

	toMenuBtn.Init("Proceed")
	flare = LoadImage("flare.png", 1, Image.MidHandle)
	winIcon = LoadImage( "bgr/winIcon" + CurrentLevel + "" + loadadd + ".png", 1, Image.MidHandle )

	winMode = False

End

Function WinActivate:Void()' Activates Win Mode'

	winMode = True

	'alive = False
	speed = 0

	SaveGame()

End

'DRAW'

Function DrawWin:Void()

	DrawFadeBgr()

	DrawFont( "Congratulations!", dw/2, dh/4, True )

	Yellow()
	If CurrentLevel = 2
		DrawFont( "With the mask, you can swim", 	dw/2, dh/4*3, 						True, 70 )
		DrawFont( "longer under the water!", 		dw/2, dh/4*3 + fontH*.7 * Retina, 	True, 70 )
	End
	If CurrentLevel = 3
		DrawFont( "With the oxygen, you can", 		dw/2, dh/4*3, 						True, 70 )
		DrawFont( "swim even more longer!", 		dw/2, dh/4*3 + fontH*.7 * Retina, 	True, 70 )
	End
	If CurrentLevel = 4
		DrawFont( "You have found the sacred", 		dw/2, dh/4*3, 						True, 70 )
		DrawFont( "secret of your life!", 			dw/2, dh/4*3 + fontH*.7 * Retina, 	True, 70 )
	End
	White()

	SetBlend(1)
	DrawImage ( flare, dw/2, dh/2, flareRotation, Retina*4, Retina*4 )
	SetBlend(0)
	
	DrawImage ( winIcon, dw/2, dh/2 )

	toMenuBtn.Draw(dw/2 - toMenuBtn.Width/2, dh - toMenuBtn.Height)

End

'UPDATE'

Function WinUpdate:String()

	If toMenuBtn.Pressed()

		winMode = False
		If CurrentLevel = 4 CurrentLevel = 1

		WinDeinit()
		ResetForNextLevel()

		Return FromGameToMenu()

	End

	flareRotation += 1

	Return Game

End

'DEINIT'

Function WinDeinit:Void()

	flare.Discard()
	toMenuBtn.Deinit()
	winIcon.Discard()

End

'd888888b d888888b .88b  d88. d88888b 
'`~~88~~'   `88'   88'YbdP`88 88'     
'   88       88    88  88  88 88ooooo 
'   88       88    88  88  88 88~~~~~ 
'   88      .88.   88  88  88 88.     
'   YP    Y888888P YP  YP  YP Y88888P 

Function DrawTime:Void()

	Local hors:Int
	Local mins:Int
	Local secs:Int

	hors = globalTime/3600
	mins = (globalTime - hors*3600) / 60
	secs = globalTime - hors*3600 - mins*60

	Local horsS:String
	Local minsS:String
	Local secsS:String

	If hors < 10 horsS = "0"
	If mins < 10 minsS = "0"
	If secs < 10 secsS = "0"

	Local fullTimeStr:String = horsS+hors+":"+minsS+mins+":"+secsS+secs

	DrawFont( fullTimeStr, dw - fullTimeStr.Length()*fontKern*.7*Retina, dh - fontH * .7 - powersIcon.Height(), False, 70 )

End

'd888888b d8b   db d8888b. d888888b  .o88b.  .d8b.  d888888b  .d88b.  d8888b. .d8888. 
'  `88'   888o  88 88  `8D   `88'   d8P  Y8 d8' `8b `~~88~~' .8P  Y8. 88  `8D 88'  YP 
'   88    88V8o 88 88   88    88    8P      88ooo88    88    88    88 88oobY' `8bo.   
'   88    88 V8o88 88   88    88    8b      88~~~88    88    88    88 88`8b     `Y8b. 
'  .88.   88  V888 88  .8D   .88.   Y8b  d8 88   88    88    `8b  d8' 88 `88. db   8D 
'Y888888P VP   V8P Y8888D' Y888888P  `Y88P' YP   YP    YP     `Y88P'  88   YD `8888Y' 

Function IndicatorsInit:Void()

	If CurrentLevel > 1 maskGlobal = upgradeThe[5]
	If CurrentLevel > 2 oxygenGlobal = upgradeThe[6]

End

Function DrawIndicators:Void()

	Local mLength:Int = maskIndicator.Width() * (maskGlobal/upgradeThe[5])
	Local oLength:Int = oxygenIndicator.Width() * (oxygenGlobal/upgradeThe[6])

	If CurrentLevel > 1
		DrawImageRect( oxygenIndicator, 	0, 					healthImg.Height()*3.3 - healthImg.Height(), 	0, 0, mLength, maskIndicator.Height() 	)
	End
	If CurrentLevel = 3
		DrawImageRect( oxygenIndicator, maskIndicator.Width(), 	healthImg.Height()*3.3 - healthImg.Height(), 	0, 0, oLength, oxygenIndicator.Height()	)
	End

End