set week_ to "1"
set year_str to "2"

set myDelimiter to ","
set textToSplitAndJoin to {query} as string
-- set textToSplitAndJoin to 49 as string


set text item delimiters of AppleScript to myDelimiter
set myList to text items of textToSplitAndJoin

repeat with i from 1 to count of myList
	if i is equal to 1 then
		set week_ to item i of myList
	else if i is equal to 2 then
		set year_str to item i of myList
	end if
end repeat

-- Date

set currentWeek to (do shell script "date +\"%U\"") as number

try
	set week_num to week_ as number
on error errorMessage
	set week_num to currentWeek
end try
set year_num to year_str as number
if week_num < 0 then
	set week_num to currentWeek + week_num
end if
if week_num < 1 or week_num > 52 then
	set week_num to currentWeek
end if




set currentYear to year of (current date)
if year_num < currentYear - 2 or year_num > currentYear + 2 then
	set year_num to currentYear
end if


-- Set startDate to Sunday
set startDate to getSundayOfWeek(week_num, year_num)
set startDate's hours to 0
set startDate's minutes to 0
set startDate's seconds to 0

on getSundayOfWeek(week, year)
	set d to current date
	if year is missing value then
		set year to year of d
	end if
	set d's year to year
	set d's month to January
	set d's day to 1
	set dayOfWeek to weekday of d
	if dayOfWeek is not Sunday then
		set d to d - (((day of week of d) - 1) * days)
	end if
	set d to d + ((week - 1) * 7 * days)
	return d
end getSundayOfWeek




set reportText to week_num & ",\n\n***\n\n### Weekly Review"


on getformatDate(theDate)
	-- Convert weekday to Chinese
	set year_str to year of theDate as string
	set month_str to (month of theDate) as string
	set day_str to day of theDate as string
	set weekday_str to weekday of theDate as string
	
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
end getformatDate

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
			set textTemp to return & "***\n#### " & name of currentProj & return
			-- Loop through each day of the week
			repeat with i from 0 to 6
				-- Set the start and end of the day
				set drop_task_bool to false
				
				set dayStart to startDate + i * days
				set dayEnd to dayStart + 1 * days
				
				-- set theTasks to (every flattened task of currentProj where its completed = true and completion date is greater than dayStart and completion date is less than dayEnd)
				-- set dropTasks to (every flattened task of currentProj where its dropped = true and dropped date is greater than dayStart and dropped date is less than dayEnd)
				-- set dropTasks to 
				set theTasks to (every flattened task of currentProj where (its completed = true and completion date is greater than dayStart and completion date is less than dayEnd) or (its dropped = true and dropped date is greater than dayStart and dropped date is less than dayEnd))
				if theTasks is not equal to {} then
					set textTemp to textTemp & return & "##### " & my getformatDate(dayStart) & return
					
					repeat with b from 1 to length of theTasks
						-- Get the current task to work with
						set currentTask to item b of theTasks
						-- Save the completed date to a variable
						
						-- Get the time of the completed date
						set taskID to id of currentTask
						set omnifocusURL to "omnifocus:///task/" & taskID
						if completed of currentTask then
							-- currentTask ?????
							set completedDate to completion date of currentTask
							set time_str to time string of completedDate
							set textTemp to textTemp  & "- [x] [" & name of currentTask & "](" & omnifocusURL & ")  ?" & time_str & return
							set task_bool to true
						else if dropped of currentTask then
							-- currentTask ?????
							set completedDate to dropped date of currentTask
							set time_str to time string of completedDate
							set textTemp to textTemp  & "- [ ] [" & name of currentTask & "](" & omnifocusURL & ")  ?" & time_str & return
							set task_bool to true
						else
							-- currentTask ???????????????
							display dialog "The task is neither completed nor dropped."
						end if

					end repeat
				end if
				
				-- if dropTasks is not equal to {} then
				-- 	set drop_text to drop_text  & return & "##### ??" & return
					
				-- 	repeat with b from 1 to length of dropTasks
				-- 		-- Get the current task to work with
				-- 		set currentTask to item b of dropTasks
				-- 		-- Save the completed date to a variable
				-- 		set completedDate to dropped date of currentTask
				-- 		-- Get the time of the completed date
				-- 		set taskID to id of currentTask
				-- 		set omnifocusURL to "omnifocus:///task/" & taskID
				-- 		-- Add the task to the report text with the completed time
				-- 		set time_str to time string of completedDate
				-- 		set drop_text to drop_text & "- [ ] [" & name of currentTask & "](" & omnifocusURL & ") ?" & time_str & return
				-- 		set drop_bool to true
				-- 	end repeat
				-- end if
			end repeat
			
			-- if drop_bool then
			-- 	set reportText to reportText & drop_text & return
			-- end if
			if task_bool then
				set reportText to reportText & textTemp & return
			end if
		end repeat
	end tell -- end tell front document
end tell -- end tell application "OmniFocus"


return reportText