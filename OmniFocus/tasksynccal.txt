-- Run Script
-- AppleScript
-- ADD

on getCalendarName(folder_name)
	set default_calendar_button to {"OmniFocus", "??", "??", "??", "??", "??", "??", "??"}
	
	if folder_name is in {"??", "??", "??"} then
		return "??"
	else if folder_name is in {"??", "??"} then
		return "??"
	else if folder_name is "??" then
		return "??"
	else if folder_name is in {"????", "??"} then
		return "??"
	else if folder_name is in {"??", "??", "afraid", "afraid", "OmniFocus", "????"} then
		return "??"
	else if folder_name is "??" then
		return "??"
	else
		set selected_button to choose from list default_calendar_button Â
			with prompt "????????????" default items {item 1 of default_calendar_button} Â
			without multiple selections allowed and empty selection allowed
		
		if selected_button is not false then
			return item 1 of selected_button
		else
			-- User canceled the selection
			return "OmniFocus"
		end if
	end if
end getCalendarName

-- ????
on measureTimeDifference()
	set startTime to do shell script "date +%s"
	return startTime
end measureTimeDifference

-- ????
on logExecutionTime(startTime)
	set endTime to do shell script "date +%s"
	set executionTime to endTime - startTime
	return executionTime
end logExecutionTime

property default_duration : 30 --minutes
set num to 0

tell application "OmniFocus"
	tell front window
		set task_elements to selected trees of content
		repeat with item_ref from 1 to count of task_elements
			-- ??????????????
			set startTime to my measureTimeDifference()
			set num to num + 1
			
			set the_task to value of item item_ref of task_elements
			
			set task_name to name of the_task
			set task_note to note of the_task
			set task_due to due date of the_task
			set task_estimate to estimated minutes of the_task
			set task_url to "omnifocus:///task/" & id of the_task
			if task_estimate is missing value then set task_estimate to default_duration
			set end_date to task_due
			set start_date to task_due - (task_estimate * minutes)
			set theProject to containing project of the_task
			set folder_name to name of folder of theProject
			set calendar_name to my getCalendarName(folder_name)
			-- ??????????????
			tell application "Calendar"
				set calendar_element to calendar calendar_name
				set start_date to task_due
				set end_date to start_date + (default_duration * minutes) -- Calculate end date
				-- Delete existing events with the same summary as the current task
				set shortcutName to "del_ical_task"
				set shortcutInput to task_name
				log shortcutInput
				-- ???????????
				do shell script "open 'shortcuts://run-shortcut?name=" & shortcutName & "&input=" & shortcutInput & "'"
				-- Add a new event for the current task
				make new event at end of events of calendar_element with properties {summary:task_name, start date:start_date, end date:end_date, allday event:true}
			end tell
			-- ??????????????
			set execution_time to "???" & my logExecutionTime(startTime) & "?"
			set msg to "Added:" & task_name
			set title to "?" & num & "/" & (count of task_elements) & "?"
			display notification execution_time with title msg subtitle title sound name "Purr"
		end repeat
	end tell
end tell

display alert "Script Finished" message "All operations completed." buttons {"OK"} default button "OK"