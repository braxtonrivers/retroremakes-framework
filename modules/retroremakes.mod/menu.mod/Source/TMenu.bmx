Rem
'
' Copyright (c) 2007-2010 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
EndRem

Type TMenu

	Field _label:String					' title shown when menu is rendered
	Field _itemsList:TList				' items in this menu
	Field _currentItem:TMenuItem		' current active item
	
	Field _labelColor:TColourRGB
	Field _itemcolor:TColourRGB
	Field _selectionColor:TColourRGB	' change to oscilator?
	Field _footerColor:TColourRGB
	
	Field _animateItem:Int

	Method ToString:String()
		Return _label
	End Method
	
	Method New()
		_itemsList = New TList
		_labelColor = New TColourRGB
		_itemcolor = New TColourRGB
		_selectionColor = New TColourRGB			' change to oscilator later on?
		_footercolor = New TColourRGB
		_animateItem = True
		
		SetLabelColor(0, 255, 0)
		SetItemColor(255, 255, 255)
		SetSelectionColor(0, 255, 255)
		SetFooterColor(100, 100, 100)
	End Method
	
	Function Create:TMenu(label:String)
		Local menu:Tmenu = New Tmenu
		menu._label = label
		Return menu
	End Function
	
	Method Update()
		_currentItem.Update()
		
		If _animateItem
			_selectionColor.a:-0.01
			If _selectionColor.a < 0.3 Then _selectionColor.a = 1.0
		End If
	End Method
	
	Method Render(ypos:Int)
		
		'determine size of vertical alignment	
		Local height:Int = TextHeight("A")
		SetTransform 0, 1, 1
		SetBlend ALPHABLEND
		
		_labelColor.Set()
		_DrawMenuText(_label, ypos)
		ypos:+height + 20

		For Local i:TMenuItem = EachIn _itemsList
			If i = _currentItem
			
				If _animateItem
					SetScale 1.15, 1.25
					SetColor 100, 100, 100
					_DrawMenuText(i.ToString(), ypos)
				
					_selectionColor.Set()
					SetBlend LIGHTBLEND
					_DrawMenuText(i.ToString(), ypos)
				Else
					_selectionColor.Set()
					SetAlpha 1
					_DrawMenuText(i.ToString(), ypos)
				EndIf

				SetAlpha 1.0
				SetBlend ALPHABLEND
				SetScale 1, 1
				_footerColor.set()
				_DrawMenuText(i.GetFooter(), rrGetGraphicsHeight() - height)
			Else
				SetScale 1, 1
				_itemcolor.Set()
				_DrawMenuText(i.ToString(), ypos)
			EndIf
			ypos:+height
		Next
		SetScale 1, 1
	End Method

	Method AddItem(item:TMenuItem)
		_itemsList.AddLast(item)
		FirstItem()
	End Method
	
	Method FirstItem()
		_currentItem = TMenuItem(_itemsList.First())
	End Method

	Method LastItem()
		_currentItem = TMenuItem(_itemsList.Last())
	End Method

	Method NextItem()
		Local thisLink:TLink = _itemsList.FindLink(_currentItem)
		Local newLink:TLink = thisLink.NextLink()
		If newLink = Null Then FirstItem() ; Return
		_currentItem = TMenuItem(newLink.Value())
	End Method

	Method PreviousItem()
		Local thisLink:TLink = _itemsList.FindLink(_currentItem)
		Local newLink:TLink = thisLink.PrevLink()
		If newLink= Null Then LastItem() ; Return
		_currentItem = TMenuItem(newLink.Value())
	End Method
	
	Method GetCurrentItem:TMenuItem()						'todo: anders
		Return _currentItem
	End Method
	
	Method GetItems:TList()
		Return _itemsList
	End Method
	
	Method PreviousOption()
		If TOptionMenuItem(_currentItem) Then TOptionMenuItem(_currentItem).PreviousOption()
	End Method
	
	Method NextOption()
		If TOptionMenuItem(_currentItem) Then TOptionMenuItem(_currentItem).NextOption()
	End Method

	Method SetLabelColor(r:Int, g:Int, b:Int)
		_labelColor.r = r
		_labelColor.g = g
		_labelColor.b = b
		_labelColor.a = 1.0
	End Method
	
	Method SetItemColor(r:Int, g:Int, b:Int)
		_itemColor.r = r
		_itemColor.g = g
		_itemColor.b = b
		_itemColor.a = 1.0
	End Method

	Method SetSelectionColor(r:Int, g:Int, b:Int)
		_selectionColor.r = r
		_selectionColor.g = g
		_selectionColor.b = b
		_selectionColor.a = 1.0
	End Method	

	Method SetFooterColor(r:Int, g:Int, b:Int)
		_footerColor.r = r
		_footerColor.g = g
		_footerColor.b = b
		_footerColor.a = 1.0
	End Method
	
	Method SetActiveItemAnimation(bool:Int)
		_animateItem = bool
	End Method
	
	Method SetLabel(l:String)
		_label = l
	End Method
		
	Method _DrawMenuText(text:String, ypos:Int)
		Local xscale:Float, yscale:Float
		Local xpos:Int
		GetScale(xscale, yscale)
		xpos = rrGetGraphicsWidth() / 2 - TextWidth(text) * xscale / 2
		DrawText(text, xpos, ypos - (TextHeight(text) * yscale / 2))
	End Method
	
End Type
