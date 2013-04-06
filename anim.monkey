Strict

Import imp

Const STOP:Int = 0, LOOP:Int = 1, ONE_SHOT:Int = 2

Class animClass

	Field img:atlasClass
	Field f:Int, paused:Bool
	Field type:Int
	Field partX:Float[10000], partY:Float[10000]
	Field partRot:Float[10000], partSclX:Float[10000], partSclY:Float[10000]
	Field keyFrame:Bool[941], frameCnt:Int, curFrame:Int, lastFrame:Int


	Method Init:Void(path:String, theImg:atlasClass = Null)

		type = STOP

		If theImg = Null
			img = New atlasClass
			img.Load(path + "img" + loadadd + ".png")
		Else
			img = theImg
		End

		Local tempData:String = app.LoadString( path + "anim.txt" )

		'atlas images enumerator'
		Local frmNum:Int = 0
		Local p:Int

		'read data from txt'
		For Local animLine:String = EachIn tempData.Split("~n")

			p = Int(animLine[1..2])

			For Local animValue:String = EachIn animLine.Split(",")

				Select animValue[0..1]

					Case "f"
						f = Int(animValue[1..])
						keyFrame[f] = True
						lastFrame = f

					Case "x" partX[ p + f * 10 ] = Int(animValue[1..]) * Retina

					Case "y" partY[ p + f * 10 ] = Int(animValue[1..]) * Retina

					Case "r" partRot[ p + f * 10 ] = Int(animValue[1..])

					Case "s" partSclX[ p + f * 10 ] = Float(Int(animValue[1..])) / 100.0

					Case "z" partSclY[ p + f * 10 ] = Float(Int(animValue[1..])) / 100.0

				End

			Next

			frmNum += 1

		Next

		frameCnt = frmNum

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

		If keyFrame[curFrame] Return

		For Local pt:Int = 0 Until img.cnt

			Local prevKey:Int = PrevKey()
			Local nextKey:Int = NextKey()

			Local prev10:Int = pt + prevKey * 10
			Local next10:Int = pt + nextKey * 10

			partX[pt + curFrame * 10] = 		Tween( partX[prev10], partX[next10], curFrame, prevKey, nextKey )
			partY[pt + curFrame * 10] = 		Tween( partY[prev10], partY[next10], curFrame, prevKey, nextKey )

			partRot[pt + curFrame * 10] = 		Tween( partRot[prev10], partRot[next10], curFrame, prevKey, nextKey )

			partSclX[pt + curFrame * 10] = 		Tween( partSclX[prev10], partSclX[next10], curFrame, prevKey, nextKey )
			partSclY[pt + curFrame * 10] = 		Tween( partSclY[prev10], partSclY[next10], curFrame, prevKey, nextKey )

		End

	End

	Method NextKey:Int()

		For Local fr:Int = curFrame To lastFrame

			If keyFrame[fr]

				Return fr

			End

		End

		Return 0

	End

	Method PrevKey:Int()

		For Local fr:Int = curFrame - 1 To 0 Step -1

			If keyFrame[fr]

				Return fr

			End

		End

		Return 0

	End

	Method Draw:Void( theX:Float, theY:Float )

		For Local atl:Int = 0 Until img.cnt

			Local f:Int = atl + curFrame * 10

			img.Draw( atl, partX[f] + theX, partY[f] + theY, partRot[f], partSclX[f], partSclY[f] )

		End

		'DrawText(partX[curFrame*10], 10, 10)
		'DrawText(PrevKey() + " " + NextKey(), 10, 40)

		For Local fr:Int = 0 To 940

		If keyFrame[fr] = True

			DrawCircle( fr + 10, 630, 5 )

		End

	End

	White()

	DrawText( curFrame, curFrame + 10 - String(curFrame).Length()*8/2, 550 )

	End

	Method Deinit:Void()

		img.Deinit()

	End

End

Function Tween:Float(b:Float, e:Float, f:Float, p:Float, n:Float)

	Local c:Float = e - b
	Local d:Float = n - p
	Local t:Float = f - p

	Return c * t / d + b

	'(-70 - -178) * 192 / 97 + -178

End

