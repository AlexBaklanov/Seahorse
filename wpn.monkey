Strict

Import imp

Global powersIcon:Image

Global shellImg:Image
Global lightningImg:Image
Global lightningFImg:Image
Global bubbleImg:Image
Global anchorImg:Image
Global batiscafImg:Image
Global fishFlockImg:Image
Global fishCleenImg:Image
Global starfishImg:Image
Global psyImg:Image
Global psyEffectImg:Image
Global fleeImg:Image
Global hyperJumpImg:Image
Global hammerImg:Image
Global stoneImg:Image
Global fireFlyImg:Image
Global swirlImg:Image
Global reduceImg:Image
Global enemyCoinsImg:Image
Global camouflageImg:Image

' Order array
Global wn:Int[] = [6,4,1,19,7,21,15,3,2,16,20,8,17,14,5,11,9,10,13,18,12]


Function WeaponLoad:Void()

	If weaponActivated[1] Or weaponActivated[2]
		shellImg 			= LoadImage("powersUse/Wshell"			+loadadd+".png", 1, Image.MidHandle) 
	End
	If weaponActivated[3] 
		lightningImg 		= LoadImage("powersUse/Wlightning"		+loadadd+".png") 
	End
	If weaponActivated[3] 
		lightningFImg		= LoadImage("powersUse/WlightningFlash"	+loadadd+".png", 1, Image.MidHandle) 	
	End
	If weaponActivated[4] 
		bubbleImg 			= LoadImage("powersUse/Wbubbles"			+loadadd+".png", 1, Image.MidHandle) 
	End
	If weaponActivated[5] 
		anchorImg 			= LoadImage("powersUse/Wanchor"			+loadadd+".png") 						
	End
	If weaponActivated[7] 
		batiscafImg			= LoadImage("powersUse/Wbatiscaf"			+loadadd+".png", 3, Image.MidHandle) 	
	End
	If weaponActivated[8] 
		fishFlockImg		= LoadImage("powersUse/WfishFlock"		+loadadd+".png", 1, Image.MidHandle) 	
	End
	If weaponActivated[9] 
		fishCleenImg		= LoadImage("powersUse/WfishCleen"		+loadadd+".png", 1, Image.MidHandle) 	
	End
	If weaponActivated[10] 
		starfishImg			= LoadImage("powersUse/Wstarfish"			+loadadd+".png", 1, Image.MidHandle)	
	End	
	If weaponActivated[11] 
		psyImg 				= LoadImage("powersUse/Wpsy"				+loadadd+".png") 						
	End
	If weaponActivated[11] 
		psyEffectImg		= LoadImage("powersUse/WpsyEffect"		+loadadd+".png", 1, Image.MidHandle) 	
	End
	If weaponActivated[12] 
		fleeImg 			= LoadImage("powersUse/Wflee.png"						   , 1, Image.MidHandle) 	
	End
	If weaponActivated[13] 
		hyperJumpImg		= LoadImage("powersUse/WhyperJump.png"				   , 1, Image.MidHandle)
	End
	If weaponActivated[15] 
		hammerImg 			= LoadImage("powersUse/Whammer"		+retinaStr+".png"  , 1, Image.MidHandle)
	End
	If weaponActivated[16] 
		stoneImg 			= LoadImage("powersUse/Wstone"			+loadadd+".png", 1, Image.MidHandle)
	End
	If weaponActivated[17] 
		fireFlyImg 			= LoadImage("powersUse/WfireFly"			+loadadd+".png", 1, Image.MidHandle)
	End
	If weaponActivated[18] 
		swirlImg 			= LoadImage("powersUse/Wswirl"			+loadadd+".png", 1, Image.MidHandle)
	End
	If weaponActivated[19] 
		reduceImg 			= LoadImage("powersUse/Wreduce.png"					   , 1, Image.MidHandle)
	End
	If weaponActivated[20] 
		enemyCoinsImg 		= LoadImage("powersUse/WenemyCoins"		+loadadd+".png", 1, Image.MidHandle)
	End
	If weaponActivated[21] 
		'camouflageImg 		= LoadImage("powersUse/Wcamouflage"		+loadadd+".png", 1, Image.MidHandle)
	End

	powersIcon				= LoadImage("powersUse/powersIcon"		+loadadd+".png", 32*Retina, 32*Retina, 25 )

End

