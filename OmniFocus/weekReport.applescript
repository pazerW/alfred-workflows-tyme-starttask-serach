-- Set the current date
set todayDate to current date

-- Find the number of days between the current day and Sunday (beginning of the week)
set daysToSunday to (weekday of todayDate) - 1
if daysToSunday < 0 then set daysToSunday to 6 -- Sunday is 0, so adjust for negative values

-- Set startDate to Sunday
set startDate to todayDate - daysToSunday * days
set startDate's hours to 0
set startDate's minutes to 0
set startDate's seconds to 0

set reportText to "\\n\\n***\\n\\n### ??????"


on getformatDate(theDate)
    -- Convert weekday to Chinese
    set year_str to year of theDate as string
    set month_str to (month of theDate) as string
    set day_str to day of theDate as string
    set weekday_str to weekday of theDate as string
	
    if weekday_str is "Monday" then
        set weekday_str to "??"
    else if weekday_str is "Tuesday" then
        set weekday_str to "??"
    else if weekday_str is "Wednesday" then
        set weekday_str to "??"
    else if weekday_str is "Thursday" then
        set weekday_str to "??"
    else if weekday_str is "Friday" then
        set weekday_str to "??"
    else if weekday_str is "Saturday" then
        set weekday_str to "??"
    else if weekday_str is "Sunday" then
        set weekday_str to "??"
    end if
	if month_str is "January" then
		set month_str to "1"
	else if month_str is "February" then
		set month_str to "2"
	else if month_str is "March" then
		set month_str to "3"
	else if month_str is "April" then
		set month_str to "4"
	else if month_str is "May" then
		set month_str to "5"
	else if month_str is "June" then
		set month_str to "6"
	else if month_str is "July" then
		set month_str to "7"
	else if month_str is "August" then
		set month_str to "8"
	else if month_str is "September" then
		set month_str to "9"
	else if month_str is "October" then
		set month_str to "10"
	else if month_str is "November" then
		set month_str to "11"
	else if month_str is "December" then
		set month_str to "12"
	end if
	return year_str & "-" & month_str & "-" & day_str 
end getYearMother

on formatDate(theDate)
    -- Format the date
    set year_str to year of theDate as string
    set month_str to text item 1 of ((month of theDate) as string)
    set day_str to day of theDate as string
    set weekday_str to weekday of theDate as string
    set time_str to time string of theDate

    -- Combine the date and time
    return getformatDate(theDate) & " " & time_str
end formatDate


tell application "OmniFocus"
	tell front document
		set theProjects to every flattened project
		repeat with a from 1 to length of theProjects
			set textTemp to ""
            set drop_text to ""

			set task_bool to false
			set drop_bool to false
			
			set currentProj to item a of theProjects
			set textTemp to return & "***\\n#### " & name of currentProj
			-- Loop through each day of the week
			repeat with i from 0 to 6
				-- Set the start and end of the day
				set drop_task_bool to false
				
				set dayStart to startDate + i * days
				set dayEnd to dayStart + 1 * days
				
				set theTasks to (every flattened task of currentProj where its completed = true and completion date is greater than dayStart and completion date is less than dayEnd)
				set dropTasks to (every flattened task of currentProj where its dropped = true and dropped date is greater than dayStart and dropped date is less than dayEnd)
				-- set dropTasks to 
				if theTasks is not equal to {} then
					set textTemp to textTemp & return & return & "##### " & my getformatDate( dayStart )  & return
					
					repeat with b from 1 to length of theTasks
						-- Get the current task to work with
						set currentTask to item b of theTasks
						-- Save the completed date to a variable
						set completedDate to completion date of currentTask
						-- Get the time of the completed date
						set taskID to id of currentTask
						set omnifocusURL to "omnifocus:///task/" & taskID
						-- Add the task to the report text with the completed time
						set time_str to time string of completedDate
						set textTemp to textTemp & return & "- [x] [" & name of currentTask & "](" & omnifocusURL & ") â? " & time_str
						set task_bool to true
					end repeat
				end if
				
				if dropTasks is not equal to {} then
					set drop_text to drop_text & return & return & "###### ????" & return

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
						set drop_text to drop_text & return & "- [ ] [" & name of currentTask & "](" & omnifocusURL & ") â? " & time_str
						set drop_bool to true
					end repeat
				end if
			end repeat

            if drop_bool then
				set reportText to reportText & drop_text & return
			end if
			if task_bool then
				set reportText to reportText & textTemp & return
			end if            
		end repeat
	end tell -- end tell front document
end tell -- end tell application "OmniFocus"


return reportText