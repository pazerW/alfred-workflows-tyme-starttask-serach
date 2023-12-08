-- Run Script
-- AppleScript


-- Create the new filename as YYYYMMDD.txt
set todayDate to current date

-- Set the starting date of the report
set startDate to todayDate - 0 * days
set startDate's hours to 0
set startDate's minutes to 0
set startDate's seconds to 0

-- Set the ending date of the report
set endDate to todayDate - 0 * days
set endDate's hours to 23
set endDate's minutes to 59
set endDate's seconds to 59
set totalText to ""
set reportText to "\\n\\n### ????"
set drop_text to "\\n\\n### ????"


tell application "OmniFocus"

	set topLevelTags to tags of default document
	set subTag to ""
	repeat with aTag in topLevelTags
		if name of aTag is "Goal" then
			repeat with childTag in tags of aTag
				if name of childTag is "??Now" then
					set subTag to childTag
					exit repeat
				end if
			end repeat
		end if
	end repeat
	tell front document

		set theProjects to every flattened project
		repeat with a from 1 to length of theProjects
            set drop_bool to false
			set currentProj to item a of theProjects

			set theTasks to (every flattened task of currentProj where its completed = true and completion date is greater than startDate and completion date is less than endDate)
            set dropTasks to (every flattened task of currentProj where its dropped = true and dropped date is greater than startDate and dropped date is less than endDate)
            if dropTasks is not equal to {} then

				set drop_text to drop_text & return & return & "##### " & name of currentProj & return

                repeat with b from 1 to length of dropTasks
                    -- Get the current task to work with
                    set currentTask to item b of dropTasks
                    -- Save the completed date to a variable
                    set completedDate to dropped date of currentTask
                    -- Get the time of the completed date
                    set taskID to id of currentTask
                    set omnifocusURL to "omnifocus:///task/" & taskID
                    -- Add the task to the report text with the completed time
					set time_str to time string of completedDate

                    set drop_text to drop_text & return & "- [ ] [" & name of currentTask & "](" & omnifocusURL & ") â ?" & time_str
                    set drop_bool to true
                end repeat
            end if
            if drop_bool then
                set totalText to totalText & drop_text & return
                set drop_text to ""
            end if  
			if theTasks is not equal to {} then
				
				set reportText to reportText & return & return & "#### " & name of currentProj & return

				repeat with b from 1 to length of theTasks
					-- Get the current task to work with
					set currentTask to item b of theTasks
					-- Save the completed date to a variable
					set completedDate to completion date of currentTask
					-- Get the time of the completed date
					set taskID to id of currentTask
					set omnifocusURL to "omnifocus:///task/" & taskID
					set completedTime to time string of completedDate
					-- Add the task to the report text with thecompleted time
					set time_str to time string of completedDate
					set reportText to reportText & return & "- [x] [" & name of currentTask & "](" & omnifocusURL & ")  ?" & time_str
					
					if repetition of currentTask is not missing value then
						set taskName to name of currentTask
						set matchingTasks to (every flattened task of currentProj whose name is taskName and completed is false)
						
						if (count of matchingTasks) > 0 then
							set foundTask to item 1 of matchingTasks 
							set taskTags to name of tags of foundTask
							if "??Now" is in taskTags then
								remove subTag from tags of foundTask
							end if
						end if
					end if
					
				end repeat
			end if
		end repeat
	end tell -- end tell front document
end tell -- end tell application "OmniFocus"
property subTag : missing value
set totalText to totalText &reportText & return

return totalText