Function DeinitWeapon:Void()

	If weaponActivated[1] Or weaponActivated[2] 	
		shellImg.Discard()			
	End
	If weaponActivated[3] 							
		lightningImg.Discard()		
	End
	If weaponActivated[3] 							
		lightningFImg.Discard()		
	End
	If weaponActivated[4] 							
		'bubbleImg.Discard()			
	End
	If weaponActivated[5] 							
		anchorImg.Discard()			
	End
	If weaponActivated[7] 							
		batiscafImg.Discard()		
	End
	If weaponActivated[8] 							
		fishFlockImg.Discard()		
	End
	If weaponActivated[9] 							
		fishCleenImg.Discard()		
	End
	If weaponActivated[10] 							
		starfishImg.Discard()		
	End
	If weaponActivated[11] 							
		psyImg.Discard()			
	End
	If weaponActivated[11] 							
		psyEffectImg.Discard()		
	End
	If weaponActivated[12] 							
		fleeImg.Discard()			
	End
	If weaponActivated[13] 							
		hyperJumpImg.Discard()		
	End
	If weaponActivated[15] 							
		hammerImg.Discard()			
	End
	If weaponActivated[16] 							
		stoneImg.Discard()			
	End
	If weaponActivated[17] 							
		fireFlyImg.Discard()		
	End
	If weaponActivated[18] 							
		swirlImg.Discard()			
	End
	If weaponActivated[19]
		reduceImg.Discard()
	End
	If weaponActivated[20]
		enemyCoinsImg.Discard()
	End
	If weaponActivated[21]
		'camouflageImg.Discard()
	End

End

Function DrawWeapons:Void()

	If weaponShell.active 			= 1 	
		weaponShell.Draw()
	End	
	If weaponShell3.active 			= 1		
		weaponShell3.Draw()
	End	
	If weaponLightning.active 		= 1 	
		weaponLightning.Draw()
	End
	If weaponBubbles.active 		= 1 	
		weaponBubbles.Draw()
	End
	If weaponAnchor.active 			= 1 	
		weaponAnchor.Draw()
	End
	If weaponBatiscaf.active 		= 1 	
		weaponBatiscaf.Draw()
	End
	If weaponFishFlock.active 		= 1 	
		weaponFishFlock.Draw()
	End
	If weaponFishCleen.active 		= 1 	
		weaponFishCleen.Draw()
	End
	If weaponStarfish.active 		= 1 	
		weaponStarfish.Draw()
	End
	If weaponPsy.active 			= 1 	
		weaponPsy.Draw()
	End
	If weaponFlee.active 			= 1 	
		weaponFlee.Draw()
	End
	If weaponHyperJump.active 		= 1 	
		weaponHyperJump.Draw()
	End
	If weaponHammer.active 			= 1 	
		weaponHammer.Draw()
	End
	If weaponStone.active 			= 1 	
		weaponStone.Draw()
	End
	If weaponFireFly.active 		= 1 	
		weaponFireFly.Draw()
	End
	If weaponSwirl.active 			= 1 	
		weaponSwirl.Draw()
	End
	If weaponReduce.active 			= 1 	
		weaponReduce.Draw()
	End
	If weaponEnemyCoins.active 		= 1 	
		weaponEnemyCoins.Draw()
	End
	If weaponCamouflage.active 		= 1 	
		weaponCamouflage.Draw()
	End

End

Function UpdateWeapons:Void()

	If weaponShell.active 			= 1 	
		weaponShell.Update()
	End
	If weaponShell3.active 			= 1		
		weaponShell3.Update()
	End
	If weaponLightning.active 		= 1 	
		weaponLightning.Update()
	End
	If weaponBubbles.active 		= 1 	
		weaponBubbles.Update()
	End
	If weaponAnchor.active 			= 1 	
		weaponAnchor.Update()
	End
	If weaponBatiscaf.active 		= 1 	
		weaponBatiscaf.Update()
	End
	If weaponFishFlock.active 		= 1 	
		weaponFishFlock.Update()
	End
	If weaponFishCleen.active 		= 1 	
		weaponFishCleen.Update()
	End
	If weaponStarfish.active 		= 1 	
		weaponStarfish.Update()
	End
	If weaponPsy.active 			= 1 	
		weaponPsy.Update()
	End
	If weaponFlee.active 			= 1 	
		weaponFlee.Update()
	End
	If weaponHyperJump.active 		= 1 	
		weaponHyperJump.Update()
	End
	If weaponHammer.active 			= 1 	
		weaponHammer.Update()
	End
	If weaponStone.active 			= 1 	
		weaponStone.Update()
	End
	If weaponFireFly.active 		= 1 	
		weaponFireFly.Update()
	End
	If weaponSwirl.active 			= 1 	
		weaponSwirl.Update()
	End
	If weaponReduce.active 			= 1 	
		weaponReduce.Update()
	End
	If weaponEnemyCoins.active 		= 1 	
		weaponEnemyCoins.Update()
	End
	If weaponCamouflage.active 		= 1 	
		weaponCamouflage.Update()
	End

End

