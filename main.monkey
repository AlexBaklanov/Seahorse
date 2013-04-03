Import imp

Global coords = False

Class GameGW Extends App
		
		Field JustChanged:Bool
		Field WaitALittle:Int
		Field ModeOld:String
		
		Method OnCreate()
			
			SetUpdateRate 60

			MainInit()
			
			
		End
		
		Method OnUpdate()

			If AAPublishingIsAdShown() 
				PauseInit()
				Return
			End
		
			WindowsUpdate()
			If windowActive Return
			
			If WaitALittle > 0
				WaitALittle -= 1
				Return
			End

			#If TARGET="ios"
			If isGCShown() Return
			#Endif
			
			If KeyHit(KEY_F1) And KeyHit(KEY_SPACE)
				If coords = True coords = False Else coords = True
			Endif
			
			UpdateAllAnimations()
			
			UpdateBubbles()
			
			Select Mode
				
				Case Game
					
					Mode = mainGame.Update()
					
				Case Menu
					
					Mode = menu.Update()
					
				Case Comix
					
					Mode = comix.Update()
					
				Case Shop
					
					Mode = shop.Update()
					
			End
			
			If Mode <> ModeOld And Mode <> Game
				WaitALittle = 20
				ModeOld = Mode
			End
			
			ModeOld = Mode
			
			
		End
		
		Method OnRender()
		
			Select Mode
			
				Case Game
					
					mainGame.Draw()
					
				Case Menu
					
					menu.Draw()
					
				Case Comix
					
					comix.Draw()
					
				Case Shop
					
					shop.Draw()
			
			End
			
			DrawAllAnimations()
			
			WindowsRender()
			
			DrawBubbles()
			
			'DrawText(Int(alive), 10, 10)
			
			'If LoadingProcess = True DrawImage (loading, cx(240), cy(160))
			White()
			If coords = True DrawText(MouseX() + ", "+ MouseY(), 0,0)
			'DrawText(distance, 10,10)
			'DrawText(typeBought[3], 10,30)
			'DrawText(typeBought[4], 10,50)
			
			#rem
			If BlockShopView > 0
				
				SetAlpha(.7)
				DrawImage( fadeout, 0, 0, 0, cx(480), cy(320) )
				SetAlpha(1)
				
				DrawFont("Not available in this version.", DeviceWidth/2, DeviceHeight/2 - cx(50), True )
				
				'Yellow()
				'DrawFont("Visit App Store", DeviceWidth/2, DeviceHeight/2 + cx(50), True )
				'DrawFont("Visit Amazon", DeviceWidth/2, DeviceHeight/2 + cx(100), True )
				'White()
				
				DrawFont("See links below.", DeviceWidth/2, DeviceHeight/2 + cx(50), True )
				
				BlockShopView -= 1
				
			Endif
			#end
			
			'If PromoTest
			'        SetAlpha(.3)
			'        DrawRect(380, 220, 100, 100)
			'        SetAlpha(1)
			'Endif

		End

		Method OnSuspend()

			AAPUblishingOnSuspend()
			PauseInit()

		End

		Method OnResume()

			'If GameCenterTrue = True And IsGameCenterAvailable() InitializeGameCenter()'ReInitGameCenter()
			
			'hideCrossPromoButton()

                Select Mode

                        Case Game

                                'Play(game_music,0,1)
                                'StopChannel(1)
                                'StopChannel(2)

                        Case Menu

                                'If ChannelState(1) = 0 Play (menua_music,1,1)
                                'If ChannelState(2) = 0 Play (menub_music,2,1)

                                'SetChannelVolume(1,1)
                                'SetChannelVolume(2,0)

						'showCrossPromoButton()

                        Case GameOver

                        Case Shop
		

                End

        End

		'Global furame#

		Method OnLoading()
		
			
			#rem		
			Cls
			
			If furame < 3.9 furame += .2 Else furame = 0
			
			If LoadingProcess = True And target<>"android" DrawImage (explosion, 240, 160, Int(furame) )
			
			DrawFont("!",320,160, True)
			#end
			
			
		End

        Method OnExit()

                Select Mode

                        Case Game

                        Case Menu

                        Case GameOver

                        Case Missions

                End

        End

End





Function Main()

        New GameGW

End

'=================


