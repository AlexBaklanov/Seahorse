Strict

Import imp

Global enCounter:Int = 30
Global enemiesChance:Int[30]
Global enemies:enemiesClass = New enemiesClass

Global enemiesCount:Int

Global enemyImg:atlasClass[30]
Global enemyFrm:framesClass[30]
'Global enemyAnim:animClass[30]

Global OldLevel:Int

Class enemiesClass

	Field enemyCounter:Int

	Field img:Image[50]

	Field closeToHero:Int

	'd888888b d8b   db d888888b d888888b 
	'  `88'   888o  88   `88'   `~~88~~' 
	'   88    88V8o 88    88       88    
	'   88    88 V8o88    88       88    
	'  .88.   88  V888   .88.      88    
	'Y888888P VP   V8P Y888888P    YP    

	Method Init:Void()
		
		OldLevel = CurrentLevel

		enemyCounter = enCounter

		enemiesReadData()

		Local zeroAdd:String

		For Local enm:Int = 1 To enemiesChance.Length()
			
			If ToLoadEnemy(enm)

				If enm < 10 zeroAdd = "0" Else zeroAdd = ""

				Select enm

					Case 29
						img[enm] = LoadImage("enemies/enemy"+zeroAdd+""+enm+""+loadadd + ".png", 2, Image.MidHandle)

					Case 8, 9, 11, 14, 16, 19, 22, 24, 27, 28, 30
						img[enm] = LoadImage("enemies/enemy"+zeroAdd+""+enm+""+loadadd + ".png", 3, Image.MidHandle)

					Case 7, 15, 23, 21
						img[enm] = LoadImage("enemies/enemy"+zeroAdd+""+enm+""+loadadd + ".png", 4, Image.MidHandle)

					Case 10, 12, 26
						img[enm] = LoadImage("enemies/enemy"+zeroAdd+""+enm+""+loadadd + ".png", 5, Image.MidHandle)

					Case 4, 5, 25
						img[enm] = LoadImage("enemies/enemy"+zeroAdd+""+enm+""+loadadd + ".png", 6, Image.MidHandle)

					Case 17
						img[enm] = LoadImage("enemies/enemy"+zeroAdd+""+enm+""+loadadd + ".png", 100*Retina, 100*Retina, 8, Image.MidHandle)

					Case 1, 2, 3, 6

						enemyImg[enm] = New atlasClass
						enemyImg[enm].Init("enemies/enemy" + zeroAdd + "" + enm + "/img" + loadadd + ".png")

						enemyFrm[enm] = New framesClass
						enemyFrm[enm].Init("enemies/enemy" + zeroAdd + "" + enm + "/")
						'Print "img: " + enm
					
					Default
						img[enm] = LoadImage("enemies/enemy"+zeroAdd+""+enm+""+loadadd + ".png", 1, Image.MidHandle)

				End
				
			End

		Next

		closeToHero = hero.x + hero.Width/2

	End

	'db    db d8888b. d8888b.  .d8b.  d888888b d88888b 
	'88    88 88  `8D 88  `8D d8' `8b `~~88~~' 88'     
	'88    88 88oodD' 88   88 88ooo88    88    88ooooo 
	'88    88 88~~~   88   88 88~~~88    88    88~~~~~ 
	'88b  d88 88      88  .8D 88   88    88    88.     
	'~Y8888P' 88      Y8888D' YP   YP    YP    Y88888P

	Method Update:Void()

		If GameOverMode = False enemyCounter -= 1

		If enemyCounter < 0 And alive RequestEnemy()

		For Local en := Eachin enemy

			en.Update()

			'OUT of SCREEN'
			If ( en.x < -1 * en.w ) Or ( en.y < -1 * en.h ) Or ( en.y > dh + dh * (1 - Int(en.burned)) + en.w ) Or ( en.kicked And ( en.x > dw + en.w ) )
				en.Deinit()
				enemy.Remove(en)
			End

			If friendMode = False And weaponCamouflage.active <> 1 And weaponHyperJump.active <> 1 And en.kicked = False And en.x < closeToHero

				'COLLISION'
				If en.catched = False And Distance(en.pivotX, en.pivotY, hero.x, hero.y) < en.sclX * en.radius
					
					If en.kicked

						en.xMove = speed * globalSpeed * 20
						en.yMove = (en.y - hero.y) / 10.0
						en.rotSpeed = (en.y - hero.y) / 10.0

					Else

						If alive enemy.Remove(en)
					
					End

					If alive
						
						If weaponBatiscaf.active = 1 And weaponBatiscaf.hits > 0

							weaponBatiscaf.hits -= 1
							If weaponBatiscaf.hits = 0 weaponBatiscaf.active = 2

							CreateKick(en, 1)

						ElseIf weaponFireFly.active = 1 And weaponFireFly.hits > 0

							weaponFireFly.hits -= 1
							If weaponFireFly.hits = 0 weaponFireFly.active = 2

							CreateKick(en, 1)
							
						Else
							
							Local arm:Float = armor
							Local dam:Float = en.damage * en.sclX - arm
							
							health -= dam
							
							globalSpeed -= 1
							If globalSpeed < 1 globalSpeed = 1
							
							CreateKick(en, 1)

						End
						
						For Local ben:Int = 1 To 5

							CreateBonus( 3,0, en.x + Rnd(-50, 50) * Retina, en.y + Rnd(-50, 50) * Retina )

						Next

					End

				End

			End

		Next

	End

	'd8888b. d8888b.  .d8b.  db   d8b   db 
	'88  `8D 88  `8D d8' `8b 88   I8I   88 
	'88   88 88oobY' 88ooo88 88   I8I   88 
	'88   88 88`8b   88~~~88 Y8   I8I   88 
	'88  .8D 88 `88. 88   88 `8b d8'8b d8' 
	'Y8888D' 88   YD YP   YP  `8b8' `8d8'  

	Method Draw:Void()

		'enemiesCount = 0

		For Local en := Eachin enemy

			en.Draw()

			'enemiesCount += 1

		Next
		'DrawText("From: " + enemySpeed[2][6..9] + " To: " + enemySpeed[2][12..15], 200, 200)
		'DrawText(enemyYMove[12], 200, 200)

	End

	'd8888b. d88888b d888888b d8b   db d888888b d888888b 
	'88  `8D 88'       `88'   888o  88   `88'   `~~88~~' 
	'88   88 88ooooo    88    88V8o 88    88       88    
	'88   88 88~~~~~    88    88 V8o88    88       88    
	'88  .8D 88.       .88.   88  V888   .88.      88    
	'Y8888D' Y88888P Y888888P VP   V8P Y888888P    YP    

	Method Deinit:Void()

		For Local enm:Int = 1 Until enemiesChance.Length()

			If ToLoadEnemy(enm)
				If enemyImg[enm] <> Null enemyImg[enm].Deinit()
				If img[enm] <> Null img[enm].Discard()
			End

		Next

		For Local en := Eachin enemy

			en.Deinit()

		Next
		enemy.Clear()

	End

