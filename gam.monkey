Strict

Import imp

Global CurrentLevel:Int = 1

Global winMode:Bool

Global maskIndicator:Image
Global oxygenIndicator:Image
		'maskIndicator = LoadImage( "maskIndicator" + loadadd + ".png" )
		'oxygenIndicator = LoadImage( "oxygenIndicator" + loadadd + ".png" )


Global mainGame:mainGameClass = New mainGameClass

Class mainGameClass

	Field skip1000 := New Buttons

	'd888888b d8b   db d888888b d888888b 
	'  `88'   888o  88   `88'   `~~88~~' 
	'   88    88V8o 88    88       88    
	'   88    88 V8o88    88       88    
	'  .88.   88  V888   .88.      88    
	'Y888888P VP   V8P Y888888P    YP    
	
	Method Init:Void()

		'Cheats'
		skip1000.Init(">") 'hidden button'

		If levelEnd = 0 LoadLevel(CurrentLevel)
							
		BackgroundInit()
		WinInit()
		GUIInit()
		CrabPreviousInit()
		FriendInit()

		hero.Init()
		enemies.Init()
		bonuses.Init()
		obstacles.Init()

		StreamsInit()
		IndicatorsInit()
		SpeedInit()

		WeaponInit()

	End

	'db    db d8888b. d8888b.  .d8b.  d888888b d88888b 
	'88    88 88  `8D 88  `8D d8' `8b `~~88~~' 88'     
	'88    88 88oodD' 88   88 88ooo88    88    88ooooo 
	'88    88 88~~~   88   88 88~~~88    88    88~~~~~ 
	'88b  d88 88      88  .8D 88   88    88    88.     
	'~Y8888P' 88      Y8888D' YP   YP    YP    Y88888P

	Method Update:String()

		'Cheats'
		If skip1000.Pressed() distance += 2000
		If KeyHit(KEY_A) distance += 500
		If KeyHit(KEY_R) enemyRadiusEnabled = Not enemyRadiusEnabled
		If KeyHit(KEY_B) health -= 10
		If KeyHit(KEY_H) health += 100

		If pauseMode Return PauseUpdate()
		If winMode Return WinUpdate()

		If pause_btn.Pressed() pauseMode = True

		NextLevelAreaInit()

		BackgroundUpdate()

		CaveUpdate()
		hero.Update()
		enemies.Update()
		bonuses.Update()
		obstacles.Update()

		StreamsUpdate()

		FriendUpdate()
		CrabPreviousUpdate()
		
		If GameOverMode = False 
			CrabAnimationUpdate()
			SpeedUpdate()
			GameTime()
		End

		If distance > levelEnd WinActivate()

		If GameOverMode Return GameOverUpdate()

		Return Game

	End



	'd8888b. d8888b.  .d8b.  db   d8b   db 
	'88  `8D 88  `8D d8' `8b 88   I8I   88 
	'88   88 88oobY' 88ooo88 88   I8I   88 
	'88   88 88`8b   88~~~88 Y8   I8I   88 
	'88  .8D 88 `88. 88   88 `8b d8'8b d8' 
	'Y8888D' 88   YD YP   YP  `8b8' `8d8'  


	Method Draw:Void()

		BackgroundDraw()
		
		'DRAW THE BLUR FROM THE HYPER JUMP'
		If weaponHyperJump.duration > 0 DrawImage (hyperJumpImg,dw/2,dh/2 - (hyperJumpImg.Height()/2 - dh/2),0,Retina,Retina)

		CaveDraw()
		
		enemies.Draw()
		obstacles.Draw()
		bonuses.Draw()

		CrabAnimationDraw()
		CrabPreviousDraw()

		hero.Draw()

		FriendDraw()

		StreamsDraw()
		
		GUIDraw()

		If GameOverMode

			GameOverDraw()
			Return

		End

		

		NextWeaponDraw()
		
		If winMode DrawWin()

		'If distance > 100 DrawText(validEnemies[0], 10, 100)
		'DrawText(speed, 10, 120)
		'DrawText(globalSpeed, 10, 140)

		If pauseMode DrawPause()

		SetAlpha(0)
		skip1000.Draw(dw - skip1000.Width - 200*Retina, 0)
		SetAlpha(1)

	End

	'd8888b. d88888b .d8888. d88888b d888888b 
	'88  `8D 88'     88'  YP 88'     `~~88~~' 
	'88oobY' 88ooooo `8bo.   88ooooo    88    
	'88`8b   88~~~~~   `Y8b. 88~~~~~    88    
	'88 `88. 88.     db   8D 88.        88    
	'88   YD Y88888P `8888Y' Y88888P    YP    


	Method Reset:Void()

		BackgroundReset()

		hero.Reset()

		If CurrentLevel = 1 distance = 11000
		If CurrentLevel = 2 distance = 14000
		If CurrentLevel = 3 distance = 0
		distance = 0

		acceleration = upgradeThe[1]
		If CurrentLevel > 1 acceleration = 0.007
		globalSpeed = 1
		speed = 1

		alive = True

		ResetWeapons()

		caveMode = False

		'isFriendShown = False
		'isFriendWindowShown = False

	End

	'd8888b. d88888b d888888b d8b   db d888888b d888888b 
	'88  `8D 88'       `88'   888o  88   `88'   `~~88~~' 
	'88   88 88ooooo    88    88V8o 88    88       88    
	'88   88 88~~~~~    88    88 V8o88    88       88    
	'88  .8D 88.       .88.   88  V888   .88.      88    
	'Y8888D' Y88888P Y888888P VP   V8P Y888888P    YP    

	Method Deinit:Void()
		
		BackgroundDeinit()
		
		GUIDeinit()
		
		CrabPreviousDeinit()
		
		enemies.Deinit()
		bonuses.Deinit()
		obstacles.Deinit()
		hero.Deinit()
		
		StreamsDeinit()
		
		'fireBtn.Deinit()
		
		'maskIndicator.Discard()
		'oxygenIndicator.Discard()
		
		DeinitFriend()
		
	End

