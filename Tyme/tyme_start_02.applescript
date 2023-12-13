on run argv
	set documentsFolder to path to documents folder
	set documentsFolderPath to POSIX path of documentsFolder
	if argv is {} then
		set argv to "2CB98742-FAA5-40A8-9F2A-F20194D524CF-12005-000006E43DED0631"
	end if
	set currentDate to current date
	set year_ to year of currentDate as text
	set month_ to text -2 thru -1 of ("0" & (month of currentDate as integer))
	set day_ to text -2 thru -1 of ("0" & (day of currentDate as integer))
	set formattedDate to year_ & month_ & day_
	log formattedDate
	set filePath to documentsFolderPath & "alfred/" & formattedDate & "_reach.txt"
	
	set fileContent to tyme(argv) & "," & argv
	
	try
		set fileDescriptor to open for access filePath with write permission
	on error
		close access filePath
		set fileDescriptor to open for access filePath with write permission
	end try
	try
		set currentContent to read fileDescriptor
	on error
		set currentContent to ""
	end try 
	set fileContent to repContext(filePath, fileContent)
	write fileContent to fileDescriptor starting at 0
	close access fileDescriptor
end run

on tyme(argv)
	tell application "Tyme"
		set tskID to argv
		StartTrackerForTaskID tskID
		set tsk to the first item of (every task of every project whose id = tskID)
		set tskName to name of tsk
		return tskName
	end tell
end tyme

on repContext(filePath, newContext)
	set historicalCount to (system attribute "HISTORICAL_COUNT")
	-- ?????????
	set fileDescriptor to open for access filePath
	-- ????????
	set AppleScript's text item delimiters to ","
	set strBoolean to false
	-- ?????????
	set firstPart to first text item of newContext
	-- ???????
    try
		set fileContent to read fileDescriptor
        set result_str to ""
        set taskDetailsLines to paragraphs of fileContent
        set actualCount to count of taskDetailsLines
        if actualCount < historicalCount then
            set historicalCount to actualCount
        end if

        -- ?????????????????
        repeat with i from 1 to historicalCount
            -- ????????
            set firstLine to paragraph i of fileContent
            try 
                set firstCurrentPart to first text item of firstLine
                if firstCurrentPart is equal to firstPart then
                    set strBoolean to true
                else
                    set result_str to result_str & "\n" &firstLine
                end if
            on error
                log "error"
            end try
        end repeat
        close access fileDescriptor
        set result_str to newContext & "\n" & result_str
        return result_str
	on error
		return newContext
	end try  

end repContext