Strict

Import imp

Global isAnyPowerAvailable:Bool
Global powersBackBtn:Buttons = New Buttons
Global powersUpgradeMode:Int
Global slidePowersUpgrade:Int
Global powersUpgradeBgr:Image

Global powersActivateImg:Image
'Global powersLockedImg:Image

Global itemWindow:Image
Global bluredBgr:Image
Global isWindowShow:Int

Global buy_btn := New Buttons
Global cancel_btn := New Buttons
Global done_btn := New Buttons

Global powersText:String[29]
Global powerButton:PowersButtonsClass[29]
Global powersPic:Image

Global powerIconForeground:Image

Global allPowerBtnsImg:Image

Function PowersCreate:Void()

	powersUpgradeBgr = LoadImage( "powers/powersUpgradeBgr" + retinaStr + ".jpg", 1, Image.MidHandle )
	powersActivateImg = LoadImage( "powers/activated" + loadadd + ".png" )
	bluredBgr = LoadImage( "powers/bluredBgr.jpg", 1, Image.MidHandle )
	itemWindow = LoadImage( "powers/itemWindow" + retinaStr + ".png", 1, Image.MidHandle )
	powerIconForeground = LoadImage( "powers/powerIconForeground" + loadadd + ".png", 2 )

	buy_btn.Init("", "powers/powersBuy", 1,1,2)
	cancel_btn.Init("", "powers/powersCancel", 1,1,2)

	isAnyPowerAvailable = False

	allPowerBtnsImg = LoadImage( "powers/power_btns" + loadadd + ".png", 64 * Retina, 71 * Retina, 21 )

	For Local pwrs:Int = 1 To 21

		Local pwrbtn:PowersButtonsClass = New PowersButtonsClass
		pwrbtn.Init(pwrs)
		PowersButtons.AddLast(pwrbtn)

		powerButton[pwrs] = pwrbtn

	Next

	CheckForAvailablePowers()

	Local pwrsTxt$ = app.LoadString("powers/powers.txt")
	Local pt:Int
	
	For Local line$=Eachin pwrsTxt.Split( "~n" )

		pt += 1

		powersText[pt] = line

	Next

End


'8 8888      88 8 888888888o   8 888888888o.            .8.    8888888 8888888888 8 8888888888   
'8 8888      88 8 8888    `88. 8 8888    `^888.        .888.         8 8888       8 8888         
'8 8888      88 8 8888     `88 8 8888        `88.     :88888.        8 8888       8 8888         
'8 8888      88 8 8888     ,88 8 8888         `88    . `88888.       8 8888       8 8888         
'8 8888      88 8 8888.   ,88' 8 8888          88   .8. `88888.      8 8888       8 888888888888 
'8 8888      88 8 888888888P'  8 8888          88  .8`8. `88888.     8 8888       8 8888         
'8 8888      88 8 8888         8 8888         ,88 .8' `8. `88888.    8 8888       8 8888         
'` 8888     ,8P 8 8888         8 8888        ,88'.8'   `8. `88888.   8 8888       8 8888         
'  8888   ,d8P  8 8888         8 8888    ,o88P' .888888888. `88888.  8 8888       8 8888         
'   `Y88888P'   8 8888         8 888888888P'   .8'       `8. `88888. 8 8888       8 888888888888


Global touchDownTime:Float


Function PowersUpdate:Void()

	Local tappedNum:Int

	' Window'
	If isWindowShow

		If winResult = 1

			winResult = 0

			coins += 500000

			CheckForAvailablePowers()

		End

		If weaponActivated[isWindowShow] = False And buy_btn.Pressed()

			If coins >= weaponCost[isWindowShow]

				weaponActivated[isWindowShow] = True
				coins -= weaponCost[isWindowShow]
				SaveGame()

				CheckForAvailablePowers()
				
				waveBack = True
				winSclActive = True
				sclWave = 1

			Else

				window.Init(["Yes, please", "No, thanks"], "Not enough coins", "Would you like to buy some now?")

			End

		End

		If cancel_btn.Pressed() Or done_btn.Pressed()
			
			
			waveBack = True
			winSclActive = True
			sclWave = 1

			'isWindowShow = 0
			'powersPic.Discard()

		End

		Return

	End

	For Local pwrbtn := Eachin PowersButtons

		tappedNum += 1

		#rem
		If pwrbtn.Pressed() And TouchDown(0)

			pwrbtn.moved = True

			touchDownTime = 1

			Return

		Else

			touchDownTime = 0

		End
		#end

		If pwrbtn.Pressed() 'pwrbtn.locked = False And pwrbtn.Pressed()

			isWindowShow = tappedNum
			
			winSclActive = True
			sclWaveMax = 0.2 sclWave = 0 sclWaveSpeed = .15

			Local nl:String = ""
			If isWindowShow < 10 nl = "0"
			powersPic = LoadImage( "powers/pics/pics" + nl + "" + isWindowShow + "" + retinaStr + ".png", 1, Image.MidHandle )

			Exit

		End

	End

