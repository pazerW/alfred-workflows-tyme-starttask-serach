
-- 外部参数
try
	set argu to "{query}" as string
on error ErrorMsg
	log "Error:" & ErrorMsg
	return
end try

-- 获取当前日期
set currentDate to current date
set dayString to text -2 thru -1 of ("0" & (day of currentDate as text))
set yearString to year of currentDate as text
set formattedDate to yearString & dayString

-- 获取临时目录路径
set tempDirectory to path to temporary items

-- 构建文件路径，以当前日期命名文件
set filePath to (tempDirectory as text) & formattedDate & "_array_data.txt"

-- 获取 Tyme 中所有未完成的任务
on getTaskNamesArr()
	set taskDetailsArr to {}
	tell application "Tyme"
		set allProjects to every project
		repeat with aProject in allProjects
			if not (completed of aProject) then
				set projectName to name of aProject
				set projectTasks to tasks of aProject
				repeat with aTask in projectTasks
					if not (completed of aTask) then
						set taskName to name of aTask
						set taskID to id of aTask -- Fetching Tyme task ID
						set taskDetails to {name:taskName, id:taskID}
						set end of taskDetailsArr to taskDetails
					end if
				end repeat
			end if
		end repeat
	end tell
	return taskDetailsArr
end getTaskNamesArr


-- 将任务数组写入文件
on storeTaskDetailsToFile(taskDetails, filePath)
	set fileRef to open for access file filePath with write permission
	set textToWrite to ""
	repeat with task in taskDetails
		set textToWrite to textToWrite & "" & (name of task) & "," & (id of task) & linefeed
	end repeat
	
	write textToWrite to fileRef
	close access fileRef
end storeTaskDetailsToFile

-- 在数组中搜索特定内容并返回包含搜索内容的数组
on searchArrayForString(searchString, arrayToSearch)
	set foundArray to {}
	
	repeat with itemInArray in arrayToSearch
		if itemInArray contains searchString then
			set end of foundArray to itemInArray
		end if
	end repeat
	return foundArray
end searchArrayForString

-- 在数组中搜索特定名称并返回包含搜索内容的数组
on searchArrayForName(searchString, arrayToSearch)
	set foundArray to {}
	repeat with itemInArray in arrayToSearch
		set itemName to name of itemInArray
		if itemName contains searchString then
			set end of foundArray to itemInArray
		end if
	end repeat
	return foundArray
end searchArrayForName

-- 从文件中读取数组
on retrieveTaskDetailsFromFile(filePath)
	try
		set fileRef to (open for access file filePath)
		set fileContents to ""
		try
			set fileContents to (read fileRef)
		end try
		close access fileRef
		if fileContents is not equal to "" then
			set taskDetailsArr to {}
			set taskDetailsLines to paragraphs of fileContents
			repeat with aLine in taskDetailsLines
				set {taskName, taskID} to my extractDetails(aLine)
				if taskName is not missing value and taskID is not missing value then
					set end of taskDetailsArr to {name:taskName, id:taskID}
				end if
			end repeat
			return taskDetailsArr
		else
			error "The file is empty"
		end if
	on error ErrorMsg
		error "Error accessing the file or file not found：" & ErrorMsg
	end try
end retrieveTaskDetailsFromFile

-- 从文件中提取任务名称和 ID
on extractDetails(aLine)
	try
		set AppleScript's text item delimiters to {","}
		set {taskName, taskID} to text items of aLine
		set AppleScript's text item delimiters to {}
		if (count of {taskName, taskID}) = 2 then
			return {taskName, taskID}
		else
			return {missing value, missing value}
		end if
	on error ErrorMsg
		return {missing value, missing value}
	end try
end extractDetails

-- 从文件中读取数组，如果文件不存在，则写入示例数组
set loadedArray to {}
try
	set loadedArray to retrieveTaskDetailsFromFile(filePath)
on error ErrorMsg
	set loadedArray to getTaskNamesArr()
	storeTaskDetailsToFile(loadedArray, filePath)
end try


-- 搜索包含特定内容的数组
set searchString to argu as string
-- set searchString to argu as string

set newArrayFromSearch to searchArrayForName(searchString, loadedArray)


-- 未找到对应数据
set systemLanguage to do shell script "defaults read NSGlobalDomain AppleLanguages | tr -d '[:space:]' | cut -d'\"' -f2"
-- 设置不同语言下的输出文本
if systemLanguage contains "zh-Hans" then
	set end of newArrayFromSearch to {name:"未找到对应任务", id:""}
else
	set end of newArrayFromSearch to {name:"Task not found", id:""}
end if


-- 将搜索结果数组转换为指定的 JSON 格式
set jsonResult to ""
repeat with itemInArray in newArrayFromSearch
	try
		set itemName to name of itemInArray
		set itemId to id of itemInArray
		set jsonString to "{\"title\": \"" & itemName & "\", \"subtitle\": \"\", \"arg\": \"" & itemId & "\", \"valid\": \"true\", \"icon\": {\"path\": \"\"}},"
		set jsonResult to jsonResult & jsonString
	on error errormsg
		log errormsg
	end try
end repeat

-- 移除最后一个逗号
if length of jsonResult > 0 then
	set jsonResult to text 1 thru -2 of jsonResult
end if

-- 添加 { "items": 到 JSON 输出的第一行
set finalJson to "{ \"items\": [" & jsonResult & "] }"

-- 显示结果
return finalJson
