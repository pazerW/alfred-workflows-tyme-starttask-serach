-- Run Script
-- AppleScript

property calendar_name : "OmniFocus" -- This is the name of your calendar
property default_duration : 30 --minutes
set num to 0
tell application "OmniFocus"
	tell front window
		
		set task_elements to selected trees of content
		
		repeat with item_ref from 1 to count of task_elements
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
			set msg to "Run event: " & task_name & "【" & num & "/" & (count of task_elements) & "】"
			display notification msg with title "Calendar" subtitle "Runing " sound name "Purr"
			tell application "Calendar"
				set calendar_element to calendar calendar_name
				set start_date to task_due
				set end_date to start_date + (default_duration * minutes) -- Calculate end date
				
				set event_list to (every event of calendar_element whose summary is task_name)
				
				if (count of event_list) is not 0 then
					repeat with an_event in event_list
						delete an_event
					end repeat
				end if
				
				if not (exists (first event of calendar_element whose (start date = start_date) and (summary = task_name))) then
					make new event at end of events of calendar_element with properties {summary:task_name, start date:start_date, end date:end_date}
				end if
			end tell
			
		end repeat
		
	end tell
	
end tell