#!/bin/bash

# Select date using Zenity calender picker and store into a variable
# check to make sure date was selected




# Select time (12-hour format) with zenity using --entry with HH:MM format and store into a variable
# check to make sure a valid format was entered




# Select AM or PM with zenity --list and check to make sure it was selected



# Convert 12-hour time to 24-hour time
# store the hour in a variable for hour
# store the minutes in a variable for minutes





# Select script file using zenity and store it in a variable
# check to make sure it was selected 



# Ask if the scheduled script needs DISPLAY and XAUTHORITY variables
# if you choose to use zenity to choose your files on the create_backup.sh you
# will need to use the display. Since the cronjob will run in the background
# you can use the DISPLAY and the XAURHORITY to display your gui
# use display="DISPLAY=:0" and xauthority="XAUTHORITY=/home/$USER/.Xauthority"
# to use your display



# Select repetition schedule using Zenity --list and --column will be 
# Once a day, Once a week, Once a month, Once a year




# Calculate day and month for the initial run and store
# in a variable into day and variable for month




# Use a case to define cron job schedule based on user's selection
# of the repetition selected from your Zenity list
# each selection would store in a variable the syntax for
# Every day at the selected time "$minute $hour * * *"
# Every week on the selected day of the week "$minute $hour * * $weekday"
# Every month on the selected day"$minute $hour $day * *"
# Every year on the selected date "$minute $hour $day $month *"





# Add the cron job using the variable that was created in the case and the display as well as the script


# Show confirmation

