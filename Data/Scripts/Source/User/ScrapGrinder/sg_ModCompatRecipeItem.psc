ScriptName ScrapGrinder:sg_ModCompatRecipeItem extends ObjectReference
{dummy crafted item script for scrap grinding mod compatibility}

; This is an inefficient method of adding custom items to the scrappable list
; and will be replaced whenever I get around to remaking the mod.


int Property nTypeIndex Auto
FormList Property pBaseComponentsList Auto
{base components list}
FormList Property pBaseScrapItemsList Auto
{base component scrap items}
FormList Property pModAddComponents Auto
{mod components to add}
FormList Property pModAddScrapItems Auto
{mod scrap items to add}
GlobalVariable Property pModAddedGlobal Auto
{global toggle to make sure forms need to be added/removed}


Function AddModScrap()
	int idx = 0
	If (pModAddedGlobal.GetValue() < 1)
		While (idx < pModAddComponents.GetSize())
			If (!pBaseComponentsList.HasForm(pModAddComponents.GetAt(idx)))
				pBaseComponentsList.AddForm(pModAddComponents.GetAt(idx))
				pBaseScrapItemsList.AddForm(pModAddScrapItems.GetAt(idx))
			EndIf
			idx += 1
		EndWhile
		pModAddedGlobal.SetValue(1)
	EndIf
EndFunction


Function ResetModScrap()
	int idx = 0
	If (pModAddedGlobal.GetValue() > 0)
		While (idx < pModAddComponents.GetSize())
			If (pBaseComponentsList.HasForm(pModAddComponents.GetAt(idx)))
				pBaseComponentsList.RemoveAddedForm(pModAddComponents.GetAt(idx))
			EndIf
			If (pBaseScrapItemsList.HasForm(pModAddScrapItems.GetAt(idx)))
				pBaseScrapItemsList.RemoveAddedForm(pModAddScrapItems.GetAt(idx))
			EndIf
			idx += 1
		EndWhile
		pModAddedGlobal.SetValue(0)
	EndIf
EndFunction


Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
	If (akNewContainer == Game.GetPlayer() as ObjectReference)
		If (nTypeIndex == 0)
			Self.AddModScrap()
		Else
			Self.ResetModScrap()
		EndIf
	EndIf
	akNewContainer.RemoveItem(Self as Form, 1, True, None)
EndEvent
