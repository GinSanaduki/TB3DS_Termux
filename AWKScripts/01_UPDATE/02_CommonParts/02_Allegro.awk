#! /usr/bin/gawk
# 02_Allegro.awk

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

function Allegro(){
	# 本日分のAcquiredHTML/List_of_disciplinary_dismissal_disposal_YYYYMMDD.txtの存在確認
	print FNAME"が存在するか確認します・・・";
	cmd = "ls \""FNAME"\" > "OUT_DEVNULL;
	ret = RetExecCmd(cmd);
	# 取得していない場合、取得する
	if(ret == 1){
		Allegro_Sub00();
		return 0;
	}
	# 現在のハッシュリストを確認する
	print FNAME"は取得済です。";
	print FNAME_HASH"に"FNAME"の記載があるかを確認します・・・";
	GetHashTable();
	BitField = 0;
	len = length(HashTable);
	if(len == 0){
		Allegro_Sub00();
		return 0;
	}
	for(i in HashTable){
		split(HashTable[i],HashTableLine,",");
		if(HashTableLine[1] == FNAME){
			BitField = 1;
			break;
		}
		delete HashTableLine;
	}
	if(BitField == 0){
		Allegro_Sub00();
		return 0;
	}
	print FNAME_HASH"に"FNAME"の記載を確認しました。";
	print FNAME_HASH"のETag値、Last-Modified値が一致するかを確認します。";
	Allegro_Sub03();
	if(HashTableLine[3] != ETag){
		print FNAME_HASH"のETag値が不一致でした。";
		print "再取得を行います。";
		Allegro_Sub00();
		return 0;
	}
	if(HashTableLine[4] != YYYYMMDDHHmmSS){
		print FNAME_HASH"のLast-Modified値が不一致でした。";
		print "再取得を行います。";
		Allegro_Sub00();
		return 0;
	}
	print FNAME_HASH"のETag値、Last-Modified値が一致しました。";
	print FNAME"の確認を終了します。";
	delete HashTableLine;
}

# ------------------------------------------------------------------------------------------------------------------------

function Allegro_Sub01(){
	print "国立印刷局HPへの接続が可能か確認します・・・";
	ret = EditHTTPResponse();
	if(ret == 0){
		print "国立印刷局HPへの接続は問題ありませんでした。";
	} else {
		print "国立印刷局HPへの接続に失敗しました。";
		print "システムを終了します。";
		exit 99;
	}
	print "クローラを起動させたため、5秒インターバルを発生させます。";
	SLEEP();
	print "国立印刷局HPからHTMLのダウンロードを開始します・・・。";
	GetContents(MEXT_URL,FNAME);
	print "国立印刷局HPからのHTMLのダウンロードが完了しました。";
}

# ------------------------------------------------------------------------------------------------------------------------

function Allegro_Sub00(){
	Allegro_Sub01();
	Allegro_Sub00_RetHash = ReturnHashValue(FNAME);
	# ファイル名、ハッシュ値
	print FNAME","Allegro_Sub00_RetHash > FNAME_HASH;
	close(FNAME_HASH);
}

# ------------------------------------------------------------------------------------------------------------------------

function Allegro_Sub03(){
	print "国立印刷局HPへの接続が可能か確認します・・・";
	ret = EditHTTPResponse();
	if(ret == 0){
		print "国立印刷局HPへの接続は問題ありませんでした。";
	} else {
		print "国立印刷局HPへの接続に失敗しました。";
		print "システムを終了します。";
		exit 99;
	}
}

# ------------------------------------------------------------------------------------------------------------------------

