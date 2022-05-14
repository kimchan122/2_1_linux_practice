#!/bin/bash
#made by Kim Chan

countdir=$(ls -al `pwd` | grep ^d | wc -l)
countf=$(ls -al `pwd` | grep ^- | wc -l)
sumofdir=$(du -hs `pwd` | cut -f 1)
countexe=$(ls -al `pwd` | grep ^- | grep '\-..x..x..x' | wc -l)
countfile=$(ls -al `pwd` | grep ^- | grep -e 'r--' -e 'rw-' -e '-w-' | wc -l)

RESET(){
countdir=$(ls -al `pwd` | grep ^d | wc -l)
countf=$(ls -al `pwd` | grep ^- | wc -l)
sumofdir=$(du -hs `pwd` | cut -f 1)
countexe=$(ls -al `pwd` | grep ^- | grep '\-..x..x..x' | wc -l)
countfile=$(ls -al `pwd` | grep ^- | grep -e 'r--' -e 'rw-' -e '-w-' | wc -l)
}

RIGHTSET(){
rcountdir=$(ls -al `pwd` | grep ^d | wc -l)
rcountf=$(ls -al `pwd` | grep ^- | wc -l)
rsumofdir=$(du -hs `pwd` | cut -f 1)
rcountexe=$(ls -al `pwd` | grep ^- | grep '\-..x..x..x' | wc -l)
rcountfile=$(ls -al `pwd` | grep ^- | grep -e 'r--' -e 'rw-' -e '-w-' | wc -l)
}

setline=4
checkmode=1
checkupdown=3
checkenter=0
Twenty=20
wantpath=0
depth=0

DISPLAY_LEFT_DIR(){ # 디렉토리 출력
Twenty=20
dir=$(ls -ahl `pwd` | grep ^d | head -$Twenty | cut -f 2 -d ":" | cut -c 4-20 | sed 's/\(.*\)/ \1/')
power=$(ls -ahl `pwd` | grep ^d | head -$Twenty | cut -f -1 -d' ' | sed 's/\(.*\)/                   \1/')
size=$(ls -ahl `pwd` | grep ^d | head -$Twenty | tr -s ' ' | cut -d ' ' -f 5 | sed 's/\(.*\)/                                  \1/')
Twenty=`expr $Twenty - $countdir`

#tput cup 39 30
#echo "DIR_Twenty : $Twenty"
tput cup 4 0
echo '[34m'"${size}"
tput cup 4 34
echo '-    '
tput cup 5 34
echo '-    '
tput cup 4 0
echo "${power}"
tput cup 4 0
echo "${dir}[30m[47m"
}

DISPLAY_LEFT_EXE(){ # 실행파일 출력
	#tput cup 40 30
	#echo "INPUT_EXE_Twenty : $Twenty"
exe=$(ls -ahl `pwd` | grep ^- | grep '\-..x..x..x' | head -$Twenty | cut -f 2 -d ":" | cut -c 4-20 | sed 's/\(.*\)/ \1/')
power=$(ls -ahl `pwd` | grep ^- | grep '\-..x..x..x' | head -$Twenty | cut -f -1 -d' ' | sed 's/\(.*\)/                   \1/')
size=$(ls -ahl `pwd` | grep ^- | grep '\-..x..x..x' | head -$Twenty | tr -s ' ' | cut -d ' ' -f 5 | sed 's/\(.*\)/                                  \1/')


#echo "EXE_COUNT : `$exe | wc -l`"

Twenty=`expr $Twenty - $countexe`
	#tput cup 41 30
	#echo "OUTPUT_EXE_Twenty : $Twenty"
exestart=`expr $countdir + 4`
	#tput cup 37 0
	#echo "EXESTART : $exestart"
tput cup $exestart 0
echo '[32m'"${size}"
tput cup $exestart 0
echo "${power}"
tput cup $exestart 0
echo "${exe}[30m[47m"
}

DISPLAY_LEFT_FILE(){ # 일반 파일 출력
if [[ $Twenty -lt 0 ]]
then
Twenty=0
else
Twenty=$Twenty
fi

filestart=`expr $countdir + $countexe + 4`
file=$(ls -ahl `pwd` | grep ^- | grep -e 'r--' -e 'rw-' -e '-w-' | head -$Twenty | cut -f 2 -d ":" | cut -c 4-20 | sed 's/\(.*\)/ \1/')
power=$(ls -ahl `pwd` | grep ^- | grep -e 'r--' -e 'rw-' -e '-w-' | head -$Twenty | cut -f -1 -d' ' | sed 's/\(.*\)/                   \1/')
size=$(ls -ahl `pwd` | grep ^- | grep -e 'r--' -e 'rw-' -e '-w-' | head -$Twenty | tr -s ' ' | cut -d ' ' -f 5 | sed 's/\(.*\)/                                  \1/')
Twenty=`expr $Twenty - $countdir  - $countexe`

	#tput cup 38 0
	#echo "FILE_TWENTY : $Twenty"
	#tput cup 42 25
	#echo "FILESTART : $filestart"
tput cup $filestart 0
echo '[30m'"${size}"
tput cup $filestart 0
echo "${power}"
tput cup $filestart 0
echo "${file}[30m"
}