End


'8 888888888o.      8 888888888o.            .8. `8.`888b                 ,8' 
'8 8888    `^888.   8 8888    `88.          .888. `8.`888b               ,8'  
'8 8888        `88. 8 8888     `88         :88888. `8.`888b             ,8'   
'8 8888         `88 8 8888     ,88        . `88888. `8.`888b     .b    ,8'    
'8 8888          88 8 8888.   ,88'       .8. `88888. `8.`888b    88b  ,8'     
'8 8888          88 8 888888888P'       .8`8. `88888. `8.`888b .`888b,8'      
'8 8888         ,88 8 8888`8b          .8' `8. `88888. `8.`888b8.`8888'       
'8 8888        ,88' 8 8888 `8b.       .8'   `8. `88888. `8.`888`8.`88'        
'8 8888    ,o88P'   8 8888   `8b.    .888888888. `88888. `8.`8' `8,`'         
'8 888888888P'      8 8888     `88. .8'       `8. `88888. `8.`   `8'          



Global pbCols:Int = 7
Global pbRows:Int = 3

Global waveAdd:Float
Global waveSpd:Float
Global waved:Bool

Global winSclActive:Bool, amplitude:Float = .3
Global sclWave:Float, sclWaveSpeed:Float, sclWaveMax:Float
Global waveBack:Bool, sclAlpha:Float

Global Rt:Int
Global swimRt:Float

Function PowersDraw:Void()
	
	If sclWave < 1.0

		DrawImage ( powersUpgradeBgr, slidePowersUpgrade + dw/2, dh/2, 0, retinaScl, retinaScl )
		powersBackBtn.Draw( slidePowersUpgrade, 0 )

		'DrawImage( coinsBgr, slidePowersUpgrade + dw/2, dh - (pbRows+1.4)*64*Retina )
		Yellow()
		DrawFont( "|" + coins, slidePowersUpgrade + dw/2 + fontKern*Retina/2, dh - (pbRows+1.4)*64*Retina, True )
		White()
		
		If slidePowersUpgrade = 0 And waved = False
			'If ChannelState(0) = 0 PlaySound( bottlesSnd, 0 )
			waveAdd += waveSpd
			If waveAdd < -5 waveAdd = -5 waveSpd = 1
			If waveAdd > 0 waveAdd = 0 waved = True
		End

		Local pbXc:Int
		Local pbYc:Int

		Local pbX:Float
		Local pbY:Float

		Local pbNum:Int

		Local addWidth:Int = 2 * Retina
		Local addHeight:Int = 10 * Retina

		For Local pwrbtn := Eachin PowersButtons
			
			Local waveAdd1:Float = waveAdd * pbXc

			pbNum += 1

			If pbNum = 22 Exit

			Local wCostTxt:String = weaponCost[wn[pbNum-1]]

			If touchDownTime = 0
				pbX = slidePowersUpgrade + dw/2 - Float(pbCols)*( pwrbtn.Width + addWidth )/2.0 + ( pwrbtn.Width + addWidth ) * pbXc
				pbY = dh - pbRows*( powerButton[wn[pbNum-1]].Height + addHeight ) + ( powerButton[wn[pbNum-1]].Height + addHeight ) * pbYc
			Else
				pbX = TouchX()
				pbY = TouchY()
			End

			'button
			powerButton[wn[pbNum-1]].Draw( pbX + waveAdd1, pbY )
			DrawImage (powerIconForeground, 	pbX + waveAdd1 + 	Int( powerButton[wn[pbNum-1]].btn.Down ) * Retina, 
												pbY + 				Int( powerButton[wn[pbNum-1]].btn.Down ) * Retina, 
												Int(weaponActivated[wn[pbNum-1]]) )

			'active
			If weaponActivated[wn[pbNum-1]]
				'DrawImage ( powersActivateImg, pbX + waveAdd1, pbY )
				wCostTxt = "" '"bought"
			End

			'locked
			'If wn[pbNum-1] > CurrentLevel * 7 DrawImage ( powersLockedImg, pbX + waveAdd1, pbY )

			'cost
			DrawFont ( wCostTxt, pbX + pwrbtn.Width/2 + 11*Retina + waveAdd1, pbY + pwrbtn.Height/6, True, 60 )

			pbXc += 1
			If pbXc > pbCols - 1
				pbXc = 0
				pbYc += 1
			End

		Next
		
	End
	
	If isWindowShow
		
		If winSclActive
			
			If waveBack
				
				sclWave -= .05
				sclAlpha = sclWave
				
				If sclWave < .1
					
					If weaponActivated[isWindowShow] = True
						For Local bub:Int = 1 To 5
							CreateBubbles( powerButton[isWindowShow].btn.x + Rnd(50*Retina), powerButton[isWindowShow].btn.y + Rnd(50*Retina) )
						Next
					End
					
					waveBack = False
					winSclActive = False
					isWindowShow = 0
					powersPic.Discard()
					Return
				End
				
			Else
				
				sclWave += sclWaveSpeed
				sclAlpha += .05
				If sclAlpha > 1.0 sclAlpha = 1.0
				
				If (sclWaveSpeed < 0 And sclWave < 1-sclWaveMax) Or (sclWaveSpeed > 0 And sclWave > 1+sclWaveMax) 
					sclWaveSpeed = - sclWaveSpeed
					sclWaveMax *= amplitude
				End
				If sclWaveMax < 0.005 sclWave = 1.0 winSclActive = False
				If sclWaveSpeed > 0.00001 And sclWave > .5 sclWaveSpeed *= .84
					
			End
			
		End

		Local itemWindowHeight:Int = itemWindow.Height()

		Local buy_btnWidth:Int = buy_btn.Width/2
		Local buy_btnHeight:Int = buy_btn.Height
		
		
		If sclWave < 1.0 SetAlpha(sclAlpha)
		DrawImage( bluredBgr, dw/2, dh/2, 0, Retina, Retina )
		If sclWave < 1.0 SetAlpha(1)
		
		Local sclWavePos:Float
		If sclWaveMax = .2 And sclWave<1 sclWavePos = sclWave Else sclWavePos = 1.0
			
		Local sclWaveNeg:Float = sclWave
		If sclWave < 1 And sclWaveMax = .2
			sclWaveNeg = sclWave
		Else
			If sclWave > 1 sclWaveNeg = 1 - (sclWave - 1)
			If sclWave < 1 sclWaveNeg = 1 + (1 - sclWave)
		End
		
		If waveBack sclWaveNeg = sclWave
		
		Rt += 1
		If Rt > 300 Rt = 0

		If Rt < 150 swimRt += .05 Else swimRt -= .05
		
		'WINDOW'
		DrawImage( powersPic,  dw/2 - (1.0 - sclWavePos) * 300.0 + swimRt, dh/2  + swimRt,  + swimRt/5, retinaScl * sclWaveNeg, retinaScl * sclWave )
		
		DrawImage( itemWindow, dw/2 - (1.0 - sclWavePos) * 300.0, dh/2, 0, retinaScl * sclWave, retinaScl * sclWaveNeg )
		

		'BUTTONS'
		If weaponActivated[isWindowShow] SetAlpha(.5)
			buy_btn.Draw( 373*Retina, 392*Retina - sclAlpha*200*Retina )
		If weaponActivated[isWindowShow] SetAlpha(1)
			
		cancel_btn.Draw( 98 * Retina, 431 * Retina  - sclAlpha*200*Retina )
		
		
			'DrawFont( powersText[isWindowShow], dw/2, dh/2 + itemWindowHeight - buy_btnHeight * 1.3, True, 100 )
		'Else
