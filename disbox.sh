#!/bin/bash

clear

gum style --foreground 190 "$(cowsay -y 'welcome to disbox, a nice script to manage your distrobox containers!')" 
echo
echo "**What would you like to do?**" | gum format -t markdown

# Asks for an action.
DO=$(gum choose --ordered --cursor="~> " --limit=1 "Create a container!" "Enter a container!" "List my containers!" "Delete a container!" "Stop a running container!" "Upgrade a container!" "Nothing, thanks!")

# Everything to do with creating containers.
if [[ $DO == "Create a container!" ]]
then
    clear
    gum style --foreground 190 "$(cowsay -y 'Name your new container!')"
    echo
    BOXNAME=$(gum input --prompt.foreground 170 --prompt "This container shall be called... " --placeholder "super sick container wow") && clear
        while [[ $BOXNAME == " " ]] || [[ $BOXNAME == "" ]]
        do
            gum style --foreground 160 "$(cowsay -b 'It actually has to be named something..')" && echo && BOXNAME=$(gum input --prompt.foreground 170 --prompt "This container shall be called... " --placeholder "super sick container wow") && clear
        done
    
    gum style --foreground 190 "$(cowsay -y "Choose a distro! The latest known version of it will be pulled. You may also enter a custom image URL (to choose versions or a different distro). Only the optimised images (toolbox) are listed here, get other ones at Distrobox's documentation.")"
    echo
    BOXKIND=$(gum choose --ordered --cursor="~> " --limit=1 --height=5 "Custom Image?" "Arch Linux" "Debian" "Ubuntu" "Fedora" "openSUSE" "AlmaLinux" "Alpine" "Rocky Linux" "CentOS")
        if [[ $BOXKIND == "Custom Image?" ]]
        then
            # Asks for a custom image URL.
            BOXKINDREAL=$(gum input --prompt.foreground 170 --prompt "Insert your image URL: " --placeholder "come on tell me what it is" | tr '[:upper:]' '[:lower:]' | tr -d '[:blank:]')
        elif [[ $BOXKIND == "Fedora" ]]
        then
            # Fedora is just special.
            BOXKINDREAL=$(echo "registry.fedoraproject.org/$BOXKIND-toolbox:latest" | tr '[:upper:]' '[:lower:]' | tr -d '[:blank:]')
        else
            # Most of the toolbox images are hosted on quay.io.
            BOXKINDREAL=$(echo "quay.io/toolbx-images/$BOXKIND-toolbox:latest" | tr '[:upper:]' '[:lower:]' | tr -d '[:blank:]')
        fi
    # Shows all the options that have been chosen by the user.
    gum style --foreground 190 "$(cowsay -y "Ready to make a new container? Confirm your choices first!")" && gum confirm "$(echo "Container Name: $BOXNAME" && echo "Distro: $BOXKIND" && echo "Image URL: $BOXKINDREAL")"
    clear
    # Runs distrobox-create without interaction. The user has interacted enough.
    gum style --foreground 190 "$(cowsay -y "Please wait! Your container is being built!") && echo && gum spin --spinner pulse --spinner.foreground="170" --title "Creating container..." -- distrobox-create --image $BOXKINDREAL --name $BOXNAME --yes
    clear
    gum style --foreground 190 "$(cowsay -y "Yay, your container is ready! Have fun!")"
    echo
    gum confirm "Launch the container $BOXNAME? You can launch it later through this script, or using `distrobox enter $BOXNAME`." && distrobox-enter $BOXNAME || clear && exit

fi