Strict

Import imp

Global bonusesChance:Int[11]
Global bonuses:bonusesClass = New bonusesClass

Global coins:Int
Global coinsGame:Int

Global getImg:Image

Class bonusesClass

	Field bonusesCounter:Float, bonusesInterval:Float = 30

	Field img:Image[11]

	Field closeToHero:Int
	
	Method Init:Void()

		bonusesCounter = bonusesInterval / globalSpeed

		For Local bns:Int = 1 To bonusesChance.Length() - 1
		
			Local bnsZero:String = "0" + String(bns)
			If bns > 9 bnsZero = String(bns)

			Select bns

				Case 1, 2, 4, 5, 6, 7, 8, 10

					img[bns] = LoadImage("bonus/bonus"+bnsZero+""+loadadd + ".png", 5, Image.MidHandle)

				Default

					img[bns] = LoadImage("bonus/bonus"+bnsZero+""+loadadd + ".png", 1, Image.MidHandle)

			End

		Next

		getImg = LoadImage( "bonus/getCoin" + loadadd + ".png", 1, Image.MidHandle )

		closeToHero = hero.x + 15*Retina + img[1].Width() + magnet * Retina
		
		If weaponActivated[14] magnet = 80

	End

	Method Update:Void()
		
		Local collectorX:Float
		Local collectorY:Float
		
		If friendMode
			collectorX = hero.x+friendHeroPositionX
			collectorY = hero.y+friendHeroPositionY
		Else
			collectorX = hero.xConcerningToHero
			collectorY = hero.yConcerningToHero
		End
		
		If GameOverMode = False And isStreamActive = False bonusesCounter -= 1
		If bonusesCounter < 0 RequestBonus()

		For Local bo := Eachin bonus

			bo.Update()

			'OUT of SCREEN'
			If bo.x < -1 * bo.img.Width() Or bo.y < -1 * bo.img.Height() Or bo.y > dh + bo.img.Width()
				bonus.Remove(bo)
			End

			If weaponHyperJump.active <> 1 And bo.x < closeToHero

				'COLLISION'
				If Distance(bo.x, bo.y, collectorX, collectorY) < 15*Retina + bo.img.Width() * bo.sclX / 2

					If bo.inactive = False
						bonus.Remove(bo)
					End

					health += bo.healing
					coinsGame += bo.coin
					If bo.coin > 0 CreateCoinsIndicator(bo.coin, bo.x, bo.y)

				End

			End

			If (weaponActivated[6] Or weaponActivated[14] Or friendMode) And weaponHyperJump.active <> 1 MagnetHandle(bo)

		Next

	End

	Method Draw:Void()

		For Local bo := Eachin bonus

			bo.Draw()

		Next

		'DrawText(bonusesCounter, 20,20)

	End

	Method Deinit:Void()

		bonus.Clear()

		For Local bns:Int = 1 Until bonusesChance.Length()

			img[bns].Discard()

		Next

		getImg.Discard()

	End

End

Global bonus := New List<bonusClass>

Function RequestBonus:Void()

	Local theType:Int = CalculateTypeOfBonus()

	CreateBonus(theType)

End

Function CreateBonus:Void(theType:Int, nextVar:Int = 0, theX:Float = 0, theY:Float = 0)

	Local bo:bonusClass = New bonusClass
	bo.Init(theType, nextVar, theX, theY)
	bonus.AddLast(bo)

	If theType <> 3 bonuses.bonusesCounter = bonuses.bonusesInterval / globalSpeed

End

Global validBonuses:Int[] '= [1]

Function CalculateTypeOfBonus:Int()

	Local theType:Int

	If validBonuses.Length() = 1

		Return validBonuses[0]

	End

	Repeat

		theType = Rnd( 1, bonusesChance.Length() + .9 )

		For Local bns:Int = 1 To validBonuses.Length()

			If theType = validBonuses[bns - 1] Return theType

		Next

	Forever

End

' bonus each'

Global rnbo:Int