DISPLAY_LEFT(){ # 왼쪽 화면
DISPLAY_LEFT_DIR
#tput cup 50 0
#echo "T1 : $Twenty"
while [[ $Twenty -gt 0 ]]
do
	if [[ "$Twenty" -le 0 ]]
	then break
	else
		DISPLAY_LEFT_EXE
		if [[ $Twenty -le 0 ]]
		then break
		else
			tput cup 60 20
			DISPLAY_LEFT_FILE
			break
		fi
	fi
done

#tput cup 31 0
}

#===============================================

printall=4
printnull=42
level=1

DISPLAY_RIGHT_DIR_DIR(){
        nowdir=$(pwd | rev | cut -f 1 -d "/" | rev | sed 's/\(.*\)/                                          \1/')
        tput cup $printall $printnull
        echo '^[[34m'"${nowdir}"'^[[30m'
        printall=`expr $printall + 1`
        rcountdir=$(ls -ahl `pwd` | grep ^d | wc -l)
        if [[ $rcountdir -eq 2 ]]
	then
	        DISPLAY_RIGHT_EXE
 	        DISPLAY_RIGHT_FILE
        else
		cd "$0"
#               forcount=`expr $rcountdir + 2`
                for((i=3;i<=$forcount;i++))
                do
                if [[ $printall -gt 23 ]]
                then break
                else
                rdir=$(ls -ahl `pwd` | grep ^d | head -$i | tail -1 | cut -f 2 -d ":" | cut -c 4-)
		
		prdir=$(ls -ahl `pwd` | grep ^d | head -$i | tail -1 | cut -f 2 -d ":" | cut -c 4-)
		tput cup $printall $printnull
		echo "$rdir"
		DISPLAY_RIGHT_DIR_DIR $rdir
#                level=`expr $level + 1`
                nowdir=$(pwd | rev | cut -f 1 -d "/" | rev | sed 's/\(.*\)/                                          \1/')
                fi
                done
                DISPLAY_RIGHT_EXE
                DISPLAY_RIGHT_FILE
		cd ..
        fi
}

DISPLAY_RIGHT_DIR(){
	
	nowdir=$(pwd | rev | cut -f 1 -d "/" | rev )
	tput cup $printall $printnull
	echo '[34m'"${nowdir}"'[30m'
	printall=`expr $printall + 1`
	printnull=`expr $printnull + 2`
	rcountdir=$(ls -ahl `pwd` | grep ^d | wc -l)
	
	if [[ $rcountdir -eq 2 ]]
	then
		DISPLAY_RIGHT_EXE
		DISPLAY_RIGHT_FILE
		printnull=`expr $printnull - 2`
	else
#		forcount=`expr $rcountdir + 2`
		for((i=3;i<=$rcountdir;i++))
		do
		if [[ $printall -gt 23 ]]
		then break
		else
		rdir=$(ls -ahl `pwd` | grep ^d | head -$i | tail -1 | cut -f 2 -d ":" | cut -c 4-)

		prdir=$(ls -ahl `pwd` | grep ^d | head -$i | tail -1 | cut -f 2 -d ":" | cut -c 4- | sed 's/\(.*\)/                                            \1/')
#		DISPLAY_RIGHT_DIR_DIR $rdir
#		level=`expr $level + 1`
		tput cup $printall `expr $printnull - 2`
		echo "├─[34m$rdir"'[30m'
#	        nowdir=$(pwd | rev | cut -f 1 -d "/" | rev | sed 's/\(.*\)/                                          \1/') 
		printall=`expr $printall + 1`

		fi
		done
		DISPLAY_RIGHT_EXE
		DISPLAY_RIGHT_FILE

		printnull=`expr $printnull - 2`
	fi
}

DISPLAY_RIGHT_EXE(){
	rcountexe=$(ls -al `pwd` | grep ^- | grep '\-..x..x..x' | wc -l)
	for((i=1;i<=$rcountexe;i++))
	do
	if [[ $printall -gt 23 ]]
	then break
	else
	rexe=$(ls -ahl `pwd` | grep ^- | grep '\-..x..x..x' | head -$i | tail -1 | cut -f 2 -d ":" | cut -c 4- )
	tput cup $printall `expr $printnull - 2`
	echo "├─[32m$rexe"'[30m'
	printall=`expr $printall + 1`
	fi
	done
}

