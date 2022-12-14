#!/bin/bash

read_config () {
    mapfile -t array_times < <(grep ":" $config | sed 's/://'| sed 's/\w*$//')
    mapfile -t array_values < <(grep ":" $config | sed 's/.* //')
}

update_backlight () {
    index=0
    while (( $time > ${array_times[index]} && $index <= ${#array_times[@]} )); do
        ((index++))
    done
    sudo ddcutil setvcp 10 ${array_values[index]} --bus 0
}

loop () {
    time=$(date +%H%M)
    read_config
    update_backlight
    sleep 5
    loop
}

prompt_config () {
    read -p "Do you want to generate a default one? [Y/n]" answer
    case $answer in
        [yY][eE][sS]|[yY])
            generate_config
            ;;
        [nN][oO]|[nN])
            ;;
        "")
            generate_config
            ;;
        *)
            ;;
    esac
}

generate_config () {
    [ -d ~/.config ] || mkdir ~/.config
    [ -d ~/.config/natulit ] || mkdir ~/.config/natulit

    echo -e "18:00 80\n19:00 70\n 20:00 60\n 21:00 50" > ~/.config/natulit/config
    echo "Finished creating the default configuration file."
    loop
}

config=~/.config/natulit/config
[ -f $config ] && loop || echo "The config file \"$config\" does not exist!" && prompt_config
