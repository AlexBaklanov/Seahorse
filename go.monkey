Strict

Import imp

Global GameOverMode:Bool

Global progressBgr:Image
Global progressYou:Image
Global progressWay:Image

Global youX:Float
Global youY:Float
Global youSpd:Float

Global progressHeight:Int

Global distance:Float
Global distanceLast:Int

Const distGUILenght:Int = 400

Global distanceGUI:Int
Global distanceGUILast:Float
Global distGUIfont:String

Global go_Shop_btn:Buttons = New Buttons

	'd888888b d8b   db d888888b d888888b 
	'  `88'   888o  88   `88'   `~~88~~' 
	'   88    88V8o 88    88       88    
	'   88    88 V8o88    88       88    
	'  .88.   88  V888   .88.      88    
	'Y888888P VP   V8P Y888888P    YP    

Function GameOverInit:Void()

	GameOverMode = True

	'some "forever" vars'
	distanceGUI = 		Float(distGUILenght) * Float(Retina) / Float(levelEnd) * Float(distance)
	distanceGUILast = 	Float(distGUILenght) * Float(Retina) / Float(levelEnd) * Float(distanceLast)

	'Error distanceLast

	Local dist:Int = Int(distance)

	go_Shop_btn.Init("Continue")

	'text "You traveled"
	'distGUIfont = textID[4] + dist/10

	progressBgr = LoadImage( "progress_bgr" +  loadadd + ".png", 1, Image.MidHandle )
	progressYou = LoadImage( "progress_you" +  loadadd + ".png", 1, Image.MidHandle )
	progressWay = LoadImage( "progress_way" +  loadadd + ".png" )
	
	progressHeight = dh/2 - progressBgr.Height()/3
	youX = -progressYou.Width()
	youY = progressHeight
	youSpd = 0

	acceleration = 0

End

Global blinkYou:Float

	'd8888b. d8888b.  .d8b.  db   d8b   db 
	'88  `8D 88  `8D d8' `8b 88   I8I   88 
	'88   88 88oobY' 88ooo88 88   I8I   88 
	'88   88 88`8b   88~~~88 Y8   I8I   88 
	'88  .8D 88 `88. 88   88 `8b d8'8b d8' 
	'Y8888D' 88   YD YP   YP  `8b8' `8d8'  

Function GameOverDraw:Void()
	
	'DrawFadeBgr()
	
	'DISTANCE DRAW'

	
	
	'Bgr
	DrawImage( progressBgr, dw/2, progressHeight )
	
	'New way
	'DrawImageRect( progressWay, dw/2 - distGUILenght*Retina/2, progressHeight, 0, 0, distanceGUI, progressWay.Height() )

	If distanceGUI > distanceGUILast
	
		Local yellowZero:Int = 	(progressBgr.Width()/2 - distGUILenght/2*Retina)
		Local yellowFrom:Int = 	yellowZero + distanceGUILast
		Local yellowTo:Int = 	distanceGUI - distanceGUILast

		'Old way
		Yellow()
		DrawImageRect( progressBgr, dw/2 + yellowFrom, progressHeight, yellowFrom, 0, yellowTo, progressBgr.Height() )
		White()

	End
	
	'YOU
	DrawImage( progressYou, dw/2 - distGUILenght*Retina/2 + youX, youY )
	SetAlpha(.5)
	DrawImage( progressYou, dw/2 - distGUILenght*Retina/2 + distanceGUILast, youY )
	SetAlpha(1)
	
	go_Shop_btn.Draw 	( dw - go_Shop_btn.Width, dh - go_Shop_btn.Height )
	
	'text "You need some rest"
	DrawFont( textID[5], 			dw/2, 30*Retina, True )
	
	'DrawFont (distGUIfont, 			dw/2, 80*Retina, True, 80 )
	DrawTime()
	
	'Yellow()
	'text Coins Earned'
	'DrawFont (textID[6] + coinsGame, 	dw/2, 100*Retina, True, 80 )
	'White()
	
End

	'db    db d8888b. d8888b.  .d8b.  d888888b d88888b 
	'88    88 88  `8D 88  `8D d8' `8b `~~88~~' 88'     
	'88    88 88oodD' 88   88 88ooo88    88    88ooooo 
	'88    88 88~~~   88   88 88~~~88    88    88~~~~~ 
	'88b  d88 88      88  .8D 88   88    88    88.     
	'~Y8888P' 88      Y8888D' YP   YP    YP    Y88888P

Function GameOverUpdate:String()
	
	'Fall Down
	If youX < distanceGUI
		youX += youSpd
		youSpd += .2*Retina
	End

	If go_Shop_btn.Pressed()

		GameOverDeinit()
		GameOverMode = False
		Return FromGameToShop()

	End

	Return Game

