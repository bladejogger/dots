#!/bin/bash

BATT=0
BATT_INFO=$(acpi -b | grep "Battery ${BATT}")
BATT_STATE=$(echo "${BATT_INFO}" | grep -wo "Full\|Charging\|Discharging")
BATT_POWER=$(echo "${BATT_INFO}" | grep -o '[0-9]\+%' | tr -d '%')
BATT_INFO=${BATT_INFO:11}
ARRAY=(${BATT_INFO//,/ })
BATT_TIME="${ARRAY[2]} ${ARRAY[3]}"

ICON=""
COLOR=""

if [[ "${BATT_STATE}" = "Charging" ]]; then
    if [[ "${BATT_POWER}" -le 94 ]]; then
        ICON="A"
        COLOR="#FFFFFF"
    else
        ICON="B"
        COLOR="#55CC55"
    fi
elif [[ "${BATT_STATE}" = "Discharging" ]]; then
    if [[ "${BATT_POWER}" -le 10 ]]; then
        ICON="C"
        COLOR="#AA2222"
    elif [[ "${BATT_POWER}" -le 25 ]]; then
        ICON="D"
        COLOR="#FFFFFF"
    elif [[ "${BATT_POWER}" -le 50 ]]; then
        ICON="E"
        COLOR="#FFFFFF"
    elif [[ "${BATT_POWER}" -le 75 ]]; then
        ICON="F"
        COLOR="#FFFFFF"
    else
        ICON="G"
        COLOR="#FFFFFF"
    fi
else
    ICON="H"
    COLOR="#FFFFFF"
fi

if [[ "${BLOCK_BUTTON}" -eq 1 ]]; then
    # left click -> time
    #if [[ "${ARRAY[3]}" == "at" ]]; then
    if [ "${ARRAY[3]}" == "at" ]; then
        BATT_TIME="${ARRAY[2]} ${ARRAY[3]} ${ARRAY[4]} ${ARRAY[5]}"
    fi
    notify-send $ICON "$BATT_TIME"
fi

echo "${ICON} ${BATT_POWER}%"
echo "${ICON} ${BATT_POWER}%"
echo $COLOR


