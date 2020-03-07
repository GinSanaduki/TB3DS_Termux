#! /usr/bin/gawk
# 04_FileUtils.awk

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

function GetHashValue(GetHashValue_FileName){
	cmd = "sha512sum \""GetHashValue_FileName"\"";
	GetHashValue_hash = RetTextExecCmd(cmd);
	return substr(GetHashValue_hash,1,64);
}

# ------------------------------------------------------------------------------------------------------------------------

function GetHashTable(){
	cmd = "cat \""FNAME_HASH"\"";
	cnt = 1;
	while(cmd | getline esc){
		HashTable[cnt] = esc;
		cnt++;
	}
	close(cmd);
}

# ------------------------------------------------------------------------------------------------------------------------

function ReturnHashValue(ReturnHashValue_FileName){
	print ReturnHashValue_FileName"のハッシュ値を取得します・・・";
	return GetHashValue(ReturnHashValue_FileName);
}

# ------------------------------------------------------------------------------------------------------------------------

