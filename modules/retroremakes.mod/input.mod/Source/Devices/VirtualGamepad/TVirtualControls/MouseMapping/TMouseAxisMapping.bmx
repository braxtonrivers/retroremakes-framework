rem
'
' Copyright (c) 2007-2010 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Rem
	bbdoc: A mouse axis that can be mapped to a #TVirtualControl
End Rem
Type TMouseAxisMapping Extends TVirtualControlMapping

	Field axisId_:Int
	Field axisDirection_:Int
	
	Method Update(message:TMessage)
		Select message.messageID
			Case MSG_MOUSE
				Local data:TMouseMessageData = TMouseMessageData(message.data)
				SetLastDigitalStatus(GetDigitalStatus())
				SetLastAnalogueStatus(GetAnalogueStatus())
				Local analogueAxisValue:Float
				Local digitalAxisValue:Int
					
				Select axisId_
					Case RR_MOUSE_X
						analogueAxisValue = data.mousePosX - data.lastMousePosX
					Case RR_MOUSE_Y
						analogueAxisValue = data.mousePosY - data.lastMousePosY
					Case RR_MOUSE_Z
						analogueAxisValue = data.mousePosZ - data.lastMousePosZ
				End Select
					
				If axisDirection_ = 1
					If analogueAxisValue <= 0.0
						analogueAxisValue = 0.0
						digitalAxisValue = 0
					Else
						digitalAxisValue = 1
					End If
				ElseIf axisDirection_ = -1
					If analogueAxisValue >= 0.0
						analogueAxisValue = 0.0
						digitalAxisValue = 0
					Else
						digitalAxisValue = 1
					End If
				End If
					
				SetAnalogueStatus(Abs(analogueAxisValue))
				SetDigitalStatus(digitalAxisValue)
										
				If digitalAxisValue = 0
					If GetLastDigitalStatus() <> GetDigitalStatus()
						IncrementHits()
					EndIf
				End If
		End Select
	End Method
	
	Method SetAxis(axisId:Int, axisDirection:Int)
		axisId_ = axisId
		axisDirection_ = axisDirection
	End Method
	
	Method GetName:String()
		Local name:String
		Local direction:String
		If axisDirection_ = -1
			direction = "-"
		ElseIf axisDirection_ = 1
			direction = "+"
		End If		
		Select axisId_
			Case RR_MOUSE_X
				name = "Mouse " + direction + "X"
			Case RR_MOUSE_Y
				name = "Mouse " + direction + "Y"
			Case RR_MOUSE_Z
				name = "Mouse " + direction + "Z"
		End Select
		Return name			
	End Method
	
	
	Method Save(control:TVirtualControl)
		Local section:String = "VirtualGamepad" + control.GetGamepad().GetPaddedId()
		Local axisName:String
		Select axisId_
			Case RR_MOUSE_X
				axisName = "x"
			Case RR_MOUSE_Y
				axisName = "y"
			Case RR_MOUSE_Z
				axisName = "z"
		End Select
		rrSetStringVariables(control.GetPaddedControlId(), [control.GetName(),  ..
									"mouse", "axis", axisName,  String(axisDirection_)], section)
	End Method
	
End Type
