#! /usr/bin/gawk
# 03_TelecommunicationControl.awk

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

function EditHTTPResponse(){
	# HTMLに対しスパイダを掛け、HTTPレスポンスヘッダを取得する。
	# HTTPレスポンスヘッダは標準エラー出力として出るため、標準出力に統合している。
	if(HTTP_Command == "CURL"){
		cmd = "curl -D - -s  -o /dev/null \""MEXT_URL"\"";
	} else {
		cmd = "wget -q --spider -S \""MEXT_URL"\" 2>&1";
	}
	cnt = 1;
	while(cmd | getline esc){
		HTTPResArrays[cnt] = esc;
		cnt++;
	}
	close(cmd);
	if(HTTP_Command == "WGET"){
		for(i in HTTPResArrays){
			# 先頭の半角スペースを除去
			HTTPResArrays[i] = substr(HTTPResArrays[i],3);
		}
	}
	
	# 以降の仕組みは、mkzipdic_kenall.shを参考にしています。
	# https://github.com/ShellShoccar-jpn/zip2addr/blob/master/data/mkzipdic_kenall.sh
	
	# HTTPリターンコードを取得
	status = 0;
	for(i in HTTPResArrays){
		print HTTPResArrays[i];
		mat = match(HTTPResArrays[i],/^HTTP\//);
		if(mat > 0){
			split(HTTPResArrays[i],SplitLine_HTTP);
			status = SplitLine_HTTP[2];
			delete SplitLine_HTTP;
			break;
		}
	}
	if (status >= 200) {
		return 0;
	} else {
		return 99;
	}
}

# ------------------------------------------------------------------------------------------------------------------------

function GetContents(GetContents_URL,GetContents_OUTFILE){
	if(HTTP_Command == "CURL"){
		cmd = "curl -s -o \""GetContents_OUTFILE"\" \""GetContents_URL"\"";
	} else {
		cmd = "wget -q \""GetContents_URL"\" -O \""GetContents_OUTFILE"\"";
	}
	ExecCmd(cmd);
}

# ------------------------------------------------------------------------------------------------------------------------

function SLEEP(){
	cmd = "sleep 5";
	ExecCmd(cmd);
}

# ------------------------------------------------------------------------------------------------------------------------

function EditHTTPResponse_02(EditHTTPResponse_02_URL){
	# HTMLに対しスパイダを掛け、HTTPレスポンスヘッダを取得する。
	# HTTPレスポンスヘッダは標準エラー出力として出るため、標準出力に統合している。
	if(HTTP_Command == "CURL"){
		cmd = "curl -D - -s  -o /dev/null \""EditHTTPResponse_02_URL"\"";
	} else {
		cmd = "wget -q --spider -S \""EditHTTPResponse_02_URL"\" 2>&1";
	}
	cnt = 1;
	while(cmd | getline esc){
		HTTPResArrays[cnt] = esc;
		cnt++;
	}
	close(cmd);
	if(HTTP_Command == "WGET"){
		for(i in HTTPResArrays){
			# 先頭の半角スペースを除去
			HTTPResArrays[i] = substr(HTTPResArrays[i],3);
		}
	}
	# 以降の仕組みは、mkzipdic_kenall.shを参考にしています。
	# https://github.com/ShellShoccar-jpn/zip2addr/blob/master/data/mkzipdic_kenall.sh
	
	# HTTPリターンコードを取得
	status = 0;
	for(i in HTTPResArrays){
		mat = match(HTTPResArrays[i],/^HTTP\//);
		if(mat > 0){
			split(HTTPResArrays[i],SplitLine_HTTP);
			status = SplitLine_HTTP[2];
			delete SplitLine_HTTP;
			break;
		}
	}
	delete HTTPResArrays;
	if (status >= 200 && status < 300) {
		return 0;
	} else {
		return 99;
	}
}

# ------------------------------------------------------------------------------------------------------------------------