''		Local doneTxt:String = "Purchased."
''			DrawFont( doneTxt, dw/2, dh/2 + buy_btnHeight * 1.3, True, 70 )
''			done_btn.Draw( 	dw/2 - buy_btnWidth, 	dh/2 + buy_btnHeight )
''		End
		
		

		'If waveBack = False Return
		
	End
	'DrawText(touchDownTime, 100,100)
	'DrawText(sclWave, 100,100)

End





Function CheckForAvailablePowers:Void()

	isAnyPowerAvailable = False
	Local pbNum:Int

	For Local pwrbtn := Eachin PowersButtons

		pbNum += 1

		If weaponActivated[ wn[pbNum-1] ] = False And weaponCost[ wn[pbNum-1] ] <= coins 'And powerButton[wn[pbNum-1]].locked = False 
			isAnyPowerAvailable = True
		End

	Next

End

Global PowersButtons := New List<PowersButtonsClass>

Class PowersButtonsClass
	
	Field btn:Buttons = New Buttons
	Field Height:Int
	Field Width:Int

	Field x:Float
	Field y:Float

	Field moved:Bool

	'Field locked:Bool

	Method Init:Void( pbNum:Int )

		Local zero:String

		If pbNum < 10 zero = "0" Else zero = ""

		Local allPowerBtnsImgFrame:Int = pbNum - 1
		'= allPowerBtnsImg.GrabImage( 64 * (pbNum-1) * Retina, 71 * (pbNum-1) * Retina, 64 * Retina, 71 * Retina )

		btn.Init("", "none", 1, 1, 3, allPowerBtnsImg, allPowerBtnsImgFrame)

		Width = btn.Width
		Height = btn.Height

		'If pbNum > CurrentLevel * 7 locked = True

	End

	Method Draw:Void( theX:Float, theY:Float )

		If moved
			x = TouchX()
			y = TouchY()
		Else
			x = theX
			y = theY
		End

		btn.Draw(x, y)

	End

	Method Pressed:Bool()

		If btn.Pressed() Return True

		Return False

	End

	Method Deinit:Void()

		btn.Deinit()

	End

End