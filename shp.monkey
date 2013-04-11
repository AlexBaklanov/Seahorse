Strict

Import imp

Const HEALTH_RUNOUT:Int = 3

Global friendMode:Bool
Global armor:Float

Global CurrentUpgrade:Int

Global ubX:Float[10], ubY:Int[10], ubX_to:Int[10], ubY_to:Float[10]
Global ubY_rnd:Float[] = [10.0, -20.0, -16.0, 20.0, -18.0, 9.0, -3.0]

Global waveUpgrades:Float[10]
Global waveSin:Float[10]
Global waveSinSpd:Float = 2

Global powX:Int
Global powY:Int

Global descX:Int, descY:Int, descScl:Int
Global isHelpShown:Bool

'ALL ABOUT UPGRADES'

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

' Sounds'
Global bottlesSnd:Sound


'---------------------------------------------------------------------------------------------------------------------------------------------------'
'---------------------------------------------------------------------------------------------------------------------------------------------------'
'---------------------------------------------------------------------------------------------------------------------------------------------------'
'---------------------------------------------------------------------------------------------------------------------------------------------------'
'---------------------------------------------------------------------------------------------------------------------------------------------------'
'---------------------------------------------------------------------------------------------------------------------------------------------------'


Global shop:shopClass = New shopClass

Global shopItemsMax:Int

Global shopGUI := New atlasClass