End


'd88888b db    db d8b   db  .o88b. d888888b d888888b  .d88b.  d8b   db .d8888. 
'88'     88    88 888o  88 d8P  Y8 `~~88~~'   `88'   .8P  Y8. 888o  88 88'  YP 
'88ooo   88    88 88V8o 88 8P         88       88    88    88 88V8o 88 `8bo.   
'88~~~   88    88 88 V8o88 8b         88       88    88    88 88 V8o88   `Y8b. 
'88      88b  d88 88  V888 Y8b  d8    88      .88.   `8b  d8' 88  V888 db   8D 
'YP      ~Y8888P' VP   V8P  `Y88P'    YP    Y888888P  `Y88P'  VP   V8P `8888Y' 


Function ResetForNextLevel:Void()

	Local LevelCostMultiplier:Int = 1

	CurrentLevel += 1
	'If CurrentLevel = 4 CurrentLevel = 1

	If CurrentLevel = 2 LevelCostMultiplier = 6
	If CurrentLevel = 3 LevelCostMultiplier = 25

	levelEnd = 0

	'Distance
	distanceGUI = 0
	distanceGUILast = 0
	distanceLast = 0
	distance = 0

	'Health
	upgradeThe[0] = 60
	upgradeCost[0] = 30 * LevelCostMultiplier
	upgradeLevel[0] = 0

	'Speed
	'upgradeThe[1] = 0.001
	'upgradeCost[1] = 100
	'upgradeLevel[1] = 0
	'SPEED_MAX = 1.0

	'Armor
	upgradeThe[2] = 0
	upgradeCost[2] = 50 * LevelCostMultiplier
	upgradeLevel[2] = 0

	'friend
	upgradeThe[3] = 0
	upgradeCost[3] = 100 * LevelCostMultiplier
	upgradeLevel[3] = 0

	'RunOut
	upgradeThe[4] = 100
	upgradeCost[4] = 20 * LevelCostMultiplier
	upgradeLevel[4] = 0

	'mask
	upgradeThe[5] = 10
	upgradeCost[5] = 20 * LevelCostMultiplier
	upgradeLevel[5] = 0

	'oxygen
	upgradeThe[6] = 10
	upgradeCost[6] = 10 * LevelCostMultiplier
	upgradeLevel[6] = 0

	comix.done = False

	isFriendShown = False
	isFriendWindowShown = False
	
	SetUpgradeCoefs()
	