Function ResetWeapons:Void()

	weaponShell.active = 0
	weaponShell3.active = 0
	weaponLightning.active = 0
	weaponBubbles.active = 0
	weaponAnchor.active = 0
	weaponBatiscaf.active = 0
	weaponFishFlock.active = 0
	weaponFishCleen.active = 0
	weaponStarfish.active = 0
	weaponPsy.active = 0
	weaponFlee.active = 0
	weaponHyperJump.active = 0
	weaponHammer.active = 0
	weaponFireFly.active = 0
	weaponSwirl.active = 0
	weaponReduce.active = 0
	weaponEnemyCoins.active = 0
	weaponCamouflage.active = 0
	
End


Function AnyWeaponActive:Bool()

	If weaponShell.active 			= 1 	Return True
	If weaponShell3.active 			= 1 	Return True
	If weaponLightning.active 		= 1 	Return True
	If weaponBubbles.active 		= 1 	Return True
	If weaponAnchor.active 			= 1 	Return True
	If weaponBatiscaf.active 		= 1 	Return True
	If weaponFishFlock.active 		= 1 	Return True
	If weaponFishCleen.active 		= 1 	Return True
	If weaponStarfish.active 		= 1 	Return True
	If weaponPsy.active 			= 1 	Return True
	If weaponFlee.active 			= 1 	Return True
	If weaponHyperJump.active 		= 1 	Return True
	If weaponHammer.active 			= 1 	Return True
	If weaponStone.active 			= 1 	Return True
	If weaponFireFly.active 		= 1 	Return True
	If weaponSwirl.active 			= 1 	Return True
	If weaponReduce.active 			= 1 	Return True
	If weaponEnemyCoins.active 		= 1 	Return True
	If weaponCamouflage.active 		= 1 	Return True
	Return False

End

Global weaponActivated:Bool[30]
Global weaponReady:Bool[30]
'								shell 	shell3 	lightning 	bubble 	anchor 	magnet 	batiscaf 	fishflock 	fishCleen 	starfish 	psy 	flee 	
Global weaponCost:Int[] = [0, 	2000, 	3000, 	500, 		1000, 	1000, 	200, 	2000, 		2000, 		2000, 		2000, 		1000, 	5000, 	3000, 4000, 1000, 200, 1200, 1300, 5000, 3000, 4000, 1000, 200, 1200, 1300, 5000, 3000, 400]

Global WeaponNumber:Int

Function CheckForWeapons:Void()

	'If AnyWeaponActive() Return False

	If ( KeyHit(KEY_W) Or Swipe() ) And globalFriend <= 0 'Or fireBtn.Pressed() )

		'hero.jump = 0
		touched = False
		
		For Local wnbr:Int = 0 To wn.Length()-1
			
			If weaponActivated[ wn[wnbr] ] And weaponReady[ wn[wnbr] ]
				WeaponNumber = wn[wnbr]
				weaponReady[wn[wnbr]] = False
				Exit
			End
			
			WeaponNumber = 0
			
		Next
		
		Select WeaponNumber
			
			Case 1		
				weaponShell.Create()
				
			Case 2		
				weaponShell3.Create()
				
			Case 3
				weaponLightning.Create()
					
			Case 4
				weaponBubbles.Create()
		
			Case 5
				weaponAnchor.Create()
		
			Case 7
				weaponBatiscaf.Create()
		
			Case 8
				weaponFishFlock.Create()
		
			Case 9
				weaponFishCleen.Create()
		
			Case 10
				weaponStarfish.Create()
		
			Case 11
				weaponPsy.Create()
		
			Case 12
				weaponFlee.Create()
		
			Case 13
				weaponHyperJump.Create()
		
			Case 15
				weaponHammer.Create()
				
			Case 16
				weaponStone.Create()
		
			Case 17
				weaponFireFly.Create()
		
			Case 18
				weaponSwirl.Create()
		
			Case 19
				weaponReduce.Create()
		
			Case 20
				weaponEnemyCoins.Create()
		
			Case 21
				weaponCamouflage.Create()
				
		End

	End

End
'============================= CLASSES  ==============================='
'============================= CLASSES  ==============================='
'============================= CLASSES  ==============================='

'Shell'

Global weaponShell:weaponShellClass = New weaponShellClass

Class weaponShellClass
	
	Field x:Float
	Field y:Float

	Field active:Int

	Field activated:Bool

	Field wSpeed:Float

	Method Create:Void()

		x = hero.x
		y = hero.y

		wSpeed = 4 * Retina

		active = 1

	End

	Method Draw:Void()

		x += wSpeed
		'wSpeed += .1

		If x > dw + shellImg.Width()
			active = 2
			wSpeed = 0
		End

		DrawImage( shellImg, x, y )

		For Local en := Eachin enemy

			If Distance ( en.x, en.y, x, y ) < en.img.Width()/2 + shellImg.Width()/2

				en.kicked = True
				en.xMove = speed*globalSpeed*3
				en.yMove = (en.y - hero.y) / 10.0
				en.rotSpeed = (en.y - hero.y) / 10.0

			End

		Next

	End
	
	Method Update:Void()
		
	End

