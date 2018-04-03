property clickCommandPath : ""
property clickCommandPosix : ""
on run argv
	tell application "System Events" to tell (first process whose frontmost is true)
		delay 0.05
		if front window exists then
			tell front window
				if value of attribute "AXFullScreen" then
					set value of attribute "AXFullScreen" to false
					delay 1
				end if
			end tell
		end if
	end tell
	tell application "Mountain Duck"
		activate
		set clickCommandPath to ((path to me as text) & "::")
		set clickCommandPosix to ((POSIX path of clickCommandPath) & "cliclick")
		tell application "System Events" to tell process "Mountain Duck"
			delay 0.1
			set {xCoord, yCoord} to position of menu bar 1
			my clickObjectByCoords(menu bar 1, item 1 of argv)
			pick menu item (item 1 of argv) of menu 1 of menu bar item 1 of menu bar 1
			if not enabled of menu item "Connect" of menu 1 of menu item (item 1 of argv) of menu 1 of menu bar item 1 of menu bar 1 then
				click menu item "Disconnect" of menu 1 of menu item (item 1 of argv) of menu 1 of menu bar item 1 of menu bar 1
			else
				click menu item "Connect" of menu 1 of menu item (item 1 of argv) of menu 1 of menu bar item 1 of menu bar 1
			end if
		end tell
	end tell
end run

on clickObjectByCoords(someObject, xText)
	tell application "System Events" to tell process "Finder"
		set {xMenuSize, yMenuSize} to size of menu bar 1
	end tell
	using terms from application "System Events"
		set {xCoord, yCoord} to position of someObject
		if (xCoord < 0) then
			--set xCoord to (xMenuSize + xCoord)
		end if
		set {xSize, ySize} to size of someObject
	end using terms from
	set xClick to round (xCoord + xSize / 2) rounding down -- middle
	set yClick to round (yCoord + ySize / 2) rounding down -- middle
	clickAtCoords(xClick, yClick, xText)
end clickObjectByCoords

on clickAtCoords(xClick, yClick, xText)
	set xClick to round xClick rounding down
	set yClick to round yClick rounding down
	set reply to do shell script quoted form of clickCommandPosix & " -r c:=" & xClick & ",=" & yClick
	return ((xClick as string) & "," & yClick)
end clickAtCoords