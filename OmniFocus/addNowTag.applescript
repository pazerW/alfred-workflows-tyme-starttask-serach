-- Run Script
-- AppleScript


property subTag : missing value

tell application "OmniFocus"
	set topLevelTags to tags of default document
	repeat with aTag in topLevelTags
		if name of aTag is "Goal" then
			repeat with childTag in tags of aTag
				if name of childTag is "Now" then
					set subTag to childTag
					exit repeat
				end if
			end repeat
		end if
	end repeat
	tell front window
		
		set selectedTasks to value of (selected trees of content)
		repeat with aTask in selectedTasks
			set taskTags to name of tags of aTask
			
			if "Now" is in taskTags then
				
				remove subTag from tags of aTask
			else
				add subTag to tags of aTask
				set today to current date
				set today's hours to 0
				set today's minutes to 30
				set today's seconds to 0
				
				set due date of aTask to today
			end if
		end repeat
		
	end tell
end tell