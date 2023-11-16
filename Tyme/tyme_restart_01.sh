-- Script Filter
-- Shell\

#!/bin/bash

-- GetTymeLastTimer
-- URL
-- https://www.icloud.com/shortcuts/40956c44904442348095f8a04d7604fe
shortcutName="GetTymeLastTimer"  

shortcutResult=$(shortcuts run "$shortcutName")
jsonString="{ \"items\": [" 
jsonString+="{\"title\": \""
jsonString+=$shortcutResult
jsonString+="\", \"subtitle\": \"\", \"arg\": \"\", \"valid\": \"true\", \"icon\": {\"path\": \"\"}},"
jsonString+="] }"

printf "$jsonString"


-- Next step
-- Run shortcuts
-- URL
-- https://www.icloud.com/shortcuts/56dccad89e78461194e8e99aba3bf611