End

'Shell 3'

Global weaponShell3:weaponShell3Class = New weaponShell3Class

Class weaponShell3Class
	
	Field x:Float
	Field y1:Float
	Field y2:Float
	Field y3:Float

	Field active:Int

	Field activated:Bool

	Field wSpeed:Float

	Method Create:Void()

		x = hero.x
		y1 = hero.y
		y2 = hero.y
		y3 = hero.y

		wSpeed = 4 * Retina

		active = 1

	End

	Method Draw:Void()

		x += wSpeed
		y1 -= wSpeed/2
		y3 += wSpeed/2
		'wSpeed += .1

		If x > dw + shellImg.Width()
			active = 2
			wSpeed = 0
		End

		Local sclShell:Float = .7

		DrawImage( shellImg, x, y1, 0, sclShell, sclShell )
		DrawImage( shellImg, x, y2, 0, sclShell, sclShell )
		DrawImage( shellImg, x, y3, 0, sclShell, sclShell )

		For Local en := Eachin enemy

			Local dist1:Float = Distance ( en.x, en.y, x, y1 )
			Local dist2:Float = Distance ( en.x, en.y, x, y2 )
			Local dist3:Float = Distance ( en.x, en.y, x, y3 )
			Local distDiff:Float = en.img.Width()/2 + shellImg.Width()/2 * sclShell

			If (dist1 < distDiff Or dist2 < distDiff Or dist3 < distDiff)
				'enemy.Remove(en)
				en.kicked = True
				en.xMove = speed*globalSpeed*3
				en.yMove = (en.y - hero.y) / 10.0
				en.rotSpeed = (en.y - hero.y) / 10.0
			End

		Next

	End
	
	Method Update:Void()
		
	End

End

'Lightning'

Global weaponLightning:weaponLightningClass = New weaponLightningClass

Class weaponLightningClass
	
	Field x:Float
	Field y:Float

	Field active:Int

	Field activated:Bool

	Field duration:Int
	Field power:Int

	Field isAnyBurned:Bool

	Method Create:Void()

		x = hero.x
		y = hero.y

		active = 1

		duration = 60
		power = 20
		
		Local ltg:Int = 0
		
		For Local en := Eachin enemy

			If en.x > hero.x And en.y < hero.y + 200*Retina And en.y > hero.y - 200*Retina And en.lightned = False

				en.lightned = True
				ltg += 1
				
				If ltg = 3 Exit

			End

		Next

	End

	Method Draw:Void()

		duration -= 1

		If duration = -100
			active = 2
		End

		For Local en := Eachin enemy

			If duration >= 0 And en.lightned

				Local angle:Float = ATan( (en.y - y) / (-en.x + x) )
				Local hyp:Float = Distance( hero.x, hero.y, en.x, en.y )

				DrawImageRect( lightningImg, hero.x, hero.y-lightningImg.Height()/2, 0, 0, hyp, lightningImg.Height(), angle, 1, 1 )

				DrawImage( lightningFImg, en.x, en.y, Rnd(0,360), 1, 1 )

				en.kicked = True
				en.xMove = speed*globalSpeed*.3
				en.yMove = 2*Retina
				en.rotSpeed = Rnd(-3,3)*Retina

				power -= 1
				
				If power = 0
					en.burned = True
					en.lightned = False
					power = 20
				End

				Return

			End

		Next

	End
	
	Method Update:Void()
		
	End

End

'Bubbles

Global weaponBubbles:weaponBubblesClass = New weaponBubblesClass

Class weaponBubblesClass
	
	Field x:Float, y:Float

	Field active:Int

	Field activated:Bool

	Field amount:Int
	Field move:Float
	
	Field scl:Float, sclSpd:Float, sclMax:Float
	Field x2:Float = 1.0

	Method Create:Void()

		active = 1
		amount = 0
		move = .1 * Retina

		For Local en := Eachin enemy
			If en.x > hero.x
				en.catched = True
				
				x2 = Float( en.img.Width()*en.sclX ) / 256*Retina
				amount += 1
			End
			If amount = 5 Exit
		Next
		
		scl = 0.0 sclMax = .2 sclSpd = .15

	End

	Method Draw:Void()

		For Local en := Eachin enemy
			If en.catched
				DrawImage (bubbleImg, en.x, en.y, 0, scl, scl)
			End
		End

	End
	
	Method Update:Void()
		
		amount = 0
		move += .01 * Retina
		
		If scl <> 1.0
		
		scl += sclSpd
		'sclAlpha += .05
		'If sclAlpha > 1.0 sclAlpha = 1.0
		
		If (sclSpd < 0 And scl < 1-sclMax) Or (sclSpd > 0 And scl > 1+sclMax) 
			sclSpd = - sclSpd
			sclMax *= .3
		End
		If sclMax < 0.005 scl = 1.0
		If sclSpd > 0.00001 And scl > .5 sclSpd *= .84
			
		End

		For Local en := Eachin enemy
			If en.catched
				en.y -= move
				amount += 1
			End
		End

		If amount = 0 active = 2
		
	End

