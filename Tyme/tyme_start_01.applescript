
-- ????
try
	set argu to "{query}" as string
on error ErrorMsg
	log "Error:" & ErrorMsg
	return
end try


set historicalCount to (system attribute "HISTORICAL_COUNT")
-- ??????
set currentDate to current date
set dayString to text -2 thru -1 of ("0" & (day of currentDate as text))
set yearString to year of currentDate as text
set formattedDate to yearString & dayString

-- ????????
set tempDirectory to path to temporary items
-- ????????????????
set filePath to (tempDirectory as text) & formattedDate & "_array_data.txt"

-- ?? Tyme ?????????
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


-- ?????????
on storeTaskDetailsToFile(taskDetails, filePath)
	set fileRef to open for access file filePath with write permission
	set textToWrite to ""
	repeat with task in taskDetails
		set textToWrite to textToWrite & "" & (name of task) & "," & (id of task) & linefeed
	end repeat
	
	write textToWrite to fileRef
	close access fileRef
end storeTaskDetailsToFile

-- ??????????????????????
on searchArrayForString(searchString, arrayToSearch)
	set foundArray to {}
	
	repeat with itemInArray in arrayToSearch
		if itemInArray contains searchString then
			set end of foundArray to itemInArray
		end if
	end repeat
	return foundArray
end searchArrayForString

-- ??????????????????????
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

-- ??????
on getHistoricalTaskNamesArr()
    set documentsFolder to path to documents folder
    set documentsFolderPath to POSIX path of documentsFolder
    -- ??????????? "YYYYMMDD" ??
    set currentDate to current date
    set year_ to year of currentDate as text
    set month_ to text -2 thru -1 of ("0" & (month of currentDate as integer))
    set day_ to text -2 thru -1 of ("0" & (day of currentDate as integer))
    set formattedDate to year_ & month_ & day_
    -- ????
	log 0

    set filePath to documentsFolderPath & "alfred/" & formattedDate & "_reach.txt"
	-- ?????????
	set fileDescriptor to open for access filePath
	-- ???????
	try
		set fileContent to read fileDescriptor
	on error
		close access fileDescriptor
		return {}
	end try

	-- ????
	if fileDescriptor is not equal to "" then
			set taskDetailsArr to {}
			set taskDetailsLines to paragraphs of fileContent
			set counter to 0
		    set actualCount to count of taskDetailsLines
			set historicalCount to my historicalCount 
			if actualCount < historicalCount then
				set historicalCount to actualCount
			end if
			repeat with aLine in taskDetailsLines
				if counter is equal to my historicalCount then
					exit repeat
				end if
				set {taskName, taskID} to my extractDetails(aLine)
				if taskName is not missing value and taskID is not missing value then
					set end of taskDetailsArr to {name:taskName, id:taskID}
				end if
				-- ???????
				set counter to counter + 1				
			end repeat
			return taskDetailsArr
    else
        error "The file is empty"
    end if
    close access fileDescriptor
end getHistoricalTaskNamesArr

-- ????????
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
		error "Error accessing the file or file not found?" & ErrorMsg
	end try
end retrieveTaskDetailsFromFile

-- ??????????? ID
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

-- ????????????????????????
set loadedArray to {}
try
	set loadedArray to retrieveTaskDetailsFromFile(filePath)
on error ErrorMsg
	set loadedArray to getTaskNamesArr()
	storeTaskDetailsToFile(loadedArray, filePath)
end try


-- ???????????
set searchString to argu as string
-- set searchString to argu as string

set newArrayFromSearch to searchArrayForName(searchString, loadedArray)

-- ?? newArrayFromSearch ????? loadedArray ??????????? newArrayFromSearch
if count of newArrayFromSearch is equal to 0 then
	 -- ????
    set historicalTaskNamesArr to getHistoricalTaskNamesArr()
    -- ??????
    set newArrayFromSearch to historicalTaskNamesArr
end if


-- ?? newArrayFromSearch ???????????????
if count of newArrayFromSearch is equal to 0 then
	-- ??????
	set systemLanguage to do shell script "defaults read NSGlobalDomain AppleLanguages | tr -d '[:space:]' | cut -d'\"' -f2"
	-- ????????????
	if systemLanguage contains "zh-Hans" then
		set end of newArrayFromSearch to {name:"???????", id:""}
	else
		set end of newArrayFromSearch to {name:"Task not found", id:""}
	end if
end if

-- ????????????? JSON ??
set jsonResult to ""
repeat with itemInArray in newArrayFromSearch
	try
		set itemName to name of itemInArray
		set itemId to id of itemInArray
		set jsonString to "{\"title\": \"" & itemName & "\", \"subtitle\": \"\", \"arg\": \"" & itemId & "\", \"valid\": \"true\", \"icon\": {\"path\": \"\"}},"
		set jsonResult to jsonResult & jsonString
	on error ErrorMsg
		log ErrorMsg
	end try
end repeat

-- ????????
if length of jsonResult > 0 then
	set jsonResult to text 1 thru -2 of jsonResult
end if

-- ?? { "items": ? JSON ??????
set finalJson to "{ \"items\": [" & jsonResult & "] }"

-- ????
return finalJson
