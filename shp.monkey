Strict

Import imp

Const HEALTH_RUNOUT:Int = 3

Global friendMode:Bool
Global armor:Float

Global CurrentUpgrade:Int

Global btnHeight:Int

Global ubX:Float[10], ubY:Int[10], ubX_to:Int[10], ubY_to:Float[10]
Global ubY_rnd:Float[] = [10.0, -20.0, -16.0, 20.0, -18.0, 9.0, -3.0]

Global waveUpgrades:Float[10]
Global waveSin:Float[10]
Global waveSinSpd:Float = 2

Global scaleItemsY:Float' = .82
Global padscale:Float = 1.067

Global powX:Int
Global powY:Int

Global descX:Int, descY:Int, descScl:Int
Global isHelpShown:Bool

'ALL ABOUT UPGRADES'

Global btnScaleDraw:Float[] = [1, .5, .5, .5, .5, .5, .5]
Global btnDistDraw:Float[7]

Global upgradeThe:Float[10]
Global upgradeCoef:Float[] 		= [35, 				0.002, 			4, 				3000, 			20,				3,				3 ]
Global upgradeMax:Int[] 		= [10, 				3, 				10, 			10, 			15,				20,				20 ]

Global upgradeCost:Int[10]
Global upgradeCostCoef:Float[]

Global upgradeName:String[] 	= ["Health:   ", 	"Speed:    ", 	"Armor:    ", 	"Friend:   ", 	"Strength: ", 	"Mask:     ", 	"Oxygen:   "]
Global upgradeDesc:String[]		= [
									"The more Health you have, the more", 'HEALTH'
									"you can swim!",

									"The faster your speed, the sooner", 'SPEED'
									"you get to final point!",

									"The stronger your armor, the less", 'ARMOR'
									"damage you get from sea inhabitants.", 

									"Once you meet your friend, he can", 'FRIEND'
									"carry you for some time.", 

									"The harder your spirit, the less", 'STRENGTH'
									"your Health is wasting.", 

									"The Health doesn't wasting while", 'MASK'
									"you're in the mask!", 

									"Additional Oxygen supply prevents", 'OXYGEN'
									"Health from wasting as well." ]

Global upgradeText:String[]		= [ "Increase Health!",  
									"How fast Rory is.", 
									"Rory's defense from sea inhabitants.", 
									"Your fiend carries Rory for some time.", 
									"How fast Rory's health is wasting.", 
									"Mask prevents health from wasting.", 
									"Additional health." ]

Global upgradeSeen:Bool[10]
Global upgradeLevel:Int[10]
Global upgradeCurLevel:Image


'GFX'
Global upgradeLevelImg:Image
Global itemBgr:Image
Global itemBgrN:Image
Global coinsBgr:Image
Global shopIcons:Image
Global availablePower:Image
Global helpLine:Image

'Btns'
Global morecoins := New Buttons
Global levelUp_btn := New Buttons
Global powersUpgrade_btn:Buttons = New Buttons
Global help_btn := New Buttons
Global upgradesBtn := New List<upgradesBtnClass>
Global play_btn := New Buttons
Global menu_btn := New Buttons

'Buttons of Main upgrades'
Global upgradeBtn:Buttons[10]

Class upgradesBtnClass

	Field btn:Buttons = New Buttons
	Field n:Int

	Method Init:Void(ubNum:Int)

		btn.Init( "", "shop/item", 1, 1, 2 )

		upgradeBtn[ubNum-1] = New Buttons
		upgradeBtn[ubNum-1] = btn

		n = ubNum

	End

	Method Draw:Void( theX:Float, theY:Float )

		btn.Draw(theX, theY)

	End

	Method Pressed:Bool()

		If btn.Pressed() Return True

		Return False

	End

	Method Deinit:Void()

		btn.Deinit()

	End


End

' Sounds'
Global bottlesSnd:Sound





'---------------------------------------------------------------------------------------------------------------------------------------------------'
'---------------------------------------------------------------------------------------------------------------------------------------------------'
'---------------------------------------------------------------------------------------------------------------------------------------------------'
'---------------------------------------------------------------------------------------------------------------------------------------------------'
'---------------------------------------------------------------------------------------------------------------------------------------------------'
'---------------------------------------------------------------------------------------------------------------------------------------------------'

Global shop:shopClass = New shopClass

Global shopItemsCount:Int

