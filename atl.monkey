Strict

Import imp

Class atlasClass
	
	Field x:Float[50], y:Float[50]
	Field xStart:Int[50], yStart:Int[50], w:Int[50], h:Int[50], pivotX:Int[50], pivotY:Int[50]
	Field img:Image[50], _img:Image
	Field cnt:Int, num:Int[50], _path:String
	Field frm:Int[50]

	Method Init:Void(path:String)

		'load image atlas'
		_img = LoadImage( path )
		'Print "load atlas " + path

		_path = path

		'correct path'
		Local correctPath:Int = 4
		Local retinaValue:Int = 1

		If path.Contains("@")
			retinaValue = Retina
			correctPath = 6
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

					Case "x" xStart[imgNum] = Int(rectValue[1..]) * retinaValue

					Case "y" yStart[imgNum] = Int(rectValue[1..]) * retinaValue

					Case "w" w[imgNum] = Int(rectValue[1..]) * retinaValue

					Case "h" h[imgNum] = Int(rectValue[1..]) * retinaValue

					'pivot x'
					Case "i" pivotX[imgNum] = Int(rectValue[1..]) * retinaValue

					'pivot y'
					Case "j" pivotY[imgNum] = Int(rectValue[1..]) * retinaValue

					'frame'
					Case "f" frm[imgNum] = Int(rectValue[1..])

				End

			Next

			If frm[imgNum] = 0 frm[imgNum] = 1

			'Print frm[imgNum]

			img[imgNum] = _img.GrabImage(xStart[imgNum], yStart[imgNum], w[imgNum] / frm[imgNum], h[imgNum], frm[imgNum])
			img[imgNum].SetHandle( pivotX[imgNum] / frm[imgNum], pivotY[imgNum] )

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
		
		'Print "deinit atlas " + _path

		For Local i:Int = 0 Until cnt

			img[i].Discard()

		Next

		_img.Discard()

	End

End






