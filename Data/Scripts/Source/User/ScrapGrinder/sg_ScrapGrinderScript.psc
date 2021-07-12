ScriptName ScrapGrinder:sg_ScrapGrinderScript extends WorkbenchScript
{handles the workbench's linked container}


Container Property pContainerForm Auto
{input container}
Keyword Property pContainerLink Auto
{keyword for the container's linked reference}


; deletes the container when the workbench is removed
Event OnWorkshopObjectDestroyed(ObjectReference akReference)
	ObjectReference OutputContainer = Self.GetLinkedRef(pContainerLink)
	If (OutputContainer)
		OutputContainer.Delete()
		Self.SetLinkedRef(None, pContainerLink)
	EndIf
EndEvent

; creates the container
Event OnWorkshopObjectPlaced(ObjectReference akReference)
	ObjectReference OutputContainer = Self.PlaceAtMe(pContainerForm as Form, 1, True, False, True)
	If (OutputContainer)
		OutputContainer.MoveTo(Self as ObjectReference, -16, 0, 64, True)
		Self.SetLinkedRef(OutputContainer, pContainerLink)
	EndIf
EndEvent

; moves the container with the workbench
Event OnWorkshopObjectMoved(ObjectReference akReference)
	ObjectReference OutputContainer = Self.GetLinkedRef(pContainerLink)
	If (OutputContainer)
		OutputContainer.MoveTo(Self as ObjectReference, -16, 0, 64, True)
	EndIf
EndEvent
