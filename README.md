# alfred-workflows-tyme-starttask-search
## Tyme

### Tyme Start

Initiate Tyme timer and set it for 25 minutes;

Use "ts" followed by the Tyme Task name to select and start;

Keyword: ts

![image.png](https://pazer-markdown.oss-cn-beijing.aliyuncs.com/img20231103103731.png)

Search:

![image.png](https://pazer-markdown.oss-cn-beijing.aliyuncs.com/img20231103103825.png)

Search for the corresponding name and start the timer after selection;

### Tyme Stop

Stop the Tyme timer;

Keyword: tst

### Tyme Restart

When not currently timing, restart the Tyme timer for the last recorded Task project;

Keyword: tsre


## Timer


Alfred Timer: Enter the number of minutes to start the timer;

Keyword: timer 25

Start a 25-minute timer.

## OmniFocus

### OmniFocus Restart Tasks Due

In OmniFocus, select tasks and sort them based on their due dates with the specified interval; (automatically skip Fridays, Saturdays, and Sundays)

Keyword: omrt 2

Set the due dates of the selected tasks with a 2-day interval.

### OmniFocus Sync to iCal

Sync the selected tasks from OmniFocus to iCal, using the due dates as the date and time.

keyword: oms

Update：

Update different calendars added to iCal based on the folder where the project is located in OmniFocus; You need to manually add calendars in iCloud and set up a relationship between folders and calendars.


### OmniFocus Set Task Due Time and Now Tag

For selected tasks in OmniFocus, add the "Now" tag and update the due time to the current time.

keyword: omt

### Sync Completed Tasks from OmniFocus to Obsidian

Synchronize completed projects to Obsidian.

This includes two scenarios, one for today and one for each week.

Will synchronize updates and discard abandoned projects.

Keyword: omsob

Parameter 1: Sync Weekly Report
No parameter: Sync Today's Report