End

'Anchor'

Global weaponAnchor:weaponAnchorClass = New weaponAnchorClass

Class weaponAnchorClass
	
	Field x:Float
	Field y:Float

	Field active:Int

	Field activated:Bool

	Field amount:Int
	Field move:Float

	Method Create:Void()

		active = 1
		amount = 5
		move = 1

		For Local en := Eachin enemy
			If en.x > hero.x
				en.catched = True
				amount -= 1
			End
			If amount = 0 Exit
		Next

	End

	Method Draw:Void()

		amount = 0
		move += .1

		For Local en := Eachin enemy
			If en.catched
				DrawImage( anchorImg, en.x - anchorImg.Width()/2, en.y )
				en.y += move
				amount += 1
			End
		End

		If amount = 0 active = 2

	End
	
	Method Update:Void()
		
	End

End

'Batiscaf'

Global weaponBatiscaf:weaponBatiscafClass = New weaponBatiscafClass

Class weaponBatiscafClass

	Field active:Int

	Field activated:Bool

	Field hits:Int

	Method Create:Void()

		active = 1
		hits = 3

	End

	Method Draw:Void()

		DrawImage( batiscafImg, hero.x, hero.y, 3 - hits )

	End
	
	Method Update:Void()
		
	End

End

'Fish Flock'

Global weaponFishFlock:weaponFishFlockClass = New weaponFishFlockClass

Class weaponFishFlockClass
	
	Field x:Float[20]
	Field y:Float[20]
	Field wSpeed:Float[20]

	Field cnt:Int = 10

	Field active:Int

	Field activated:Bool

	Method Create:Void()

		For Local wfY:Int = 1 To cnt

			x[wfY] = -1 * Rnd(0, dw/1.5)
			y[wfY] = dh/2 - dh/4 + (dh/2/cnt)*wfY
			wSpeed[wfY] = 4 * Retina * Rnd(.8, 1.2)

		Next

		x[1] = -10*Retina

		active = 1

	End

	Method Draw:Void()

		For Local wfY:Int = 1 To cnt

			x[wfY] += wSpeed[wfY]

			If x[wfY] > dw * 2 + fishFlockImg.Width()
				active = 2
				wSpeed[wfY] = 0
			End

		Local sclFishFlock:Float = .7

		DrawImage( fishFlockImg, x[wfY], y[wfY], 0, sclFishFlock, sclFishFlock )

		For Local en := Eachin enemy

			Local dist:Float = Distance ( en.x, en.y, x[wfY], y[wfY] )
			Local distDiff:Float = en.img.Width()/2 + fishFlockImg.Width()/2 * sclFishFlock

			If (dist < distDiff)
				
				en.kicked = True
				en.xMove = speed*globalSpeed*3
				en.yMove = (en.y - hero.y) / 10.0
				en.rotSpeed = (en.y - hero.y) / 10.0
				
			End

		Next


		Next

	End
	
	Method Update:Void()
		
	End

End

'Fish Cleen'

Global weaponFishCleen:weaponFishCleenClass = New weaponFishCleenClass

Class weaponFishCleenClass
	
	Field x:Float[20]
	Field y:Float[20]
	Field wSpeed:Float[20]

	Field cnt:Int = 7

	Field active:Int

	Field activated:Bool

	Method Create:Void()

		Local xPosC:Int = 50 * Retina
		Local minus:Int = 1

		For Local wfY:Int = 1 To cnt

			minus = wfY
			If wfY > 4 minus = cnt - wfY + 1

			x[wfY] = -dw/2 + xPosC * minus
			y[wfY] = dh/2 - dh/4 + (dh/2/cnt)*wfY
			wSpeed[wfY] = 5 * Retina

		Next

		active = 1

	End

	Method Draw:Void()

		For Local wfY:Int = 1 To cnt

			x[wfY] += wSpeed[wfY]

			If x[wfY] > dw * 2 + fishCleenImg.Width()
				active = 2
				wSpeed[wfY] = 0
			End

			Local sclFishFlock:Float = 1

			DrawImage( fishCleenImg, x[wfY], y[wfY], 0, sclFishFlock, sclFishFlock )

			For Local en := Eachin enemy

				Local dist:Float = Distance ( en.x, en.y, x[wfY], y[wfY] )
				Local distDiff:Float = en.img.Width()/2 + fishCleenImg.Width()/2 * sclFishFlock

				If (dist < distDiff) And en.kicked = False
					
					en.kicked = True
					en.xMove = -speed * globalSpeed * Retina
					If en.y < dh/2 en.yMove = -4*Retina Else en.yMove = 4*Retina

					en.rotSpeed = Rnd(-2,2)
					
				End

				If en.kicked And en.y < dh/4 Or en.y > dh/4*3
					en.yMove = 0
					'en.kicked = False
				End

			Next


		Next

	End
	
	Method Update:Void()
		
	End

