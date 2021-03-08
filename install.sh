#!/bin/bash

#/**
# * ChrisTechTips Grub2 Theme Installer
# *
# * @license MIT
# * @author  "Chris Titus" <contact@christitus.com>
# * @author  "Matthias Morin" <mat@tangoman.io>
# * @version 1.0.0
# * @link    https://youtu.be/BAyzHP1Cqb0
# */

THEME_DIR='/usr/share/grub/themes'
THEME_NAME=''

function echo_title() {     echo -ne "\033[1;44;37m${*}\033[0m\n"; }
function echo_caption() {   echo -ne "\033[0;1;44m${*}\033[0m\n"; }
function echo_bold() {      echo -ne "\033[0;1;34m${*}\033[0m\n"; }
function echo_danger() {    echo -ne "\033[0;31m${*}\033[0m\n"; }
function echo_success() {   echo -ne "\033[0;32m${*}\033[0m\n"; }
function echo_warning() {   echo -ne "\033[0;33m${*}\033[0m\n"; }
function echo_secondary() { echo -ne "\033[0;34m${*}\033[0m\n"; }
function echo_info() {      echo -ne "\033[0;35m${*}\033[0m\n"; }
function echo_primary() {   echo -ne "\033[0;36m${*}\033[0m\n"; }
function echo_error() {     echo -ne "\033[0;1;31merror:\033[0;31m\t${*}\033[0m\n"; }
function echo_label() {     echo -ne "\033[0;1;32m${*}:\033[0m\t"; }
function echo_prompt() {    echo -ne "\033[0;36m${*}\033[0m "; }

function splash() {
    local hr
    hr=" **$(printf "%${#1}s" | tr ' ' '*')** "
    echo_title "${hr}"
    echo_title " * $1 * "
    echo_title "${hr}"
    echo
}

function check_root() {
    # Checking for root access and proceed if it is present
    ROOT_UID=0
    if [[ ! "${UID}" -eq "${ROOT_UID}" ]]; then
        # Error message
        echo_error 'Run me as root.'
        echo_info 'try sudo ./install.sh'
        exit 1
    fi
}

function select_theme() {
    themes=('Vimix' 'Cyberpunk' 'Shodan' 'fallout' 'CyberRe' 'Quit')

    PS3=$(echo_prompt '\nChoose The Theme You Want: ')
    select THEME_NAME in "${themes[@]}"; do
        case "${THEME_NAME}" in
            'Vimix')
                splash 'Installing Vimix Theme'
                break;;
            'Cyberpunk')
                splash 'Installing Cyberpunk Theme'
                break;;
            'Shodan')
                splash 'Installing Shodan Theme'
                break;;
            'fallout')
                splash 'Installing fallout Theme'
                break;;
            'CyberRe')
                splash 'Installing CyberRe Theme'
                break;;
            'Quit')
                echo_info 'User requested exit'
                exit 0;;
            *) echo_warning "invalid option \"${REPLY}\"";;
        esac
    done
}

function backup() {
    # Backup grub config
    echo_info 'cp -an /etc/default/grub /etc/default/grub.bak'
    cp -an /etc/default/grub /etc/default/grub.bak
}

function install_theme() {
    # create themes directory if not exists
    if [[ ! -d "${THEME_DIR}/${THEME_NAME}" ]]; then
        # Copy theme
        echo_primary "Installing ${THEME_NAME} theme..."

        echo_info "mkdir -p \"${THEME_DIR}/${THEME_NAME}\""
        mkdir -p "${THEME_DIR}/${THEME_NAME}"

        echo_info "cp -a ./themes/\"${THEME_NAME}\"/* \"${THEME_DIR}/${THEME_NAME}\""
        cp -a ./themes/"${THEME_NAME}"/* "${THEME_DIR}/${THEME_NAME}"
    fi
}

function config_grub() {
    echo_primary 'Enabling grub menu'
    # remove default grub style if any
    echo_info "sed -i '/GRUB_TIMEOUT_STYLE=/d' /etc/default/grub"
    sed -i '/GRUB_TIMEOUT_STYLE=/d' /etc/default/grub

    echo_info "echo 'GRUB_TIMEOUT_STYLE=\"menu\"' >> /etc/default/grub"
    echo 'GRUB_TIMEOUT_STYLE="menu"' >> /etc/default/grub

    #--------------------------------------------------

    echo_primary 'Setting grub timeout to 10 seconds'
    # remove default timeout if any
    echo_info "sed -i '/GRUB_TIMEOUT=/d' /etc/default/grub"
    sed -i '/GRUB_TIMEOUT=/d' /etc/default/grub

    echo_info "echo 'GRUB_TIMEOUT=\"10\"' >> /etc/default/grub"
    echo 'GRUB_TIMEOUT="10"' >> /etc/default/grub

    #--------------------------------------------------

    echo_primary "Setting ${THEME_NAME} as default"
    # remove theme if any
    echo_info "sed -i '/GRUB_THEME=/d' /etc/default/grub"
    sed -i '/GRUB_THEME=/d' /etc/default/grub

    echo_info "echo \"GRUB_THEME=\"${THEME_DIR}/${THEME_NAME}/theme.txt\"\" >> /etc/default/grub"
    echo "GRUB_THEME=\"${THEME_DIR}/${THEME_NAME}/theme.txt\"" >> /etc/default/grub
}

function update_grub() {
    # Update grub config
    echo_primary 'Updating grub config...'
    if [[ -x "$(command -v update-grub)" ]]; then
        echo_info 'update-grub'
        update-grub

    elif [[ -x "$(command -v grub-mkconfig)" ]]; then
        echo_info 'grub-mkconfig -o /boot/grub/grub.cfg'
        grub-mkconfig -o /boot/grub/grub.cfg

    elif [[ -x "$(command -v grub2-mkconfig)" ]]; then
        if [[ -x "$(command -v zypper)" ]]; then
            echo_info 'grub2-mkconfig -o /boot/grub2/grub.cfg'
            grub2-mkconfig -o /boot/grub2/grub.cfg

        elif [[ -x "$(command -v dnf)" ]]; then
            echo_info 'grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg'
            grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
        fi
    fi
}

function main() {
    splash 'ChrisTechTips Grub2 Theme Installer'

    check_root
    select_theme

    install_theme

    config_grub
    update_grub

    echo_success 'All done !'
}

main
