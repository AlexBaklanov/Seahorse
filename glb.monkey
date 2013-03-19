Strict

Import imp


Global target:String
Global addX#
Global addY#
Global Retina:Int

Global dw:Int
Global dh:Int

Global loadadd:String
Global loadfolder:String

Global retinaStr:String
Global retinaScl:Int

Global kerning:Float=12

Global InAppPurchase:Bool = True
Global PlayerName:Bool = False
Global BlockShop:Bool = False

Global enemyRadiusEnabled:Bool

'=================== MODES ===================
Global Menu:String="Menu"
Global Game:String="Game"
Global GameOver:String="GameOver"
Global Missions:String="Missions"
Global Shop:String="Shop"
Global Comix:String="Comix"

Global Mode:String=Menu

Global ModeFrom:String

Global GameCenterTrue:Bool

Global font:Image
Global fontW:Int = 20
Global fontH:Int = 16
Global fontKern:Float = 11.0
Global btn:Image

Global windowImg:Image
Global fadeImg:Image

Global imagesRects2x:Int

Function indicate2xForImageRectangles:Void()

	If retinaStr = "@p" imagesRects2x = 2 Else imagesRects2x = 1

End

Function LoadGeneralImages:Void()

	font = 			LoadImage( "font"+loadadd+".png", 		20*Retina, 		40*Retina, 		96, 	Image.MidHandle )

	btn = 			LoadImage( "button"+loadadd+".png", 	224*Retina, 	bh*Retina, 		2 						)

	windowImg = 	LoadImage( "window"+loadadd+".png", 									1, 		Image.MidHandle )

	fadeImg = 		LoadImage( "fade.png", 													1, 		Image.MidHandle )

	bubbles = 		LoadImage ( "bonus/bonus03" + loadadd + ".png", 1, Image.MidHandle )

End

Function LoadGeneralFiles:Void()

	LoadTextIDs()

	StreamsLoad()

End

