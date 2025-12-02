#!/bin/bash

# Select date using Zenity calender picker and store into a variable
# check to make sure date was selected
DATE=$(zenity --calendar --title="Select Date" --text="Choose a date for the cron job" --date-format="%Y-%m-%d")

if [ -z "$DATE" ]; then
    zenity --error --text="No date selected. Exiting."
    exit 1
fi

# Select time (12-hour format) with zenity using --entry with HH:MM format and store into a variable
# check to make sure a valid format was entered
TIME=$(zenity --entry --title="Enter Time" --text="Enter time in HH:MM format (12-hour):" --entry-text="12:00")

if [ -z "$TIME" ]; then
    zenity --error --text="No time entered. Exiting."
    exit 1
fi

if ! [[ "$TIME" =~ ^[0-1]?[0-9]:[0-5][0-9]$ ]]; then
    zenity --error --text="Invalid time format. Please use HH:MM format."
    exit 1
fi

# Select AM or PM with zenity --list and check to make sure it was selected
AMPM=$(zenity --list --title="Select AM or PM" --column="Period" "AM" "PM" --height=200)

if [ -z "$AMPM" ]; then
    zenity --error --text="No AM/PM selection made. Exiting."
    exit 1
fi

# Convert 12-hour time to 24-hour time
# store the hour in a variable for hour
# store the minutes in a variable for minutes
HOUR=$(echo "$TIME" | cut -d: -f1)
MINUTE=$(echo "$TIME" | cut -d: -f2)

HOUR=$((10#$HOUR))

if [ "$AMPM" == "PM" ] && [ $HOUR -ne 12 ]; then
    HOUR=$((HOUR + 12))
elif [ "$AMPM" == "AM" ] && [ $HOUR -eq 12 ]; then
    HOUR=0
fi

# Select script file using zenity and store it in a variable
# check to make sure it was selected 
SCRIPT=$(zenity --file-selection --title="Select the script to schedule" --file-filter="*.sh")

if [ -z "$SCRIPT" ]; then
    zenity --error --text="No script selected. Exiting."
    exit 1
fi

# Ask if the scheduled script needs DISPLAY and XAUTHORITY variables
# if you choose to use zenity to choose your files on the create_backup.sh you
# will need to use the display. Since the cronjob will run in the background
# you can use the DISPLAY and the XAURHORITY to display your gui
# use display="DISPLAY=:0" and xauthority="XAUTHORITY=/home/$USER/.Xauthority"
# to use your display
NEEDS_DISPLAY=$(zenity --question --title="Display Required?" --text="Does this script need GUI/Display access?\n(Required for scripts using Zenity)" --ok-label="Yes" --cancel-label="No")

if [ $? -eq 0 ]; then
    DISPLAY_VAR="DISPLAY=:0"
    XAUTHORITY_VAR="XAUTHORITY=/home/$USER/.Xauthority"
    DISPLAY_PREFIX="$DISPLAY_VAR $XAUTHORITY_VAR "
else
    DISPLAY_PREFIX=""
fi

# Select repetition schedule using Zenity --list and --column will be 
# Once a day, Once a week, Once a month, Once a year
REPETITION=$(zenity --list --title="Select Repetition Schedule" --column="Schedule" "Once a day" "Once a week" "Once a month" "Once a year" --height=250)

if [ -z "$REPETITION" ]; then
    zenity --error --text="No repetition schedule selected. Exiting."
    exit 1
fi

# Calculate day and month for the initial run and store
# in a variable into day and variable for month
DAY=$(date -d "$DATE" +%d)
MONTH=$(date -d "$DATE" +%m)
WEEKDAY=$(date -d "$DATE" +%u)

# Use a case to define cron job schedule based on user's selection
# of the repetition selected from your Zenity list
# each selection would store in a variable the syntax for
# Every day at the selected time "$minute $hour * * *"
# Every week on the selected day of the week "$minute $hour * * $weekday"
# Every month on the selected day"$minute $hour $day * *"
# Every year on the selected date "$minute $hour $day $month *"
case "$REPETITION" in
    "Once a day")
        CRON_SCHEDULE="$MINUTE $HOUR * * *"
        ;;
    "Once a week")
        CRON_SCHEDULE="$MINUTE $HOUR * * $WEEKDAY"
        ;;
    "Once a month")
        CRON_SCHEDULE="$MINUTE $HOUR $DAY * *"
        ;;
    "Once a year")
        CRON_SCHEDULE="$MINUTE $HOUR $DAY $MONTH *"
        ;;
    *)
        zenity --error --text="Invalid repetition schedule."
        exit 1
        ;;
esac

# Add the cron job using the variable that was created in the case and the display as well as the script
(crontab -l 2>/dev/null; echo "$CRON_SCHEDULE ${DISPLAY_PREFIX}bash \"$SCRIPT\"") | crontab -

# Show confirmation
zenity --info --title="Cron Job Created" --text="Cron job successfully scheduled!\n\nSchedule: $REPETITION\nTime: $HOUR:$(printf "%02d" $MINUTE)\nScript: $SCRIPT\nCron Expression: $CRON_SCHEDULE\n\nYou can view all cron jobs with: crontab -l"
