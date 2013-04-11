Strict

Import imp

Global menu:menuClass = New menuClass

'Global playMenuBtn := New Buttons

Global levelPlay:Button[5]

Global shopMenuBtn := New Button
Global shopMoreGames := New Button
Global playSurvivalBtn := New Button
Global reset_btn := New Button

'Global menuPerc:Image[4]
Global menuPerces := New atlasClass

Global tempAnim:AnimBundle

Class menuClass

	Field bgr:Image

	Method Init:Void()

		reset_btn.Init("X")

		bgr = LoadImage ( "menu/menu"+retinaStr+".jpg", 1, Image.MidHandle )

		For Local lp:Int = 1 To 3
			levelPlay[lp] = New Button
			levelPlay[lp].Init("", "menu/level"+lp+"",1,1,2)
			'menuPerc[lp] = LoadImage( "menu/menuPerc0" + lp + "" + loadadd + ".png" )
		Next

		menuPerces.Init("menu/menuPerces" + loadadd + ".png")

		flare = LoadImage("flare.png", 1, Image.MidHandle)

		shopMenuBtn.Init("Store")

		playSurvivalBtn.Init("Sprint")

		'tempAnim = New AnimBundle("crab")
		'tempAnim.Play("the_anim")
		'tempAnim.sclX = 1
		'tempAnim.sclY = 1
		'tempAnim.animType = 0

		shopMoreGames.Init("More Games")

	End

	Field am:Int
	Field swimPerc:Float
	Field rotateFlare:Float

	Method Update:String()

		'Error CurrentLevel

		'tempAnim.Update()

		If levelPlay[CurrentLevel].Pressed()

			menu.Deinit()

			If comix.done

				mainGame.Init()
				mainGame.Reset()

				Return Game

			Else

				comix.Init()

				Return Comix

			End

		End

		'Perc rotation'
		rotateFlare += .3
		If rotateFlare > 360 rotateFlare = 0

		am += 1
		If am > 300 am = 0

		If am < 150 swimPerc += .05 Else swimPerc -= .05

		'Shop btn'
		If CurrentLevel < 4 And shopMenuBtn.Pressed()

			menu.Deinit()
			shop.Init()

			Return Shop

		End

		If reset_btn.Pressed()

			window.Init( ["Yes", "No"], "You won't be able to undo this!", "Do you want to reset the game?" )

		End

		If shopMoreGames.Pressed()

			AAPublishingShowMoreGames()

		End

		If winResult = 1

			winResult = 0
			ResetGame()
			SaveGame()

		End

		Return Menu

	End

	Method Draw:Void()

		DrawImage ( bgr, dw/2, dh/2, 0 , retinaScl, retinaScl )

		'DrawImage ( menuPerc[1], -5 - swimPerc, 								dh - menuPerc[1].Height() + swimPerc, swimPerc/5, 1,1 )
		'DrawImage ( menuPerc[2], dw - menuPerc[2].Width() + swimPerc, 		-5 - swimPerc,						swimPerc/5, 1,1 )
		'DrawImage ( menuPerc[3], dw - menuPerc[3].Width() + swimPerc, 		dh - menuPerc[3].Height() + swimPerc, swimPerc/5, 1,1 )

		menuPerces.Draw(0, 	-5 - swimPerc, 							dh - menuPerces.h[0] + swimPerc, 		swimPerc/5)
		menuPerces.Draw(1, 	dw - menuPerces.w[1] + swimPerc, 		-5 - swimPerc,							swimPerc/5)
		menuPerces.Draw(2, 	dw - menuPerces.w[2] + swimPerc, 		dh - menuPerces.h[2] + swimPerc, 		swimPerc/5)

		reset_btn.Draw( dw - reset_btn.w, dh/3*2 )

		DrawFont( "v0.28", 10 * Retina, 10 * Retina, False, 50 )

		If CurrentLevel = 4

			playSurvivalBtn.Draw( dw/2 - playSurvivalBtn.w/2, dh/5 * 3 )

			SetAlpha(.5)

		End

		SetBlend(1)
		DrawImage( flare, dw/2, dh/2, rotateFlare, 3, 3 )
		SetBlend(0)
		levelPlay[CurrentLevel].Draw( dw/2 - levelPlay[CurrentLevel].w/2, dh/2 - levelPlay[CurrentLevel].h/2	   )
		DrawFont ( "", dw/2 - levelPlay[CurrentLevel].w/2, dh/5, True	)

		If CurrentLevel < 4	shopMenuBtn.Draw( dw/2 - shopMenuBtn.w/2, dh - shopMenuBtn.h )

		shopMoreGames.Draw(0, 0)

		'tempAnim.Draw(dw/2, dh/2)

		'DrawText(menuPerces.thpath, 10,10)

	End

	Method Deinit:Void()

		bgr.Discard()

		For Local lp:Int = 1 To 3
			levelPlay[lp].Deinit()
		Next

		menuPerces.Deinit()

		shopMenuBtn.Deinit()
		shopMoreGames.Deinit()

		playSurvivalBtn.Deinit()

		reset_btn.Deinit()

		flare.Discard()

	End

End