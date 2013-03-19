#if TARGET="ios"

'GameCenter Module
'by: York Burkhardt -> pucupo-games.com

Private
'Import "native/GameCenter.h"
Import "native/ios.cpp"



Public




Extern

Function IsGameCenterAvailable:Bool()
Function InitializeGameCenter:Void()
Function ReInitGameCenter:Void()
Function IsPlayerAvailable:Bool()
Function SendScore:Void(scScore%, scCategory$)
Function SendAchievement:Void(scAchName$, scPercent#)
Function OpenLeaderBoard:Void()
Function OpenAchievements:Void()
Function DeInitGameCenter:Void()
Function IsGameCenterVisible:Bool()


Function CrossPromoInit:Void()
Function hideCrossPromoButton:Void()
Function showCrossPromoButton:Void()


Function isKiipVisible:String()
Function KPunlockAchievement:Void(ach:String)
Function KPupdateLeaderboard:Void(score:Int, lbId:String)
Function InitKiip:Void()

Function flurryInit(secret_code:String)
Function flurrySendEvent(event_name:String)
Function flurrySendParameterEvent(event_name:Srting, param:String)

Function GiveVideoReward:Void()


#Else




Global PromoTest:Bool


Function CrossPromoInit:Void()
End

Function showCrossPromoButton:Void()
        PromoTest = True
End

Function hideCrossPromoButton:Void()
        PromoTest = False
End

Function IsGameCenterAvailable:Bool()
End
Function InitializeGameCenter:Void()
End
Function ReInitGameCenter:Void()
End
Function IsPlayerAvailable:Bool()
End
Function SendScore:Void(scScore%, scCategory$)
End
Function SendAchievement:Void(scAchName$, scPercent#)
End
Function OpenLeaderBoard:Void()
End
Function OpenAchievements:Void()
End
Function DeInitGameCenter:Void()
End
Function IsGameCenterVisible:Bool()
End



        'Function hideCrossPromoButton:Void()
        'Function showCrossPromoButton:Void()


Function isKiipVisible:String()
End
Function KPunlockAchievement:Void(ach:String)
End
Function KPupdateLeaderboard:Void(score:Int, lbId:String)
End
Function InitKiip:Void()
End

Function flurryInit(secret_code:String)
End
Function flurrySendEvent(event_name:String)
End
Function flurrySendParameterEvent(event_name:String, param:String)
End


Function TapJoyInit:Void()
End
Function TapjoyShowAd:Void()
End
Function TapjoyCanGiveReward:Bool()
	Return False
End

Function GiveVideoReward:Void()
End

Function TapjoyPoints:Int()
	Return 0
End

Function isAdShown:Bool()
	Return False
End

#EndIf