Class shopClass

	Field bgr:Image

	Method Init:Void()

		'images'
		bgr = LoadImage ( "shop/shop"+retinaStr+".jpg", 1, Image.MidHandle )
		helpLine = LoadImage ( "shop/helpLine.png", 1, Image.MidHandle )
		coinsBgr = LoadImage( "shop/coinsBgr"+loadadd+".png", 1, Image.MidHandle )
		shopIcons = LoadImage( "shop/shopIcons"+loadadd+".png", 7, Image.MidHandle )
		availablePower = LoadImage( "shop/powers_btn.png" )
		upgradeLevelImg = LoadImage( "shop/upgradeLine"+loadadd+".png", 57*Retina, 20*Retina, 3 )
		upgradeCurLevel = LoadImage( "shop/upgradeLevel"+loadadd+".png" )

		'sounds'
		bottlesSnd = LoadSound( "sounds/bottles.wav" )

		'buttons'
		play_btn.Init("", "shop/play",1,1,2)
		menu_btn.Init("", "shop/menu",1,1,2)
		morecoins.Init("", "shop/morecoins",1,1,2)
		powersUpgrade_btn.Init("", "shop/powers",1,1,2)
		help_btn.Init("", "shop/help", 1,1,2)
		powersBackBtn.Init("Done")
		levelUp_btn.Init( "", "shop/upgrade", 1, 1, 2 )

		For Local btnu:Int = 1 To 7

			Local nubtn:upgradesBtnClass = New upgradesBtnClass
			nubtn.Init(btnu)
			upgradesBtn.AddLast(nubtn)

		Next

		PowersCreate()

		acceleration = accelerationGlobal

		alive = True

		slidePowersUpgrade = dw
		scaleItemsY = 1.02
		If CurrentLevel = 3 scaleItemsY = .84

		SetUpgradeCoefs()
		SetUpgradeButtonsDistances()

		SetRandomButtonsFirstCoordinates()

		btnHeight = 80 * Retina

		isHelpShown = False
		descScl = 0

		Select CurrentLevel

			Case 1,2
				shopItemsCount = 5
			Case 3
				shopItemsCount = 6

		End

		WavesSet()

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

	Method Update:String()

		If KeyHit(KEY_C) Or Swipe()
			coins += 7000
			CheckForAvailablePowers()
		End

		GameTime()

		'If isShopWindowOpen
		'
		'	shopWindow.Update()
		'	Return Shop
		'
		'End

		If powersUpgradeMode = -1

			If slidePowersUpgrade > 0 slidePowersUpgrade += powersUpgradeMode * 32 * Retina Else slidePowersUpgrade = 0

			If isWindowShow = 0 And powersBackBtn.Pressed()

				powersUpgradeMode = 1
				slidePowersUpgrade = 0

			End

			PowersUpdate()

			Return Shop

		Elseif powersUpgradeMode = 1

			If slidePowersUpgrade < dw slidePowersUpgrade += powersUpgradeMode * 32 * Retina Else slidePowersUpgrade = dw
			If slidePowersUpgrade = dw powersUpgradeMode = 0

		End

		If play_btn.Pressed()

			Self.Deinit()

			If comix.done

				mainGame.Init()

				'If it's not a GameOver, don't reset the game
				If ModeFrom <> "Not GameOver"
					mainGame.Reset()
				End

				ModeFrom = ""

				Return Game

			Else

				comix.Init()

				Return Comix

			End

		End

		If menu_btn.Pressed()

			SaveGame()

			Self.Deinit()
			menu.Init()

			Return Menu

		End

		If powersUpgrade_btn.Pressed()

			powersUpgradeMode = - 1
			slidePowersUpgrade = dw

				waved = False
				waveAdd = 0
				waveSpd = -.8 * Retina

		End

		CheckUpgrades()

		WavesUpdate()

		Return Shop

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

	Field blinkAvailablePowers:Float
	Field blinkAvailablePowersSpeed:Float = 0.001

	Method Draw:Void()

		DrawImage ( bgr, dw/2, dh/2, 0, retinaScl, retinaScl )

		If slidePowersUpgrade > 0

			play_btn.Draw( dw/2 - play_btn.Width/2, dh - play_btn.Height )
			menu_btn.Draw ( 0, dh - menu_btn.Height )
			DrawShopCoinsIndicator()

			morecoins.Draw( 0, -morecoins.Height/3 )

			If isAnyPowerAvailable
				blinkAvailablePowers += blinkAvailablePowersSpeed
				If blinkAvailablePowers > 1.0
					blinkAvailablePowers = 1.0
					blinkAvailablePowersSpeed = -.001
				End
				If blinkAvailablePowers < .97
					blinkAvailablePowers = .97
					blinkAvailablePowersSpeed = .005
				End
			Else
				blinkAvailablePowers = 1
			End

			Local addPowersButton:Int
			If CurrentLevel < 3 addPowersButton = 1			
			powersUpgrade_btn.Draw( dw - powersUpgrade_btn.Width, 
									dh - powersUpgrade_btn.Height,
									blinkAvailablePowers )


			'##     ## ########   ######   ########     ###    ########  ########  ######  
			'##     ## ##     ## ##    ##  ##     ##   ## ##   ##     ## ##       ##    ## 
			'##     ## ##     ## ##        ##     ##  ##   ##  ##     ## ##       ##       
			'##     ## ########  ##   #### ########  ##     ## ##     ## ######    ######  
			'##     ## ##        ##    ##  ##   ##   ######### ##     ## ##             ## 
			'##     ## ##        ##    ##  ##    ##  ##     ## ##     ## ##       ##    ## 
			' #######  ##         ######   ##     ## ##     ## ########  ########  ######  

			Local uu:Int = 0
			Local uut:Int
			For Local ib := Eachin upgradesBtn

				uut = uu

				If uu = 1
					uut = 4
				Elseif uu = 4
					uut = 1
				End

				If CurrentLevel = 1 And uu = 5 Exit

				If CurrentLevel = 2
					If uu = 5 Exit
					If uu = 4 uut = 5
				End

				If CurrentLevel = 3
					If uu = 6 Exit
					If uu = 5 uut = 6
					If uu = 4 uut = 5
				End

				If uut = 3 And isFriendShown = False isFriendDisable = True Else isFriendDisable = False

				Local scaleItemsX:Float = 1.0

				If dw = 1024 Or dw = 2048 scaleItemsX = padscale

				'Button

				' Oxygen
				'If uu = 5 And uut = 6

				''	ubX[uu] = 115		*Retina
				''	ubY[uu] = 150		*Retina

				'End

				'ubX[uu] = upgradeBtn[uut].Width / 2 * (uu+1) - upgradeBtn[uut].Width / 2 * btnScaleDraw[uut] '+ btnDistDraw[uut]
				'ubY[uu] = dh / 3 - upgradeBtn[uut].Height / 2 * btnScaleDraw[uut]

				'upgrade picture-button

				Local halfXScale:Float = upgradeBtn[uut].Width/2*btnScaleDraw[uut]
				Local halfYScale:Float = upgradeBtn[uut].Height/2*btnScaleDraw[uut]

				DrawImage (shopIcons, 	ubX[uu] + halfXScale,
										ubY[uu] + halfYScale*2/3.3,
										0,
										.7 + .3 * (btnScaleDraw[uut] - .5) * 2,
										.7 + .3 * (btnScaleDraw[uut] - .5) * 2,
										uut)

				'If uut = CurrentUpgrade SetBlend(1)
				upgradeBtn[uut].Draw( ubX[uu], ubY[uu] + waveUpgrades[uu], btnScaleDraw[uut] )
				'If uut = CurrentUpgrade SetBlend(0)

				'upgrade process
				DrawUpgradeProgress(uut, 	ubX[uu] + upgradeBtn[uut].Width*.15*btnScaleDraw[uut], 
											ubY[uu] + upgradeBtn[uut].Height/1.8*btnScaleDraw[uut] )

				If CurrentUpgrade = uut

					'Upgrade BTN
					If upgradeCost[CurrentUpgrade] > coins Or upgradeLevel[CurrentUpgrade] = upgradeMax[CurrentUpgrade] Or isFriendDisable SetAlpha (.5)

					levelUp_btn.Draw( 	ubX[uu] + halfXScale - levelUp_btn.Width/2 * (btnScaleDraw[uut] - .5) * 2, 
										ubY[uu] + halfYScale + levelUp_btn.Height/2 * (btnScaleDraw[uut] - .5) * 2, 
										(btnScaleDraw[uut] - .5) * 2 )

					If upgradeCost[CurrentUpgrade] > coins Or upgradeLevel[CurrentUpgrade] = upgradeMax[CurrentUpgrade] Or isFriendDisable SetAlpha (1)

					'NAME'
					DrawFont( 	upgradeName[CurrentUpgrade], 
								ubX[uu] + halfXScale, '- levelUp_btn.Width/2 * (btnScaleDraw[uut] - .5) * 2, 
								ubY[uu] + halfYScale, '- levelUp_btn.Height/2 * (btnScaleDraw[uut] - .5) * 2, 
								True,
								(btnScaleDraw[uut] - .5) * 200 )

				End


				'cost

				Local costText:String = "|" + upgradeCost[uut]
				If upgradeLevel[uut] = upgradeMax[uut] costText = "Done"
				Yellow()
				DrawFont ( costText, 	ubX[uu] + upgradeBtn[uut].Width*btnScaleDraw[uut]*.55, 
										ubY[uu] + upgradeBtn[uut].Height*btnScaleDraw[uut]*.85, 
										True, 
										70 + 30 * (btnScaleDraw[uut] - .5) * 2 )
				White()


				uu += 1

			Next






			'########     ###    ########     ###    ##     ##  ######  
			'##     ##   ## ##   ##     ##   ## ##   ###   ### ##    ## 
			'##     ##  ##   ##  ##     ##  ##   ##  #### #### ##       
			'########  ##     ## ########  ##     ## ## ### ##  ######  
			'##        ######### ##   ##   ######### ##  #  ##       ## 
			'##        ##     ## ##    ##  ##     ## ##     ## ##    ## 
			'##        ##     ## ##     ## ##     ## ##     ##  ######  