Class bonusClass
	
	Field x:Float, y:Float

	Field yWave:Float, yForce:Int

	Field xMove:Float, yMove:Float

	Field lifeTime:Int

	Field swimX:Float, swimForce:Float, swimNegPosRnd:Int

	Field rot:Float, rotSpeed:Float

	Field sclX:Float, sclY:Float

	Field sclStart:Float

	Field spd:Float

	Field img:Image
	Field theType:Int
	Field theVar:Int
	Field healing:Int
	Field coin:Int

	Field anim:Float, frame:Int

	Field isMagnetted:Bool
	
	Field inactive:Bool
	Field alph:Float, alphSpd:Float

	Method Init:Void(type:Int, nextVar:Int = 0, theX:Float, theY:Float)

		theType = type

		img = bonuses.img[type]

		x = theX
		y = theY

		lifeTime = 100

		If type <> 3

		If theX = 0 x = dw + img.Width()
		If theY = 0 y = Rnd(dh/10, dh - dh/10)

		End

		rot = Rnd(0,360)
		sclX = 1
		sclY = 1

		spd = 1

		healing = 0
		coin = 0
		
		inactive = False
		
		alph = 1.0
		alphSpd = .05

		' global coins speed
		Local coins_speed:Float = Rnd(.9, 1.1)

		Select theType

			'coins'
			Case 1

				rot = 0
				coin = 1

				spd = coins_speed

				anim = Rnd(0,20)

			Case 2

				coin = 5

				spd = coins_speed

				anim = Rnd(0,20)

			' bubbles
			Case 3

				spd = coins_speed
				rot = 0
				sclX = Rnd(.3, .7)
				sclY = sclX
				yMove = -sclX * 2
				lifeTime = Rnd(50, 300)
				inactive = True

			Case 4

				coin = 10

				spd = 1.2

				anim = Rnd(0,20)

			Case 5

				coin = 15
				spd = coins_speed
				anim = Rnd(0,20)

			Case 6

				coin = 20
				spd = coins_speed
				anim = Rnd(0,20)

			Case 7

				coin = 25
				spd = coins_speed
				anim = Rnd(0,20)
				
			Case 8

				coin = 30
				spd = coins_speed
				anim = Rnd(0,20)
				
			Case 9
			
				rot = 0
				
				coin = 0
				spd = 0
				x = hero.xConcerningToHero
				y = hero.yConcerningToHero
				
				anim = 0
				sclX = Rnd(.6, .8)
				sclY = sclX
				
				xMove = -speed*Rnd(1.1, 2)
				yMove = Rnd( 0, -1 )
				
				rot = Rnd( 0,360 )
				
				inactive = True
				
			Case 10

				coin = 40
				spd = coins_speed
				anim = Rnd(0,20)

		End

	End

	Method Draw:Void()
		
		If alph < 1.0 SetAlpha( alph )
		DrawImage( img, x, y, rot, sclX, sclY, frame )
		If alph < 1.0 SetAlpha( 1 )
			
		'DrawText( alph, x+10, y+10 )
		
	End

	Method Update:Void()

		x -= spd * Retina * globalSpeed
		
		x += xMove * Retina
		y += yMove * Retina

		rot += rotSpeed

		Select theType

			Case 1, 2, 4, 5, 6, 7, 8, 10

				anim += .16
				If anim > 30 anim = 0
				If anim < 5 frame = anim Else frame = 0
				
			Case 9
			
				sclX -= alphSpd/2
				sclY = sclX
				
				alph -= alphSpd
				alphSpd -= .0012
				
				yMove -= .05
				
				rot -= 3
				
				If alph < 0 bonus.Remove(Self)
				
		End 

	End

End

Global magnet:Int = 40
Global magnetSpeed:Float = .9

Function MagnetHandle:Void(bo:bonusClass)
	
	Local collectorX:Float
	Local collectorY:Float
	
	If friendMode
		collectorX = hero.x+friendHeroPositionX
		collectorY = hero.y+friendHeroPositionY
	Else
		collectorX = hero.xConcerningToHero
		collectorY = hero.yConcerningToHero
	End
		
	If bo.isMagnetted = False And bo.theType <> 3 And bo.theType <> 9 And Sqrt( Pow( (bo.x - collectorX), 2 ) + Pow( (bo.y - collectorY), 2 ) ) < 15*Retina + bo.img.Width() * bo.sclX / 2 + magnet * Retina

		bo.isMagnetted = True
		bo.spd = 0

	End

	If bo.isMagnetted

		Local flyX:Float = (bo.x - collectorX) / 9.0
		Local flyY:Float = (bo.y - collectorY) / 9.0

		bo.x -= flyX
		bo.y -= flyY

	End

End


Global coinsIndicator := New List<coinsIndicatorClass>

Class coinsIndicatorClass

	Field x:Float
	Field y:Float

	Field gx:Float
	Field gy:Float

	Field gScl:Float

	Field gRot:Int

	Field alpha:Float

	Field amount:Int

	Method Init:Void( coinAmount:Int, cX:Float, cY:Float )

		amount = coinAmount

		x = hero.x
		y = hero.y

		gx = cX
		gy = cY

		alpha = 1

		gScl = 0.1
		gRot = Rnd(0,360)

	End

	Method Draw:Void()

		SetAlpha(alpha)
		Yellow()
		SetBlend(1)
		DrawFont ( "+" + amount, x, y, True, 70 )
		SetBlend(0)
		White()
		SetAlpha(1)

		y -= 2
		x -= 1

		alpha -= .02

		If alpha > .6

			If alpha > .8 gScl += .07 Else gScl -= .07

			gRot += 1

			DrawImage( getImg, gx, gy, gRot, gScl, gScl )

			gx -= speed * globalSpeed * Retina

		End

	End

End

Function CreateCoinsIndicator:Void(coinAmount:Int, cX:Float, cY:Float)

	Local co:coinsIndicatorClass = New coinsIndicatorClass
	co.Init(coinAmount, cX, cY)
	coinsIndicator.AddLast(co)

End

Function DrawCoinsIndicator:Void()

	For Local co := Eachin coinsIndicator

		co.Draw()

		If co.alpha <= 0 coinsIndicator.Remove(co)

	Next

End