DISPLAY_RIGHT_FILE(){
	rcountfile=$(ls -al `pwd` | grep ^- | grep -e 'r--' -e 'rw-' -e '-w-' | wc -l)
	for((i=1;i<=$rcountfile;i++))
	do
	if [[ $printall -gt 23 ]]
	then break
	else
	rfile=$(ls -ahl `pwd` | grep ^- | grep -e 'r--' -e 'rw-' -e '-w-' | head -$i | tail -1 | cut -f 2 -d ":" | cut -c 4- )
	tput cup $printall `expr $printnull - 2`
#	for((i=0;i<=`expr $printnull \* 2`;i++))
#	do
#	echo -n " "
#	done
	if [[ i -eq $rcountfile ]]
	then echo "└─$rfile"
	else
	echo "├─$rfile"
	fi
	printall=`expr $printall + 1`
	fi
	done

}

DISPLAY_RIGHT(){ # 오른쪽 화면 출력
	DISPLAY_RIGHT_DIR
#	DISPLAY_RIGHT_EXE
#	DISPLAY_RIGHT_FILE
}

CURRENT_PATH(){
tput cup 2 1
	echo '[35m'"Current Path : `pwd`"'[30m'
}

DISPLAY_BAR(){ # UI 바 출력
tput cup 0 0
	echo '[46m''[30m'"File Explorer"'[47m'
CURRENT_PATH
tput cup 25 4
	echo "Directory : $(expr $countdir - 2)"
tput cup 25 25
	echo "File : $countf"
tput cup 25 43
	echo "Current Directory Size : $sumofdir"
for i in 2 25
do
for j in 0 82
do
tput cup $i $j
echo "|"
done
done

for((i=4;i<=23;i++))
do
for j in 0 41 82
do
	tput cup $i $j
	echo "|"
done
done
for((i=0;i<=82;i++))
do
for j in 1 3 24 26
do
	tput cup $j $i
	echo -n "-"
done
done

}
###################################################################