End

Global enemy := New List<enemyClass>

Function RequestEnemy:Void()

	Local theType:Int = CalculateTypeOfEnemy()

	Select theType

		Case 0

			enemies.enemyCounter = enCounter / globalSpeed

		Default

			CreateEnemy(theType)

	End

End

Function CreateEnemy:Void(theType:Int, nextVar:Int = 0)

	Local en:enemyClass = New enemyClass
	en.Init(theType, nextVar)
	enemy.AddLast(en)

	enemies.enemyCounter = enCounter / globalSpeed

End

Global validEnemies:Int[]' = [1, 2]

Function CalculateTypeOfEnemy:Int()

	Local theType:Int

	If validEnemies.Length() = 1

		Return validEnemies[0]

	End

	Repeat

		theType = Rnd( 1, enemiesChance.Length() + .9 )

		For Local enm:Int = 1 To validEnemies.Length()

			If theType = validEnemies[enm - 1] Return theType

		Next

	Forever

End

Function ToLoadEnemy:Bool(curEnemy:Int)
	
	Select OldLevel
		
		Case 1
			
			Select curEnemy
				
				Case 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
				
					Return True
					
			End
			
		Case 2
		
			Select curEnemy
				
				Case 7, 16, 4, 26, 17, 29, 20, 1, 12, 14
				
					Return True
					
			End
			
		Case 3
		
			Select curEnemy
				
				Case 27, 9, 11, 10, 28, 15, 23, 21, 24, 13
				
					Return True
					
			End
		
	End
	
	Return False
			
End