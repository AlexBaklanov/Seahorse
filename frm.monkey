Strict

Import imp

Class framesClass

	Field f:Int
	Field partX:Float[10000], partY:Float[10000]
	Field partRot:Float[10000], partSclX:Float[10000], partSclY:Float[10000]
	Field keyFrameMove:Bool[941], keyFrameRot:Bool[941], keyFrameScl:Bool[941], frameCnt:Int, lastFrame:Int
	Field part:Int[10]

	Method Init:Void(path:String)

		Local tempData:String = app.LoadString( path + "anim.txt" )

		'atlas images enumerator'
		Local frmNum:Int = 0
		Local p:Int

		'read data from txt'
		For Local animLine:String = EachIn tempData.Split("~n")

			p = Int(animLine[1..2])

			For Local animValue:String = EachIn animLine.Split(",")

				'Print "Read Value " + animValue

				Select animValue[0..1]

					Case "f"

						f = Int(animValue[1..])
						lastFrame = f

					Case "m"

						keyFrameMove[f] = False
						keyFrameRot[f] = False
						keyFrameScl[f] = False

						Local ft:Int = Int(animValue[1..])

						Local v:Int = ft - Int(ft/2) * 2

						ft = Int(ft/2)

						Local t:Int = ft - Int(ft/2) * 2

						Local l:Int = Int(ft/2)

						If v = 1 keyFrameMove[f] = True
						If t = 1 keyFrameRot[f] = True
						If l = 1 keyFrameScl[f] = True

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

	Method Deinit:Void()

		

	End

End






