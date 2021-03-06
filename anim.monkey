Strict

Import imp

Const STOP:Int = 0, LOOP:Int = 1, ONE_SHOT:Int = 2

Class animClass

	Field img:atlasClass, selfImage:Bool
	Field f:Int, paused:Bool
	Field type:Int, _path:String
	Field partX:Float[0], partY:Float[0]
	Field partRot:Float[0], partSclX:Float[0], partSclY:Float[0]
	Field keyFrameMove:Bool[0], keyFrameRot:Bool[0], keyFrameScl:Bool[0], frameCnt:Int, curFrame:Int, lastFrame:Int, frm:framesClass

	Method Init:Void(path:String, theImg:atlasClass = Null, theFrames:framesClass = Null)

		_path = path

		'Print "load anim " + path

		type = STOP

		If theImg = Null
			img = New atlasClass
			img.Init(path + "img" + loadadd + ".png")
			selfImage = True
		Else
			img = theImg
		End

		If theFrames = Null
			frm = New framesClass
			frm.Init( path )
		Else
			frm = theFrames
		End

		lastFrame = frm.lastFrame
		frameCnt = frm.frameCnt

		Local arrSize:Int = img.cnt + lastFrame * 10 + 1

		partX = partX.Resize(arrSize)
		partY = partY.Resize(arrSize)
		partRot = partRot.Resize(arrSize)
		partSclX = partSclX.Resize(arrSize)
		partSclY = partSclY.Resize(arrSize)

		keyFrameMove = keyFrameMove.Resize(arrSize)
		keyFrameRot = keyFrameRot.Resize(arrSize)
		keyFrameScl = keyFrameScl.Resize(arrSize)

		For Local p:Int = 0 Until img.cnt

			For Local f:Int = 0 To lastFrame

				keyFrameMove[p + f * 10] = frm.keyFrameMove[p + f * 10]
				keyFrameRot[p + f * 10] = frm.keyFrameRot[p + f * 10]
				keyFrameScl[p + f * 10] = frm.keyFrameScl[p + f * 10]

				partX[ p + f * 10 ] = frm.partX[ p + f * 10 ]
				partY[ p + f * 10 ] = frm.partY[ p + f * 10 ]
				partRot[ p + f * 10 ] = frm.partRot[ p + f * 10 ]
				partSclX[ p + f * 10 ] = frm.partSclX[ p + f * 10 ]
				partSclY[ p + f * 10 ] = frm.partSclY[ p + f * 10 ]

			Next

		Next

	End

	Method Play:Void(theType:Int = LOOP)

		type = theType
		curFrame = 0
		paused = False

	End

	Method Stop:Void()

		type = STOP
		curFrame = 0

	End

	Method Pause:Void()

		type = 0
		paused = True

	End

	Method Stopped:Bool()

		If type = STOP Return True

		Return False

	End

	Method Paused:Bool()

		Return paused

	End

	Method Update:Void()

		Select type

			Case LOOP

				curFrame += 1
				If curFrame > lastFrame curFrame = 0

			Case ONE_SHOT

				If curFrame < lastFrame curFrame += 1
				If curFrame = lastFrame type = STOP

		End
		'If KeyHit(KEY_RIGHT) curFrame += 1
		'If KeyHit(KEY_LEFT) curFrame -= 1

		CalculateCurrentFrame()

	End

	Field x:Float, y:Float

	Method CalculateCurrentFrame:Void()

		For Local pt:Int = 0 Until img.cnt

			If keyFrameMove[pt + curFrame * 10] = False

				Local prevKey:Int = PrevKey(kfMOVE, pt)
				Local nextKey:Int = NextKey(kfMOVE, pt)

				Local prev10:Int = pt + prevKey * 10
				Local next10:Int = pt + nextKey * 10

				partX[pt + curFrame * 10] = 		Tween( partX[prev10], partX[next10], curFrame, prevKey, nextKey )
				partY[pt + curFrame * 10] = 		Tween( partY[prev10], partY[next10], curFrame, prevKey, nextKey )

			End

			If keyFrameRot[pt + curFrame * 10] = False

				Local prevKey:Int = PrevKey(kfROT, pt)
				Local nextKey:Int = NextKey(kfROT, pt)

				Local prev10:Int = pt + prevKey * 10
				Local next10:Int = pt + nextKey * 10

				partRot[pt + curFrame * 10] = 		Tween( partRot[prev10], partRot[next10], curFrame, prevKey, nextKey )

			End

			If keyFrameScl[pt + curFrame * 10] = False

				Local prevKey:Int = PrevKey(kfSCL, pt)
				Local nextKey:Int = NextKey(kfSCL, pt)

				Local prev10:Int = pt + prevKey * 10
				Local next10:Int = pt + nextKey * 10

				partSclX[pt + curFrame * 10] = 		Tween( partSclX[prev10], partSclX[next10], curFrame, prevKey, nextKey )
				partSclY[pt + curFrame * 10] = 		Tween( partSclY[prev10], partSclY[next10], curFrame, prevKey, nextKey )

			End

		End

	End

	Field kfMOVE:Int = 0
	Field kfROT:Int = 1
	Field kfSCL:Int = 2

	Method NextKey:Float(kfType:Int, thePart:Int)

		';For Local pt:Int = 0 Until part.cnt

			For Local fr:Int = curFrame To 940

				If kfType = 0 And keyFrameMove[thePart + fr * 10] Return fr
				If kfType = 1 And keyFrameRot[thePart + fr * 10] Return fr
				If kfType = 2 And keyFrameScl[thePart + fr * 10] Return fr

			End

		'Next

		Return 0

	End

	Method PrevKey:Float(kfType:Int, thePart:Int)

		'For Local pt:Int = 0 Until part.cnt

			For Local fr:Int = curFrame - 1 To 0 Step -1

				If kfType = 0 And keyFrameMove[thePart + fr * 10] Return fr
				If kfType = 1 And keyFrameRot[thePart + fr * 10] Return fr
				If kfType = 2 And keyFrameScl[thePart + fr * 10] Return fr

			End

		'Next

		Return 0

	End

	Method Draw:Void( theX:Float, theY:Float, globalScl:Float = 1.0 )

		For Local atl:Int = 0 Until img.cnt

			Local f:Int = atl + curFrame * 10

			If atl > 0

				'part.Draw(at, partX[atF] + partX[0 + curFrame * 10], partY[atF] + partY[0 + curFrame * 10], partRot[atF], partSclX[atF], partSclY[atF])
				img.Draw( 	atl, 
							partX[f] * globalScl + theX + partX[0 + curFrame * 10] * globalScl, 
							partY[f] * globalScl + theY + partY[0 + curFrame * 10] * globalScl, 
							partRot[f], 
							partSclX[f] * globalScl, 
							partSclY[f] * globalScl )

			Else
				
				'part.Draw(at, partX[atF], partY[atF], partRot[atF], partSclX[atF], partSclY[atF])
				img.Draw( 	atl, 
							partX[f] * globalScl + theX, 
							partY[f] * globalScl + theY, 
							partRot[f], 
							partSclX[f] * globalScl, 
							partSclY[f] * globalScl )

			End

			

		End

	End

	Method Deinit:Void()

		'Print "deinit anim " + _path

		If selfImage
			img.Deinit()
		End

	End

End

Function Tween:Float(b:Float, e:Float, f:Float, p:Float, n:Float)

	Local c:Float = e - b
	Local d:Float = n - p
	Local t:Float = f - p

	'Return c * t / d + b

	t /= d/2
	If (t < 1) Return c/2*t*t*t + b
	t -= 2
	Return c/2*(t*t*t + 2) + b

End