End

	'd8888b. d88888b d888888b d8b   db d888888b d888888b 
	'88  `8D 88'       `88'   888o  88   `88'   `~~88~~' 
	'88   88 88ooooo    88    88V8o 88    88       88    
	'88   88 88~~~~~    88    88 V8o88    88       88    
	'88  .8D 88.       .88.   88  V888   .88.      88    
	'Y8888D' Y88888P Y888888P VP   V8P Y888888P    YP    

Function GameOverDeinit:Void()

	progressBgr.Discard()
	progressYou.Discard()
	progressWay.Discard()

	go_Shop_btn.Deinit()

	CrabAnimationDeinit()

End

	' .o88b. d8888b.  .d8b.  d8888b. .d8888. 
	'd8P  Y8 88  `8D d8' `8b 88  `8D 88'  YP 
	'8P      88oobY' 88ooo88 88oooY' `8bo.   
	'8b      88`8b   88~~~88 88~~~b.   `Y8b. 
	'Y8b  d8 88 `88. 88   88 88   8D db   8D 
	' `Y88P' 88   YD YP   YP Y8888P' `8888Y' 

Global crabAnimImg:Image
Global crabAnimY:Float
Global crabAnimYend:Int
Global crabAnimSpd:Float
Global crabAnimAcceleration:Float
Global crabAnimScale:Float = .112

Function CrabAnimationInit:Void()
	
	crabAnimImg = LoadImage ( "hero/finish" + loadadd + ".png" )
	crabAnimImg.SetHandle( crabAnimImg.Width()/2, 0 )
	
	crabAnimY = dh + 10 * Retina
	crabAnimYend = dh - crabAnimImg.Height()

	crabAnimSpd = 14.0 * Retina
	crabAnimAcceleration = .7 * Retina

End

Function CrabAnimationDraw:Void()

	'DrawText (crabAnimScale, 100, 10)

	Local crabAnimX:Int = hero.x + 60 * Retina

	If alive = False
		DrawImage( crabAnimImg, crabAnimX, crabAnimY, 0, 1.112 - crabAnimScale, 0.888 + crabAnimScale )
		DrawDistanceOnTheCrab( crabAnimX + crabAnimImg.Width() * .04, crabAnimY + crabAnimImg.Height() * .25 )
	End

End

Function CrabAnimationUpdate:Void()

	If health <= -10
		
		If alive

			CrabAnimationInit()
			StreamDeactivate()
			hero.PrepareForGameOver()
			
		End
		
		If globalSpeed < 0 globalSpeed = 0
		
		If globalSpeed = 0

			'hard to understand scale-speed-position abrah-cadabrah with Crab's animation
			crabAnimY -= crabAnimSpd
			crabAnimSpd -= crabAnimAcceleration
			crabAnimScale = crabAnimSpd / 50.0 / Retina

			If crabAnimAcceleration > 0 And crabAnimY > crabAnimYend And crabAnimSpd < 0 crabAnimAcceleration = -crabAnimAcceleration
			
			If crabAnimY < crabAnimYend And crabAnimAcceleration < 0
				crabAnimY = crabAnimYend
				crabAnimScale = .112
			End
			
			'final game over'
			If (crabAnimY = crabAnimYend And GameOverMode = False) Or DistanceDidNotBecomeBetter()
				GameOverInit()
			End
			
		End
		
	End

End

Function CrabAnimationDeinit:Void()

	crabAnimImg.Discard()

End

'======================================================================================================='

Global crabPreviousImg:Image
Global crabPreviousDraw:Bool
Global crabPreviousHideY:Int

Function CrabPreviousInit:Void()

	crabPreviousImg = LoadImage ( "hero/finish" + loadadd + ".png" )

	crabPreviousDraw = False

	crabPreviousHideY = 0

End

Function CrabPreviousDraw:Void()

	Local crabPreviousX:Int = dw - (distance*Retina - (distanceLast * Retina - (dw - hero.x) ) )
	Local crabPreviousY:Int = dh - crabPreviousImg.Height() + crabPreviousHideY

	If crabPreviousDraw

		DrawImage ( crabPreviousImg, crabPreviousX, crabPreviousY )
		DrawDistanceOnTheCrab( crabPreviousX + crabPreviousImg.Width() * .55, crabPreviousY + crabPreviousImg.Height() * .25, True )

	End


End

Function CrabPreviousUpdate:Void()

	If distance > (distanceLast - (dw - hero.x) )

		If crabPreviousDraw = False
			crabPreviousDraw = True
		End

	End

	If alive = False And crabPreviousHideY < crabPreviousImg.Height() And DistanceDidNotBecomeBetter() = False

		crabPreviousHideY += 2 * Retina

	End	

End

Function CrabPreviousDeinit:Void()

	crabPreviousImg.Discard()

End

'======================================================================================================='

Function DrawDistanceOnTheCrab:Void(theX:Int, theY:Int, theLast:Bool = False)

	Local dist:Int

	If theLast

		dist = Int(distanceLast)

	Else

		dist = Int(distance)

	End

	Local distStr:String = String(dist/10) + "m"

	DrawFont( distStr, theX, theY, False, 100, 10.0 * Retina )

End






