#!/usr/bin/gawk
# 02_SubSystem_02.awk
# gawk -f AWKScripts/01_UPDATE/03_SubSystem/02_SubSystem_02.awk -v HTTP_Command=CURL
# gawk -f AWKScripts/01_UPDATE/03_SubSystem/02_SubSystem_02.awk -v HTTP_Command=WGET

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
	FS = "\t";
	if(HTTP_Command != "CURL" && HTTP_Command != "WGET"){
		print "Argument Invalid : CURL or WGET";
		exit 99;
	}
	print "#!/bin/sh";
	print "echo Starting PDF download process...";
	PDFFileList = "EditedHTML/PDFFileList_"strftime("%Y%m%d",systime())".txt";
}

{
	Tex = "AcquiredPDF/"$7;
	print "ls "Tex" > /dev/null 2>&1";
	print "Ret=$?";
	# https://kanpou.npb.go.jp/20200123/20200123g00013/pdf/20200123g000130141.pdf
	# 20200123g000130141.pdf
	YYYYMMDD = substr($7,1,8);
	Part = substr($7,1,14);
	Input = "https://kanpou.npb.go.jp/"YYYYMMDD"/"Part"/pdf/"$7;
	if(HTTP_Command == "CURL"){
		print "test $Ret -ne 0 -o ! -s "Tex" && echo Downloading "Tex" && curl -s -o "Tex" "Input" && echo Waiting 10 sec... && sleep 10";
	} else {
		print "test $Ret -ne 0 -o ! -s "Tex" &&  echo Downloading "Tex" && wget "Input" -O "Tex" && echo Waiting 10 sec... && sleep 10";
	}
	print "test $Ret -eq 0 -a -s "Tex" && echo "Tex" already Existed, download skipped.";
	print Tex > PDFFileList;
}

END{
	print "echo PDF download process Completed.";
}