Function DrawFont:Void(str_font:String, fontX:Int, fontY:Int, center:Bool, size:Float=100.0, kern# = fontKern*Retina)
	
	Local str_font_length:Float = str_font.Length
	'kerning_local = kern
		
	For Local fs:Int = 0 To str_font_length-1
		
		If center=False
			
			If str_font[fs]>31 DrawImage(font, fontX+fs*(kern*(size/100.0)), fontY, 0, (size/100.0), (size/100.0), str_font[fs]-32)
			
		Else
		
			If str_font[fs]>31 DrawImage(font, fontX - (str_font_length*(kern*(size/100.0)))/2.0 + Float(fs)*kern*(size/100.0), fontY, 0, (size/100.0), (size/100.0), str_font[fs]-32)
			
		Endif
				
	Next
	
End

Global bm:Int = 18
Global bh:Int = 48


'8 888888888o   8 8888      88 8888888 8888888888 8888888 8888888888 ,o888888o.     b.             8    d888888o.   
'8 8888    `88. 8 8888      88       8 8888             8 8888    . 8888     `88.   888o.          8  .`8888:' `88. 
'8 8888     `88 8 8888      88       8 8888             8 8888   ,8 8888       `8b  Y88888o.       8  8.`8888.   Y8 
'8 8888     ,88 8 8888      88       8 8888             8 8888   88 8888        `8b .`Y888888o.    8  `8.`8888.     
'8 8888.   ,88' 8 8888      88       8 8888             8 8888   88 8888         88 8o. `Y888888o. 8   `8.`8888.    
'8 8888888888   8 8888      88       8 8888             8 8888   88 8888         88 8`Y8o. `Y88888o8    `8.`8888.   
'8 8888    `88. 8 8888      88       8 8888             8 8888   88 8888        ,8P 8   `Y8o. `Y8888     `8.`8888.  
'8 8888      88 ` 8888     ,8P       8 8888             8 8888   `8 8888       ,8P  8      `Y8o. `Y8 8b   `8.`8888. 
'8 8888    ,88'   8888   ,d8P        8 8888             8 8888    ` 8888     ,88'   8         `Y8o.` `8b.  ;8.`8888 
'8 888888888P      `Y88888P'         8 8888             8 8888       `8888888P'     8            `Yo  `Y8888P ,88P' 

Class Buttons

	Field x:Float, y:Float
	Field Width:Int, Height:Int

	Field text:String
	Field textLength:Int
	Field textScl:Float = 1
	Field i:Image
	Field frame:Int

	Field other:Bool
	Field type:Int
	Field Down:Bool
	Field btnScale:Float
	
	Field bubblesReady:Bool

	Method Init:Void(theText:String, otherImg:String = "", w:Int = 1, h:Int = 1, theType:Int = 1, img:Image = Null, theFrame:Int = 0 )

		type = theType

		If otherImg = ""
			i = btn
			other = False
		Else
			If type = 1 i = LoadImage(otherImg+"_btn"+loadadd+".png", 2)
			If type = 2 i = LoadImage(otherImg+"_btn"+loadadd+".png")
			If type = 3 i = img
			other = True
		End

		frame = theFrame

		Width = w

		If w = 1 Width = i.Width()

		Height = h

		If h = 1 Height = i.Height()

		text = theText
		textLength = text.Length()

		If textLength*fontKern*Retina < 192*Retina And other = False
			Width = textLength*fontKern*Retina + bh*Retina
		End

		x = -10000
		y = -10000
		
		bubblesReady = True

	End

	Method Draw:Void(xpos:Float, ypos:Float, scl:Float = 1.0)

		x = xpos
		y = ypos

		btnScale = scl

		Local ln:Int = text.Length()*fontKern*Retina

		If ln < 192*Retina And other = False

			DrawImageRect(i, x,                     y,      0,                      0, bm*Retina,   bh*Retina, Int(Down))

			DrawImageRect(i, x + bm*Retina,         y,      bm*Retina,              0, ln,          bh*Retina, Int(Down))

			DrawImageRect(i, x + bm*Retina + ln,    y,      i.Width() - bm*Retina,  0, bm*Retina,   bh*Retina, Int(Down))

		Else

			If type = 1 DrawImage(i, x, y, Int(Down))
			If type = 2 DrawImage(i, Float(x+Int(Down)*Retina), Float(y+Int(Down)*Retina), 0, btnScale, btnScale)
			If type = 3 DrawImage(	i, 
										Float(x+Int(Down)*Retina), 
										Float(y+Int(Down)*Retina),
										0, 
										btnScale, 
										btnScale,
										frame )

		End

		'SetColor(0,180,255)
		DrawFont(text, x + Width/2 + Int(Down)*Retina, y + Height/2 + Int(Down)*Retina, True, textScl*100)
		'White()

	End

	Method Pressed:Bool()

		If TouchDown(0) And TouchX() > x And TouchX() < x + Width*btnScale And TouchY() > y And TouchY() < y + Height*btnScale
			Down = True
			'If bubblesReady CreateButtonBubbles(x,y)
			'bubblesReady = False
			Return False
		Endif

		If TouchDown(0)
			Down = False
			Return False
		Endif

		If Down
			Down = False
			bubblesReady = True
			Return True
		Endif

		Return False

	End

	Method Deinit:Void()

		If i <> btn i.Discard()

	End

End

Function CreateButtonBubbles:Void()
	For Local bbb:Int = 1 To 5
		CreateBubbles( TouchX() + Rnd(-30, 30)*Retina, TouchY() + Rnd(-30, 30)*Retina )
	End
End

Global windowActive:Bool
Global window:windowClass = New windowClass
Global winResult:Int

Class windowClass
	
	Field btns:Buttons[] = []

	Field head:String
	Field text:String

	Field type:Int

	Method Init:Void( theBtns:String[], theHead:String, theText:String, theType:Int = 1 )

		btns = btns.Resize(theBtns.Length())

		For Local bt:Int = 0 To theBtns.Length() - 1

			btns[bt] = New Buttons
			btns[bt].Init(theBtns[bt])

		Next

		head = theHead
		text = theText

		windowActive = True


	End

	Method Update:Int()

		For Local bt:Int = 0 To btns.Length() - 1

			If btns[bt].Pressed() Return bt + 1

		Next
		
		Return 0

	End

	Method Draw:Void()

		DrawFadeBgr()

		DrawImage( windowImg, dw/2, dh/2 )

		Yellow()
		DrawFont ( head, dw/2, dh/2 - windowImg.Height()/2, True )
		White()

		DrawFont ( text, dw/2, dh/2, True )

		For Local bt:Int = 0 To btns.Length() - 1

			btns[bt].Draw( dw/(btns.Length() + 1) * (bt+1) - btns[bt].Width/2, dh/2 + windowImg.Height()/2 - btns[bt].Height )

		Next

	End

	Method Deinit:Void()

		For Local bt:Int = 0 To btns.Length() - 1

			btns[bt].Deinit()

		Next

		windowActive = False

	End

End

Function WindowsRender:Void()

	If windowActive

		window.Draw()

	End

End

Function WindowsUpdate:Void()

	If windowActive

		winResult = window.Update()

		If winResult

			window.Deinit()

		End

	End

End




Function Distance:Float(firstObjectX:Float, firstObjectY:Float, secondObjectX:Float, secondObjectY:Float)

	Return Sqrt( Pow( (firstObjectX - secondObjectX), 2 )  + Pow( (firstObjectY - secondObjectY), 2 ) )

End

Global swipeTime:Int
Global swipeX:Float

Function Swipe:Bool()

	If TouchDown(0) And alive

		swipeTime += 1

		If swipeX = 0 swipeX = TouchX()

		Return False

	End

	If swipeTime > 0 And swipeTime < 50 And TouchX() > swipeX + 100*Retina

		swipeTime = 0
		swipeX = 0

		Return True

	End

	swipeTime = 0
	swipeX = 0

	Return False

End

Function RightScreenSide:Int(btn:Buttons)

	Return DeviceWidth() - btn.Width

End

Function DownScreenSide:Int(btn:Buttons)

	Return DeviceHeight() - btn.Height

End

Function Black:Void()
	SetColor(0,0,0)
End

Function Yellow:Void()
	SetColor(255,205,0)
End

Function White:Void()
	SetColor(255,255,255)
End

Global somethingIsSliding:Bool

Function SlideThe:Int(param:Int, maxAmount:Int = 100, spd:Int = 1)

	somethingIsSliding = True

	param += spd

	If param > maxAmount somethingIsSliding = False

	Return param

End

Global globalTime:Int
Global gtCounter:Int

Function GameTime:Void()

	If Millisecs() > gtCounter + 1000

		gtCounter = Millisecs()

		globalTime += 1

	End

End

Function DrawFadeBgr:Void()

	SetAlpha(.3)
	DrawImage (fadeImg, dw/2, dh/2, 0, 512*Retina, 384*Retina )
	SetAlpha(1)

End

Global animation := New List<animationClass>

Class animationClass

	Field img:Image

	Field x:Float, y:Float

	Field type:Int

	Field animCounter:Float, animSpeed:Float

	Field frame:Int, frameCount:Int
	
	Field isAnimationEnabled:Bool
	
	Method Init:Void(animImg:Image, ax:Float, ay:Float, animSpd:Float, theType:Int = 1, frameCnt:Int)

		img = animImg

		frameCount = frameCnt - 1
		

		isAnimationEnabled = True

		x = ax
		y = ay

		animSpeed = animSpd
		type = theType

	End

	Method Update:Void()

		If isAnimationEnabled

			animCounter += animSpeed

			Select type

				Case 1 'Loop
					If animCounter > frameCount animCounter = 0

				Case 2 'One shot
					If animCounter > frameCount animCounter = 0 animSpeed = 0 isAnimationEnabled = False

				Case 3 'ping-pong
					If animCounter > frameCount
						animCounter = frameCount
						animSpeed = -animSpeed
					End
					If animCounter < 0
						animCounter = 0
						animSpeed = -animSpeed
					End

				Case 4 'One shot and delete
					If animCounter > frameCount
						animCounter = 0
						animSpeed = 0
						animation.Remove(Self)
					End

			End

		End

	End

	Method Draw:Void()

		If isAnimationEnabled
			frame = animCounter
			DrawImage( img, x, y, frame )
		End

	End

End

Function LoadAnimation:Image(name:String, frameCnt:Int, mid:Bool = True)

	Local img:Image

	If mid
		img = LoadImage( name + "" + loadadd + ".png", frameCnt, Image.MidHandle )
	Else
		img = LoadImage( name + "" + loadadd + ".png", frameCnt )
	End

	Return img

End

Function Animate:Void(animImg:Image, ax:Float, ay:Float, animSpd:Float, theType:Int = 1)

	Local frameCnt:Int = animImg.Frames()

	Local anm := New animationClass
	anm.Init(animImg, ax, ay, animSpd, theType, frameCnt)
	animation.AddLast(anm)

End

Function DrawAllAnimations:Void()

	For Local anms := Eachin animation
		
		anms.Draw()
		
	End

End

Function UpdateAllAnimations:Void()

	For Local anms := Eachin animation
		
		anms.Update()
		
	End

End

Global bubbles:Image

Function CreateBubbles:Void(theX:Float, theY:Float)
	
	Local bu := New BubblesClass
	bu.Init(theX, theY)
	Bubbles.AddLast(bu)
	
End

Function DrawBubbles:Void()
	
	For Local bu := Eachin Bubbles
		bu.Draw()
	End
	
End

Function UpdateBubbles:Void()
	
	For Local bu := Eachin Bubbles
		bu.Update()
	End
	
End

Global Bubbles := New List<BubblesClass>

Class BubblesClass
	
	Field x:Float, y:Float
	Field scl:Float
	
	Field spd:Float
	
	Method Init:Void(X:Int, Y:Int)
			
		x = X
		y = Y
		
		scl = Rnd( .3, .7 )
			
	End
	
	Method Update:Void()
		
		y -= 2 * scl * Retina
		
		If y < -10*Retina Bubbles.Remove(Self)
		
	End
	
	Method Draw:Void()

		DrawImage( bubbles, x, y, 0, scl, scl )

	End
	
	
End