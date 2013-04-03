Strict

Import imp

Global gameCenterLeaderboardsBtn := New Buttons
Global gameCenterAchievementsBtn := New Buttons

Global gameCenterHandle:GameCenter

Const gameCenterLeaderBoardBestDistance:String = "com.whitezebra.tutling.bestdistanceinonegame"
Const gameCenterLeaderBoardID2:String = ""
Const gameCenterLeaderBoardID3:String = ""

Const gameCenterAchievementID00:Sring = "com.whitezebra.turtling.a00"

Function GameCenterInit:Void()

	gameCenterHandle=GameCenter.GetGameCenter()
	gameCenterHandle.StartGameCenter()

End

Function GCShowLeaderboards:Void( id:String )

	gameCenterHandle.ShowLeaderboard( id )

End

Function GCShowAchievements:Void(  )

	gameCenterHandle.ShowAchievements()
	
End

Function GCReportScore:Void( scoreValue:Int, id:String )

	gameCenterHandle.ReportScore( scoreValue, id )

End

Function GCReportScore:Void( progressValue:Int, id:String )

	gameCenterHandle.ReportAchievement( progressValue, id )

End

Function GCReportScore:Void( id:String )

	gameCenterHandle.ReportAchievement( 1.0, id )

End

Function isGCShown:Bool()

	If gameCenterHandle.GameCenterState() > 2 Return True

	Return False

End

