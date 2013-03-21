Strict

Import imp

Const JUMP_FORCE:Float = 2.0
Const GRAVITY_FORCE:Float = .04

Global gravity:Float

Global health:Int
Global alive:Bool = True

Global heroSwim:Float

Global hero:heroClass = New heroClass

Global blink:Int
Global tired:Int

Global touched:Bool

Global maskGlobal:Int
Global oxygenGlobal:Int

Global heroScl:Float

Class heroClass

	Field x:Float, y:Float, xConcerningToHero:Float, yConcerningToHero:Float, xConcerningToMask:Float, yConcerningToMask:Float
	
	Field force:Float, jump:Float, runOut:Float, isSwim:Bool, blinkCount:Int = 100
	Field Width:Int, Height:Int, upperBoundary:Int, lowerBoundary:Int, isBoundaryReached:Bool

	Field img:Image, tiredBubble:Image
	Field mask:Image, oxygen:Image, maskX:Float, maskY:Float, maskRot:Int, oxygenX:Float, oxygenY:Float, oxygenRot:Int
	
	Method Init:Void()

		x = dw / 5
		y = dh / 2

		xConcerningToHero = x
		yConcerningToHero = y
		
		xConcerningToMask = xConcerningToHero
		yConcerningToMask = yConcerningToHero
		
		gravity = GRAVITY_FORCE * Retina
		
		img = LoadImage("hero/hero"+loadadd+".png", 55*Retina , 55*Retina, 16, Image.MidHandle)
		tiredBubble = LoadImage("hero/heroTired"+loadadd+".png")
		kickImg = LoadImage( "hero/kick"+loadadd+".png", 4, Image.MidHandle )
		
		'waves = LoadImage("waves"+loadadd+".png", 1, Image.MidHandle)

		heroSwim = 0

		armor = upgradeThe[2]

		mask = 		LoadImage( "hero/mask"+loadadd+".png", 1, Image.MidHandle )
		oxygen = 	LoadImage( "hero/oxygen"+loadadd+".png", 1, Image.MidHandle )

		'magnetRadius = LoadImage("magnetRadius.png", 1, Image.MidHandle)
		'magnetRadiusAlpha = 0.0

		Width = img.Width()
		Height = img.Height()

		heroScl = 1.0

		lowerBoundary = dh - 10*Retina
		upperBoundary = 0
		isBoundaryReached = False

		alive = True
		
		'wavesScl = 0.0
		'wavesOn = False

	End

	'd8888b. d8888b.  .d8b.  db   d8b   db 
	'88  `8D 88  `8D d8' `8b 88   I8I   88 
	'88   88 88oobY' 88ooo88 88   I8I   88 
	'88   88 88`8b   88~~~88 Y8   I8I   88 
	'88  .8D 88 `88. 88   88 `8b d8'8b d8' 
	'Y8888D' 88   YD YP   YP  `8b8' `8d8'  

	Method Draw:Void()

		TiredBubbleDraw()
		FriendDraw()
		HeroDraw()

		MaskDraw()
		OxygenDraw()

		DrawKick()

		DrawWeapons()

		'DrawText(force, 10,70)
		'DrawText(distanceLast, 10,90)
		
	End

	Method TiredBubbleDraw:Void()

		tired = 0
		If health < 0
			If alive DrawImage (tiredBubble, x, y - img.Height()/2 - tiredBubble.Height())
			tired = 8
		End

	End

	Method FriendDraw:Void()

		If friendMode
			Local rotFriend:Int = (yConcerningToHero - y) * 4 / Retina
			DrawImage( friendImg, x+friendHeroPositionX, y+friendHeroPositionY, rotFriend, 1, 1, Int(curFriendFrame) )
			heroSwim = 0
		End

	End

	Method HeroDraw:Void()

		Local rotHero:Int = (yConcerningToMask - yConcerningToHero) * 3 / Retina
		If friendMode rotHero = (yConcerningToHero - y) * 15 / Retina
		DrawImage (img, xConcerningToHero, yConcerningToHero, rotHero + 10, heroScl, heroScl, heroSwim + blink + tired)

	End

	Method MaskDraw:Void()

		If CurrentLevel > 1
			If maskGlobal > 0
				maskX = xConcerningToMask
				maskY = yConcerningToMask
				maskRot = 0
			Else
				maskX += speed/2*globalSpeed
				maskY += 1*Retina
				maskRot += 1
			End
			If winMode = False DrawImage ( mask, maskX, maskY, maskRot, 1, 1 )
		End

	End

	Method OxygenDraw:Void()

		If CurrentLevel > 2
			If oxygenGlobal > 0
				oxygenX = xConcerningToMask
				oxygenY = yConcerningToMask
				oxygenRot = 0
			Else
				oxygenX += speed/2*globalSpeed
				oxygenY += 1*Retina
				oxygenRot += 1
			End
			If winMode = False DrawImage ( oxygen, oxygenX, oxygenY, oxygenRot, 1, 1 )
		End
		
	End

	'db    db d8888b. d8888b.  .d8b.  d888888b d88888b 
	'88    88 88  `8D 88  `8D d8' `8b `~~88~~' 88'     
	'88    88 88oodD' 88   88 88ooo88    88    88ooooo 
	'88    88 88~~~   88   88 88~~~88    88    88~~~~~ 
	'88b  d88 88      88  .8D 88   88    88    88.     
	'~Y8888P' 88      Y8888D' YP   YP    YP    Y88888P

	Field disableJump:Bool

	Method Update:Void()
		
		'When HYPER JUMP is on - no swim!
		If weaponHyperJump.active = 1 Return
		
		UpdateWeapons()

		HandleBoundaries()

		If GameOverMode = False RunOutHandle()

		HandleSmoothMovements()
		
		If friendMode AnimateFirstShowFriend()

		CheckForWeapons()

		GenerateBlink()

		HandleJump()
		
	End

	Method HandleJump:Void()

		If TouchHit(0) And alive And disableJump = False

			jump = JUMP_FORCE * Retina
			force = 0
			
			AnimateHero()
			
			touched = False

			CreateBubblesFromHeroJump()

			isBoundaryReached = False

		End

		If isBoundaryReached Return

		y += force - jump
		force += gravity
		
		jump -= gravity
		If jump < 0 jump = 0
			
		If isSwim
			heroSwim -= .2
			If heroSwim < 0
				heroSwim = 0
				isSwim = False
			End
		End

	End

	Method HandleSmoothMovements:Void()

		xConcerningToHero = x
		If friendMode yConcerningToHero += (y - yConcerningToHero) / 2 Else yConcerningToHero = y
			
		xConcerningToMask += (xConcerningToHero - xConcerningToMask) / 2.5
		yConcerningToMask += (yConcerningToHero - yConcerningToMask) / 2.5

	End

	Method AnimateHero:Void()

		heroSwim = 3.9
		isSwim = True
				
	End

	Method CreateBubblesFromHeroJump:Void()

		CreateBonus(3, 0, xConcerningToHero, yConcerningToHero )
		For Local x:Int = 0 Until 3
			CreateBonus(9, 0, xConcerningToHero, yConcerningToHero )
		Next

	End

	Method GenerateBlink:Void()

		blinkCount -= 1

		If blinkCount < 10 blink = 4

		If blinkCount = 0

			blinkCount = Rnd(30,100)
			blink = 0

		End

	End

	Method HandleBoundaries:Void()

		If y > dh - 10*Retina y = lowerBoundary
		If y < upperBoundary y = upperBoundary

		If isBoundaryReached = False And alive And y = lowerBoundary
			isBoundaryReached = True
			force = 0
		End

	End

	'd8888b. d88888b .d8888. d88888b d888888b 
	'88  `8D 88'     88'  YP 88'     `~~88~~' 
	'88oobY' 88ooooo `8bo.   88ooooo    88    
	'88`8b   88~~~~~   `Y8b. 88~~~~~    88    
	'88 `88. 88.     db   8D 88.        88    
	'88   YD Y88888P `8888Y' Y88888P    YP    

	Method Reset:Void()

		y = dh / 2
		health = upgradeThe[0]
		force = 0
		jump = 0

	End

	'd8888b. d88888b d888888b d8b   db d888888b d888888b 
	'88  `8D 88'       `88'   888o  88   `88'   `~~88~~' 
	'88   88 88ooooo    88    88V8o 88    88       88    
	'88   88 88~~~~~    88    88 V8o88    88       88    
	'88  .8D 88.       .88.   88  V888   .88.      88    
	'Y8888D' Y88888P Y888888P VP   V8P Y888888P    YP    

	Method Deinit:Void()
		
		img.Discard()
		tiredBubble.Discard()
		kickImg.Discard()
		
		kick.Clear()
		coinsIndicator.Clear()
		
		DeinitWeapon()
		
		mask.Discard()
		oxygen.Discard()
		
	End

	' OTHER ==========================================================================================================='
	' OTHER ==========================================================================================================='
	' OTHER ==========================================================================================================='
	' OTHER ==========================================================================================================='
	' OTHER ==========================================================================================================='

	

	'Run Out of health/mask/oxygen'

	Method RunOutHandle:Void()

		If runOut < upgradeThe[4] * Retina

			runOut += HEALTH_RUNOUT * Retina 'time to take a unit from health/mask/oxygen'

		Else

			runOut = 0

			If maskGlobal = 0 And oxygenGlobal = 0 health -= 1

			If friendMode = False
				
				If CurrentLevel = 2
					If maskGlobal > 0 maskGlobal -= 1
				End

				If CurrentLevel = 3
					If oxygenGlobal = 0 
						If maskGlobal > 0 maskGlobal -= 1
					Else
						oxygenGlobal -= 1
					End
				End
			End

		End

	End

	Method PrepareForGameOver:Void()

		health = -10
		alive = False
		If gravity = 0 gravity = .01
		gravity = -gravity
		isBoundaryReached = False
		hero.upperBoundary = -hero.Height
		
	End

	Method PrepareForStream:Void()

		disableJump = True
		gravity = 0
		force = 0
		jump = 0
		heroSwim = 0

	End

	Method CorrectYPosition:Void()

		If isStreamActive And Int(y) <> Int(streamCurrentHeroPosition)

			y += (streamCurrentHeroPosition - y) / 20

		End

	End

	Method OutOfStream:Void()

		disableJump = False
		gravity = GRAVITY_FORCE * Retina

	End

End

Global kickImg:Image

Global kick := New List<kickClass>

Class kickClass
	
	Field x:Int
	Field y:Int

	Field frame:Float

	Field scl:Float

	Method Init:Void(theEnemy:enemyClass, theScale:Float)

		x = hero.x + (theEnemy.x - hero.x)/2
		y = hero.y + (theEnemy.y - hero.y)/2

		frame = 0.0

		scl = theScale

	End

	Method Draw:Void()

		DrawImage ( kickImg, x, y, 0, scl, scl, Int(frame) )

		frame += .4
		If frame > 3.9 kick.Remove(Self)

	End

End


Function CreateKick:Void(theEnemy:enemyClass, theScale:Float)

	Local ki:kickClass = New kickClass
	ki.Init(theEnemy, theScale)
	kick.AddLast(ki)

End

Function DrawKick:Void()

	For Local ki := Eachin kick

		ki.Draw()

	End

End


