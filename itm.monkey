Strict

Import imp

Global isShopWindowOpen:Bool

Global shopWindow := New shopWindowClass

Global upgradeItemBtn := New Buttons
Global upgradeItemDoneBtn := New Buttons

Class shopWindowClass

	Field x:Int, y:Int
	Field xStep:Int

	Field wx:Float, wy:Float
	Field wxLast:Float, wyLast:Float
	Field wxStep:Float, wyStep:Float

	Field CX:Int

	Field itemNumber:Int

	Field bA:Float

	Field bgr:Image, window:Image

	Field isBeingClosed:Bool

	Field stepCount:Float = 16.0
	
	Method Init:Void(itemNum:Int, WX:Int, WY:Int)

		bgr = LoadImage ( "shop_blured"+retinaStr+".jpg", 1, Image.MidHandle )
		window = LoadImage ( "shopWindow"+retinaStr+".png", 1, Image.MidHandle )

		x = dw*2
		y = dh/2

		xStep = (dw*1.5)/16

		itemNumber = itemNum

		Local btnText:String = upgradeCost[itemNumber]
		If upgradeMax[itemNumber] = upgradeLevel[itemNumber] btnText = "Done"
		upgradeItemBtn.Init( btnText )

		upgradeItemDoneBtn.Init( "Close" )

		wx = WX
		wy = WY

		wxLast = dw/6
		wyLast = dh/4

		wxStep = (wxLast - wx) / stepCount
		wyStep = (wyLast - wy) / stepCount

		bA = 0.0

		CX = 0

	End

	Method Draw:Void()

		If bA < 1.0 SetAlpha(bA)
		DrawImage( bgr, dw/2, dh/2, 0, Retina, Retina )
		If bA < 1.0 SetAlpha(1)

		DrawShopCoinsIndicator( CX )

		DrawImage( window, x, y, 0, Retina, Retina )

		If upgradeMax[itemNumber] > upgradeLevel[itemNumber]
			If upgradeCost[itemNumber] > coins And upgradeLevel[itemNumber] < upgradeMax[itemNumber] SetAlpha(.5)
			upgradeItemBtn.Draw( x + dw/3 - upgradeItemBtn.Width/2 * Retina, y + window.Height()/2 * Retina )
			If upgradeCost[itemNumber] > coins And upgradeLevel[itemNumber] < upgradeMax[itemNumber] SetAlpha(1)
		End

		upgradeItemDoneBtn.Draw( x - dw/3 - upgradeItemDoneBtn.Width/2, y + window.Height()/2 * Retina )

		DrawFont( upgradeText[itemNumber], x + window.Width()/2 * Retina - upgradeText[itemNumber].Length() * fontKern * Retina, dh/2 - window.Height()/4 * Retina, True )
		DrawFont( upgradeDesc[itemNumber], x - window.Width()/2 * Retina + 20*Retina, dh/2 + window.Height()/5 * Retina, False, 80 )		

		upgradeBtn[itemNumber].Draw(wx, wy)
		DrawUpgradeProgress(itemNumber, wx, wy)
		
	End

	Method Update:Void()

		If isBeingClosed

			x += xStep

			wx -= wxStep
			wy -= wyStep

			bA -= 0.0625

			CX += dh/2/(stepCount-3)
			If CX > 0 CX = 0
			
			If x > dw*2 self.Deinit()

			Return

		End

		If x > dw/2
			x -= xStep
			wx += wxStep
			wy += wyStep
			bA += 0.0625
			CX -= dh/2/(stepCount-3)
		Else
			x = dw/2
		End

		If upgradeCost[itemNumber] <= coins And upgradeLevel[itemNumber] < upgradeMax[itemNumber] And isFriendDisable = False

			If upgradeItemBtn.Pressed()

				upgradeLevel[itemNumber] += 1

				coins -= upgradeCost[itemNumber]

				upgradeThe[itemNumber] += upgradeCoef[itemNumber]
				upgradeCost[itemNumber] *= upgradeCostCoef[itemNumber]

				If itemNumber = 1 SPEED_MAX += .33

				CheckForAvailablePowers()

				SaveGame()

				upgradeItemBtn.Deinit()

				If upgradeMax[itemNumber] > upgradeLevel[itemNumber]
					Local btnText:String = upgradeCost[itemNumber]
					upgradeItemBtn.Init( btnText )
				End

			End

		End

		If upgradeItemDoneBtn.Pressed()	isBeingClosed = True

	End

	Method Deinit:Void()

		bgr.Discard()
		window.Discard()

		upgradeItemBtn.Deinit()

		isShopWindowOpen = False
		isBeingClosed = False
		
	End

End