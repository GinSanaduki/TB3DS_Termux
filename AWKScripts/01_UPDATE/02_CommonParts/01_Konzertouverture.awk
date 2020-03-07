#! /usr/bin/gawk
# 01_Konzertouverture.awk

# ------------------------------------------------------------------------------------------------------------------------

# Copyright 2020 The TB3DS_Termux Project Authors, GinSanaduki.
# All rights reserved.
# Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
# TB3DS Scripts provides a function to obtain a list of disciplinary dismissal disposal.
# This Scripts needs GAWK(the GNU implementation of the AWK programming language) version 4.0 or later,
# Tesseract(Optical character recognition engine) version 4.0 or later developed by Google, Original author Ray Smith, Hewlett-Packard,
# Poppler(free software utility library for rendering Portable Document Format (PDF) documents) developed by freedesktop.org,
# and Termux(Android terminal emulator and Linux environment app that works directly with no rooting or setup required) 
# developed by Fredrik Fornwall, Henrik Grimler,  glow(Neo-Oli), Leonid Plyushch and others.

# ------------------------------------------------------------------------------------------------------------------------

function Konzertouverture(){
	Declaration();
	DirPrep();
}

# ------------------------------------------------------------------------------------------------------------------------

function Declaration(){
	MEXT_URL = "https://kanpou.npb.go.jp/";
	HTML_FILENAME = "List_of_disciplinary_dismissal_disposal_"strftime("%Y%m%d",systime())".txt";
	DIR_HTML = "AcquiredHTML";
	DIR_HTML_EDIT = "EditedHTML";
	DIR_HTML_EDIT_DEUX = "EditedHTML_Deux";
	DIR_HTML_EDIT_TROIS = "EditedHTML_Trois";
	DIR_HASHCONF = "HashConf";
	DIR_DEFINECSV = "DefineCSV";
	DIR_ACQUIREDPDF = "AcquiredPDF";
	FNAME = DIR_HTML"/"HTML_FILENAME;
	FNAME_EDIT = DIR_HTML_EDIT"/"HTML_FILENAME;
	FNAME_HASH = DIR_HASHCONF"/HashInfo_"strftime("%Y%m%d",systime())".def";
	CALL_GAWK = "gawk";
	OUT_DEVNULL = "/dev/null 2>&1";
}

# ------------------------------------------------------------------------------------------------------------------------

function DirPrep(){
	MD(DIR_HTML);
	MD(DIR_HTML_EDIT);
	MD(DIR_HTML_EDIT_DEUX);
	MD(DIR_HTML_EDIT_TROIS);
	MD(DIR_ACQUIREDPDF);
	MD(DIR_HASHCONF);
	cmd = "touch "FNAME_HASH;
	ExecCmd(cmd);
	GENEHASH();
}

# ------------------------------------------------------------------------------------------------------------------------

function ExecCmd(CMDTEXT){
	system(CMDTEXT);
	close(CMDTEXT);
}

# ------------------------------------------------------------------------------------------------------------------------

function RetExecCmd(CMDTEXT){
	RETVAL = system(CMDTEXT);
	close(CMDTEXT);
	return RETVAL;
}

# ------------------------------------------------------------------------------------------------------------------------

function RetTextExecCmd(CMDTEXT){
	while(CMDTEXT | getline RetTextExecCmdEsc){
		break;
	}
	close(CMDTEXT);
	return RetTextExecCmdEsc;
}

# ------------------------------------------------------------------------------------------------------------------------

function MD(DIR_MD){
	CMD_MD = "mkdir -p \""DIR_MD"\" > "OUT_DEVNULL;
	ExecCmd(CMD_MD);
}

# ------------------------------------------------------------------------------------------------------------------------

function RM(DIR_RM){
	CMD_RM = " rm -r \""DIR_RM"\" > "OUT_DEVNULL;
	ExecCmd(CMD_RM);
}

# ------------------------------------------------------------------------------------------------------------------------

function MDRM(DIR_MDRM){
	RM(DIR_MDRM);
	MD(DIR_MDRM);
}

# ------------------------------------------------------------------------------------------------------------------------