End

'starfish

Global weaponStarfish:weaponStarfishClass = New weaponStarfishClass

Class weaponStarfishClass
	
	Field x:Float
	Field y:Float

	Field yWave:Float
	Field yWaveForce:Float

	Field rot:Int

	Field active:Int

	Field activated:Bool

	Field wSpeed:Float

	Method Create:Void()

		x = hero.x
		y = hero.y

		wSpeed = 4 * Retina

		active = 1

		yWaveForce = -1

	End

	Method Draw:Void()

		Local waveHeight:Float = 3
		Local waveAcc:Float = .3

		yWave += waveAcc * yWaveForce
		If yWave < -waveHeight Or yWave > waveHeight yWaveForce = -yWaveForce

		x += wSpeed
		y += yWave * Retina
		'wSpeed += .1

		rot += -3

		If x > dw + starfishImg.Width()
			active = 2
			wSpeed = 0
		End

		DrawImage( starfishImg, x, y, rot, 1, 1 )

		For Local en := Eachin enemy

			If Distance ( en.x, en.y, x, y ) < en.img.Width()/2 + starfishImg.Width()/2

				en.kicked = True
				en.xMove = speed*globalSpeed*3
				en.yMove = (en.y - hero.y) / 10.0
				en.rotSpeed = (en.y - hero.y) / 10.0

			End

		Next

	End
	
	Method Update:Void()
		
	End

End


'Psy

Global weaponPsy:weaponPsyClass = New weaponPsyClass

Class weaponPsyClass
	
	Field x:Float
	Field y:Float

	Field active:Int

	Field activated:Bool

	Field duration:Int
	Field power:Int

	Field isAnyBurned:Bool

	Method Create:Void()

		x = hero.x
		y = hero.y

		active = 1

		duration = 100
		power = 20
		
		Local ltg:Int = 0
		
		For Local en := Eachin enemy

			If en.x > hero.x And en.y < hero.y + 200*Retina And en.y > hero.y - 200*Retina And en.lightned = False

				en.lightned = True
				ltg += 1
				
				If ltg = 5 Exit

			End

		Next

	End

	Method Draw:Void()

		duration -= 1

		If duration = -100
			active = 2
		End

		For Local en := Eachin enemy

			If duration >= 0 And en.x > hero.x And en.burned = False

				Local angle:Float = ATan( (en.y - y) / (-en.x + x) )
				Local hyp:Float = Distance( hero.x, hero.y, en.x, en.y )

				SetBlend(1)

				SetAlpha(Float(power)/20.0)
				DrawImage( psyImg, hero.x, hero.y-psyImg.Height()/2, angle, 1, 1 )
				SetAlpha(1)
				
				DrawImage( psyEffectImg, en.x, en.y, Rnd(0,360), 2, 2 )
				DrawImage( psyEffectImg, en.x, en.y, Rnd(0,360), 2.2, 2.2 )

				SetBlend(0)
				
				en.kicked = True
				en.xMove = speed*globalSpeed*.3
				en.yMove = 2*Retina
				en.rotSpeed = Rnd(-3,3)*Retina

				power -= 1
				
				If power = 0
					en.burned = True
					en.lightned = False
					power = 20
				End

				Return

			End

		Next

	End
	
	Method Update:Void()
		
	End

End

'Flee'

Global weaponFlee:weaponFleeClass = New weaponFleeClass

Class weaponFleeClass
	
	Field flyX:Float
	Field flyY:Float

	Field rot:Int

	Field time:Int

	Field active:Int

	Field activated:Bool

	Method Create:Void()

		active = 1
		rot = 360
		time = 1000

	End

	Method Draw:Void()

		If time < 100 SetAlpha( Float(time)/100.0 )
		DrawImage( fleeImg, hero.x, hero.y, rot, Retina*1.8, Retina*1.8 )
		If time < 100 SetAlpha(1)

		rot -= 6
		If rot < 0 rot = 360

		time -= 1

		If time < 0
			active = 2
			For Local en := Eachin enemy
				If en.isFlee
					en.isFlee = False
					en.kicked = False
				End
			Next
		End

		For Local en := Eachin enemy

			If en.isFlee = False And Sqrt( Pow( (en.x - hero.x), 2 ) + Pow( (en.y - hero.y), 2 ) ) < 100*Retina + en.img.Width() * en.sclX / 2

				en.isFlee = True
				en.kicked = True

			End

			If en.isFlee

				flyX = (en.x - hero.x) / 50.0
				flyY = (en.y - hero.y) / 50.0

				en.x += flyX
				en.y += flyY

			End

		Next

	End
	
	Method Update:Void()
		
	End

