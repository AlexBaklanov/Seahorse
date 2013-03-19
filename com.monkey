Strict

Import imp

Global comix := New ComixClass

Global skipBtn := New Buttons

Class ComixClass
	
	Field x:Float
	Field img:Image

	Field stp:Float

	Field done:Bool

	Field pauseStart:Int = 100

	Field fadeAlpha:Float

	Method Init:Void()

		img = LoadImage ( "comix/comix" + CurrentLevel + "" + retinaStr + ".jpg", 1, Image.MidHandle )

		stp = dw / 300

		x = dw + pauseStart

		skipBtn.Init("skip>>")

	End

	Method Update:String()

		x -= stp

		If x < -pauseStart Or skipBtn.Pressed()

			done = True

			Self.Deinit()

			mainGame.Init()
			mainGame.Reset()

			Return Game

		End

		Return Comix

	End

	Method Draw:Void()

		Local imgX:Float = x

		fadeAlpha = 0

		If x > dw
			imgX = dw
			fadeAlpha = ((x - dw) / pauseStart)
		End
		If x < 0
			imgX = 0
			fadeAlpha = -x/100
		End
		
		Local sclIP:Float = 1.0
		Local movIP:Int = 0
		If dw = 480 Or dw = 960
			sclIP = .936
			movIP = 16 * Retina
		End

		DrawImage( img, imgX, dh/2 + movIP, 0, retinaScl * sclIP, retinaScl * sclIP )
		
		skipBtn.Draw(dw - 10*Retina - skipBtn.Width, dh - 10*Retina - skipBtn.Height )

		SetAlpha(fadeAlpha)
		SetColor(0,0,0)
		DrawRect ( 0,0,dw,dh )
		White()
		SetAlpha(1)

	End

	Method Deinit:Void()

		img.Discard()

	End

End