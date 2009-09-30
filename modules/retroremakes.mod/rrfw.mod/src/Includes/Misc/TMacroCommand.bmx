Rem
	bbdoc: Class representing #TCommand macros.
End Rem
Type TMacroCommand Extends TCommand Final

	Field commands:TList = New TList
	
	Method Execute:Int()
		For Local command:TCommand = EachIn commands
			command.Execute()
		Next
		Return commands.Count()
	End Method
	
	Method Unexecute:Int()
		Local reversedCommands:TList = commands.Reversed()
		For Local command:TCommand = EachIn reversedCommands
			command.Execute()
		Next
		Return reversedCommands.Count()
	End Method
	
	Method CanBeUndone:Int()
		For Local command:TCommand = EachIn commands
			If Not command.CanBeUndone()
				Return False
			End If
		Next
		Return True
	End Method
	
	Method Merge:Int(command:TCommand)
		Return False
	End Method
	
	Method ToString:String()
		Local asString:String = "Macro Command:~n"
		
		For Local command:TCommand = EachIn commands
			asString:+"+ " + command.ToString() + "~n"
		Next
		Return asString
	End Method
	
	Method MacroCommand(commandList:TList)
		For Local command:TCommand = EachIn commandList
			commands.AddLast(command)
		Next
	End Method
	
	Method AddCommand(command:TCommand)
		commands.AddLast(command)
	End Method
End Type
