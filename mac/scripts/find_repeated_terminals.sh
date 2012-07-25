#! /usr/bin/awk -f
# CSV file structure
# KDNR###KDANREDE###EMAIL###KDNAME1###KDSTRASSE###KDPLZ###KDORT###KDUSTID###STEUERNUMMER###LKZ###DPPROVISION###BANKNAME###BLZ###KTO###PHOTEL###AGTBST

function AddTerminalToUniqArray(terminal) {
	uniq_terminal_array[terminal] = terminal
}

function IsTerminalInUniqArray(terminal) {
	return terminal in uniq_terminal_array
}

function AddTerminalToRepeatedArray(terminal, agency) {
	repeated_array[agency, terminal] = terminal
}

BEGIN { 
	FS="###"
	agency=1
	terminal=16 
}
{
	if ($terminal ~ /,+/) {
		count = split($terminal, sub_array, ",")
		for(i=1; i<=count; ++i) {
			sub_item = sub_array[i]
			if (IsTerminalInUniqArray(sub_item)) {
				AddTerminalToRepeatedArray(sub_item, $agency)
			} else {
				AddTerminalToUniqArray(sub_item)
			}
		}
	} else if (IsTerminalInUniqArray($terminal)) {
		AddTerminalToRepeatedArray($terminal, $agency)
	} else {
		AddTerminalToUniqArray($terminal)
	}
}
END {
	# only to see how reading from multidemensional array works, 
	# because it is possible to print directly in the function AddTerminalToRepeatedArray
	for(row in repeated_array) {
		split(row, item_array, SUBSEP)
		print item_array[1] " " item_array[2]
	}
}