-- Run Script
-- AppleScript

on getCalendarName(folder_name)
	set default_calendar_button to {"OmniFocus", "自我", "身体", "知识", "学历", "事业", "娱乐", "个人"}
	
	if folder_name is in {"成长", "内在", "心理"} then
		return "自我"
	else if folder_name is in {"技能", "知识"} then
		return "知识"
	else if folder_name is "学历" then
		return "学历"
	else if folder_name is in {"家庭事务", "家庭"} then
		return "家庭"
	else if folder_name is in {"工作", "创造"} then
		return "事业"
	else if folder_name is "身体" then
		return "身体"
	else
		set selected_button to choose from list default_calendar_button ¬
			with prompt "请选择一个日历添加事件：" default items {item 1 of default_calendar_button} ¬
			without multiple selections allowed and empty selection allowed
		
		if selected_button is not false then
			return item 1 of selected_button
		else
			-- User canceled the selection
			return "OmniFocus"
		end if
	end if
end getCalendarName



property argv : 1
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
			set theProject to containing project of the_task
			set folder_name to name of folder of theProject
			set calendar_name to my getCalendarName(folder_name)
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
					log "task_name: " & task_name
					log "start_date: " & start_date
					log "end_date: " & end_date
					log "calendar_name:" & calendar_name
					make new event at end of events of calendar_element with properties {summary:task_name, start date:start_date, end date:end_date}
				end if
			end tell
			
		end repeat
		
	end tell
	
end tell