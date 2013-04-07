Strict

Import imp

Class atlasClass
	
	Field x:Float[10], y:Float[10]
	Field xStart:Int[10], yStart:Int[10], w:Int[10], h:Int[10], pivotX:Int[10], pivotY:Int[10]
	Field img:Image[10], _img:Image, thpath:String
	Field cnt:Int, num:Int[10]

	Method Init:Void(path:String)

		'load image atlas'
		_img = LoadImage( path )

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
		Local imgNum:Int = 0

		'read data from txt'
		For Local rectLine:String = EachIn tempData.Split("~n")

			For Local rectValue:String = EachIn rectLine.Split(",")

				Select rectValue[0..1]

					Case "x" xStart[imgNum] = Int(rectValue[1..])*retinaValue

					Case "y" yStart[imgNum] = Int(rectValue[1..])*retinaValue

					Case "w" w[imgNum] = Int(rectValue[1..])*retinaValue - xStart[imgNum]

					Case "h" h[imgNum] = Int(rectValue[1..])*retinaValue - yStart[imgNum]

					'pivot x'
					Case "i" pivotX[imgNum] = Int(rectValue[1..])*retinaValue

					'pivot y'
					Case "j" pivotY[imgNum] = Int(rectValue[1..])*retinaValue

				End

			Next

			img[imgNum] = _img.GrabImage(xStart[imgNum], yStart[imgNum], w[imgNum], h[imgNum])
			img[imgNum].SetHandle( pivotX[imgNum], pivotY[imgNum] )

			imgNum += 1

		Next

		cnt = imgNum

		'_img.Discard()

	End

	Method Draw:Void( theNum:Int, theX:Float, theY:Float, theRotation:Float = 0.0, theScaleX:Float = 1.0, theScaleY:Float = 1.0 )

		DrawImage(img[theNum], theX, theY, theRotation, theScaleX, theScaleY)

		num[theNum] = theNum

		x[num[theNum]] = theX
		y[num[theNum]] = theY

	End

	Method Deinit:Void()

		_img.Discard()

	End

End






