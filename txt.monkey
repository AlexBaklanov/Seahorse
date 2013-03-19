Strict

Import imp

Global textID:String[200]

Function LoadTextIDs:Void()

	Local levelfile$ = app.LoadString("GameTexts.txt")
	
	For Local line$=Eachin levelfile.Split( "~n" )

		If line.Contains("ID")

			textID[Int(line[4..7])] = line[10..]

		End
		
	Next

End