DISPLAY_BOARD(){ # 하얀 배경 출력
for((i=1;i<=26;i++))
	do
	for((j=0;j<=82;j++))
	do
	tput cup $i $j
	echo '[47m'" "
	done
done
}
###################################################################
leftcursor(){ # 왼쪽 창 커서 구현
#tput cup 31 0
#echo "CURSOR_SETLINE : $setline"
if [ `expr $setline - 3` -le $countdir ] && [ $checkenter -eq 1 ]
then
#tput cup 28 30
#echo "ENTERED!!!"
#(ls -ahl | grep ^d | head -`expr $setline - 3` | tail -1 | cut -c 45-)
next=`pwd`
path=$(ls -ahl `pwd` | grep ^d | head -`expr $setline - 3` | tail -1 | cut -f 2 -d ":" | cut -c 4-)
#tput cup 32 30
#echo "NONANANA"
#echo "PATH : "$path""
next="$path"
#echo "NEXT : "$next""
cd "$path"
#ls
checkenter=0
setline=4
#countdir=$(ls -al `pwd` | grep ^d | wc -l)
#countfile=$(ls -al `pwd` | grep ^- | wc -l)
#sumofdir=$(du -hs `pwd` | cut -f 1)
#countexe=$(ls -al `pwd` | grep ^- | grep '\-..x..x..x' | wc -l)
#countfile=$(ls -al `pwd` | grep ^- | grep -e 'r--' -e 'rw-' -e '-w-' | wc -l)
RESET
frame
CURRENT_PATH
leftcursor
#echo "LEFT_SETLINE : $setline"

else
sumline=`expr $countdir + $countexe + $countfile + 3`
if [[ $sumline -gt 23 ]]
then sumline=23
else sumline=$sumline
fi

#tput cup 32 0
#echo "SUMLINE : $sumline"
#echo "SETLINE : $setline"
if [[ $setline -lt 4 ]] # 위로 더 못올라가게
then
	setline=4
elif [[ $setline -gt $sumline ]] # 아래로 더 못내려가게
then
	setline=$sumline
else 
	setline=$setline
fi

#echo "SSSSSSETLINE : $setline"
##printline=`expr $setline - 1`
count=`expr $countdir + 3`

if [[ $count -le 23 ]]
then count=$count
else count=23
fi

#tput cup 43 0
#echo "COUNT : $count"

if [ "$setline" -le "$count" ]
then
	now=$(ls -ahl `pwd` | grep ^d | head -`expr $setline - 3` | tail -1 | cut -f 2 -d ":" | cut -c 4-20 | sed 's/\(.*\)/\1/')
	power=$(ls -ahl `pwd` | grep ^d | head -`expr $setline - 3` | tail -1 | cut -f -1 -d' ' | sed 's/\(.*\)/                  \1/')
	size=$(ls -ahl `pwd` | grep ^d | head -`expr $setline - 3` | tail -1 | tr -s ' ' | cut -d ' ' -f 5 | sed 's/\(.*\)/                                 \1/')
else
count=`expr $count + $countexe`

if [ $count -gt 24 ]
then count=$count
fi

#tput cup 42 0
#echo "COUNTT : $count"
	if [ "$setline" -le "$count" ]
	then
	now=$(ls -ahl `pwd` | grep ^- | grep '\-..x..x..x' | head -`expr $setline - 3 - $countdir` | tail -1 | cut -f 2 -d ":" | cut -c 4-20 | sed 's/\(.*\)/\1/')
	power=$(ls -ahl `pwd` | grep ^- | grep '\-..x..x..x' | head -`expr $setline - 3 - $countdir` | tail -1 | cut -f -1 -d' ' | sed 's/\(.*\)/                  \1/')
	size=$(ls -ahl `pwd` | grep ^- | grep '\-..x..x..x' | head -`expr $setline - 3 - $countdir` | tail -1 | tr -s ' ' | cut -d ' ' -f 5 | sed 's/\(.*\)/                                 \1/')
	
	else
	count=`expr $count + $countfile`
	if [ "$count" -gt 24 ]
	then count=$count
	else count=23
	fi
	tput cup 43 0
#	echo "COUNTTT : $count"
	now=$(ls -ahl `pwd` | grep ^- | grep -e 'r--' -e 'rw-' -e '-w-' | head -`expr $setline - 3 - $countdir - $countexe` | tail -1 | cut -f 2 -d ":" | cut -c 4-20 | sed 's/\(.*\)/\1/')
	power=$(ls -ahl `pwd` | grep ^- | grep -e 'r--' -e 'rw-' -e '-w-' | head -`expr $setline - 3 - $countdir - $countexe` | tail -1 | cut -f -1 -d' ' | sed 's/\(.*\)/                  \1/')
	size=$(ls -ahl `pwd` | grep ^- | grep -e 'r--' -e 'rw-' -e '-w-' | head -`expr $setline - 3 - $countdir - $countexe` | tail -1 | tr -s ' ' | cut -d ' ' -f 5 | sed 's/\(.*\)/                                 \1/')
	fi
fi
tput cup $setline 1
echo "[44m[37m                                        "
tput cup $setline 1
gong="-    "
if [[ "$setline" -eq 4 ]] || [[ "$setline" -eq 5 ]]
then echo "[44m[37m                                 -      "
else echo "[44m[37m${size}"
fi
tput cup $setline 1
echo "${power}"
tput cup $setline 1
echo "${now}[30m[47m"
#tput cup 22 60
#echo "$countdir, $countexe, $countfile"
tput cup $setline 1
checkenter=0
fi
}

rightcursor(){ # 오른쪽 창 커서}
printall=`expr $printall - 1`
#tput cup 35 50
#	echo "SETLINE : $setline"
#tput cup 36 50
#	echo "PRINTALL : $printall"
if [[ $setline -lt 4 ]]
then
	setline=4
elif [[ $setline -gt $printall ]]
then
	setline=$printall
else
	setline=$setline
fi
tput cup $setline 77
	echo '[31m'"<-"'[30m'
}

cursor(){ #커서구현
#tput cup 40 0
#echo "CHECKMODE : $checkmode"
if [ $checkmode -eq 1 ]
then
leftcursor
tput cup 31 10
#echo "ONEONE"
elif [ $checkmode -eq 2 ]
then
rightcursor
echo ""
fi
}

key(){ 
tput cup 27 0
read -n 3 key # 위로 가니까 -1
if [ "${key}" = "[A" ]
then 
#echo "up"
RESET
checkupdown=3
setline=`expr $setline - 1`

elif [ "${key}" = "[B" ] # 아래로 가니까 +1
then
#echo "down"
RESET
checkupdown=4
setline=`expr $setline + 1`

elif [ "${key}" = "[C" ]
then
#tput cup 29 0
#echo "right"
RESET
setline=4
checkmode=2

elif [ "${key}" = "[D" ]
then
#tput cup 29 0
#echo "left"
RESET
setline=4
checkmode=1

elif [ "${key}" = "" ]
then
RESET
#setline=4
checkenter=1

else echo ""
fi
}

frame(){
DISPLAY_BOARD
printall=4
DISPLAY_RIGHT
DISPLAY_LEFT
DISPLAY_BAR
#tput cup 30 0
}

#===    up : func ===#
#=== under : main ===#
main(){
while true
do
tput cup 30 20
echo '[46m''[30m'""
clear
frame
cursor
key
#checkenter=0
done
}
main
