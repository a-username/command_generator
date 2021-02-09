#!/bin/bash

COMMAND="npm run cli -- simulation generate"

# Ansi color code variables
red="\e[0;91m"
blue="\e[0;94m"
expand_bg="\e[K"
blue_bg="\e[0;104m${expand_bg}"
red_bg="\e[0;101m${expand_bg}"
green_bg="\e[0;102m${expand_bg}"
green="\e[0;92m"
white="\e[0;97m"
bold="\e[1m"
uline="\e[4m"
reset="\e[0m"

function question1 {

    printf "${green}Does the request specify that employers should be generated? Y/N\n${reset}"

    read q2

    case $q2 in
      [Yy])
        COMMANDEMP="${COMMAND}:employers -d [output directory] -n "
        employerNumber;;
      [Nn])
        COMMANDCL="${COMMAND} -d [output directory] "
        printf "\nGreat! Then we don\'t need to bother generating any.\n"
        claimStart;;
      (*)
        printf "${red}Cannot parse your response, please use Y or N${reset}";;
    esac
}

function employerNumber {

    printf "${green}\nHow many employers would you like to generate?\n${reset}"

    read number1

    if ! [[ "$number1" =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; then
        printf "${red}Please enter a valid number.${reset}"
        employerNumber
    else
        COMMANDEMP=$COMMANDEMP$number1
        COMMANDCL="${COMMANDCL} -d [output directory] "
        printf "\nHere\'s your command for generating employers!:\n"
        printf "${blue}${COMMANDEMP}\n${reset}"
        printf "\nNow let\'s get the command for generating claims:\n"
        claimStart
    fi
}

function claimStart {

    printf "\n${green}Are you using an existing employee claims dataset (claims.json file)? Y/N\n${reset}"

    read claims

    case $claims in
      [Yy])
        COMMANDPA="${COMMANDCL}--employersFrom [employer direcory] --employeesFrom"
        claimDir;;
      [Nn])
        COMMANDPAC="${COMMANDCL}--employersFrom [employer direcory] -f"
        scenario;;
      (*)
        printf "${red}Cannot parse your response, please use Y or N${reset}"
        claimStart;;
    esac


}

function claimDir {

    printf "\n${green}Please specify a path to the directory containing the claims.json\n${reset}Note: the path can be written either absolute or relative to the pfml/e2e directory.\n"

    read claimPath

    COMMANDPAC="${COMMANDPA} ${claimPath} -f "

    printf "\nHere\'s what your command looks like so far:\n"

    printf "\n${blue}$COMMANDPAC${reset}\n"

    printf "${green}Does the employeesFrom path look correct? Y/N${reset}\n"

    read pathConfirm

    case $pathConfirm in
      [Yy])
        scenario;;
      [Nn])
        claimDir;;
      (*)
        printf "${red}Cannot parse your response, please use Y or N${reset}"
        claimDir;;
    esac
}

function scenario {

    printf "\n${green}Are you using a custom scenario file? Y/N\n${reset}Please note, in leiu of a custom scenario file the pfml/e2e/src/simulation/scenarios/lower.ts file will be used.\n"

    read scenFile

    case $scenFile in
      [Yy])
        scenDir;;
      [Nn])
        COMMANDPACS="${COMMANDPAC} pfml/e2e/src/simulation/scenarios/lower.ts -n "
        claimNum;;
      (*)
        printf "${red}Cannot parse your response, please use Y or N${reset}"
        scenario;;
    esac
}

function scenDir {

    printf "\n${green}Please specify a path to the directory containing the [scenio].ts file.\n${reset}Note: the path can be written either absolute or relative to the pfml/e2e directory.\n"

    read scenPath

    COMMANDPACS="${COMMANDPAC}${scenPath} -n "

    printf "Here\'s what your command looks like so far:\n"

    printf "${blue}$COMMANDPACS${reset}\n"

    printf "${green}Does the path following -f look correct? Y/N\n${reset}"

    read scenConfirm

    case $claimPath in
      [Yy])
        claimNum;;
      [Nn])
        scenDir;;
      (*)
        printf "${red}Cannot parse your response, please use Y or N${reset}"
        scenDir;;
    esac
}

function claimNum {

    printf "\nAlmost done!!\n${green}How many new claims are you generating?${reset}\n"

    read number2

    if ! [[ "$number2" =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; then
        printf Please enter a valid number.
        claimNum
    else
        COMMANDEND=$COMMANDPACS$number2
        printf "\nHooray! Here\'s your command!:\n"
        printf "${blue}${COMMANDEND}${reset}\n"
        printf "Make sure your paths are correct and replace any placeholders. These commands should be run from the pfml/e2e/data directory.\n"
        exit 1
    fi
}

question1