Class shopClass

	Field upgradeScl:Float[] = [1, .5, .5, .5, .5, .5, .5]
	Field upgradesToShow:Int[7]

	Field bgr:Image

	Field upgradeLevelImg:Image
	Field coinsBgr:Image
	Field shopIcons:Image
	Field chooseUpgradeBtn:Button[10]

	Field morecoins := New Button
	Field levelUp_btn := New Button
	Field help_btn := New Button
	Field play_btn := New Button
	Field menu_btn := New Button

	Field powersUpgrade_btn := New Button

	'd888888b d8b   db d888888b d888888b 
	'  `88'   888o  88   `88'   `~~88~~' 
	'   88    88V8o 88    88       88    
	'   88    88 V8o88    88       88    
	'  .88.   88  V888   .88.      88    
	'Y888888P VP   V8P Y888888P    YP    

	Method Init:Void()

		LoadShopGFX()

		'sounds'
		bottlesSnd = LoadSound( "sounds/bottles.wav" )

		PowersCreate()

		acceleration = accelerationGlobal
		'alive = True

		powersSlide = dw

		SetUpgradeCoefs()

		isHelpShown = False
		descScl = 0

		Select CurrentLevel

			Case 1
				upgradesToShow = [0, 4, 2, 3, 1]

			Case 2
				upgradesToShow = [0, 4, 2, 3, 5]

			Case 3
				upgradesToShow = [0, 4, 2, 3, 5, 6]

		End

		SetUpgradeButtonsDistances()
		SetRandomButtonsFirstCoordinates()

	End

	Method LoadShopGFX:Void()

		shopGUI.Init("shop/shopGUI" + loadadd + ".png")

		'images'
		bgr = LoadImage ( "shop/shop"+retinaStr+".jpg", 1, Image.MidHandle )

		coinsBgr = shopGUI.img[5]
		shopIcons = shopGUI.img[0]
		upgradeLevelImg = shopGUI.img[8]

		'buttons'
		play_btn.Init("", "", 1, 1, 3, shopGUI.img[2])
		menu_btn.Init("", "", 1, 1, 3, shopGUI.img[4])
		morecoins.Init("", "", 1, 1, 3, shopGUI.img[7])
		powersUpgrade_btn.Init("", "", 1, 1, 3, shopGUI.img[3])
		help_btn.Init("", "", 1, 1, 3, shopGUI.img[9])
		levelUp_btn.Init( "", "", 1, 1, 3, shopGUI.img[6])

		ChooseButtonsInit()

	End

	Method ChooseButtonsInit:Void()

		For Local up:Int = 0 To 6

			chooseUpgradeBtn[up] = New Button
			chooseUpgradeBtn[up].Init( "", "", 1, 1, 3, shopGUI.img[1] )

			waveSin[up] = Rnd(180)

		Next

	End

	Method SetUpgradeButtonsDistances:Void()

		Local counter:Float = 30 * Retina
		If CurrentLevel = 3 counter = -5 * Retina

		For Local up:Int = 0 Until upgradesToShow.Length()

			Local curUp:Int = upgradesToShow[up]

			Local isSelected:Int = 1
			If CurrentUpgrade = curUp isSelected = 2

			Local btnWidthAll:Float = chooseUpgradeBtn[up].w/2.4 * isSelected

			counter += btnWidthAll

			ubX_to[up] = counter - btnWidthAll
			ubY_to[up] = dh / 3 - chooseUpgradeBtn[up].h / 4 * isSelected + ubY_rnd[up] * Retina

		Next

	End

	Method SetRandomButtonsFirstCoordinates:Void()

		For Local allscl:Int = 0 Until upgradeScl.Length()

			ubX[allscl] = Rnd(-500, dw+500) * Retina
			ubY[allscl] = dh+500*Retina

		Next

	End

	'db    db d8888b. d8888b.  .d8b.  d888888b d88888b 
	'88    88 88  `8D 88  `8D d8' `8b `~~88~~' 88'     
	'88    88 88oodD' 88   88 88ooo88    88    88ooooo 
	'88    88 88~~~   88   88 88~~~88    88    88~~~~~ 
	'88b  d88 88      88  .8D 88   88    88    88.     
	'~Y8888P' 88      Y8888D' YP   YP    YP    Y88888P

	Method Update:String()

		If KeyHit(KEY_C) Or ControlTouch() = swipeRight
			coins += 7000
			CheckForAvailablePowers()
		End

		GameTime()

		If powersUpgradeMode = -1

			If powersSlide > 0 powersSlide += powersUpgradeMode * 32 * Retina Else powersSlide = 0

			If curPowerWindow = -1 And powersBackBtn.Pressed()

				powersUpgradeMode = 1
				powersSlide = 0

			End

			PowersUpdate()

			Return Shop

		Elseif powersUpgradeMode = 1

			If powersSlide < dw powersSlide += powersUpgradeMode * 32 * Retina Else powersSlide = dw
			If powersSlide = dw powersUpgradeMode = 0

		End

		If play_btn.Pressed() Return PlayBtnHandle()

		If menu_btn.Pressed() Return MenuBtnHandle()

		If powersUpgrade_btn.Pressed() PowersUpgradeBtnHandle()

		CheckUpgrades()
		WavesUpdate()

		Return Shop

	End

	Method PlayBtnHandle:String()

		Self.Deinit()

		If comix.done

			mainGame.Init()

			'If we came from GameOver, reset the game
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

	Method MenuBtnHandle:String()

		SaveGame()
		Self.Deinit()
		menu.Init()

		Return Menu

	End

	Method PowersUpgradeBtnHandle:Void()

		powersUpgradeMode = - 1
		powersSlide = dw

		inertiaDone = False
		inertiaAdd = 0
		inertiaSpd = -.8 * Retina

	End

	Method SmoothUpgradeButtonsScaleAndMove:Void()

		For Local allscl:Int = 0 Until upgradeScl.Length()

			If CurrentUpgrade = allscl

				Local speedScale:Float = (1.0 - upgradeScl[allscl]) / 20

				If upgradeScl[allscl] < 1.0
					upgradeScl[allscl] += speedScale
				Else 
					upgradeScl[allscl] = 1.0
				End

			Else

				Local speedScale:Float = (upgradeScl[allscl] - .5) / 20

				If upgradeScl[allscl] > .5
					upgradeScl[allscl] -= speedScale
				Else 
					upgradeScl[allscl] = .5
				End

			End

			ubX[allscl] += (ubX_to[allscl] - ubX[allscl]) / 10.0
			ubY[allscl] += (ubY_to[allscl] - ubY[allscl]) / 10.0

		Next

	End

	Method HelpHandle:Void()

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

	End

	Method UpgradeButtonPressed:Void()

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

	End

	Method WavesUpdate:Void()

		For Local up:Int = 0 To 6

			waveSin[up] += waveSinSpd
			If waveSin[up] = 180
				waveSin[up] = 0
				waveSinSpd = -waveSinSpd
			End

			waveUpgrades[up] = Sin(waveSin[up])*5.0

		End

	End


	' .o88b. db   db d88888b  .o88b. db   dD      db    db d8888b.  d888b  d8888b.  .d8b.  d8888b. d88888b .d8888. 
	'd8P  Y8 88   88 88'     d8P  Y8 88 ,8P'      88    88 88  `8D 88' Y8b 88  `8D d8' `8b 88  `8D 88'     88'  YP 
	'8P      88ooo88 88ooooo 8P      88,8P        88    88 88oodD' 88      88oobY' 88ooo88 88   88 88ooooo `8bo.   
	'8b      88~~~88 88~~~~~ 8b      88`8b        88    88 88~~~   88  ooo 88`8b   88~~~88 88   88 88~~~~~   `Y8b. 
	'Y8b  d8 88   88 88.     Y8b  d8 88 `88.      88b  d88 88      88. ~8~ 88 `88. 88   88 88  .8D 88.     db   8D 
	' `Y88P' YP   YP Y88888P  `Y88P' YP   YD      ~Y8888P' 88       Y888P  88   YD YP   YP Y8888D' Y88888P `8888Y' 

	Method CheckUpgrades:Void()

		HelpHandle()

		Local curUp:Int

		For Local up:Int = 0 Until upgradesToShow.Length()

			Local curUp:Int = upgradesToShow[up]

			'Select Current Upgrade
			If CurrentUpgrade <> curUp And chooseUpgradeBtn[curUp].Pressed()

				CurrentUpgrade = curUp
				SetUpgradeButtonsDistances()
				CreateButtonBubbles()

			End

		Next

		UpgradeButtonPressed()

		SmoothUpgradeButtonsScaleAndMove()

	End

	'd8888b. d8888b.  .d8b.  db   d8b   db 
	'88  `8D 88  `8D d8' `8b 88   I8I   88 
	'88   88 88oobY' 88ooo88 88   I8I   88 
	'88   88 88`8b   88~~~88 Y8   I8I   88 
	'88  .8D 88 `88. 88   88 `8b d8'8b d8' 
	'Y8888D' 88   YD YP   YP  `8b8' `8d8'  


	Method Draw:Void()

		If powersSlide

			DrawImage ( bgr, dw/2, dh/2, 0, retinaScl, retinaScl )

			play_btn.Draw( dw/2 - play_btn.w/2, dh - play_btn.h )
			menu_btn.Draw ( 0, dh - menu_btn.h )
			DrawShopCoinsIndicator()
			morecoins.Draw( 0, -morecoins.h/3 )

			BlinkPowerBtnHandle()
		
			powersUpgrade_btn.Draw( dw - powersUpgrade_btn.w, 
									dh - powersUpgrade_btn.h,
									blinkAvailablePowers )

			For Local up:Int = 0 Until upgradesToShow.Length()

				Local curUp:Int = upgradesToShow[up]

				'disable friend'
				If curUp = 3 And isFriendShown = False isFriendDisable = True Else isFriendDisable = False

				Local upgradeW:Float = chooseUpgradeBtn[curUp].w * upgradeScl[curUp]
				Local upgradeH:Float = chooseUpgradeBtn[curUp].h * upgradeScl[curUp]

				chooseUpgradeBtn[curUp].Draw( ubX[up], ubY[up] + waveUpgrades[up], upgradeScl[curUp] )

				DrawImage (shopIcons, 	ubX[up] + upgradeW * .5,
										ubY[up] + upgradeH * .3 + waveUpgrades[up],
										0,
										.5 + upgradeScl[curUp] / 2,
										.5 + upgradeScl[curUp] / 2,
										curUp)

				'upgrade process
				DrawUpgradeProgress(curUp, 	ubX[up] + chooseUpgradeBtn[curUp].w * .15 * upgradeScl[curUp], 
											ubY[up] + chooseUpgradeBtn[curUp].h * .56 * upgradeScl[curUp] + waveUpgrades[up] )

				If CurrentUpgrade = curUp

					'Upgrade BTN
					If upgradeCost[curUp] > coins Or upgradeLevel[curUp] = upgradeMax[curUp] Or isFriendDisable SetAlpha (.5)

					levelUp_btn.Draw( 	ubX[up] + upgradeW * .5,
										ubY[up] + upgradeH * .8 + waveUpgrades[up],
										(upgradeScl[curUp] - .5) * 2 )

					If upgradeCost[curUp] > coins Or upgradeLevel[curUp] = upgradeMax[curUp] Or isFriendDisable SetAlpha (1)

					'NAME'
					DrawFont( 	upgradeName[curUp],
								ubX[up] + upgradeW / 2,
								ubY[up] + upgradeH / 2 + waveUpgrades[up],
								True,
								(upgradeScl[curUp] - .5) * 200 )

				End


				'cost

				Local costText:String = "|" + upgradeCost[curUp]
				If upgradeLevel[curUp] = upgradeMax[curUp] costText = "Done"
				Yellow()
				DrawFont ( costText, 	ubX[up] + upgradeW * .55, 
										ubY[up] + upgradeH * .81 + waveUpgrades[up], 
										True, 
										70 + 30 * (upgradeScl[curUp] - .5) * 2 )
				White()

			Next

		End

		If powersUpgradeMode <> 0

			PowersDraw()

		End

	End

	Field blinkAvailablePowers:Float
	Field blinkAvailablePowersSpeed:Float = 0.001

	Method BlinkPowerBtnHandle:Void()

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

	End

	Method DrawShopCoinsIndicator:Void(addCX:Int = 0, addCY:Int = 0)

		DrawImage( coinsBgr, morecoins.w + coinsBgr.Width()/2 + addCX, coinsBgr.Height()/2 )
		Yellow()
		DrawFont( coins, morecoins.w + coinsBgr.Width() + addCX, coinsBgr.Height()/2, False )
		White()

	End

	Method DrawUpgradeProgress:Void(curUp:Int, ubX:Float, ubY:Float)

		Local upCoef:Float = 3 * Retina

		DrawImage( upgradeLevelImg, ubX, ubY, 0 )

		If upgradeLevel[curUp] / upgradeMax[curUp] < 1

			DrawImageRect( 	upgradeLevelImg, 

							ubX + upCoef, 
							ubY, 

							upCoef, 
							0, 

							(upgradeLevelImg.Width() - upCoef*2) * ( Float(upgradeLevel[curUp])  / Float(upgradeMax[curUp] ) ), 
							upgradeLevelImg.Height(),

							1 )

		Else

			DrawImage( upgradeLevelImg, ubX, ubY, 2 )

		End

	End

	'd8888b. d88888b d888888b d8b   db d888888b d888888b 
	'88  `8D 88'       `88'   888o  88   `88'   `~~88~~' 
	'88   88 88ooooo    88    88V8o 88    88       88    
	'88   88 88~~~~~    88    88 V8o88    88       88    
	'88  .8D 88.       .88.   88  V888   .88.      88    
	'Y8888D' Y88888P Y888888P VP   V8P Y888888P    YP    

	Method Deinit:Void()

		shopGUI.Deinit()

		bgr.Discard()

		play_btn.Deinit()
		menu_btn.Deinit()

		powersUpgrade_btn.Deinit()
		powersBackBtn.Deinit()

		help_btn.Deinit()

		morecoins.Deinit()

		coinsBgr.Discard()

		For Local pw:Int = 0 Until 21
			powerButton[pw].Deinit()
		End

		For Local up:Int = 0 To 6
			chooseUpgradeBtn[up].Deinit()
		Next

		shopIcons.Discard()

		powersUpgradeBgr.Discard()

		upgradeLevelImg.Discard()

		buy_btn.Deinit()
		cancel_btn.Deinit()

		bottlesSnd.Discard()

	End

End






