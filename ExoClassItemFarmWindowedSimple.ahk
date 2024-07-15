#SingleInstance force					; Don't allow multiple versions to run

; Creator: SevenOilRigs :3
; Changes and improvements: karx11erx/Razzupaltuff. This version may be a bit overengineered, but that helped me to debug and try out things.
; This version works with 1080 windowed. Despite being the same resolution, some click coordinates need to be adjusted for 1080p fullscreen.
; v1: Redesigned the code, added code for window mode
; v2: Fixed the character often not turning at the start when reloading into the Landing directly from the Landing, more code restructuring, increased wait time before running to chest

; Change the values below to YOUR keybinds
OpenMapKey = M
InteractKey = E
SprintKey = Shift
Ghost = Tab
Orbit = Backspace

; Global data
WinWidth := A_ScreenWidth
WinHeight := A_ScreenHeight
CenterX := % A_ScreenWidth / 2
CenterY := % A_ScreenHeight / 2
PointsPerChest := 25
OverthrowLevelPoints := 1000
ReloadsToReset := % OverthrowLevelPoints / PointsPerChest
LandingButtonX := 775

; Also, the macro requires you to have the following settings:
; 7 sensitivity in game (required, or the character won't turn to where it should - karx11erx)
; FPS can be anything but 30 FPS is the most consistent
; Mouse DPI doesn't seem to play a role

; Instructions:
; Press # when you are in the landing to start the macro
; Press Esc to stop the macro


#::											; Keybind to start macro, which you can change
GetWindowSize(WinWidth, WinHeight, CenterX, CenterY)
Loop {    									; Infinite loop to go to orbit
	Send {%OpenMapKey%}						; Keybind for Map
	Sleep 2000								; Waiting for Map to load 
	SetCursorPos(CenterX, CenterY)			; Move mouse to Launch button
	Sleep 100								; Small pause
	Send {LButton}							; Press left click
	Sleep 2000								; Wait 2 seconds
	SetCursorPos(10, CenterY)				; Make the map scroll left
	Sleep 1500								; Let it scroll for 1.5 secs to put the Landing button in the middle of the screen
	SetCursorPos(LandingButtonX, CenterY)	; roughly Center mouse so map stops moving; this also puts it on the Landing's launch button
	Send {LButton Down}						; Left click
	Sleep 1200								; Wait 1.2 seconds
	Send {LButton Up}						; Let go of left click
	SetCursorPos(1620, 940)					; Move mouse to Launch button
	Sleep 100								; Small pause
	Send {LButton}							; Press left click
	Sleep 30000								; Wait 10 seconds for Landing to load
	reloadLanding := 0
	Loop %ReloadsToReset% {					; Reloading the Landing 40 times
		if (reloadLanding)
		{
			Send {%OpenMapKey%}				; Keybind for Map
			Sleep 2000						; Waiting for Map to load. Depending on your system, this may take longer. If so, increase this number
			SetCursorPos(10, CenterY)		; Make the map scroll left
			Sleep 1500						; Let it scroll for 1.5 secs to put the Landing button in the middle of the screen
			SetCursorPos(LandingButtonX, CenterY)	
			Send {LButton Down}				; Left click
			Sleep 1200						; Wait 1.2 seconds
			Send {LButton Up}				; Let go of left click
			Sleep 10000						; Wait 10 seconds for Landing to load
		}
		else
		{
			reloadLanding := 1
		}
		Sleep 1000
		Send {w Down}						; Hold w
		Send {%SprintKey% Down}				; Activate sprint
		Sleep 100
		TurnCharacter(-5)					; Turn character slightly left
		TurnCharacter(-695)					; Turn character slightly left
		Sleep 7400							; Run towards plant for 7.4 seconds (by waiting 7.4s before releasing sprint and walk forward keys)
		Send {%SprintKey% Up}				; Let go of sprint
		Send {w Up}							; Let go of w
		TurnCharacter(2900)					; Turn character right
		Sleep 24500							; Wait another 24.5 seconds to allow chests to spawn (makes a bit over 33 secs together with the previous walking part. Less may lead running to the chest before it spawns, causing it to not spawn)
		Send {w Down}						; Hold w
		Send {%SprintKey% Down}				; Activate sprint
		Sleep 6400							; Run towards chest for 6.4 seconds
		TurnCharacter(-650)					; While running, turn slightly left towards chest
		Sleep 3100							; run another 3.1 seconds in the new direction
		Send {%SprintKey% Up}				; Let go of sprint
		Send {w Up}							; Let go of w
		TurnCharacter(-1800)				; Face the chest 
		Sleep 100							; Small pause
		Send {%InteractKey% Down}			; Hold interact control down
		Sleep 1200							; Wait for <activationTime> seconds
		Send {%InteractKey% Up}				; Let go of interact control
		Sleep 1000
	}										; End of loop for running to the chest

	; This section sends you to Orbit and relaunches the Pale Heart to reset your Overthrow
	Send {%Ghost%}						; Keybind for Ghost
	Sleep 1000							; Wait 1 second
	Send {%Orbit% Down}					; Keybind for Orbit
	Sleep 4000							; Wait 4 seconds
	Send {%Orbit% Up}					; Let go of Orbit
	Sleep 10000							; Wait 10 seconds
}


GetWindowSize(ByRef width, ByRef height, ByRef CenterX, ByRef CenterY)
{
	Global WidthScale, HeightScale
	hwnd := WinExist("Destiny 2")
	if (hwnd != 0)
	{
		VarSetCapacity(rc, 16)
		DllCall("GetClientRect", "uint", hwnd, "uint", &rc)
		width := NumGet(rc, 8, "int")
		height := NumGet(rc, 12, "int")
	}
	else
	{
		width := A_ScreenWidth
		height := A_ScreenHeight
	}
	CenterX := % width / 2
	CenterY := % height / 2
}


SetCursorPos(xPos, yPos, delay = 0)
{
	Global WinWidth, WinHeight
	x := % xPos * WinWidth / 1920
	y := % yPos * WinHeight / 1080
	;ToolTip % Format("Maus X/Y: {:i}/{:i} -> {:i}/{:i}", xPos, yPos, x, y)
	MouseMove, %x%, %y%
	if (delay > 0)
	{
		Sleep delay
	}
}


TurnCharacter(x, y = 0)
{
    DllCall("mouse_event", "UInt", 0x01, "Int", x, "Int", y, "UInt", 0, "UInt", 0)
}

Esc::									; Pressing escape to exit macro
	Reload
return
