Strict

Import imp

Global isAnyPowerAvailable:Bool
Global powersBackBtn := New Button
Global powersUpgradeMode:Int
Global powersSlide:Int
Global powersUpgradeBgr:Image

Global itemWindow:Image
Global bluredBgr:Image
Global curPowerWindow:Int

Global buy_btn := New Button
Global cancel_btn := New Button

Global powersText:String[29]
Global powerButton:Button[29]
Global powerButtonW:Int = 64
Global powerButtonH:Int = 71
Global powersPic:Image

Global powerIconForeground:Image

	'd888888b d8b   db d888888b d888888b 
	'  `88'   888o  88   `88'   `~~88~~' 
	'   88    88V8o 88    88       88    
	'   88    88 V8o88    88       88    
	'  .88.   88  V888   .88.      88    
	'Y888888P VP   V8P Y888888P    YP    

Function PowersCreate:Void()

	powersUpgradeBgr = LoadImage( "powers/powersUpgradeBgr" + retinaStr + ".jpg", 1, Image.MidHandle )
	bluredBgr = LoadImage( "powers/bluredBgr.jpg", 1, Image.MidHandle )
	
	itemWindow = LoadImage( "powers/itemWindow" + retinaStr + ".png", 1, Image.MidHandle )

	powerIconForeground = shopGUI.img[11]

	buy_btn.Init("", "", 1,1,3,shopGUI.img[12])
	cancel_btn.Init("", "", 1,1,3,shopGUI.img[10])

	powersBackBtn.Init("Done")

	For Local pwrs:Int = 0 Until 21

		'Local pwrbtn:PowersButtonsClass = New PowersButtonsClass
		'pwrbtn.Init(pwrs)
		'PowersButtons.AddLast(pwrbtn)
		powerButton[pwrs] = New Button
		powerButton[pwrs].Init("", "", 1, 1, 3, shopGUI.img[pwrs + 13])

	Next

	curPowerWindow = -1

	isAnyPowerAvailable = False

	CheckForAvailablePowers()

	Local pwrsTxt$ = app.LoadString("powers/powers.txt")
	Local pt:Int
	
	For Local line$=Eachin pwrsTxt.Split( "~n" )

		pt += 1

		powersText[pt] = line

	Next

End

	'db    db d8888b. d8888b.  .d8b.  d888888b d88888b 
	'88    88 88  `8D 88  `8D d8' `8b `~~88~~' 88'     
	'88    88 88oodD' 88   88 88ooo88    88    88ooooo 
	'88    88 88~~~   88   88 88~~~88    88    88~~~~~ 
	'88b  d88 88      88  .8D 88   88    88    88.     
	'~Y8888P' 88      Y8888D' YP   YP    YP    Y88888P

Global touchDownTime:Float


Function PowersUpdate:Void()

	Local tappedNum:Int

	' Window'
	If curPowerWindow > -1

		If winResult = 1

			winResult = 0
			coins += 500000
			CheckForAvailablePowers()

		End

		If weaponPurchased[curPowerWindow] = False And buy_btn.Pressed()

			If coins >= weaponCost[curPowerWindow]

				weaponPurchased[curPowerWindow] = True
				coins -= weaponCost[curPowerWindow]
				SaveGame()

				CheckForAvailablePowers()
				
				waveBack = True
				winSclActive = True
				sclWave = 1

			Else

				window.Init(["Yes, please", "No, thanks"], "Not enough coins", "Would you like to buy some now?")

			End

		End

		If cancel_btn.Pressed()
			
			waveBack = True
			winSclActive = True
			sclWave = 1

		End

		If winSclActive
			
			If waveBack
				
				sclWave -= .05
				sclAlpha = sclWave
				
				If sclWave < .1
					
					If weaponPurchased[curPowerWindow] = True
						For Local bub:Int = 1 To 5
							CreateBubbles( powerButton[curPowerWindow].x + Rnd(50*Retina), powerButton[curPowerWindow].y + Rnd(50*Retina) )
						Next
					End
					
					waveBack = False
					winSclActive = False
					curPowerWindow = -1
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

		Return

	End

	For Local pw:Int = 0 Until 21

		If powerButton[pw].Pressed()

			curPowerWindow = pw
			
			winSclActive = True
			sclWaveMax = 0.2 sclWave = 0 sclWaveSpeed = .15

			Local nl:String = ""
			If curPowerWindow < 9 nl = "0"
			powersPic = LoadImage( "powers/pics/pics" + nl + "" + (curPowerWindow + 1) + "" + retinaStr + ".png", 1, Image.MidHandle )

			'Print "power pressed " + pw

			Exit

		End

	End

	If powersBackBtn.Pressed()

	End

	If powersSlide = 0 And inertiaDone = False
		'If ChannelState(0) = 0 PlaySound( bottlesSnd, 0 )
		inertiaAdd += inertiaSpd
		If inertiaAdd < -5 inertiaAdd = -5 inertiaSpd = 1
		If inertiaAdd > 0 inertiaAdd = 0 inertiaDone = True
	End

