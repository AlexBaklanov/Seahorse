Strict

Import imp

Global currentStream:Int, streamCurrentHeroPosition:Float

Global streamNumber:Int[20], streamStart:Int[20], streamEnd:Int[20]

'db       .d88b.   .d8b.  d8888b. 
'88      .8P  Y8. d8' `8b 88  `8D 
'88      88    88 88ooo88 88   88 
'88      88    88 88~~~88 88   88 
'88booo. `8b  d8' 88   88 88  .8D 
'Y88888P  `Y88P'  YP   YP Y8888D' 

Function StreamsLoad:Void()

	Local streamFile:String = app.LoadString("Streams.txt")

	Local lineCounter:Int

	For Local streamLine:String = EachIn streamFile.Split("~n")

		lineCounter += 1

		Local valuesCounter:Int

		For Local streamValue:String = EachIn streamLine.Split(" ")

			valuesCounter += 1

			Select valuesCounter

				Case 1

					streamNumber[lineCounter] = 	Int(streamValue)

				Case 2

					streamStart[lineCounter] = 		Int(streamValue) * 10

				Case 3

					streamEnd[lineCounter] = 		Int(streamValue) * 10

			End
			
		Next

	Next

End

	'd888888b d8b   db d888888b d888888b 
	'  `88'   888o  88   `88'   `~~88~~' 
	'   88    88V8o 88    88       88    
	'   88    88 V8o88    88       88    
	'  .88.   88  V888   .88.      88    
	'Y888888P VP   V8P Y888888P    YP    


Function StreamsInit:Void()

	StreamDeactivate()

	If CurrentLevel = 1
		
		currentStream = 1
		StreamBubblesInit()

	End

End

	'd8888b. d8888b.  .d8b.  db   d8b   db 
	'88  `8D 88  `8D d8' `8b 88   I8I   88 
	'88   88 88oobY' 88ooo88 88   I8I   88 
	'88   88 88`8b   88~~~88 Y8   I8I   88 
	'88  .8D 88 `88. 88   88 `8b d8'8b d8' 
	'Y8888D' 88   YD YP   YP  `8b8' `8d8'  


Function StreamsDraw:Void()

	'DrawText(Int(streamBubbleCount), 50, 50)

	If isStreamActive

		Select currentStream

			Case 1

				StreamBubblesDraw()

		End

	End

End

	'db    db d8888b. d8888b.  .d8b.  d888888b d88888b 
	'88    88 88  `8D 88  `8D d8' `8b `~~88~~' 88'     
	'88    88 88oodD' 88   88 88ooo88    88    88ooooo 
	'88    88 88~~~   88   88 88~~~88    88    88~~~~~ 
	'88b  d88 88      88  .8D 88   88    88    88.     
	'~Y8888P' 88      Y8888D' YP   YP    YP    Y88888P


Global isStreamActive:Bool, activatePostProposition:Bool

Function StreamsUpdate:Void()

	If isStreamActive

		Select currentStream

			Case 1

				StreamBubblesUpdate()

		End

	End

	hero.CorrectYPosition()

	If distance > streamStart[currentStream] StreamActivate()
	If distance > streamEnd[currentStream] StreamDeactivate()

End

Function StreamsDeinit:Void()

	If CurrentLevel = 1
		
		StreamBubblesDeinit()

	End

End

Function StreamActivate:Void()

	isStreamActive = True
	hero.PrepareForStream()

End

Function StreamDeactivate:Void()

	isStreamActive = False
	currentStream += 1

	activatePostProposition = True

	hero.OutOfStream()

End


'================================================================================================================================================
'================================================================================================================================================
'================================================================================================================================================
'================================================================================================================================================


'd8888b. db    db d8888b. d8888b. db      d88888b .d8888. 
'88  `8D 88    88 88  `8D 88  `8D 88      88'     88'  YP 
'88oooY' 88    88 88oooY' 88oooY' 88      88ooooo `8bo.   
'88~~~b. 88    88 88~~~b. 88~~~b. 88      88~~~~~   `Y8b. 
'88   8D 88b  d88 88   8D 88   8D 88booo. 88.     db   8D 
'Y8888P' ~Y8888P' Y8888P' Y8888P' Y88888P Y88888P `8888Y' 

