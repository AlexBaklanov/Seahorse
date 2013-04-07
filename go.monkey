Strict

Import imp

Global GameOverMode:Bool

Global progressBgr:Image
Global progressYou:Image
Global progressWay:Image

Global youX:Float
Global youY:Float
Global youSpd:Float
Global youScaleX:Float
Global youScaleSpd:Float
Global youFinalStop:Bool

Global progressHeight:Int
Global progressBgrScale:Float
Global progressBgrScaleStop:Bool
Global progressBgrScaleSpd:Float

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
	progressBgrScale = 0.0
	progressBgrScaleSpd = .12
	progressBgrScaleStop = False
	
	progressHeight = dh/2 - progressBgr.Height()/3
	youX = dw'distanceGUI * 10 '-progressYou.Width()
	youY = progressHeight
	youSpd = 0
	youScaleSpd = .1
	youScaleX = 1.0
	youFinalStop = True

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
	
	'Bgr
	DrawImage( progressBgr, dw/2, progressHeight, 0, progressBgrScale, progressBgrScale )
	
	'New way
	'DrawImageRect( progressWay, dw/2 - distGUILenght*Retina/2, progressHeight, 0, 0, distanceGUI, progressWay.Height() )

	If distanceGUI > distanceGUILast And youFinalStop And progressBgrScaleStop
		
		Local yellowZero:Int = 	(progressBgr.Width()/2 - distGUILenght/2*Retina)
		Local yellowFrom:Int = 	yellowZero + distanceGUILast
		Local yellowTo:Int = 	distanceGUI - distanceGUILast

		'Old way
		Yellow()
		DrawImageRect( progressBgr, dw/2 + yellowFrom, progressHeight, yellowFrom, 0, yellowTo, progressBgr.Height() )
		White()

	End
	
	'YOU
	DrawImage( progressYou, dw/2 - distGUILenght*Retina/2 + youX + (youScaleX - 1.0) * 12 * Retina, youY, 0, youScaleX, 1 )
	SetAlpha(.5)
	DrawImage( progressYou, dw/2 - distGUILenght*Retina/2 + distanceGUILast, youY, 0, progressBgrScale, progressBgrScale )
	SetAlpha(1)
	
	If youFinalStop And progressBgrScaleStop go_Shop_btn.Draw 	( dw - go_Shop_btn.Width, dh - go_Shop_btn.Height )
	
	'text "You need some rest"
	DrawFont( textID[5], 			dw/2, 30*Retina, True )
	
	'DrawFont (distGUIfont, 			dw/2, 80*Retina, True, 80 )
	DrawTime()
	
	'Yellow()
	'text Coins Earned'
	'DrawFont (textID[6] + coinsGame, 	dw/2, 100*Retina, True, 80 )
	'White()

	'DrawText(crabFinalGameOverDelay, 10, 120)
	
End

	'db    db d8888b. d8888b.  .d8b.  d888888b d88888b 
	'88    88 88  `8D 88  `8D d8' `8b `~~88~~' 88'     
	'88    88 88oodD' 88   88 88ooo88    88    88ooooo 
	'88    88 88~~~   88   88 88~~~88    88    88~~~~~ 
	'88b  d88 88      88  .8D 88   88    88    88.     
	'~Y8888P' 88      Y8888D' YP   YP    YP    Y88888P

Function GameOverUpdate:String()
	
	'Go from left
	If youX < distanceGUI
		youX += youSpd
		youSpd += .2*Retina
	End

	'scale stop'
	If youX >= distanceGUI And youFinalStop = False

		youScaleSpd -= .02
		
		youScaleX += youScaleSpd

		If youScaleSpd < 0 And youScaleX < 1.0

			youFinalStop = True
			youScaleX = 1.0
			AAPublishingShowAd()

		End

	End

	If progressBgrScaleStop = False

		progressBgrScaleSpd -= .006

		progressBgrScale += progressBgrScaleSpd

		If progressBgrScale < 1.0 And progressBgrScaleSpd < 0

			progressBgrScaleStop = True
			progressBgrScale = 1.0

			youX = -progressYou.Width() * 2
			youFinalStop = False

		End

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


Global crabAnim := New animClass
Global crabImg := New atlasClass
Global crabY:Float

Global crabFinalGameOverDelay:Int

Global crabAnimStarted:Bool

Function CrabAnimationInit:Void()

	crabFinalGameOverDelay = 0
	crabAnimStarted = False
	crabAnim.Stop()

End

Function CrabAnimationDraw:Void()

	'DrawText (globalSpeed, 100, 10)

	Local crabX:Int = hero.x + 60 * Retina
	
	If alive = False 

		crabAnim.Draw( crabX, crabY )

		If crabFinalGameOverDelay > 0 DrawDistanceOnTheCrab( crabAnim.img.x[2], crabAnim.img.y[2] - 60 * Retina )

	End

End

Function CrabAnimationUpdate:Void()

	If health <= -10
		
		If alive

			CrabAnimationInit()
			hero.PrepareForGameOver()
			
		End
		
		If globalSpeed < 0

			globalSpeed = 0
			crabAnim.Play(ONE_SHOT)
			crabAnimStarted = True
			acceleration = 0

		End
		
		If globalSpeed = 0

			If crabAnim.Stopped() And GameOverMode = False
				If crabFinalGameOverDelay = 0 crabFinalGameOverDelay = Millisecs()
			End

			'delay to final final gameover'
			If  Millisecs() > crabFinalGameOverDelay + 700 And crabFinalGameOverDelay > 0
				GameOverInit()
			End

			If DistanceDidNotBecomeBetter() GameOverInit()
			
		End
		
	End

	crabAnim.Update()

End

Function CrabAnimationDeinit:Void()

	crabAnim.Deinit()

End

Function DistanceDidNotBecomeBetter:Bool()

	If distance < distanceLast Return True

	Return False

End

'======================================================================================================='

Global crabPreviousImg:Image
Global crabPreviousDraw:Bool
Global crabPreviousHideY:Int

Function CrabPreviousInit:Void()

	crabImg.Init("hero/crab/img" + loadadd + ".png" ) 
	crabAnim.Init("hero/crab/", crabImg)
	crabY = dh + 5 * Retina

	crabPreviousImg = LoadImage ( "hero/finish" + loadadd + ".png" )

	crabPreviousDraw = False

	crabPreviousHideY = 0

End

Function CrabPreviousDraw:Void()

	Local crabPreviousX:Int = dw - (distance*Retina - (distanceLast * Retina - (dw - hero.x) ) )
	Local crabPreviousY:Int = dh - crabPreviousImg.Height() + crabPreviousHideY

	If crabPreviousDraw

		DrawImage ( crabPreviousImg, crabPreviousX, crabPreviousY )
		DrawDistanceOnTheCrab( crabPreviousX + crabPreviousImg.Width() * .65, crabPreviousY + crabPreviousImg.Height() * .25, True )

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

	DrawFont( distStr, theX, theY, True, 100, 10.0 * Retina )

End






