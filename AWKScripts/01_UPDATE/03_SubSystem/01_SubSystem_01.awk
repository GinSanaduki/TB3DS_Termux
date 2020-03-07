#!/usr/bin/gawk -f
# 01_SubSystem_01.awk
# gawk -f AWKScripts/01_UPDATE/03_SubSystem/01_SubSystem_01.awk -v HTTP_Command=CURL
# gawk -f AWKScripts/01_UPDATE/03_SubSystem/01_SubSystem_01.awk -v HTTP_Command=WGET

# ------------------------------------------------------------------------------------------------------------------------

# Copyright 2020 The TB3DS_Termux Project Authors, GinSanaduki.
# All rights reserved.
# TB3DS Scripts provides a function to obtain a list of disciplinary dismissal disposal.
# This Scripts needs GAWK(the GNU implementation of the AWK programming language) version 4.0 or later,
# Tesseract(Optical character recognition engine) version 4.0 or later developed by Google, Original author Ray Smith, Hewlett-Packard,
# Poppler(free software utility library for rendering Portable Document Format (PDF) documents) developed by freedesktop.org,
# and Termux(Android terminal emulator and Linux environment app that works directly with no rooting or setup required) 
# developed by Fredrik Fornwall, Henrik Grimler,  glow(Neo-Oli), Leonid Plyushch and others.

# ------------------------------------------------------------------------------------------------------------------------

BEGIN{
	if(HTTP_Command != "CURL" && HTTP_Command != "WGET"){
		print "Argument Invalid : CURL or WGET";
		exit 99;
	}
	print "#!/bin/sh";
	print "echo Starting HTML download process...";
}

{
	print "ls "$0" > /dev/null 2>&1";
	print "Ret=$?";
	tex = $0;
	sub("EditedHTML_Deux/","https://kanpou.npb.go.jp/",tex);
	if(HTTP_Command == "CURL"){
		print "test $Ret -ne 0 -o ! -s "$0" && echo Downloading "tex" && curl -s -o "$0" "tex" && echo Waiting 10 sec... && sleep 10";
	} else {
		print "test $Ret -ne 0 -o ! -s "$0" &&  echo Downloading "tex" && wget "tex" -O "$0" && echo Waiting 10 sec... && sleep 10";
	}
	print "test $Ret -eq 0 -a -s "$0" && echo "$0" already Existed, download skipped.";
}

END{
	print "echo HTML download process Completed.";
}