#rem

			'DownerMenu
			Local leftMargin:Int = 235*Retina

			descX = leftMargin + 90*Retina
			descY = dh/2 - 10*Retina

			help_btn.Draw( descX, descY )


			'Icon
			DrawImage( shopIcons, 	leftMargin - 10*Retina + shopIcons.Width()/2, 
									dh/2 + shopIcons.Height()/2 - 10*Retina, 
									CurrentUpgrade )





			'The whole button Upgrade'
			Local twbuX:Int = leftMargin + 140*Retina
			Local twbuY:Int = dh/2 + 60*Retina

			If CurrentUpgrade = 3 And isFriendShown = False isFriendDisable = True Else isFriendDisable = False

			'Upgrade BTN
			If upgradeCost[CurrentUpgrade] > coins Or upgradeLevel[CurrentUpgrade] = upgradeMax[CurrentUpgrade] Or isFriendDisable SetAlpha (.5)
			levelUp_btn.Draw( twbuX, twbuY )
			If upgradeCost[CurrentUpgrade] > coins Or upgradeLevel[CurrentUpgrade] = upgradeMax[CurrentUpgrade] Or isFriendDisable SetAlpha (1)


			Local costText:String = "~" + upgradeCost[CurrentUpgrade]
			If upgradeLevel[CurrentUpgrade] = upgradeMax[CurrentUpgrade] costText = "Done"
			Yellow()
			'upgrade Cost
			DrawFont ( costText, 	twbuX + 5*Retina + levelUp_btn.Width/2, 
														twbuY + levelUp_btn.Width/2 - 20*Retina, 
														True,
														70 )
			White()


			'BUY
			DrawFont( "Upgrade", twbuX + levelUp_btn.Width/2 + 5*Retina, twbuY + levelUp_btn.Width/2 + 42*Retina, True, 90 )






			' Progress

			SetColor(0,0,0)
			DrawImageRect( upgradeCurLevel, leftMargin - 23*Retina,
											dw/2 + 15*Retina,

											0,
											0,

											upgradeMax[CurrentUpgrade] * upgradeCurLevel.Height(),
											upgradeCurLevel.Height(),

											0,
											.5,
											1 )
			White()

			DrawImageRect( upgradeCurLevel, leftMargin - 23*Retina,
											dw/2 + 15*Retina,

											0,
											0,

											upgradeLevel[CurrentUpgrade] * upgradeCurLevel.Height(),
											upgradeCurLevel.Height(),

											0,
											.5,
											1 )

			'HELP'

			If descScl > 0

				Local dX:Float = descX + help_btn.Width/2 - descScl*.84 * Retina
				Local dY:Float = descY + help_btn.Height/2 + descScl/5 * Retina

				DrawImage( helpLine, dX, dY+ fontH*.9*Retina, 0, descScl/80.0 * Retina, descScl/80.0 * Retina )

				DrawFont( upgradeDesc[CurrentUpgrade*2], 		dX, dY, 					True, descScl )
				DrawFont( upgradeDesc[CurrentUpgrade*2+1], 		dX, dY + fontH*1.5*Retina, 		True, descScl )

			End

			'If isShopWindowOpen shopWindow.Draw()
