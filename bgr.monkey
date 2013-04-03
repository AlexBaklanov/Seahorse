Strict

Import imp

Global bgrXactual:Float
Global bgrXbottom:Float

Global fgrX:Float
Global fgrY:Float

Global bgrBottomImg:Image
Global bgrActualImg:Image
Global bgr2:Image
Global fgr:Image

Global bgrMiddleImg:Image 'center'
Global currentBgrMiddle:Int
Global bgrXmiddle:Float

Global cave:Image
Global caveMode:Bool
Global caveX:Float

Global bgr := New atlasClass

Function BackgroundInit:Void()

	'bgr atlas'
	bgr.Load("bgr/bgr0"+CurrentLevel+""+retinaStr+".png")
		
	bgrMiddleImg = LoadImage( "bgr/centerPics" + CurrentLevel + "" +retinaStr+ ".png", 256 * imagesRects2x, 256 * imagesRects2x,  16 )
	bgrMiddleImg.SetHandle( bgrMiddleImg.Width()/2, bgrMiddleImg.Height() )

	cave = LoadImage("bgr/cave"+retinaStr+".png")
	
	currentBgrMiddle = Rnd(0,10)
	bgrXmiddle = dw+bgrMiddleImg.Width()

	bgrXactual = bgr.w[0] / 2
		
End

Function BackgroundUpdate:Void()

	bgrXactual -= speed*Retina * globalSpeed / 4.0
	bgrXbottom -= speed*Retina * globalSpeed

	If bgrXactual < - bgr.w[0]*retinaScl	bgrXactual += bgr.w[0]*retinaScl
	If bgrXbottom < - bgr.w[1]*retinaScl	bgrXbottom += bgr.w[1]*retinaScl
		
	bgrXmiddle -= speed*Retina * globalSpeed / 2.0
	If bgrXmiddle < -bgrMiddleImg.Width()*retinaScl
		
		bgrXmiddle = dw+bgrMiddleImg.Width()
		currentBgrMiddle += 1
		If currentBgrMiddle = 10 currentBgrMiddle = 1
			
	End
	
End

Function BackgroundDraw:Void()
	
	'background main 0'
	bgr.Draw(0, bgrXactual, 							0, 0, retinaScl, retinaScl)
	bgr.Draw(0, bgrXactual + bgr.w[0]*retinaScl,	0, 0, retinaScl, retinaScl)
	
	DrawImage(bgrMiddleImg, bgrXmiddle, dh, 0, retinaScl, retinaScl, currentBgrMiddle)
	
	'background bottom 1'
	bgr.Draw(1, bgrXbottom, 							dh - bgr.h[1]*retinaScl, 	0, retinaScl, retinaScl)
	bgr.Draw(1, bgrXbottom + bgr.w[1]*retinaScl,	dh - bgr.h[1]*retinaScl, 	0, retinaScl, retinaScl)

End

Function BackgroundReset:Void()

	bgrXactual = 0
	bgrXbottom = 0

End

Function BackgroundDeinit:Void()
	
	bgr.Deinit()
	bgrMiddleImg.Discard()
	cave.Discard()
	
End

' .o88b.  .d8b.  db    db d88888b 
'd8P  Y8 d8' `8b 88    88 88'     
'8P      88ooo88 Y8    8P 88ooooo 
'8b      88~~~88 `8b  d8' 88~~~~~ 
'Y8b  d8 88   88  `8bd8'  88.     
' `Y88P' YP   YP    YP    Y88888P 

Function CaveUpdate:Void()

	If caveMode = False And distance > levelEnd - cave.Width() - 5 * Retina

		caveMode = True
		caveX = dw

	End

	If caveMode

		caveX -= speed * globalSpeed

	End

End

Function CaveDraw:Void()

	If caveMode

		DrawImage( cave, caveX, 0, 0, retinaScl, retinaScl )
		
		If distance < levelEnd DrawImage( winIcon, caveX + 355*Retina, dh/2 + 45*Retina )

	End

End




