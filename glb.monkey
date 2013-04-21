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

Function DrawFont:Void(str_font:String, fontX:Float, fontY:Float, center:Bool, size:Float=100.0, kern# = fontKern*Retina)
	
	Local str_font_length:Float = str_font.Length
	'kerning_local = kern
		
	For Local fs:Int = 0 To str_font_length-1
		
		If center=False
			
			If str_font[fs]>31 DrawImage(font, fontX+fs*(kern*(size/100.0)), fontY, 0, (size/100.0), (size/100.0), str_font[fs]-32)
			
		Else
		
			If str_font[fs]>31 DrawImage(	font, 
											fontX - (str_font_length*(kern*(size/100.0)))/2.0 + Float(fs)*kern*(size/100.0), 
											fontY, 
											0, 
											(size/100.0), 
											(size/100.0), 
											str_font[fs]-32)
			
		Endif
				
	Next
	
End

'd8888b. db    db d888888b d888888b  .d88b.  d8b   db 
'88  `8D 88    88 `~~88~~' `~~88~~' .8P  Y8. 888o  88 
'88oooY' 88    88    88       88    88    88 88V8o 88 
'88~~~b. 88    88    88       88    88    88 88 V8o88 
'88   8D 88b  d88    88       88    `8b  d8' 88  V888 
'Y8888P' ~Y8888P'    YP       YP     `Y88P'  VP   V8P 

Global bm:Int = 18
Global bh:Int = 48

Class Button

	Field x:Float, y:Float, px:Int, py:Int
	Field w:Int, h:Int

	Field text:String
	Field textLength:Int
	Field textScl:Float = 1
	Field i:Image
	Field frame:Int

	Field other:Bool
	Field type:Int
	Field Down:Bool
	Field btnScale:Float

	Field active:Bool = True
	
	Field bubblesReady:Bool

	Method Init:Void(theText:String, otherImg:String = "", theW:Int = 1, theH:Int = 1, theType:Int = 1, img:Image = Null, theFrame:Int = 0 )

		type = theType

		If otherImg = ""
			i = btn
			other = False
			If type = 3
				i = img
				other = True
			End
		Else
			If type = 1 i = LoadImage(otherImg+"_btn"+loadadd+".png", 2)
			If type = 2 i = LoadImage(otherImg+"_btn"+loadadd+".png")
			other = True
		End

		frame = theFrame

		w = theW

		If theW = 1 w = i.Width()

		h = theH

		If theH = 1 h = i.Height()

		px = i.HandleX()
		py = i.HandleY()

		text = theText
		textLength = text.Length()

		If textLength*fontKern*Retina < 192*Retina And other = False
			w = textLength * fontKern * Retina + bh * Retina
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
		DrawFont(text, x + w/2 + Int(Down)*Retina, y + h/2 + Int(Down)*Retina, True, textScl*100)
		'White()

	End

	Method Pressed:Bool()

		If active

			If TouchDown(0) And TouchX() > x - px And TouchX() < x - px + w * btnScale And TouchY() > y - py And TouchY() < y - py + h * btnScale
				Down = True
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

		End

		Return False

	End

	Method Deinit:Void()

		If i <> btn i.Discard()

	End

End

'db   d8b   db d888888b d8b   db d8888b.  .d88b.  db   d8b   db 
'88   I8I   88   `88'   888o  88 88  `8D .8P  Y8. 88   I8I   88 
'88   I8I   88    88    88V8o 88 88   88 88    88 88   I8I   88 
'Y8   I8I   88    88    88 V8o88 88   88 88    88 Y8   I8I   88 
'`8b d8'8b d8'   .88.   88  V888 88  .8D `8b  d8' `8b d8'8b d8' 
' `8b8' `8d8'  Y888888P VP   V8P Y8888D'  `Y88P'   `8b8' `8d8' 

Function CreateButtonBubbles:Void()
	For Local bbb:Int = 1 To 5
		CreateBubbles( TouchX() + Rnd(-30, 30)*Retina, TouchY() + Rnd(-30, 30)*Retina )
	End
End

Global windowActive:Bool
Global window:windowClass = New windowClass
Global winResult:Int

Class windowClass
	
	Field btns:Button[] = []

	Field head:String
	Field text:String

	Field type:Int

	Method Init:Void( theBtns:String[], theHead:String, theText:String, theType:Int = 1 )

		btns = btns.Resize(theBtns.Length())

		For Local bt:Int = 0 To theBtns.Length() - 1

			btns[bt] = New Button
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

			btns[bt].Draw( dw/(btns.Length() + 1) * (bt+1) - btns[bt].w/2, dh/2 + windowImg.Height()/2 - btns[bt].h )

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

'.d8888. db   d8b   db d888888b d8888b. d88888b 
'88'  YP 88   I8I   88   `88'   88  `8D 88'     
'`8bo.   88   I8I   88    88    88oodD' 88ooooo 
'  `Y8b. Y8   I8I   88    88    88~~~   88~~~~~ 
'db   8D `8b d8'8b d8'   .88.   88      88.     
'`8888Y'  `8b8' `8d8'  Y888888P 88      Y88888P 

Global swipeTime:Int
Global swipeX:Float
Global swipeY:Float

Global swipeLength:Int = 50

Const swipeLeft:Int = 1
Const swipeRight:Int = 2
Const swipeUp:Int = 3
Const swipeDown:Int = 4
Const touch:Int = 5

'Global controlTouch:Int

Function ControlTouch:Int()

	If TouchDown(0)

		swipeTime += 1

		If swipeX = 0 swipeX = TouchX()
		If swipeY = 0 swipeY = TouchY()

		Return False

	End

	If swipeTime > 0 And swipeTime < 50 

		If TouchY() < swipeY - swipeLength * Retina

			swipeTime = 0
			swipeX = 0
			swipeY = 0

			'Print swipeUp
			Return swipeUp

		End

		If TouchY() > swipeY + swipeLength * Retina

			swipeTime = 0
			swipeX = 0
			swipeY = 0

			Return swipeDown

		End

		If TouchX() > swipeX + swipeLength * Retina

			swipeTime = 0
			swipeX = 0
			swipeY = 0

			Return swipeRight

		End

		If TouchX() < swipeX - swipeLength * Retina

			swipeTime = 0
			swipeX = 0
			swipeY = 0

			Return swipeLeft

		End

		swipeTime = 0
		swipeY = 0
		swipeX = 0

		Return touch

	End

	swipeTime = 0
	swipeY = 0

	Return 0

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