End

Function SetUpgradeCoefs:Void()

	If CurrentLevel = 1  upgradeCostCoef 	= [2, 				3, 				1.83, 			1.56, 			1.48, 			1.5,			1.6 ]
	If CurrentLevel = 2  upgradeCostCoef 	= [1.58, 			3, 				1.45, 			1.37, 			1.38, 			1.265,			1.45 ]
	If CurrentLevel = 3  upgradeCostCoef 	= [1.45, 			3, 				1.32, 			1.26, 			1.3, 			1.22,			1.26 ]
	'										= ["Health:   ", 	"Speed:    ", 	"Armor:    ", 	"Friend:   ", 	"Strength: ", 	Mask:     ", 		"Oxygen:   "]
End



Function FromGameToShop:String()

	coins += coinsGame
	coinsGame = 0

	pauseMode = False

	mainGame.Deinit()
	shop.Init()

	SaveGame()

	'If health > -10 ModeFrom = "Not GameOver"

	Return Shop

End

Function FromGameToMenu:String()

	coins += coinsGame
	coinsGame = 0

	pauseMode = False

	mainGame.Deinit()

	menu.Init()

	SaveGame()

	Return Menu

End

'.d8888. d8888b. d88888b d88888b d8888b.      db   db  .d8b.  d8b   db d8888b. db      d88888b 
'88'  YP 88  `8D 88'     88'     88  `8D      88   88 d8' `8b 888o  88 88  `8D 88      88'     
'`8bo.   88oodD' 88ooooo 88ooooo 88   88      88ooo88 88ooo88 88V8o 88 88   88 88      88ooooo 
'  `Y8b. 88~~~   88~~~~~ 88~~~~~ 88   88      88~~~88 88~~~88 88 V8o88 88   88 88      88~~~~~ 
'db   8D 88      88.     88.     88  .8D      88   88 88   88 88  V888 88  .8D 88booo. 88.     
'`8888Y' 88      Y88888P Y88888P Y8888D'      YP   YP YP   YP VP   V8P Y8888D' Y88888P Y88888P 

Global globalSpeed:Float = 1
Global globalFriend:Int

Global speed:Float = 1
Global enemiesSpeed:Float
Global bgrSpeed:Float = 3.0
Global SPEED_MAX:Float = 1.5

Global accelerationGlobal:Float
Global acceleration:Float

Global speedMax:Float

Function SpeedInit:Void()

	speedMax = SPEED_MAX

	If CurrentLevel > 1
		speedMax = 2.0
		SPEED_MAX = 2.0
	End

	If upgradeThe[3] > 0
		speedMax = 4.0
	End

End

Function SpeedUpdate:Void()

	distance += speed * globalSpeed
	globalSpeed += acceleration

	If globalSpeed > speedMax
		globalSpeed = speedMax
	End

	If globalSpeed = speedMax
		acceleration = 0
	Else
		acceleration = upgradeThe[1]
	End

	If friendMode

		acceleration = .1

		globalFriend -= speed * globalSpeed

		If globalFriend < 150

			friendHeroPositionX += 5 * Retina
			acceleration = -.1
			If globalSpeed < 1 globalSpeed = 1

		End

		If globalFriend <= 0

			friendMode = False
			speedMax = SPEED_MAX
			acceleration = 0

		End

	End

	If alive = False acceleration = -.008

End



