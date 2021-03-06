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

Type TColourOscillator

	Global instance:TColourOscillator		' This holds the singleton instance of this Type
	
	Method New()
		If instance Throw "Cannot create multiple instances of this Singleton Type"
		instance = Self
	EndMethod

	Function Create:TColourOscillator()
		Return TColourOscillator.GetInstance()
	End Function
	
	Function GetInstance:TColourOscillator()
		If Not instance
			Return New TColourOscillator
		Else
			Return instance
		EndIf
	EndFunction
	
	Method SetColours(cg:TColourGen, offset:Float = 0.0)
		GenColours(cg, offset).Set()
	End Method
	
	Method SetColoursWithoutAlpha(cg:TColourGen, offset:Float = 0.0)
		GenColours(cg, offset).SetWithoutAlpha()
	End Method
	
	Method GenColours:TColourRGB(cg:TColourGen, offset:Float = 0.0)
		Local colour:TColourRGB = New TColourRGB
		Local frameCount:Float = TGameEngine.GetInstance().GetUpdateFrameCount()
		
		colour.r = (cg.r_hi - cg.r_lo) Shr 1
		colour.g = (cg.g_hi - cg.g_lo) Shr 1
		colour.b = (cg.b_hi - cg.b_lo) Shr 1
		colour.a = (cg.a_hi - cg.a_lo) Shr 1
	
		If offset <> 0.0
			colour.r = Int(colour.r * (Sin((frameCount - offset) * cg.r) + 1))
			colour.g = Int(colour.g * (Sin((frameCount - offset) * cg.g) + 1))
			colour.b = Int(colour.b * (Sin((frameCount - offset) * cg.b) + 1))
			colour.a = Int(colour.a * (Sin((frameCount - offset) * cg.a) + 1))
		Else
			colour.r = Int(colour.r * (Sin(frameCount * cg.r) + 1))
			colour.g = Int(colour.g * (Sin(frameCount * cg.g) + 1))
			colour.b = Int(colour.b * (Sin(frameCount * cg.b) + 1))
			colour.a = Int(colour.a * (Sin(frameCount * cg.a) + 1))
		EndIf
		
		colour.r = (Int(colour.r) + cg.r_lo) & $ff
		colour.g = (Int(colour.g) + cg.g_lo) & $ff
		colour.b = (Int(colour.b) + cg.b_lo) & $ff
		colour.a = Float((Int(colour.a) + cg.a_lo) & $ff) / 255.0
			
		Return colour
	End Method	
	
EndType
