Strict

Import imp

Global obCounter:Int = 30
Global obstaclesChance:Int[15]
Global obstacles:obstaclesClass = New obstaclesClass

Class obstaclesClass

	Field obstacleCounter:Int

	Field img:Image[16]

	Field closeToHero:Int
	
	Method Init:Void()

		obstacleCounter = obCounter

		Local zeroAdd:String

		For Local obs:Int = 1 To obstaclesChance.Length()

			If obs < 10 zeroAdd = "0" Else zeroAdd = ""

			Select obs

				Case 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15

					img[obs] = LoadImage("obstacles/obstacle"+zeroAdd+""+obs+""+loadadd + ".png", 4)', Image.MidHandle )
				
				Default

					img[obs] = LoadImage("obstacles/obstacle"+zeroAdd+""+obs+""+loadadd + ".png", 1)', Image.MidHandle )

			End
			
			img[obs].SetHandle( img[obs].Width()/2, img[obs].Height() )

		Next

		closeToHero = hero.x + hero.Width/2

	End

	Method Update:Void()

		If GameOverMode = False obstacleCounter -= 1

		If obstacleCounter < 0 RequestObstacle()

		For Local ob := Eachin obstacle

			ob.Update()

			'OUT of SCREEN'
			If ( ob.x < -1 * ob.img.Width() )
				obstacle.Remove(ob)
			End

			If friendMode = False And ob.x < closeToHero And ob.wave = False

				'COLLISION'
				If ( hero.x > ob.x - ob.Width / 2 )  And ( hero.x < ob.x + ob.Width / 2 ) And ( hero.y > ob.y - ob.Height ) And ( hero.y < ob.y + ob.Height ) And ob.wave = False
					
					#rem
					If weaponBatiscaf.active = 1 And weaponBatiscaf.hits > 0

						weaponBatiscaf.hits -= 1
						If weaponBatiscaf.hits = 0 weaponBatiscaf.active = 2

					Else

						If alive
							health -= 5
						End

					End
					#end
					
					ob.isCollided = True

				End

			End
			
			If ob.isCollided And hero.x < ob.x + ob.Width*ob.sclX And alive
				
				ob.ang += .5 * ob.negpos
				
			Elseif ob.isCollided
				
				ob.isCollided = False
				ob.wave = True
				'ob.xWave = ob.ang * ob.negpos
				'ob.waveMax = ob.ang * ob.negpos
				'ob.ang = 0
				
			End

		Next

	End

	Method Draw:Void()

		For Local ob := Eachin obstacle

			ob.Draw()

		Next

		'DrawText(weaponBatiscaf.hits, 20,30)
		'DrawText(obCounter, 20,50)

	End

	Method Deinit:Void()

		obstacle.Clear()

		For Local obs:Int = 1 To obstaclesChance.Length()

			img[obs].Discard()

		Next

	End

End

Global obstacle := New List<obstacleClass>
Global rotateSide:Float

Function RequestObstacle:Void()

	Local theType:Int = CalculateTypeOfObstacle()

	Select theType

		Case 0

			obstacles.obstacleCounter = obCounter / globalSpeed

		Default

			CreateObstacle(theType)

	End

End

Function CreateObstacle:Void(theType:Int, nextVar:Int = 0)

	Local ob:obstacleClass = New obstacleClass
	ob.Init(theType, nextVar)
	obstacle.AddLast(ob)

	obstacles.obstacleCounter = obCounter / globalSpeed

End

Global validObstacles:Int[] '= [1, 2]

Function CalculateTypeOfObstacle:Int()

	Local theType:Int

	If validObstacles.Length() = 1

		Return validObstacles[0]

	End

	Repeat

		theType = Rnd( 1, obstaclesChance.Length() + .9 )

		For Local obs:Int = 1 To validObstacles.Length()

			If theType = validObstacles[obs - 1] Return theType

		Next

	Forever

End

Global rnen:Int

Class obstacleClass
	
	Field x:Float, y:Float

	Field upORdown:Int, negpos:Int

	Field Width:Int, Height:Int

	Field yWave:Float, xWave:Float, rotWave:Float, waveForce:Float = -1.8, waveMax:Float, wave:Bool

	Field xMove:Float, yMove:Float, yStart:Float

	Field rot:Float, ang:Float, sclX:Float, sclY:Float

	Field flip:Int, sclStart:Float, spd:Float

	Field img:Image
	Field theType:Int

	Field theVar:Int

	Field damage:Int

	Field anim:Float
	Field frame:Int
	Field animSpd:Float
	
	Field isCollided:Bool

	Field fixedSpeed:Bool

	Method Init:Void(type:Int, nextVar:Int = 0)

		theType = type

		img = obstacles.img[type]

		sclX = Rnd(.3, .65)
		sclY = sclX

		x = dw + img.Width()

		' Decide Up Or Down?
		upORdown = Rnd(0,1.99)
		Local angle:Int = 10

		spd = 1

		damage = Int(Float(distance)/1200.0) 'theType*5

		yMove = 0

		'personal ======================================'

		Select theType

			Case 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11

				angle = 20
				flip = Rnd(0,1.99)

				sclX = Rnd(.4, .8)
				sclY = sclX

				frame = Rnd(0, 3.999)

			Case 700

				angle = 20
				flip = Rnd(0,1.99)

				sclX = Rnd(.7, 1)
				sclY = sclX				

			Case 100

				angle = 0
				sclX = Rnd(.7, 1)
				sclY = sclX

				flip = upORdown

		End

		'================================================'

		Width = img.Width() * sclX
		Height = img.Height() * sclY

		If upORdown = 0
			y = -10*Retina' + Height/2
			rot = Rnd(180 - angle,180 + angle)
			negpos = 1
		Else
			y = dh + 10*Retina' - Height/2
			rot = Rnd(-angle, angle)
			negpos = -1
		End

	End

	Method Draw:Void()

		Local flipScl:Float = sclX
		If flip = 0 flipScl = -sclX

		DrawImage( img, x, y, rot + rotWave/2 + ang, flipScl, sclY, frame )
		
		'DrawText( ang, x , y+100*negpos )

	End

	Method Update:Void()

		If wave
			
			#rem
			xWave += waveForce*Retina

			If (waveForce < 0 And xWave < -waveMax) Or (waveForce > 0 And xWave > waveMax)
				waveForce = - waveForce
				waveMax -= .4*Retina
				If waveMax < 1*Retina
					'wave = False
					xWave = 0
				End
			End
			#end
			
			ang -= ang/10.0
			
			If (ang > 0 And ang < 0.1) Or (ang < 0 And ang > -0.1)
				wave = False
				ang = 0
			End

		End

		'rotWave = xWave
		'If upORdown = 1 rotWave = -xWave

		y += yMove * Retina	
		x -= speed * globalSpeed * Retina

		Select theType

			Case 1
				
				

		End 

	End

End