#end
		End



		'=================== POWERS UPGRADE'

		If powersUpgradeMode <> 0

			PowersDraw()

		End

		'DrawText ( waveUpgrades, 10,10 )
		'DrawText( slidePowersUpgrade, 20, 100 )



	End

	Method Deinit:Void()

		bgr.Discard()

		play_btn.Deinit()
		menu_btn.Deinit()

		powersUpgrade_btn.Deinit()
		powersBackBtn.Deinit()

		help_btn.Deinit()

		morecoins.Deinit()

		coinsBgr.Discard()

		For Local pb := Eachin PowersButtons
			pb.Deinit()
		End
		PowersButtons.Clear()

		For Local ubc := Eachin upgradesBtn
			ubc.Deinit()
		End
		upgradesBtn.Clear()

		shopIcons.Discard()

		powersUpgradeBgr.Discard()

		powersActivateImg.Discard()
		'powersLockedImg.Discard()

		upgradeLevelImg.Discard()

		buy_btn.Deinit()
		cancel_btn.Deinit()
		'done_btn.Deinit()


		bottlesSnd.Discard()

	End

End

''  ####  #    # ######  ####  #    #    #    # #####   ####  #####    ##   #####  ######  ####  
'' #    # #    # #      #    # #   #     #    # #    # #    # #    #  #  #  #    # #      #      
'' #      ###### #####  #      ####      #    # #    # #      #    # #    # #    # #####   ####  
'' #      #    # #      #      #  #      #    # #####  #  ### #####  ###### #    # #           # 
'' #    # #    # #      #    # #   #     #    # #      #    # #   #  #    # #    # #      #    # 
''  ####  #    # ######  ####  #    #     ####  #       ####  #    # #    # #####  ######  ####  

