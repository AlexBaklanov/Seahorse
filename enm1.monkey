Strict

Import imp

Global rnen:Int

Global enemyDamage:Int[] = [0, 40, 5, 15, 14, 40, 10, 5, 30, 10, 20, 15, 45, 50, 50, 30, 10, 25, 50, 45, 35, 40, 35, 35, 45, 20, 20, 5, 25, 30, 25]

Class enemyClass
	
	Field x:Float, y:Float

	Field yWave:Float, xWave:Float
	Field yForce:Int
	Field xMove:Float, yMove:Float, yStart:Float
	Field radius:Float
	Field swimX:Float, swimForce:Float, swimNegPosRnd:Int
	Field rot:Float, rotSpeed:Float, rotTo:Int
	Field sclX:Float, sclY:Float, sclStart:Float
	Field spd:Float, img:Image, theType:Int, theVar:Int, fixedSpeed:Bool
	Field damage:Int
	Field catched:Bool, kicked:Bool, burned:Bool, lightned:Bool
	Field anim:Float, frame:Int, animSpd:Float, isFlee:Bool
	Field bonusCount:Int

	Method Init:Void(type:Int, nextVar:Int = 0)

		theType = type
		img = enemies.img[type]
		x = dw + img.Width()
		y = Rnd(0,dh)
		rot = Rnd(0,360)
		sclX = 1
		sclY = 1
		spd = 1
		damage = enemyDamage[theType]
		radius = 1

		Select theType

			'ball of grass'
			Case 1
				spd = Rnd(2,3)
				rotSpeed = Rnd(-1, 1)
				yMove = Rnd(-.8, .8)
				anim = Rnd(0,20)

			'red star'
			Case 2
				spd = Rnd(1,2)
				rotSpeed = Rnd(-3, 3)
				anim = Rnd(0,60)

			'one legged crab'
			Case 3
				spd = .2
				rot = 0
				swimForce = -1
				swimNegPosRnd = -1
				y = Rnd( dh/2, dh*2 )
				
				radius = .8
				
				sclX = Rnd(.9 ,1)
				sclY = sclX

			'crab otshelnik'
			Case 4
				spd = .2
				rot = 0
				swimForce = -1

			'snail with eyes'
			Case 5
				yForce = -1
				spd = Rnd(2,2.5)
				rotSpeed = Rnd(1,5)
				y = Rnd(dh/5,dh + dh/5)
				sclX = Rnd(.6, 1)
				sclY = sclX

			'blue back eyed shell'
			Case 6
				spd = 2.5
				rot = 0
				sclX = Rnd(.8, 1)
				sclY = sclX
				sclStart = sclX
				yForce = 1
				anim = Rnd(0,4)
				radius = .6
			
			'jewel shell'
			Case 7
				spd = Rnd(2,3)
				rotSpeed = Rnd(-1, 1)
				yMove = Rnd(-.8, .8)
				anim = Rnd(0,3)
				animSpd = Rnd(.3,.4)
				sclX = .8
				sclY = sclX

			'meduze'
			Case 8
				spd = 1
				rotSpeed = Rnd(-.2, .2)
				sclX = Rnd(.8, 1)
				sclY = sclX
				rot = Rnd(0, 360)
				frame = Rnd(0,3)
				
				radius = .75

			'malki 2'
			Case 9
				spd = .2
				rot = 0
				swimForce = -1

			'croissant'
			Case 10
				yForce = -1
				spd = 2
				rotSpeed = -3
				rot = 45
				y = Rnd(dh/5,dh + dh/5)
				sclX = Rnd(.6, 1)
				sclY = sclX
				yStart = y
				animSpd = .2

			'fast green'
			Case 11
				spd = .1
				rot = 0
				sclX = Rnd(.8, 1)
				sclY = sclX
				yMove = Rnd(-2, 2)
				rot = yMove * 5
				fixedSpeed = True
				
				radius = .8

			'white meduze'
			Case 12
				yForce = -1
				spd = Rnd(1,1.5)
				rotSpeed = 0
				rot = 0
				y = Rnd(dh/5,dh + dh/5)
				yStart = y + 10.0
				sclX = Rnd(.8, 1)
				sclY = sclX
				anim = 0
				radius = .5

			'sparks
			Case 13
				yForce = -1
				spd = Rnd(2,2.5)
				rotSpeed = Rnd(1, 2)
				y = Rnd(dh/5,dh + dh/5)
				sclX = Rnd(.6, 1)
				sclY = sclX
				swimX = 3

			'eg'
			Case 14
				spd = Rnd(1,2)
				rotSpeed = Rnd(-1, 1)
				yMove = Rnd(-.8, .8)
				anim = Rnd(0,10)
				sclX = Rnd(.4, .8)
				sclY = sclX

			'fast yellow shell
			Case 15
				spd = 1
				rotSpeed = 0
				rot = 0
				yMove = 0

			' triangle nose
			Case 16
				spd = Rnd(1, 2)
				yForce = 5
				sclX = Rnd(.8, 1)
				sclY = sclX
				rot = 45
				animSpd = .4
				
			'ersh
			Case 17
				spd = Rnd(1,2)
				rotSpeed = 0
				rot = 0
				yMove = Rnd(-.8, .8)
				anim = Rnd(0,3)
				animSpd = .1
				sclX = 1
				sclY = sclX
				frame = Rnd(0,8)
				radius = frame/7.7 + .3

			'corner red fish
			Case 18
				spd = 2
				rotSpeed = 0
				Local updn:Int = Rnd(-10, 10)
				If updn >= 0
					y = 0
					yForce = 1
				Else
					y = dh
					yForce = -1
				End
				sclX = Rnd(.6, .8)
				sclY = sclX
				
				radius = .8

			'sea hedgehog
			Case 19
				spd = Rnd(1,2)
				rotSpeed = Rnd(-2,2)
				rot = 0
				yMove = Rnd(-.8, .8)
				anim = Rnd(0,10)

			'nautilus new'
			Case 20
				spd = 2
				Local updn:Int = Rnd(-10, 10)
				If updn >= 0
					y = 0
					yForce = 1
				Else
					y = dh
					yForce = -1
				End
				sclX = Rnd(.8, 1)
				sclY = sclX
				rotSpeed = Rnd(-10,10)

			'electric eel
			Case 21
				spd = Rnd(1,2)
				rotSpeed = Rnd(-2,2)
				rot = 0
				yMove = Rnd(-.8, .8)
				anim = Rnd(0,10)

			'fast squid'
			Case 22
				spd = .1
				yMove = Rnd(-2, 2)
				rot = yMove * 5 + 10
				fixedSpeed = True
				
				radius = .6
				
				sclX = Rnd(.8, 1)
				sclY = sclX

			'half shell'
			Case 23
				spd = .2
				rot = 0
				swimForce = -1
				swimNegPosRnd = -1

				y = Rnd( dh/2, dh*2 )

			'meduze pink
			Case 24
				spd = 2
				rotSpeed = 0
				rot = -90
				Local updn:Int = Rnd(-10, 10)
				If updn >= 0
					y = 0
					yForce = 1
				Else
					y = dh
					yForce = -1
				End
				sclX = Rnd(.8, 1) sclY = sclX
				animSpd = .2

			'ball of grass'
			Case 25
				spd = Rnd(1,2)
				rotSpeed = 0
				rot = 0
				yMove = Rnd(-.8, .8)
				anim = Rnd(0,5)
				
				radius = .8
				
				sclX = Rnd(.7, 1)
				sclY = sclX
				

			'shark
			Case 26
				spd = .1
				rot = 0
				sclX = Rnd(.9, 1) sclY = sclX
				fixedSpeed = True
				animSpd = .2

			'dark udilshik
			Case 27
				spd = Rnd(1,2)
				rotSpeed = 0
				rot = 0
				yMove = Rnd(-.2, .2)
				anim = 0
				sclX = Rnd(.7, 1) sclY = sclX
				radius = .5
				animSpd = .2

			'meduze'
			Case 28
				spd = 1
				rotSpeed = Rnd(-.2, .2)
				sclX = Rnd(.8, 1) sclY = sclX
				rot = Rnd(0, 360)
				frame = Rnd(0, 3)

			'green leafs paparotnik
			Case 29
				spd = 1
				rotSpeed = Rnd(-.2, .2)
				sclX = Rnd(.8, 1) sclY = sclX
				rot = Rnd(0, 360)
				frame = Rnd(0, 2)

			'long fish
			Case 30
				spd = .2
				rot = 0
				swimForce = -1
				radius = .6
				sclX = Rnd(.5,.7)
				sclY = sclX

			''
			Case 200
			
				spd = 1
				rotSpeed = Rnd(-.2, .2)
				sclX = Rnd(.5, 1)
				sclY = sclX
				rot = Rnd(0, 360)

		End

	End

	Method Draw:Void()
		If burned SetColor(120,120,120)
		DrawImage( img, x, y, rot, sclX, sclY, frame )
		If burned White()
		
		If enemyRadiusEnabled SetAlpha(.2) DrawCircle (x,y,img.Width()/2*radius*sclX) SetAlpha(1)
		'DrawText(enemyDamage[theType], x+20, y+20)
	End

	Method Update:Void()

		If kicked
			x += xMove
			y += yMove
			rot += rotSpeed
			Return
		End

		If fixedSpeed
			x -= spd * Retina
		Else
			x -= spd * Retina * globalSpeed
		End

		rot += rotSpeed
		If rot > 360 rot -= 360

		If catched Return

		Select theType

			Case 1
				
				y += yMove * Retina
				anim += .16
				If anim > 20 anim = 0
				If anim < 3 
					frame = anim 
				Else 
					frame = 0
				End
				If anim = 0 CreateBonus(3,0,x,y)

			Case 2

				anim += .2
				If anim > 40 anim = 0
				If anim < 4
					frame = anim 
				Else 
					frame = 0 
					End
				If anim = 0 CreateBonus(3,0,x,y)

			Case 3

				x -= swimX * Retina
				y += swimX * swimNegPosRnd / 2 * Retina

				frame = anim
				If swimX > 1 anim += swimX/5
				If anim > 4 anim = 0

				' swim Up
				If swimForce < 0
					If swimX < 2
						swimX += .1
						Local con:Int = Rnd(30)
						If con = 0 CreateBonus(3,0,x,y)
					Else
						swimForce = 1
					End
					
				Else 'down'
					If swimX > .2
						swimX -= .01
					Else
						swimForce = -1
						swimNegPosRnd = -1
					End
				End

			Case 4

				x -= swimX * Retina
				y += swimX * swimNegPosRnd / 2 * Retina

				If swimForce < 0
					If swimX < 2
						swimX += .3
						anim -= .8
						If anim < 0 anim = 0
					Else
						swimForce = 1
					End
				Else
					If swimX > .2
						swimX -= .05
						
						anim += .4
						If anim > 5.9 anim = 5.9
					Else
						swimForce = -1
						swimNegPosRnd = Rnd(-1.9, 1.9)
						Local con:Int = Rnd(5)
						If con = 0 CreateBonus(3,0,x,y)
					End
				End

				rot = swimNegPosRnd * 20 * swimX

				frame = anim

			Case 5

				Local waveHeight:Float = 3 * sclX
				Local waveAcc:Float = .1

				y += yWave * Retina

				yWave += waveAcc * yForce
				If yWave < -waveHeight Or yWave > waveHeight yForce = -yForce

				If rot > 100 And rot < 150 frame = (rot - 100)/10
				If rot <= 100 frame = 0
				If rot >= 160 frame = 5

				If frame = 3 
					If bonusCount < 1
						CreateBonus(3,0,x,y)
						bonusCount = 1
					End
				Else
					bonusCount = 0
				End

			Case 6

				Local waveHeight:Float = 1 * sclX
				Local waveAcc:Float = .1

				y += yWave * Retina

				yWave += waveAcc * yForce
				If yWave < -waveHeight Or yWave > waveHeight yForce = -yForce

				anim += .2
				If anim > 4 anim = 0
				If anim < 4 
					frame = anim 
				Else 
					frame = 0
				End

				If anim = 0 And bonusCount < 5
					Local con:Int = Rnd(5)
					If con = 0
						CreateBonus(3,0,x,y)
						bonusCount += 1
					End
				End


			Case 7
				
				y += yMove * Retina

				anim += animSpd
				If anim > 3 Or anim < 0 animSpd = -animSpd
				frame = anim

				If frame = 0 And bonusCount < 4
					Local con:Int = Rnd(30)
					If con = 0
						CreateBonus(3,0,x,y)
						bonusCount += 1
					End
				End

			Case 9

				x -= swimX * Retina
				y += swimX * swimNegPosRnd / 2 * Retina

				If swimForce < 0
					If swimX < 2
						swimX += .3
						anim -= .8
						If anim < 0 anim = 0
					Else
						swimForce = 1
					End
				Else
					If swimX > .2
						swimX -= .05
						anim += .4
						If anim > 2.9 anim = 2.9
					Else
						swimForce = -1
						swimNegPosRnd = Rnd(-1.9, 1.9)
						Local con:Int = Rnd(5)
						If con = 0 CreateBonus(3,0,x,y)
					End
				End

				rot = swimNegPosRnd * 20 * swimX

				frame = anim

			Case 10

				Local waveHeight:Float = 3
				Local waveAcc:Float = .1

				y += yWave * Retina
				x += yWave * Retina

				yWave += waveAcc * yForce
				If yWave < -waveHeight Or yWave > waveHeight yForce = -yForce

				anim += animSpd
				If anim < 0
					animSpd =  .6
					anim = 0
				End
				If anim > 4.99
					animSpd = -.6
					anim = 4.99
					Local con:Int = Rnd(5)
					If con = 0 CreateBonus(3,0,x,y)
				End

				frame = anim

			Case 11

				If spd < 3 
					spd += .04
				Else 
					spd += .06
				End

				If spd < 4
					frame = 0
				Else
					If anim < 2.5 anim += .3
					frame = anim
				End
				y += yMove
				If x < dw*.8 And bonusCount < 6
					Local con:Int = Rnd(10)
					If con = 0 
						CreateBonus(3, 0, x, y)
						bonusCount += 1
					End
				End

			Case 12

				If yForce > 0
					y += yMove

					anim += .18
					If anim > 16 anim = 16
					frame = anim - 12
					If frame < 0 frame = 0

					If y > yStart
						yForce = -1
						yMove = 3
						frame = 4
						anim = 4.99
					End
				End

				If yForce < 0
					y -= yMove
					yMove -= .1

					anim -= .1
					If anim < 0 anim = 0
					frame = anim

					If yMove < 0
						yForce = 1
						yMove = .5
						frame = 0
						anim = 0
						Local con:Int = Rnd(5)
						If con = 0 CreateBonus(3,0,x,y)
					End
				End

			Case 13

				Local waveAcc:Float = .1
					
				y += yWave * Retina
					
				yWave += waveAcc * yForce
				If yWave > -0.2 Or yWave < 0.2 swimX = Rnd(1,3)
				If yWave < -swimX Or yWave > swimX
					yForce = -yForce
				End
				
				Local con:Int = Rnd(500)
				If con = 0 CreateBonus(3,0,x,y)

			Case 14
				
				y += yMove * Retina

				anim += .1
				If anim > 20 anim = 0
				
				If anim < 3 				frame = anim
				If anim > 2.8				frame = 2
				If anim > 9.8  				frame = 2 - (anim - 10)
				If anim > 12 				frame = 0	
				
				Local con:Int = Rnd(500)
				If con = 0 CreateBonus(3,0,x,y)

				'0 1 2

			Case 15

				spd += .05

				If x > dw*.8
					frame = 0
				Else
					anim += .3
					If anim > 3.9 anim = 2
					frame = anim
					If anim = 2 And bonusCount < 5
						CreateBonus(3, 0, x, y)
						bonusCount += 1
					End
				End

			Case 16

				yForce -= 1

				If yForce = 0

					yForce = Rnd(90,110)

					yMove = Rnd(-1,1)
					If yMove = 0 yMove = -1

					rotTo = 20*yMove

				End

				If yMove< 0 
					rot -= 1 
				Else 
					rot += 1
				End

				If (yMove > 0 And rot > rotTo) Or (yMove < 0 And rot < rotTo) rot = rotTo

				y += yMove * Retina

				anim += animSpd

				If anim < 0
					animSpd = .4
					anim = 0
				End
				If anim > 2.6
					anim = 2.6
					animSpd = -.4
				End

				frame = anim
				
				Local con:Int = Rnd(500)
				If con = 0 CreateBonus(3,0,x,y)

			Case 17

				If swimX = 0
					anim += animSpd

					radius += animSpd/10

					If radius < .3 radius = .3
					If radius > 1.2 radius = 1.2

					If anim > 7.9
						animSpd = -.1
						anim = 7.9
						swimX = 100
					End
					If anim < 0
						animSpd = .1
						anim = 0
						swimX = 100
						Local con:Int = Rnd(50)
						If con = 0 CreateBonus(3,0,x,y)
					End
				Else
					swimX -= 1
				End


				frame = anim		

			Case 18

				Local waveHeight:Float = 8 * Rnd(.2,1.0)
				Local waveAcc:Float = .05

				y += yWave * Retina

				yWave += waveAcc * yForce
				If yWave < -waveHeight Or yWave > waveHeight yForce = -yForce

				rot = yWave * 5
				
				Local con:Int = Rnd(500)
				If con = 0
					CreateBonus(3,0,x,y)
				End
					
			Case 19

				anim += .02
				If anim > 10 anim = 0
				If anim < 5
					frame = 0
					radius = .25
				Else
					frame = anim
					If frame > 2 frame = 2
					radius = .8
					Local con:Int = Rnd(50)
					If con = 0
						CreateBonus(3,0,x,y)
					End
				End

			Case 20

				Local waveHeight:Float = 8 * Rnd(.2,1.0)
				Local waveAcc:Float = .05

				y += yWave * Retina

				yWave += waveAcc * yForce
				If yWave < -waveHeight Or yWave > waveHeight yForce = -yForce

				rot = yWave * 5
				
				Local con:Int = Rnd(500)
				If con = 0
					CreateBonus(3,0,x,y)
				End

			Case 21

				anim += .05
				If anim > 10 anim = 0
				If anim < 5
					animSpd += .2
					If animSpd > 3.9 Or animSpd < 1 animSpd = 1
					frame = animSpd
					Local con:Int = Rnd(50)
					If con = 0
						CreateBonus(3,0,x,y)
					End
				Else
					frame = 0
				End

			Case 22

				If spd < 4 
					spd += .04 
				Else 
					spd += .1
				End
				If spd < 4
					frame = 0
				Else
					If anim < 2.1 anim += .8
					frame = anim
				End
				
				If x < dw*.8 And bonusCount < 6
					Local con:Int = Rnd(10)
					If con = 0 
						CreateBonus(3, 0, x, y)
						bonusCount += 1
					End
				End
				
				y += yMove

			Case 23

				x -= swimX * Retina
				y += swimX * swimNegPosRnd / 2 * Retina

				frame = anim
				If swimX > 1 anim += swimX/10.0
				If anim > 3 anim = 0

				'swim Up
				If swimForce < 0
					If swimX < 2
						swimX += .1
						Local con:Int = Rnd(50)
						If con = 0
							CreateBonus(3,0,x,y)
						End
					Else
						swimForce = 1
					End
					
				Else 'down'
					If swimX > .2
						swimX -= .01
					Else
						swimForce = -1
						swimNegPosRnd = -1
					End
				End

			Case 24

				Local waveHeight:Float = 8 * Rnd(.2,1.0)
				Local waveAcc:Float = .05

				y += yWave * Retina

				yWave += waveAcc * yForce
				If yWave < -waveHeight Or yWave > waveHeight yForce = -yForce

				rot = 90 + yWave * 5
				anim += animSpd
				If anim < 0
					anim = 0
					animSpd = -animSpd
				End
				If anim > 2
					anim = 2
					animSpd = -animSpd
				End
				frame = anim

				If anim = 0
					Local con:Int = Rnd(5)
					If con = 0 CreateBonus(3,0,x,y)
				End

			Case 25
				
				y += yMove * Retina

				anim += .2
				If anim > 5 anim = 0
				frame = anim

				If anim = 0
					Local con:Int = Rnd(5)
					If con = 0 CreateBonus(3,0,x,y)
				End

			Case 26

				If x > dw * .9 
					spd += .01 
				Else 
					spd += .5
				End

				anim += animSpd
				If anim < 0
					anim = 0
					animSpd = -animSpd
				End
				If anim > 4
					anim = 4
					animSpd = -animSpd
				End

				frame = anim

				If anim = 0
					Local con:Int = Rnd(10)
					If con = 0 CreateBonus(3,0,x,y)
				End

			Case 27

				anim += animSpd
				If anim < 0
					anim = 0
					animSpd = -animSpd
				End
				If anim > 2
					anim = 2
					animSpd = -animSpd
				End

				frame = anim

				If anim = 0
					Local con:Int = Rnd(50)
					If con = 0 CreateBonus(3,0,x,y)
				End

			Case 8, 28, 29

				Local con:Int = Rnd(500)
				If con = 0
					CreateBonus(3,0,x,y)
				End

			Case 30

				x -= swimX * Retina
				y += swimX * swimNegPosRnd / 2 * Retina

				If swimForce < 0
					If swimX < 2
						swimX += .3
						anim -= .8
						If anim < 0 anim = 0
					Else
						swimForce = 1
					End
				Else
					If swimX > .2
						swimX -= .05
						anim += .4
						If anim > 2.9 anim = 2.9
					Else
						swimForce = -1
						swimNegPosRnd = Rnd(-1.9, 1.9)
						Local con:Int = Rnd(5)
						If con = 0 CreateBonus(3,0,x,y)
					End
				End

				rot = swimNegPosRnd * 20 * swimX

				frame = anim























			'zig zag'
			Case 10456

				Local waveHeight:Float = 150 * sclX

				y += yForce * Retina

				If y > yStart + waveHeight Or y < yStart - waveHeight yForce = -yForce


			'bubble'
			Case 99

				Local waveHeight:Float = .05
				Local waveAcc:Float = .003

				yWave += waveAcc * yForce
				If yWave < -waveHeight Or yWave > waveHeight yForce = -yForce

				sclX = sclStart + yWave * Retina
				sclY = sclX


			Case 100

				x -= swimX * Retina
				y += swimX * swimNegPosRnd * Retina

				If swimForce < 0
					If swimX < 3
						swimX += .2
					Else
						swimForce = 1
						
					End
				Else
					If swimX > 1
						swimX -= .05
					Else
						swimForce = -1
						swimNegPosRnd = Rnd(-1.9, 1.9)
						rot = swimNegPosRnd * 20
					End
				End

				rot += 10 * swimX

		End 

	End

End