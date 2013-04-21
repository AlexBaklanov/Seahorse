Strict

Import imp

Global mainState:String
Global paramLine:String[500]

Function SaveGame:Void()

	mainState = ""

	'Coins 0
	addParam(coins)

	'Distance 1
	Local dist:Int = Int(distance)
	addParam(dist)

	'Health' 2 3
	addParam(upgradeThe[0])
	addParam(upgradeCost[0])

	'Speed 4 5
	addParam(upgradeThe[1] * 10000)
	addParam(upgradeCost[1])

	'Armor 6 7
	addParam(upgradeThe[2])
	addParam(upgradeCost[2])

	'friend 8 9
	addParam(upgradeThe[3])
	addParam(upgradeCost[3])

	'level 10
	addParam(CurrentLevel)

	'SPEED MAX' 11
	addParam(SPEED_MAX * 100)

	'Health runOut 12 13
	addParam(upgradeThe[4])
	addParam(upgradeCost[4])

	'time 14
	addParam(globalTime)

	'last distance' 15
	Local distLast:Int = Int(distanceLast)
	addParam(distLast)

	'comix show 16
	addParam( Int(comix.done) )

	For Local ul:Int = 17 To 26

		addParam(upgradeLevel[ul-17])

	Next

	'Mask 27 28
	addParam(upgradeThe[5])
	addParam(upgradeCost[5])

	'Baloon 29 30
	addParam(upgradeThe[6])
	addParam(upgradeCost[6])

	'friend 31 32
	addParam(Int(isFriendShown))
	addParam(Int(isFriendWindowShown))
	
	For Local us:Int = 33 To 39
		
		addParam( Int(upgradeSeen[us-33]) )
		
	End


	'GAP FOR MISC'

	For Local gfm:Int = 40 To 99

		addParam(0)

	Next



	'weapons'

	For Local ws:Int = 100 To 128

		If weaponPurchased[ ws - 100 ]
			addParam( 1 )
		Else
			addParam ( 0 )
		End

	Next

	'GAP FOR WEAPONS'

	For Local gfm:Int = 129 Until 200

		addParam(0)

	Next

	'Weapon Order'

	For Local wnpw:Int = 200 Until 230

		addParam( wn[wnpw - 200] )
		'Print wn[wnpw - 200]

	Next


	SaveState(mainState)

End











Function LoadGame:Void()

	mainState = LoadState()

	If mainState
		
		Local pn:Int = 0

		For Local line$=Eachin mainState.Split( "~n" )
			
			paramLine[pn] = line
			pn += 1
			
		Next

		'Coins'
		coins = 												Int(paramLine[0])

		'Distance
		distance = 												Int(paramLine[1])

		'Health
		upgradeThe[0] = 										Int(paramLine[2])
		upgradeCost[0] = 										Int(paramLine[3])

		'Speed
		upgradeThe[1] = 										Float(paramLine[4])/10000
		upgradeCost[1] = 										Int(paramLine[5])
		SPEED_MAX = 											Float(paramLine[11])/100

		'Armor
		upgradeThe[2] = 										Int(paramLine[6])
		upgradeCost[2] = 										Int(paramLine[7])

		'friend
		upgradeThe[3] = 										Int(paramLine[8])
		upgradeCost[3] = 										Int(paramLine[9])

		'health RunOut
		upgradeThe[4] = 										Int(paramLine[12])
		upgradeCost[4] = 										Int(paramLine[13])

		'level
		CurrentLevel = 											Int(paramLine[10])

		'time
		globalTime = 											Int(paramLine[14])

		'last distance
		distanceLast = 											Int(paramLine[15])

		'show comix'
		comix.done =											Bool(paramLine[16])

		For Local ul:Int = 17 To 26

			upgradeLevel[ul-17] = 								Int(paramLine[ul])

		Next

		'friend
		upgradeThe[5] = 										Int(paramLine[27])
		upgradeCost[5] = 										Int(paramLine[28])

		'health RunOut
		upgradeThe[6] = 										Int(paramLine[29])
		upgradeCost[6] = 										Int(paramLine[30])

		'friend'
		isFriendShown = 										Bool( Int(paramLine[31]) )
		isFriendWindowShown = 									Bool( Int(paramLine[32]) )
		
		For Local us:Int = 33 To 39
			
			upgradeSeen[us-33] = 								Bool( paramLine[us] )
			
		End

		'weapons
		For Local ws:Int = 100 To 128

			If paramLine[ws] = 1 weaponPurchased[ ws - 100 ] = True Else weaponPurchased[ ws - 100 ] = False

		Next

		'Weapon Order'

		For Local wnpw:Int = 200 Until 230

			wn[wnpw - 200] = Int( paramLine[wnpw] )

		Next

		LoadLevel(CurrentLevel)
		
	Else
		
		ResetGame()
		
	End

End















Function ResetGame:Void()

	'Coins'
	coins = 0

	'Distance
	distanceGUI = 0
	distanceGUILast = 0
	distanceLast = 0
	distance = 0

	'Health
	upgradeThe[0] = 50
	upgradeCost[0] = 10

	'Speed
	upgradeThe[1] = 0.001
	upgradeCost[1] = 100
	SPEED_MAX = 1.0

	'Armor
	upgradeThe[2] = 0
	upgradeCost[2] = 20

	'friend
	upgradeThe[3] = 0
	upgradeCost[3] = 100

	'runOut
	upgradeThe[4] = 100
	upgradeCost[4] = 20

	'mask
	upgradeThe[5] = 20
	upgradeCost[5] = 20

	'baloon
	upgradeThe[6] = 20
	upgradeCost[6] = 10


	'level
	CurrentLevel = 1
	levelEnd = 0

	'time
	globalTime = 0

	'show comix
	comix.done = False

	'friend'
	isFriendShown = False
	isFriendWindowShown = False
	
	CurrentUpgrade = 0

	'upgradeLevels
	For Local ul:Int = 17 To 26

		upgradeLevel[ul-17] = 0

	Next
	
	For Local us:Int = 33 To 39
		
		upgradeSeen[us-33] = False
		
	End

	'weapons
	For Local ws:Int = 100 To 128

		weaponPurchased[ws - 100] = False

	Next

	'Weapon Order'

		' 		0 	1 	2 	3 	4 	5 	6 	7 	8 	9 	10 	11 	12 	13 	14 	15 	16 	17 	18 	19 	20
		wn = [	5,	3,	0,	18,	6,	20,	14,	2,	1,	15,	19,	7,	16,	13,	4,	10,	8,	9,	12,	17,	11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

End



Function addParam:Void(param:Int)
	
	Local strParam:String = String(param)
	strParam = strParam.Trim()
	
	mainState += strParam + "~n"

End