End

'Hyper Jump'

Global weaponHyperJump := New weaponHyperJumpClass

Class weaponHyperJumpClass
	
	Field duration:Int
	Field active:Int
	Field activated:Bool

	Method Create:Void()

		duration = 5000
		
		globalSpeed = 50
		speedMax = 50
		
		active = 1

	End

	Method Draw:Void()

		duration -= speed * globalSpeed
		
		If duration < 0 speed = 1.0 active = 2 speedMax = 2.0

	End
	
	Method Update:Void()
		
	End

End


'Hammer'

Global weaponHammer := New weaponHammerClass

Class weaponHammerClass
	
	Field duration:Float
	Field y:Int
	
	Field active:Int
	Field activated:Bool

	Method Create:Void()

		duration = 100
		
		y = hero.y
		
		active = 1
		
		For Local en := Eachin enemy
			
			en.kicked = True
			en.xMove = (en.x - hero.x) / 10
			en.yMove = (en.y - hero.y) / 10

			en.rotSpeed = Rnd(-2,2)
			
		Next

	End

	Method Draw:Void()

		duration -= 1
		
		SetBlend(1)
		SetAlpha(duration/100.0)
		DrawImage( hammerImg, hero.x + 50*Retina, y )
		SetAlpha(1)
		SetBlend(0)
				
		If duration < 1 active = 2

	End
	
	Method Update:Void()
		
	End

End

'Stones'

Global weaponStone:weaponStoneClass = New weaponStoneClass

Class weaponStoneClass
	
	Field x:Float[20], y:Float[20], scl:Float[20]
	Field wSpeed:Float[20], wYRnd:Int

	Field cnt:Int = 10
	Field active:Int
	Field activated:Bool

	Method Create:Void()

		For Local wfY:Int = 1 To cnt
			
			x[wfY] = Rnd(0, dw/1.5)
			y[wfY] = -1 * Rnd( 0, dh/2 )
			wSpeed[wfY] = 4 * Retina * Rnd(.8, 1.2)
			scl[wfY] = Rnd(.3,1)
			
			wYRnd = Rnd(2,5)
			
		Next

		y[1] = 0

		active = 1

	End

	Method Draw:Void()

		For Local wfY:Int = 1 To cnt

			x[wfY] += wSpeed[wfY]/2
			y[wfY] += wSpeed[wfY]

			Local sclFishFlock:Float = .7

			DrawImage( stoneImg, x[wfY], y[wfY], 30, scl[wfY], scl[wfY] )

			For Local en := Eachin enemy

				Local dist:Float = Distance ( en.x, en.y, x[wfY], y[wfY] )
				Local distDiff:Float = en.img.Width()/2 + stoneImg.Width()/2 * sclFishFlock

				If (dist < distDiff)
					
					en.kicked = True
					en.xMove = (en.x - x[wfY]) / 10.0
					en.yMove = (en.y - y[wfY]) / 10.0 + wYRnd
					en.rotSpeed = Rnd(1,10)
					
				End

			Next

		Next
		
			If y[cnt] > dh + stoneImg.Width()
				active = 2
			End

	End
	
	Method Update:Void()
		
	End

End

'FireFly'

Global weaponFireFly:weaponFireFlyClass = New weaponFireFlyClass

Class weaponFireFlyClass

	Field active:Int
	Field activated:Bool
	Field hits:Int
	Field rot:Int

	Method Create:Void()

		active = 1
		hits = 5

	End

	Method Draw:Void()
		
		rot += 4
		
		SetBlend(1)
		For Local ff:Int = 1 To hits
			
			Local mainRot:Int = 360/hits
			
			DrawImage( fireFlyImg, hero.x, hero.y, rot + mainRot * ff, 1, 1 )
			
			
		Next
		SetBlend(0)

	End
	
	Method Update:Void()
		
	End

End

'Swirl'

Global weaponSwirl:weaponSwirlClass = New weaponSwirlClass