Function CheckUpgrades:Void()

	'===HELP

	If descScl = 0 And help_btn.Pressed()

		isHelpShown = True

	End

	If isHelpShown

		If descScl < 100 descScl += 10 Else descScl = 100

		If TouchHit(0) isHelpShown = False  Return

		Return

	End

	If isHelpShown = False

		If descScl > 0 descScl -= 10 Else descScl = 0

	End

	'====='

	Local uu:Int = 0
	Local uut:Int

	For Local btnu := Eachin upgradesBtn

		uut = uu

		If uu = 1
			uut = 4
		Elseif uu = 4
			uut = 1
		End

		If CurrentLevel = 1 And uu = 5 Exit

		If CurrentLevel = 2
			If uu = 5 Exit
			If uu = 4 uut = 5
		End

		If CurrentLevel = 3
			If uu = 5 uut = 6
			If uu = 4 uut = 5
		End

		'######  ######  ######  ####   ####  ###### ######  
		'##   ## ##   ## ##     ##     ##     ##     ##   ## 
		'######  ######  ####    ####   ####  ####   ##   ## 
		'##      ##   ## ##     ##  ## ##  ## ##     ##   ## 
		'##      ##   ## ######  ####   ####  ###### ######  

		If CurrentUpgrade = 3 And isFriendShown = False isFriendDisable = True Else isFriendDisable = False

		If upgradeLevel[CurrentUpgrade] < upgradeMax[CurrentUpgrade] And upgradeCost[CurrentUpgrade] <= coins And isFriendDisable = False

			If levelUp_btn.Pressed()

				CreateButtonBubbles()

				upgradeLevel[CurrentUpgrade] += 1

				coins -= upgradeCost[CurrentUpgrade]

				upgradeThe[CurrentUpgrade] += upgradeCoef[CurrentUpgrade]
				upgradeCost[CurrentUpgrade] *= upgradeCostCoef[CurrentUpgrade]

				If CurrentUpgrade = 1 SPEED_MAX += .33

				CheckForAvailablePowers()

				SaveGame()

			End

		End

		'Select Current Upgrade
		If CurrentUpgrade <> uut And upgradeBtn[uut].Pressed()

			CurrentUpgrade = uut

			'If upgradeSeen[uut] = False
			'	upgradeSeen[uut] = True
			'	isHelpShown = True
			'	SaveGame()
			'End

			'btnScaleDraw[CurrentUpgrade] = 1.0
			'btnDistDraw[uut+1] = 20
			'btnDistDraw[uut-1] = -20

			SetUpgradeButtonsDistances()

			CreateButtonBubbles()

		End

		uu += 1

	Next

	SmoothUpgradeButtonsScaleAndMove()

