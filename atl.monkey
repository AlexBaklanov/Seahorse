Strict

Import imp

Class atlasClass

	Field xStart:Int[128], yStart:Int[128], width:Int[128], height:Int[128]
	Field img:Image

	Method Load:Void(path:String)

		img = LoadImage( path )

		Local tempData:String = app.LoadString( path[ ..path.Length() - 4 ] + ".txt" )

		Local imageNumber:Int = 0

		For Local rectLine:String = EachIn tempData.Split("~n")

			For Local rectValue:String = EachIn rectLine.Split(",")

				Select rectValue[0..1]

					Case "x" xStart[imageNumber] = Int(rectValue[1..])

					Case "y" yStart[imageNumber] = Int(rectValue[1..])

					Case "w" width[imageNumber] = Int(rectValue[1..]) - xStart[imageNumber]

					Case "h" height[imageNumber] = Int(rectValue[1..]) - yStart[imageNumber]

				End

			Next

			imageNumber += 1

		Next

	End

	Method Draw:Void( theNum:Int, theX:Float, theY:Float, theRotation:Float = 0.0, theScaleX:Float = 1.0, theScaleY:Float = 1.0 )

		DrawImageRect(img, theX, theY, xStart[theNum], yStart[theNum], width[theNum], height[theNum], theRotation, theScaleX, theScaleY)

	End

	Method Deinit:Void()

		img.Discard()

	End

End