function GENEHASH(){
	cmd = "ls "DIR_HASHCONF" > "OUT_DEVNULL;
	ret = RetExecCmd(cmd);
	if(ret == 1){
		HASHMAKE();
	}
	cmd = "ls "FNAME_HASH" > "OUT_DEVNULL;
	ret = RetExecCmd(cmd);
	if(ret == 1){
		HASHMAKE();
	}
	cmd = "find "FNAME_HASH" -size 0";
	ret = RetTextExecCmd(cmd);
	if(ret != ""){
		HASHMAKE();
	}
}

# ------------------------------------------------------------------------------------------------------------------------

function HASHMAKE(){
	MD(DIR_HASHCONF);
	cmd = "touch "FNAME_HASH;
	ExecCmd(cmd);
}

# ------------------------------------------------------------------------------------------------------------------------

function RepYears(ReplaceTarget){
	gsub("��","1",ReplaceTarget);
	gsub("����1�N","1989�N",ReplaceTarget);
	gsub("����2�N","1990�N",ReplaceTarget);
	gsub("����3�N","1991�N",ReplaceTarget);
	gsub("����4�N","1992�N",ReplaceTarget);
	gsub("����5�N","1993�N",ReplaceTarget);
	gsub("����6�N","1994�N",ReplaceTarget);
	gsub("����7�N","1995�N",ReplaceTarget);
	gsub("����8�N","1996�N",ReplaceTarget);
	gsub("����9�N","1997�N",ReplaceTarget);
	gsub("����10�N","1998�N",ReplaceTarget);
	gsub("����11�N","1999�N",ReplaceTarget);
	gsub("����12�N","2000�N",ReplaceTarget);
	gsub("����13�N","2001�N",ReplaceTarget);
	gsub("����14�N","2002�N",ReplaceTarget);
	gsub("����15�N","2003�N",ReplaceTarget);
	gsub("����16�N","2004�N",ReplaceTarget);
	gsub("����17�N","2005�N",ReplaceTarget);
	gsub("����18�N","2006�N",ReplaceTarget);
	gsub("����19�N","2007�N",ReplaceTarget);
	gsub("����20�N","2008�N",ReplaceTarget);
	gsub("����21�N","2009�N",ReplaceTarget);
	gsub("����22�N","2010�N",ReplaceTarget);
	gsub("����23�N","2011�N",ReplaceTarget);
	gsub("����24�N","2012�N",ReplaceTarget);
	gsub("����25�N","2013�N",ReplaceTarget);
	gsub("����26�N","2014�N",ReplaceTarget);
	gsub("����27�N","2015�N",ReplaceTarget);
	gsub("����28�N","2016�N",ReplaceTarget);
	gsub("����29�N","2017�N",ReplaceTarget);
	gsub("����30�N","2018�N",ReplaceTarget);
	gsub("����31�N","2019�N",ReplaceTarget);
	gsub("�ߘa1�N","2019�N",ReplaceTarget);
	gsub("�ߘa2�N","2020�N",ReplaceTarget);
	gsub("�ߘa3�N","2021�N",ReplaceTarget);
	gsub("�ߘa4�N","2022�N",ReplaceTarget);
	gsub("�ߘa5�N","2023�N",ReplaceTarget);
	gsub("�ߘa6�N","2024�N",ReplaceTarget);
	gsub("�ߘa7�N","2025�N",ReplaceTarget);
	gsub("�ߘa8�N","2026�N",ReplaceTarget);
	gsub("�ߘa9�N","2027�N",ReplaceTarget);
	gsub("�ߘa10�N","2028�N",ReplaceTarget);
	# ���͑傫����������ϊ�
	gsub("12��","12",ReplaceTarget);
	gsub("11��","11",ReplaceTarget);
	gsub("10��","10",ReplaceTarget);
	gsub("9��","09",ReplaceTarget);
	gsub("8��","08",ReplaceTarget);
	gsub("7��","07",ReplaceTarget);
	gsub("6��","06",ReplaceTarget);
	gsub("5��","05",ReplaceTarget);
	gsub("4��","04",ReplaceTarget);
	gsub("3��","03",ReplaceTarget);
	gsub("2��","02",ReplaceTarget);
	gsub("1��","01",ReplaceTarget);
	gsub("�N","",ReplaceTarget);
	return ReplaceTarget;
}

# ------------------------------------------------------------------------------------------------------------------------