Global streamBubblesImage:Image
Global streamBubbleCounter:Int, streamBubbleDensity:Int = 2, streamBubbleCount:Int

Function StreamBubblesInit:Void()

	streamCurrentHeroPosition = dh / 2

	streamBubblesImage = LoadImage("powersUse/Wbubbles" + loadadd + ".png", 1, Image.MidHandle)
	streamBubbleCounter = streamBubbleDensity

End

Function StreamBubblesDraw:Void()

	'DrawText("stream 01", 100, 100)

	For Local strmBub := EachIn streamBubble

		strmBub.Draw()

	End

End

Global streamBubbleCellDrawn:Bool, streamBubbleCellErase:Bool, streamBubbleCellEraseFinished:Bool

Function StreamBubblesCellDraw:Void()

	If streamBubbleCellDrawn = False

		If streamBubbleCounter > 0

			streamBubbleCounter -= 1

		Else

			streamBubbleCounter = streamBubbleDensity

			'Create New Bubble'
			Local newStreamBubble := New streamBubblesClass
			newStreamBubble.Init(streamBubbleCount)
			streamBubble.AddLast(newStreamBubble)

			streamBubbleCount += 1

			If streamBubbleCount = 25 streamBubbleCellDrawn = True

		End

	End

End

Function StreamBubblesCellErase:Void()

	If streamBubbleCellErase

		If streamBubbleCounter > 0

			streamBubbleCounter -= 1

		Else

			streamBubbleCounter = streamBubbleDensity

			'Erase Bubble'
			For Local strmBub := EachIn streamBubble

				If strmBub.bubbleDelete = False
					strmBub.bubbleDelete = True
					Exit
				End

			End

			streamBubbleCount -= 1

			If streamBubbleCount = 0
				streamBubbleCellErase = False
				streamBubbleCellEraseFinished = True
			End

		End

	End

End

Function StreamBubblesUpdate:Void()

	StreamBubblesCellDraw()
	StreamBubblesCellErase()

	If streamBubbleCellEraseFinished = False And distance > streamEnd[currentStream] - 100 streamBubbleCellErase = True

	For Local strmBub := EachIn streamBubble

		strmBub.Update()

	End

End

Function StreamBubblesDeinit:Void()

	streamBubblesImage.Discard()

End

Global streamBubble := New List<streamBubblesClass>

Class streamBubblesClass
	
	Field x:Int, y:Int, num:Int, size:Float, sizeIncrease:Float, bubbleDelete:Bool, spd:Float, streamBubbleReady:Bool

	Method Init:Void(theNum:Int)

		num = theNum

		Local numX:Int = num - Int( num / 5 ) * 5
		Local numY:Int = Int( num / 5 )

		Local stBubSize:Float = streamBubblesImage.Width()
		'Local calculateX:Int = Int(Float (Rnd( hero.x + stBubSize, 	dw - stBubSize )) / stBubSize ) * stBubSize
		'Local calculateY:Int = Int(Float (Rnd( stBubSize, 			dh - stBubSize/2 )) / stBubSize) * stBubSize

		Local calculateX:Int = hero.x + stBubSize 		+ numX * stBubSize
		Local calculateY:Int = (dh/2 - stBubSize * 2) 	+ numY * stBubSize

		x = calculateX + Rnd( -10 * Retina, 10 * Retina )
		y = calculateY + Rnd( -10 * Retina, 10 * Retina )

		sizeIncrease = 0
		size = Rnd( .5, 1.0 )
		spd = Rnd(.8, 1.2)
		streamBubbleReady = False

	End

	Method Draw:Void()

		DrawImage( streamBubblesImage, x, y, 0, sizeIncrease, sizeIncrease )
		'DrawText(Int(bubbleDelete), x, y)

	End

	Method Update:Void()

		If bubbleDelete

			If sizeIncrease > 0

				sizeIncrease -= .2

			Else

				streamBubble.Remove(Self)

			End

		End

		If streamBubbleReady = False And sizeIncrease < size

			sizeIncrease += .1

		ElseIf streamBubbleReady = False

			sizeIncrease = size
			streamBubbleReady = True

		End

	End

End








