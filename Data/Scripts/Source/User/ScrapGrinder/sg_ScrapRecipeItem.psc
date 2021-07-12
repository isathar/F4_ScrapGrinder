ScriptName ScrapGrinder:sg_ScrapRecipeItem extends ObjectReference
{dummy crafted item script for scrap grinding}


int Property nOutputType = 0 Auto
{0 = player, 1 = workshop}
FormList Property pAllComponents Auto
{base components list}
FormList Property pCompoScrapItems Auto
{component scrap items}
FormList Property pAllComponents_Modded Auto
{separate components list for other mods}
FormList Property pCompoScrapItems_Mod Auto
{separate output scrap items for other mods}
Container Property pScrapContainer Auto
{base form for the scrap input container}
Quest Property pWorkshopParentQuest Auto
Message Property pScrapFailedMessage Auto


Function ScrapAllInventory()
	int idx = 0
	int iCurCount = 0
	bool bFoundAny = False
	ObjectReference OutputContainer = None
	ObjectReference InputContainer = Game.FindClosestReferenceOfTypeFromRef(pScrapContainer as Form, Game.GetPlayer() as ObjectReference, 1024)
	If (InputContainer as bool)
		If (nOutputType == 0)
			OutputContainer = Game.GetPlayer() as ObjectReference
		Else
			workshopparentscript tempWSQuest = pWorkshopParentQuest as workshopparentscript
			workshopscript curworkshop = tempWSQuest.GetWorkshopFromLocation(Game.GetPlayer().GetCurrentLocation())
			OutputContainer = curworkshop.GetContainer()
		EndIf
		If (OutputContainer as bool)
			While (idx < pAllComponents.GetSize())
				iCurCount = InputContainer.GetComponentCount(pAllComponents.GetAt(idx))
				If (iCurCount > 0)
					InputContainer.RemoveComponents(pAllComponents.GetAt(idx) as component, iCurCount, False)
					OutputContainer.AddItem(pCompoScrapItems.GetAt(idx), iCurCount, True)
					If (!bFoundAny)
						bFoundAny = True
					EndIf
				EndIf
				idx += 1
			EndWhile
			idx = 0
			While (idx < pAllComponents_Modded.GetSize())
				iCurCount = InputContainer.GetComponentCount(None)
				If (iCurCount > 0)
					InputContainer.RemoveComponents(pAllComponents_Modded.GetAt(idx) as component, iCurCount, False)
					OutputContainer.AddItem(pCompoScrapItems_Mod.GetAt(idx), iCurCount, True)
					If (!bFoundAny)
						bFoundAny = True
					EndIf
				EndIf
				idx += 1
			EndWhile
		Else
			pScrapFailedMessage.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)
		EndIf
	Else
		pScrapFailedMessage.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)
	EndIf
EndFunction


Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
	If (akNewContainer == Game.GetPlayer() as ObjectReference)
		Self.ScrapAllInventory()
	EndIf
	akNewContainer.RemoveItem(Self as Form, 1, True, None)
EndEvent
