# Some abreviations
abbr --add clc 'clear'
abbr --add v 'nvim'
abbr --add please 'sudo'
abbr --add dsclean 'find . -type f -name .DS_Store -print0 | xargs -0 rm'

if command -v exa > /dev/null
	abbr --add l 'exa'
	abbr --add ls 'exa'
	abbr --add ll 'exa -l'
	abbr --add lll 'exa -la'
  abbr --add lt 'exa --tree --level=2'

else
	abbr --add l 'ls'
	abbr --add ll 'ls -l'
	abbr --add lll 'ls -la'
end



# Rust stuff
source ~/.cargo/env

# SSH
set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)

set -U fish_user_paths /usr/local/sbin /usr/local/bin /usr/bin /bin

# Fish git prompt
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate ''
set __fish_git_prompt_showupstream 'none'
set -g fish_prompt_pwd_dir_length 3

# Fish should not add things to clipboard when killing
# See https://github.com/fish-shell/fish-shell/issues/772
set FISH_CLIPBOARD_CMD "cat"

# Use this instead of ssh to ensure colors transfer nicely between systems
function remote_alacritty
	# https://gist.github.com/costis/5135502
	set fn (mktemp)
	infocmp alacritty > $fn
	scp $fn $argv[1]":alacritty.ti"
	ssh $argv[1] tic "alacritty.ti"
	ssh $argv[1] rm "alacritty.ti"
end

# Updates github repos with information from upstream
function gh_update
	if git remote | grep upstream > /dev/null
    echo "upstream is set"

  else if "$argv"
    git remote add upstream $argv

  else
    read  -l -P "?Whats the URl of the original repo? > " answer
    git remote add upstream $answer

  end

  git fetch upstream
  git checkout master
  git rebase upstream/master
end

function compress
	# Usage:
	# $argv[0]: Directory or file to compress
	# $argv[1] (optional): Compression type (Default tar.bz2)

	# dirPriorToExe=`pwd`
	# dirName=`dirname $argv[0]`
	# baseName=`basename $argv[0]`
	#
	# if -e $argv[0] # Compress a file
	# 	echo "It was a file change directory to $dirName"
	# 	cd $dirName
	#  	switch $argv[1]
	# 		case tar.bz2
	# 			tar cjf $baseName.tar.bz2 $baseName
	# 		case tar.gz
	# 			tar czf $baseName.tar.gz $baseName
	# 		case gz
	# 			gzip $baseName
	# 		case tar
	# 			tar -cvvf $baseName.tar $baseName
	# 		case zip
	# 			zip -r $baseName.zip $baseName
	# 		case '*'
	# 			echo "Method not passed compressing using tar.bz2"
	# 			tar cjf $baseName.tar.bz2 $baseName
	# 	end
	#
	# 	echo "Back to Directory $dirPriorToExe"
	# 	cd $dirPriorToExe
	#
	# else
	# 	if -d $argv[0]
	# 		echo "It was a Directory change directory to $dirName"
	# 		cd $dirName
	# 		switch $argv[1]
	# 			case tar.bz2
	# 				tar cjf $baseName.tar.bz2 $baseName
	# 			case tar.gz
	# 				tar czf $baseName.tar.gz $baseName
	# 			case gz
	# 				gzip -r $baseName
	# 			case tar
	# 				tar -cvvf $baseName.tar $baseName
	# 			case zip
	# 				zip -r $baseName.zip $baseName
	# 			case '*'
	# 				echo "Method not passed compressing using tar.bz2"
	# 				tar cjf $baseName.tar.bz2 $baseName
	# 		end
	# 		echo "Back to Directory $dirPriorToExe"
	# 		cd $dirPriorToExe
	#
	# 	else
	# 		echo "'$1' is not a valid file/folder"
	#
	# 	end
	# end
	#
	# echo "Done"
	# echo "###########################################"
end

function extract
	#	TODO
	echo "Not implemented yet"
end

function fish_prompt
	set_color brblack
	echo -n "["(date "+%H:%M")"] "
	set_color blue
	echo -n (hostname)
	if [ $PWD != $HOME ]
		set_color brblack
		echo -n ':'
		set_color yellow
		echo -n (basename $PWD)
	end
	set_color green
	printf '%s ' (__fish_git_prompt)
	set_color red
	echo -n '| '
	set_color normal
end

function fish_greeting
	echo
	echo -e (uname -ro | awk '{print " \\\\e[1mOS: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (uptime -p | sed 's/^up //' | awk '{print " \\\\e[1mUptime: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (uname -n | awk '{print " \\\\e[1mHostname: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e " \\e[1mDisk usage:\\e[0m"
	echo
	echo -ne (\
		df -l -h | grep -E 'dev/(nvme0n1p2|xvda|sd|mapper)' | \
		awk '{printf "\\\\t%s\\\\t%4s / %4s  %s\\\\n\n", $6, $3, $2, $5}' | \
		sed -e 's/^\(.*\([8][5-9]\|[9][0-9]\)%.*\)$/\\\\e[0;31m\1\\\\e[0m/' -e 's/^\(.*\([7][5-9]\|[8][0-4]\)%.*\)$/\\\\e[0;33m\1\\\\e[0m/' | \
		paste -sd ''\
	)
	echo

	echo -e " \\e[1mNetwork:\\e[0m"
	echo
	# http://tdt.rocks/linux_network_interface_naming.html
	echo -ne (\
		ip addr show up scope global | \
			grep -E ': <|inet' | \
			sed \
				-e 's/^[[:digit:]]\+: //' \
				-e 's/: <.*//' \
				-e 's/.*inet[[:digit:]]* //' \
				-e 's/\/.*//'| \
			awk 'BEGIN {i=""} /\.|:/ {print i" "$0"\\\n"; next} // {i = $0}' | \
			sort | \
			column -t | \
			# public addresses are underlined for visibility \
			sed 's/ \([^ ]\+\)$/ \\\e[4m\1/' | \
			# private addresses are not \
			sed 's/m\(\(10\.\|172\.\(1[6-9]\|2[0-9]\|3[01]\)\|192\.168\.\).*\)/m\\\e[24m\1/' | \
			# unknown interfaces are cyan \
			sed 's/^\( *[^ ]\+\)/\\\e[36m\1/' | \
			# ethernet interfaces are normal \
			sed 's/\(\(en\|em\|eth\)[^ ]* .*\)/\\\e[39m\1/' | \
			# wireless interfaces are purple \
			sed 's/\(wl[^ ]* .*\)/\\\e[35m\1/' | \
			# wwan interfaces are yellow \
			sed 's/\(ww[^ ]* .*\).*/\\\e[33m\1/' | \
			sed 's/$/\\\e[0m/' | \
			sed 's/^/\t/' \
		)
	echo


  set_color normal
end