End

Function DrawShopCoinsIndicator:Void(addCX:Int = 0, addCY:Int = 0)

	DrawImage( coinsBgr, morecoins.Width + coinsBgr.Width()/2 + addCX, coinsBgr.Height()/2 )
	Yellow()
	DrawFont( coins, morecoins.Width + coinsBgr.Width() + addCX, coinsBgr.Height()/2, False )
	White()

End

Function DrawUpgradeProgress:Void(uut:Int, ubX:Float, ubY:Float)

	Local upCoef:Float = 3 * Retina

	DrawImage( upgradeLevelImg, ubX, ubY, 1 )

	If upgradeLevel[uut] / upgradeMax[uut] < 1

		DrawImageRect( 	upgradeLevelImg, 

						ubX + upCoef, 
						ubY, 

						upCoef, 
						0, 

						(upgradeLevelImg.Width() - upCoef*2) * ( Float(upgradeLevel[uut])  / Float(upgradeMax[uut] ) ), 
						upgradeLevelImg.Height(),

						2 )

		'DrawFont( upgradeCost[uut], ubX + 100*Retina, ubY + 70*Retina, True, 70 )
	Else

		DrawImage( upgradeLevelImg, ubX, ubY, 0 )

	End

End

Function SetUpgradeButtonsDistances:Void()

	Local counter:Float = 30*Retina
	If CurrentLevel = 3 counter = 0*Retina

	Local uut:Int

	For Local uu:Int = 0 To 6

		uut = uu

		If uu = 1
			uut = 4
		Elseif uu = 4
			uut = 1
		End

		If CurrentLevel = 1 And uu = 5 Exit

		If CurrentLevel = 2
			If uu = 5 Exit
			If uu = 4 uut = 5
		End

		If CurrentLevel = 3
			If uu = 6 Exit
			If uu = 5 uut = 6
			If uu = 4 uut = 5
		End	

		Local isSelected:Int = 1
		If CurrentUpgrade = uut isSelected = 2

		Local btnWidthAll:Float = upgradeBtn[uu].Width/2.4 * isSelected

		counter += btnWidthAll

		ubX_to[uu] = counter - btnWidthAll
		ubY_to[uu] = dh / 3 - upgradeBtn[uu].Height / 4 * isSelected + ubY_rnd[uu] * Retina



	Next

End

Function SmoothUpgradeButtonsScaleAndMove:Void()

	For Local allscl:Int = 0 Until btnScaleDraw.Length()

		If CurrentUpgrade = allscl

			Local speedScale:Float = (1.0 - btnScaleDraw[allscl]) / 20

			If btnScaleDraw[allscl] < 1.0
				btnScaleDraw[allscl] += speedScale
			Else 
				btnScaleDraw[allscl] = 1.0
			End

		Else

			Local speedScale:Float = (btnScaleDraw[allscl] - .5) / 20

			If btnScaleDraw[allscl] > .5
				btnScaleDraw[allscl] -= speedScale
			Else 
				btnScaleDraw[allscl] = .5
			End

		End

		ubX[allscl] += (ubX_to[allscl] - ubX[allscl]) / 10.0
		ubY[allscl] += (ubY_to[allscl] - ubY[allscl]) / 10.0

	Next

End

Function SetRandomButtonsFirstCoordinates:Void()

	For Local allscl:Int = 0 Until btnScaleDraw.Length()

		ubX[allscl] = Rnd(-500, dw+500) * Retina
		ubY[allscl] = dh+500*Retina

	Next

End

Function WavesSet:Void()

	For Local uu:Int = 0 To 6

		waveSin[uu] = Rnd(180)

	End

End

Function WavesUpdate:Void()

	For Local uu:Int = 0 To 6

		waveSin[uu] += waveSinSpd
		If waveSin[uu] = 180
			waveSin[uu] = 0
			waveSinSpd = -waveSinSpd
		End

		waveUpgrades[uu] = Sin(waveSin[uu])*5.0

	End

End