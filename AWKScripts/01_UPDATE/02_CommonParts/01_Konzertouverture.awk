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
	gsub("元","1",ReplaceTarget);
	gsub("平成1年","1989年",ReplaceTarget);
	gsub("平成2年","1990年",ReplaceTarget);
	gsub("平成3年","1991年",ReplaceTarget);
	gsub("平成4年","1992年",ReplaceTarget);
	gsub("平成5年","1993年",ReplaceTarget);
	gsub("平成6年","1994年",ReplaceTarget);
	gsub("平成7年","1995年",ReplaceTarget);
	gsub("平成8年","1996年",ReplaceTarget);
	gsub("平成9年","1997年",ReplaceTarget);
	gsub("平成10年","1998年",ReplaceTarget);
	gsub("平成11年","1999年",ReplaceTarget);
	gsub("平成12年","2000年",ReplaceTarget);
	gsub("平成13年","2001年",ReplaceTarget);
	gsub("平成14年","2002年",ReplaceTarget);
	gsub("平成15年","2003年",ReplaceTarget);
	gsub("平成16年","2004年",ReplaceTarget);
	gsub("平成17年","2005年",ReplaceTarget);
	gsub("平成18年","2006年",ReplaceTarget);
	gsub("平成19年","2007年",ReplaceTarget);
	gsub("平成20年","2008年",ReplaceTarget);
	gsub("平成21年","2009年",ReplaceTarget);
	gsub("平成22年","2010年",ReplaceTarget);
	gsub("平成23年","2011年",ReplaceTarget);
	gsub("平成24年","2012年",ReplaceTarget);
	gsub("平成25年","2013年",ReplaceTarget);
	gsub("平成26年","2014年",ReplaceTarget);
	gsub("平成27年","2015年",ReplaceTarget);
	gsub("平成28年","2016年",ReplaceTarget);
	gsub("平成29年","2017年",ReplaceTarget);
	gsub("平成30年","2018年",ReplaceTarget);
	gsub("平成31年","2019年",ReplaceTarget);
	gsub("令和1年","2019年",ReplaceTarget);
	gsub("令和2年","2020年",ReplaceTarget);
	gsub("令和3年","2021年",ReplaceTarget);
	gsub("令和4年","2022年",ReplaceTarget);
	gsub("令和5年","2023年",ReplaceTarget);
	gsub("令和6年","2024年",ReplaceTarget);
	gsub("令和7年","2025年",ReplaceTarget);
	gsub("令和8年","2026年",ReplaceTarget);
	gsub("令和9年","2027年",ReplaceTarget);
	gsub("令和10年","2028年",ReplaceTarget);
	# 月は大きい部分から変換
	gsub("12月","12",ReplaceTarget);
	gsub("11月","11",ReplaceTarget);
	gsub("10月","10",ReplaceTarget);
	gsub("9月","09",ReplaceTarget);
	gsub("8月","08",ReplaceTarget);
	gsub("7月","07",ReplaceTarget);
	gsub("6月","06",ReplaceTarget);
	gsub("5月","05",ReplaceTarget);
	gsub("4月","04",ReplaceTarget);
	gsub("3月","03",ReplaceTarget);
	gsub("2月","02",ReplaceTarget);
	gsub("1月","01",ReplaceTarget);
	gsub("年","",ReplaceTarget);
	return ReplaceTarget;
}

# ------------------------------------------------------------------------------------------------------------------------

