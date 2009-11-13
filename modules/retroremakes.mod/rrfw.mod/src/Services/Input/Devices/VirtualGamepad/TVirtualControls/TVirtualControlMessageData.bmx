rem
'
' Copyright (c) 2007-2009 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Rem
	bbdoc: Message data showing the current state of a virtual control
End Rem
Type TVirtualControlMessageData Extends TMessageData

	field gamepadId:int
	
	field controlName:string
	
	field analogueStatus:Float
	field digitalStatus:int
	field hits:int
End Type