Class weaponSwirlClass
	
	Field x:Float, y:Float
	Field active:Int
	Field activated:Bool
	Field wSpeed:Float, rot:Float
	Method Create:Void()

		x = hero.x
		y = hero.y

		wSpeed = 1 * Retina

		active = 1

	End

	Method Draw:Void()

		x += wSpeed
		'wSpeed += .1
		
		rot += 2
		If rot > 360 rot -= 360

		If x > dw + swirlImg.Width()
			active = 2
			wSpeed = 0
		End

		DrawImage( swirlImg, x, y, rot, Retina*2, Retina*2 )

		For Local en := Eachin enemy

			If Distance ( en.x, en.y, x, y ) < swirlImg.Width() * Retina

				If en.kicked = False
					en.kicked = True
					en.rot = Rnd(-10,10)
				End
				
				If en.y > y
					en.yMove -= .5
				Else
					en.yMove += .5
				End

				If en.x > x
					en.xMove -= .5
				Else
					en.xMove += .5
				End
				

			End
			
			If Distance ( en.x, en.y, x, y ) < 50*Retina

				enemy.Remove(en)
				For Local ben:Int = 1 To 5
					CreateBonus( 3,0, en.x + Rnd(-50, 50)*Retina, en.y + Rnd(-50, 50)*Retina )
				Next

			End

		Next

	End
	
	Method Update:Void()
		
	End

End

'Reduce size'

Global weaponReduce:weaponReduceClass = New weaponReduceClass

Class weaponReduceClass
	
	Field x:Float, y:Float
	Field radius:Float
	Field rot:Int
	Field time:Int
	Field active:Int
	Field activated:Bool

	Method Create:Void()

		active = 1
		rot = 0
		time = 1000
		
		x = 0 		'hero.x
		y = dh/2 	'hero.y

	End

	Method Draw:Void()
		
		'x += 2*Retina
		x = hero.x
		y = hero.y
		
		If time < 100 radius = Float(time)/100.0
		If time > 900 radius = Float(1000 - time)/100.0

		If time < 100 SetAlpha( Float(time)/100.0 )
		DrawImage( reduceImg, x, y, rot, Retina*radius, Retina*radius )
		If time < 100 SetAlpha(1)

		time -= 1

		If time < 0
			active = 2
		End

		For Local en := Eachin enemy

			If Distance ( en.x, en.y, x, y ) < reduceImg.Width()/2 * Retina * radius
				
				If en.damage > 0
					en.damage = 0
				End
				
				If en.sclX > .3
					en.sclX -= .1
					en.sclY -= .1
				End

			End

		Next

	End
	
	Method Update:Void()
		
	End

End

'Enemies to Coins'

Global weaponEnemyCoins:weaponEnemyCoinsClass = New weaponEnemyCoinsClass

Class weaponEnemyCoinsClass

	Field xMove:Float
	Field active:Int
	Field activated:Bool

	Method Create:Void()

		active = 1
		xMove = -enemyCoinsImg.Width()/2

	End

	Method Draw:Void()
		
		xMove += 5
		
		DrawImage( enemyCoinsImg, xMove, dh/2)

		If xMove > dw + enemyCoinsImg.Width()
			active = 2
		End

		For Local en := Eachin enemy

			If en.x < xMove
				
				CreateBonus(10, 0, en.x, en.y)
				
				enemy.Remove(en)

			End

		Next

	End
	
	Method Update:Void()
		
	End

End

'camouflage'

Global weaponCamouflage:weaponCamouflageClass = New weaponCamouflageClass

Class weaponCamouflageClass

	Field time:Float, rot:Int
	Field active:Int
	Field activated:Bool
	Field img:Image
	Field cur:Int

	Method Create:Void()

		active = 1
		time = 1000
		
		cur = validEnemies[0]
		
		For Local en := Eachin enemy
			If en.theType = cur
				img = en.img
				Exit
			End
		Next

	End

	Method Draw:Void()
		
		time -= 1
		
		rot += 3
		If rot > 360 rot -= 360
		
		heroScl = 0.0
		
		If time < 100
			heroScl = 1.0 - Float(time)/100.0
		End
			
		If time > 900
			heroScl = 1.0 - Float(1000 - time)/100.0
		End
		
		SetBlend(1)
		DrawImage( flare,	hero.x, hero.y, rot, 	1.0-heroScl, 			1.0-heroScl )
		SetBlend(0)
		
		DrawImage( img, 	hero.x, hero.y, 0, 		(1.0-heroScl) * -1,		1.0-heroScl )
		
		If time = 0
			active = 2
		End

	End
	
	Method Update:Void()
		
	End

End





Function WeaponInit:Void()

	For Local we:Int = 1 To 21

		weaponReady[ wn[we-1] ] = weaponActivated[ wn[we-1] ]

		weaponReady[6] = False
		weaponReady[14] = False

	Next

	WeaponLoad()
	
	WeaponNumber = 0
	
End

Function NextWeaponDraw:Void()

	For Local we:Int = 1 To 21

		If weaponReady[ wn[we-1] ]

			DrawImage( powersIcon, dw - powersIcon.Width(), dh - powersIcon.Height(), wn[we-1] - 1 )
			Return

		End

	Next

End