End

	'd8888b. d8888b.  .d8b.  db   d8b   db 
	'88  `8D 88  `8D d8' `8b 88   I8I   88 
	'88   88 88oobY' 88ooo88 88   I8I   88 
	'88   88 88`8b   88~~~88 Y8   I8I   88 
	'88  .8D 88 `88. 88   88 `8b d8'8b d8' 
	'Y8888D' 88   YD YP   YP  `8b8' `8d8'  

Global pbCols:Int = 7
Global pbRows:Int = 3

Global inertiaAdd:Float
Global inertiaSpd:Float
Global inertiaDone:Bool

Global winSclActive:Bool, amplitude:Float = .3
Global sclWave:Float, sclWaveSpeed:Float, sclWaveMax:Float
Global waveBack:Bool, sclAlpha:Float

Global Rt:Int
Global swimRt:Float

Function PowersDraw:Void()
	
	If sclWave < 1.0

		DrawImage ( powersUpgradeBgr, powersSlide + dw/2, dh/2, 0, retinaScl, retinaScl )
		powersBackBtn.Draw( powersSlide, 0 )

		Yellow()
		DrawFont( "|" + coins, powersSlide + dw/2 + fontKern*Retina/2, dh - (pbRows+1.4)*64*Retina, True )
		White()

		Local pbXc:Int
		Local pbYc:Int

		Local pbX:Float
		Local pbY:Float

		Local addWidth:Int = 2 * Retina
		Local addHeight:Int = 10 * Retina

		For Local pw:Int = 0 Until 21

			'Print pw + " " + wn[pw]
			
			Local inertiaAddForColumns:Float = inertiaAdd * pbXc

			Local wCostTxt:String = weaponCost[wn[pw]]

			pbX = powersSlide + dw/2 - Float(pbCols)*( powerButtonW + addWidth )/2.0 + ( powerButtonW + addWidth ) * pbXc
			pbY = dh - pbRows*( powerButtonH + addHeight ) + ( powerButtonH + addHeight ) * pbYc
			

			'button
			powerButton[wn[pw]].Draw( pbX + inertiaAddForColumns + 3 * Retina, pbY + 13 * Retina )
			DrawImage (powerIconForeground, 	pbX + inertiaAddForColumns + 	Int( powerButton[wn[pw]].Down ) * Retina, 
												pbY + 							Int( powerButton[wn[pw]].Down ) * Retina, 
												Int(weaponPurchased[wn[pw]]) )

			'active
			If weaponPurchased[wn[pw]]
				wCostTxt = ""
			End

			'cost
			DrawFont ( wCostTxt, pbX + powerButton[pw].w/2 + 11*Retina + inertiaAddForColumns, pbY + powerButton[pw].h/6, True, 60 )

			pbXc += 1
			If pbXc > pbCols - 1
				pbXc = 0
				pbYc += 1
			End

		Next
		
	End
	
	If curPowerWindow > -1

		Local itemWindowHeight:Int = itemWindow.Height()

		Local buy_btnWidth:Int = buy_btn.w/2
		Local buy_btnHeight:Int = buy_btn.h
		
		
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
		If weaponPurchased[curPowerWindow] 
			SetAlpha(.5)
		End
			buy_btn.Draw( 373*Retina, 392*Retina - sclAlpha*200*Retina )
		If weaponPurchased[curPowerWindow]
			SetAlpha(1)
		End
			
		cancel_btn.Draw( 98 * Retina, 431 * Retina  - sclAlpha*200*Retina )
		
	End

	DrawText(Int(weaponPurchased[3]), 100,100)
	'DrawText(sclWave, 100,100)

End

Function CheckForAvailablePowers:Void()

	isAnyPowerAvailable = False

	For Local pw:Int = 0 Until 21

		If weaponPurchased[ wn[pw] ] = False And weaponCost[ wn[pw] ] <= coins
			isAnyPowerAvailable = True
		End

	Next

End