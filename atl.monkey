Strict

Import imp

Class atlasClass

	Field xStart:Int[128], yStart:Int[128], width:Int[128], height:Int[128]
	Field img:Image, thpath:String

	Method Load:Void(path:String)

		'load image atlas'
		img = LoadImage( path )

		thpath = path

		'correct path'
		Local correctPath:Int = 4
		Local retinaValue:Int = 1

		If path.Contains("@p") 
			retinaValue = 2
			correctPath = 6
		End
		If path.Contains("@2x") 
			retinaValue = 2
			correctPath = 7
		End
		If path.Contains("@2x@2x") 
			retinaValue = 4
			correctPath = 10
		End
		'end correct path'

		'load data for atlas'
		Local tempData:String = app.LoadString( path[ ..path.Length() - correctPath ] + ".txt" )

		'atlas images enumerator'
		Local imageNumber:Int = 0

		'read data from txt'
		For Local rectLine:String = EachIn tempData.Split("~n")

			For Local rectValue:String = EachIn rectLine.Split(",")

				Select rectValue[0..1]

					Case "x" xStart[imageNumber] = Int(rectValue[1..])*retinaValue

					Case "y" yStart[imageNumber] = Int(rectValue[1..])*retinaValue

					Case "w" width[imageNumber] = Int(rectValue[1..])*retinaValue - xStart[imageNumber]

					Case "h" height[imageNumber] = Int(rectValue[1..])*retinaValue - yStart[imageNumber]

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






