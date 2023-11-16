-- Run Script
-- AppleScript

on run argv
	
	set myString to argv as string
	set oldDelimiters to AppleScript's text item delimiters
	set AppleScript's text item delimiters to ","
	set myArray to text items of myString
	set AppleScript's text item delimiters to oldDelimiters
	
	set intervalDays to item 1 of myArray
	set initialDate to item 2 of myArray
	-- 输出第一个元素
	setTaskDueDates(intervalDays, initialDate)
	
	
end run


on setTaskDueDates(intervalDays, initialDate)
	tell application "OmniFocus"
		tell front window
			if class of initialDate is text then
				set initialDate to (current date) + (initialDate * days)
			else
				set initialDate to (current date)
			end if
			
			if intervalDays is missing value then
				set intervalDays to 3 -- 默认的间隔天数
			end if
			
			set selectedTasks to value of (selected trees of content)
			set currentDate to initialDate
			
			repeat with aTask in selectedTasks
				repeat
					if (weekday of currentDate is not Friday) and (weekday of currentDate is not Saturday) and (weekday of currentDate is not Sunday) then
						exit repeat
					else
						set currentDate to currentDate + (1 * days)
					end if
				end repeat
				set due date of aTask to currentDate
				set currentDate to currentDate + (intervalDays * days)
			end repeat
		end tell
	end tell
end setTaskDueDates