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
set reportText to "\\n\\n### 今日完成项目"





tell application "OmniFocus"

	set topLevelTags to tags of default document
	set subTag to ""
	repeat with aTag in topLevelTags
		if name of aTag is "Goal" then
			repeat with childTag in tags of aTag
				if name of childTag is "☀️Now" then
					set subTag to childTag
					exit repeat
				end if
			end repeat
		end if
	end repeat
	tell front document

		set theProjects to every flattened project
		repeat with a from 1 to length of theProjects

			set currentProj to item a of theProjects

			set theTasks to (every flattened task of currentProj where its completed = true and completion date is greater than startDate and completion date is less than endDate)
			
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
					set reportText to reportText & return & "- [x] [" & name of currentTask & "](" & omnifocusURL & ") ✅ " & completedTime
					
					if repetition of currentTask is not missing value then
						-- 输出重复任务的名称和重复规则
						set taskName to name of currentTask
						-- 查找未完成的具有指定名称的任务
						set matchingTasks to (every flattened task of currentProj whose name is taskName and completed is false)
						
						-- 处理匹配的任务
						if (count of matchingTasks) > 0 then
							-- 如果至少找到一个未完成的匹配任务
							set foundTask to item 1 of matchingTasks -- 获取第一个匹配的任务
							set taskTags to name of tags of foundTask
							if "☀️Now" is in taskTags then
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


return reportText