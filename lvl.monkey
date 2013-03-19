Strict

Import imp

Global levelEnd:Int

Function LoadLevel:Void(curLev:Int)

	stage.Clear()

	Local curLevel:String

	If curLev < 10 curLevel = "0" + String(curLev)

	Local levelfile:String = app.LoadString("Level"+curLevel+".txt")
	
	For Local levelFileLine:String=Eachin levelfile.Split( "~n" )

		Local theLine:Int[10]
		Local theValE:Int[1]
		Local theValB:Int[1]
		Local theValO:Int[1]
		Local tl:Int
		Local ta:Int

		For Local levelFileColumn:String = Eachin levelFileLine.Split( "~t" )

			If levelFileColumn.Contains("[")

				levelFileColumn = levelFileColumn[1..levelFileColumn.Length()-1]

				For Local ar:String = Eachin levelFileColumn.Split( " " )

					If tl = 1
						theValE = theValE.Resize(ta+1)
						theValE[ta] = Int(ar)
					End

					If tl = 3
						theValO = theValO.Resize(ta+1)
						theValO[ta] = Int(ar)
					End

					If tl = 5
						theValB = theValB.Resize(ta+1)
						theValB[ta] = Int(ar)
					End

					ta += 1

				Next

				ta = 0

			Else
				
				theLine[tl] = Int(levelFileColumn)
	
			End

			tl += 1

		Next

		Local dist:Int = theLine[0] * 10
		Local valE:Int[] = theValE
		Local valO:Int[] = theValO
		Local valB:Int[] = theValB
		Local enCo:Int = theLine[2]
		Local obCo:Int = theLine[4]
		Local boCo:Int = theLine[6]

		levelEnd = 60000
		If CurrentLevel = 1 levelEnd = 50000

		CreateStage(dist, valE, enCo, valO, obCo, valB, boCo)
		
	Next

End

Global stage := New List<stageClass>

Class stageClass
	
	Field distance:Int

	Field validEnemies:Int[]

	Field validObstacles:Int[]

	Field validBonuses:Int[]

	Field enCounter:Int

	Field obCounter:Int

	Field boCounter:Int

	Method Init:Void(theDist:Int, theVE:Int[], theEC:Int, theVO:Int[], theOC:Int, theVB:Int[], theBC:Int)

		distance = theDist
		validEnemies = theVE
		validObstacles = theVO
		validBonuses = theVB
		enCounter = theEC
		obCounter = theOC
		boCounter = theBC

	End

End



Function CreateStage:Void(theDist:Int, theVE:Int[], theEC:Int, theVO:Int[], theOC:Int, theVB:Int[], theBC:Int)

	Local st:stageClass = New stageClass
	st.Init(theDist, theVE, theEC, theVO, theOC, theVB, theBC)
	stage.AddLast(st)

End


Function NextLevelAreaInit:Void()

	For Local st := Eachin stage

		If distance > st.distance

			validEnemies = 					st.validEnemies
			validObstacles = 				st.validObstacles
			validBonuses = 					st.validBonuses
			enCounter = 					st.enCounter
			obCounter = 					st.obCounter
			bonuses.bonusesInterval = 		st.boCounter

			'stage.Remove(st)

		End

	Next


End