#!/bin/bash

# Install necessary packages if not already installed
if ! command -v wormhole &> /dev/null; then
    echo "Magic Wormhole is not installed. Installing..."
    sudo apt-get install magic-wormhole
fi

if ! command -v zenity &> /dev/null; then
    echo "Zenity is not installed. Installing..."
    sudo apt-get install zenity
fi

send_file() {
    FILE_PATH=$(zenity --file-selection --title="Select a file to send")
    if [ $? -eq 0 ]; then
        wormhole send "$FILE_PATH" 2>&1 | zenity --text-info --width=600 --height=400 --title="Sending file" --auto-scroll
    fi
}

receive_file() {
    CODE=$(zenity --entry --title="Receive file" --text="Enter the code provided by the sender:")
    if [ $? -eq 0 ]; then
        if wormhole receive "$CODE" 2>&1 | zenity --text-info --width=600 --height=400 --title="Receiving file" --auto-scroll; then
            # Play a happy system sound after successful file receive
            paplay /usr/share/sounds/freedesktop/stereo/complete.oga
        fi
    fi
}

show_about() {
    zenity --info --width=400 --height=200 --text="Created by Kitten Technologies\nhttps://kittentechnologies.com\n\nhttps://github.com/mrcafune\n\nWhisker-Warp - A simple front-end for Magic-Wormhole\n\nCopyright (C) 2023 MrCafune, dev@kittentechnologies.com\n\nThis program is free software: you can redistribute it and/or modify\nit under the terms of the GPL3 License."
}

show_instructions() {
    zenity --info --width=400 --text="This is a simple front-end for Magic Wormhole. To send a file, click 'Send' and select a file. To receive a file, click 'Receive' and enter the code provided by the sender."
}

# Main program

while true; do
    ACTION=$(zenity --list --radiolist --width=400 --height=300 --title="Whisker-Warp" --text="Select an action:" --column="Select" --column="Action" TRUE "📤 Send" FALSE "📬 Receive" FALSE "📜 Instructions" FALSE "🐈 About" FALSE "🚪 Exit")

    case $ACTION in
        "📤 Send")
            send_file
            ;;
        "📬 Receive")
            receive_file
            ;;
         "📜 Instructions")
            show_instructions
            ;;
        "🐈 About")
            show_about
            ;;
        "🚪 Exit")
            break
            ;;
        *)
            break
            ;;
    esac
done

exit 0
