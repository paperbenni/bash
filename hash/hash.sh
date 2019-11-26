#!/usr/bin/env bash
pname hash/hash

different() {
	if type -fP awk sha256sum &>/dev/null; then
		local I=`awk '{!A[$1]++} END{print(NR)}' <(sha256sum "$@" 2>&-)`
		if [ $I -eq 0 ]; then
			printf "Usage: different [FILE_1] [FILE_2] ...\n" >&2
			return 2
		elif [ $I -eq 1 ]; then
			printf "Files are identical.\n"
		elif [ $I -eq 1 ]; then
			printf "Files are different!\n" >&2
			return 1
		fi
	else
		printf "Dependency 'awk' and/or 'sha256sum' not met.\n" >&2
		return 3
	fi
}
