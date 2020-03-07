#!/usr/bin/gawk -f
# 08_EditHTML_Deux_SubSystem_08.awk
# gawk -f AWKScripts/01_UPDATE/03_SubSystem/04_SubSystem_04.awk -v PDFFILELIST_Line=$PDFFILELIST_Line

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
	PDFFILELIST_Line = PDFFILELIST_Line + 0;
	if(PDFFILELIST_Line < 1){
		exit 99;
	}
	OCR_Cmd = "tesseract";
	Options = "-l jpn --psm 3 --dpi 450";
	TXTFileList = "EditedHTML/TXTFileList_"strftime("%Y%m%d",systime())".txt";
	RetCode = "RetCode=$?";
	Shebang = "#!/bin/sh";
	# Tesseract OCR 実行判定ビット
	BIT = "BitField=1";
	Condition01 = "test $RetCode -ne 0";
	Condition02 = "test $BitField -eq 1 && "Condition01;
	cmd = "uname -a";
	while(cmd | getline esc){
		break;
	}
	close(cmd);
	split(esc,escArrays);
	OS_Name = escArrays[length(escArrays)];
	delete escArrays;
	AccumulationTime = 0;
	ArraysCnt = 1;
	# OutFileArrays[ArraysCnt][1] : リレービットファイル名
	# OutFileArrays[ArraysCnt][2] : 所要時間
	OutFileArrays[ArraysCnt][1] = "/dev/null";
	OutFileArrays[ArraysCnt][2] = "80";
}

{
	Tex = $0;
	gsub(".pdf","",Tex);
	gsub("AcquiredPDF/","",Tex);
	OutShell = "TempShell/"Tex".sh";
	OutRetCode = "TempRetCode/RetCode_"Tex".txt";
	OutRelayBit = "RelayBit/RelayBit_"Tex".txt";
	OutFileArrays[ArraysCnt][1] = OutRelayBit;
	
	# ファイル存在確認、1バイト以上であることの確認、ハッシュファイルの存在確認、ハッシュ値の照合を行う
	HashFile_PNG = "PNGHash/"Tex".txt";
	HashFile_TXT = "TXTHash/"Tex".txt";
	FromFile =  "ConvertedPNG/"Tex".png";
	ToFile = "ConvertedTXT/"Tex;
	ToFile_02 = "ConvertedTXT/"Tex".txt";
	print ToFile_02 > TXTFileList;
	
	print Shebang > OutShell;
	GeneCheck(FromFile,HashFile_PNG,"PNG");
	print BIT > OutShell;
	GeneCheck(ToFile_02,HashFile_TXT,"TXT");
	print "" > OutShell;
	
	# TXTの判定用ビットが変化しなかった場合、Tesseractをスキップし、
	# 後続のリレービットファイルと復帰値ビットを書き出し、正常終了する。
	SkipEnd_01 = "test $BitField -eq 1 && echo Convert Skipped. : "ToFile_02;
	SkipEnd_02 = "test $BitField -eq 1 && gawk -f AWKScripts/01_UPDATE/03_SubSystem/13_SubSystem_13.awk > "OutFileArrays[ArraysCnt][1];
	SkipEnd_03 = "test $BitField -eq 1 && echo 0 > "OutRetCode;
	SkipEnd_04 = "test $BitField -eq 1 && exit 0";
	
	Tesseract = OCR_Cmd" "FromFile" "ToFile" "Options" > /dev/null 2>&1";
	SignalStart = "echo OCR Scan and Convert Start... : From "FromFile" , To "ToFile_02;
	TimeSignal_Start = "echo \""Tesseract"\" | gawk -f AWKScripts/01_UPDATE/03_SubSystem/07_SubSystem_07.awk -v Mode=START";
	SignalStop = "echo OCR Scan and Completed. : "ToFile_02;
	TimeSignal_End = "echo \""Tesseract"\" | gawk -f AWKScripts/01_UPDATE/03_SubSystem/07_SubSystem_07.awk -v Mode=END";
	GetHash = "sha512sum "ToFile_02" > "HashFile_TXT;
	
	# ハッシュ値が一致した場合は正常終了
	print SkipEnd_01 > OutShell;
	print SkipEnd_02 > OutShell;
	print SkipEnd_03 > OutShell;
	print SkipEnd_04 > OutShell;
	print "" > OutShell;
	# 実行予定時間を算出する
	OutFileArrays[ArraysCnt][2] = CalcExecTime(FromFile);
	# 累積時間
	# AccumulationTime = AccumulationTime + ExecTime;
	switch(PDFFILELIST_Line){
		case "1":
			# Shellが単発の場合、並列の時間間隔を考慮する必要はない
			break;
		case "2":
			switch(FNR){
				case "1":
					# 並列処理を行う都合上、起動時間アナウンス表示の順序を担保するためにsleepさせる
					print "sleep 1" > OutShell;
					break;
				default:
					Infinity_01();
					break;
			}
			break;
		default:
			switch(FNR){
				case "1":
					# 並列処理を行う都合上、起動時間アナウンス表示の順序を担保するためにsleepさせる
					print "sleep 1" > OutShell;
					break;
				case "2":
					Infinity_01();
					break;
				default:
					Infinity_02();
					break;
			}
	}
	
	RelayCheck();
	Announcement();
	print SignalStart > OutShell;
	print TimeSignal_Start > OutShell;
	print Tesseract > OutShell;
	print RetCode > OutShell;
	print "" > OutShell;
	
	print Condition01" && echo Convert Failed. : "ToFile_02 > OutShell;
	# 最終Shellに対しては、リレービットファイル作成命令は出さない
	if(FNR < PDFFILELIST_Line){
		print Condition01" && gawk -f AWKScripts/01_UPDATE/03_SubSystem/13_SubSystem_13.awk > "OutFileArrays[ArraysCnt][1] > OutShell;
	}
	print Condition01" && echo 1 > "OutRetCode > OutShell;
	print Condition01" && exit 99" > OutShell;
	print "" > OutShell;
	
	print TimeSignal_End > OutShell;
	print SignalStop > OutShell;
	print GetHash > OutShell;
	print "echo 0 > "OutRetCode > OutShell;
	# 最終Shellに対しては、リレービットファイル作成命令は出さない
	if(FNR < PDFFILELIST_Line){
		print "gawk -f AWKScripts/01_UPDATE/03_SubSystem/13_SubSystem_13.awk > "OutFileArrays[ArraysCnt][1] > OutShell;
	}
	print "exit 0" > OutShell;
	print "" > OutShell;
	
	ArraysCnt++;
}

END{
	delete OutFileArrays;
}

# ------------------------------------------------------------------------------------------------------------------------

function GeneCheck(TARGETFILE,HASHFILE,MODE){
	CheckCmd01 = "ls "TARGETFILE" > /dev/null 2>&1";
	CheckCmd02 = "test -s "TARGETFILE;
	CheckCmd03 = "ls "HASHFILE" > /dev/null 2>&1";
	CheckCmd04 = "test -s "HASHFILE;
	CheckCmd05 = "sha512sum --status -c "HASHFILE" > /dev/null 2>&1";
	switch(MODE){
		case "PNG":
			# ファイルチェックで異常を検知した場合、
			# 後続のリレービットファイルと復帰値ビットを書き出し、異常終了する。
			TestCmd01 = Condition01" && echo \""TARGETFILE" not found.\"";
			TestCmd02 = Condition01" && echo \""TARGETFILE" filesize is zero.\"";
			TestCmd03 = Condition01" && echo \""HASHFILE" not found.\"";
			TestCmd04 = Condition01" && echo \""HASHFILE" filesize is zero.\"";
			TestCmd05 = Condition01" && echo \"As a result of the hash value comparison, the hash values ​​do not match. PNG File : "TARGETFILE". Hash File : "HASHFILE"\"";
			Common01 = Condition01" && gawk -f AWKScripts/01_UPDATE/03_SubSystem/13_SubSystem_13.awk > "OutFileArrays[ArraysCnt][1];
			Common02 = Condition01" && echo 1 > "OutRetCode;
			Common03 = Condition01" && exit 99";
			break;
		case "TXT":
			TestCmd01 = Condition02" && echo \""ToFile_02" not found. Therefore, perform OCR.\"";
			TestCmd02 = Condition02" && echo \""ToFile_02" filesize is zero. Therefore, perform OCR.\"";
			TestCmd03 = Condition02" && echo \""HashFile_TXT" not found. Therefore, perform OCR.\"";
			TestCmd04 = Condition02" && echo \""HashFile_TXT" filesize is zero. Therefore, perform OCR.\"";
			TestCmd05 = Condition02" && echo \"As a result of the hash value comparison, the hash values ​​do not match. Therefore, perform OCR. TXT File : "ToFile_02". Hash File : "HashFile_TXT"\"";
			Common01 = Condition02" && BitField=0";
			Common02 = ":";
			Common03 = ":";
			break;
		default:
			exit 99;
	}
	
	print CheckCmd01 > OutShell;
	print RetCode > OutShell;
	print TestCmd01 > OutShell;
	Common();
	
	print CheckCmd02 > OutShell;
	print RetCode > OutShell;
	print TestCmd02 > OutShell;
	Common();
	
	print CheckCmd03 > OutShell;
	print RetCode > OutShell;
	print TestCmd03 > OutShell;
	Common();
	
	print CheckCmd04 > OutShell;
	print RetCode > OutShell;
	print TestCmd04 > OutShell;
	Common();
	
	print CheckCmd05 > OutShell;
	print RetCode > OutShell;
	print TestCmd05 > OutShell;
	Common();
}

# ------------------------------------------------------------------------------------------------------------------------

function CalcExecTime(TARGETFILE,CalcRetCode){
	# PNGファイルの容量のデフォルト値
	MB = 3.0;
	cmd = "ls "TARGETFILE" > /dev/null 2>&1";
	CalcRetCode = system(cmd);
	close(cmd);
	# 取得に失敗した場合は、デフォルト値の容量を使用する。
	if(CalcRetCode == 0){
		cmd = "ls -l "TARGETFILE" | gawk -f AWKScripts/01_UPDATE/03_SubSystem/14_SubSystem_14.awk | gawk -f AWKScripts/01_UPDATE/03_SubSystem/15_SubSystem_15.awk | tr -d \047 \047";
		while(cmd | getline Capacity){
			break;
		}
		close(cmd);
		MB = Capacity;
	}
	# 0.1MB換算の要する時間は2.232秒
	NeedSec = 2.232 * MB * 10;
	# Androidの場合、CPUが4GBだと、およそ6倍の時間がかかる。
	# まして、他に何もしていないことは考えにくいので、1.4のバッファを見込む。
	if(OS_Name == "Android"){
		NeedSec = NeedSec * 6 * 1.4;
	}
	return int(NeedSec);
}

# ------------------------------------------------------------------------------------------------------------------------

function Infinity_01(){
	Infinity_Common01();
	# 2件目のShellは、以下の条件のいずれかを充足した場合に待機ループを抜け、
	# Tesseractを起動する。
	# 1. Tesseractプロセスが0
	# 2. 1件目のShellに対する待機時間を超過
	# 3. 1件目のShellのリレービットファイルが存在
	Infinity_Common02();
	# 3. 1件目のShellのリレービットファイルが存在
	print "	ls "OutFileArrays[ArraysCnt - 1][1]" > /dev/null 2>&1" > OutShell;
	Infinity_Common03();
	print "		START_TIME=`gawk -f AWKScripts/01_UPDATE/03_SubSystem/12_SubSystem_12.awk -v StandbyStart=$StandbyStart "OutFileArrays[ArraysCnt - 1][1]"`" > OutShell;
	Infinity_Common04();
}

# ------------------------------------------------------------------------------------------------------------------------

function Announcement(){
	if(OutFileArrays[ArraysCnt][2] < 60){
		print "echo \"実行に要する時間は"OutFileArrays[ArraysCnt][2]"秒です。\"" > OutShell;
	} else {
		Quotient = int(OutFileArrays[ArraysCnt][2] / 60);
		Remainder = OutFileArrays[ArraysCnt][2] - Quotient * 60;
		print "echo \"実行に要する時間は"Quotient"分"Remainder"秒です。\"" > OutShell;
	}
	print "" > OutShell;
	print "ExecTime="OutFileArrays[ArraysCnt][2] > OutShell;
	# print "gawk -f AWKScripts/01_UPDATE/03_SubSystem/19_SubSystem_19.awk -v START_TIME=$START_TIME -v ExecTime=$ExecTime" > OutShell;
	print "gawk -f AWKScripts/01_UPDATE/03_SubSystem/19_SubSystem_19.awk -v ExecTime=$ExecTime" > OutShell;
}

# ------------------------------------------------------------------------------------------------------------------------

function Infinity_02(){
	Infinity_Common01();
	# 3件目以降のShellは、以下の条件のいずれかを充足した場合に待機ループを抜け、
	# Tesseractを起動する。
	# 1. Tesseractプロセスが0
	# 2. n件目 - 1のShellに対する待機時間を超過
	# 3. n件目 - 2のShellのリレービットファイルが存在
	Infinity_Common02();
	# 3. n件目 - 2のShellのリレービットファイルが存在
	print "	ls "OutFileArrays[ArraysCnt - 2][1]" > /dev/null 2>&1" > OutShell;
	Infinity_Common03();
	print "		START_TIME=`gawk -f AWKScripts/01_UPDATE/03_SubSystem/12_SubSystem_12.awk -v StandbyStart=$StandbyStart "OutFileArrays[ArraysCnt - 2][1]"`" > OutShell;
	Infinity_Common04();
	# プロセスが1以下の場合に、Tesseractを起動する。
	print "while true" > OutShell;
	print "do" > OutShell;
	print "	Cnt=`ps -aux | fgrep \047tesseract\047 | grep -v grep | gawk -f AWKScripts/01_UPDATE/03_SubSystem/16_SubSystem_16.awk`" > OutShell;
	print "	test $Cnt -le 1 && BREAKBit=1 && break" > OutShell;
	# 1秒から7秒の間でsleep
	print "	od -A n -t u4 -N 4 /dev/urandom | sed 's/[^0-9]//g' | gawk -f AWKScripts/01_UPDATE/03_SubSystem/18_SubSystem_18.awk" > OutShell;
	print "	RetCode=$?" > OutShell;
	print "	sleep $RetCode" > OutShell;
	print "done" > OutShell;
}

# ------------------------------------------------------------------------------------------------------------------------

function Infinity_Common01(){
	# 待機開始時間（UNIX時刻）
	print "StandbyStart=`gawk -f AWKScripts/01_UPDATE/03_SubSystem/13_SubSystem_13.awk`" > OutShell;
	# 待機終了時間（UNIX時刻）
	# Tesseractが物理CPUをフルで使用しなくなるのは終了2秒前から1秒前にかけてなので、
	# 2秒手前からスタートする。
	# Androidの場合は、元のCPUが貧弱なので、あまりそのあたりの考慮をしても、
	# 目立った高速化にはならないが・・・。
	print "PreExecTime="OutFileArrays[ArraysCnt - 1][2] > OutShell;
	print "StandbyEnd=`gawk -f AWKScripts/01_UPDATE/03_SubSystem/20_SubSystem_20.awk -v StandbyStart=$StandbyStart -v PreExecTime=$PreExecTime`" > OutShell;
}

# ------------------------------------------------------------------------------------------------------------------------

function Infinity_Common02(){
	print "BREAKBit=0" > OutShell;
	print "while true" > OutShell;
	print "do" > OutShell;
	# 1. Tesseractプロセスが0
	print "	Cnt=`ps -aux | fgrep \047tesseract\047 | grep -v grep | gawk -f AWKScripts/01_UPDATE/03_SubSystem/16_SubSystem_16.awk`" > OutShell;
	print "	test $Cnt -eq 0 && BREAKBit=1 && break" > OutShell;
	# 2. 1件目(n件目- 1)のShellに対する待機時間を超過
	print "	gawk -f AWKScripts/01_UPDATE/03_SubSystem/17_SubSystem_17.awk -v StandbyEnd=$StandbyEnd" > OutShell;
	print "	RetCode=$?" > OutShell;
	print "	test $RetCode -eq 0 && gawk -f AWKScripts/01_UPDATE/03_SubSystem/13_SubSystem_13.awk > "OutFileArrays[ArraysCnt][1] > OutShell;
	print "	test $RetCode -eq 0 && BREAKBit=2 && break" > OutShell;
}

# ------------------------------------------------------------------------------------------------------------------------

function Common(){
	print Common01 > OutShell;
	print Common02 > OutShell;
	print Common03 > OutShell;
}

# ------------------------------------------------------------------------------------------------------------------------

function Infinity_Common03(){
	print "	RetCode=$?" > OutShell;
	print "	test $RetCode -eq 0 && BREAKBit=3 && break" > OutShell;
	# 1秒から7秒の間でsleep
	print "	od -A n -t u4 -N 4 /dev/urandom | sed 's/[^0-9]//g' | gawk -f AWKScripts/01_UPDATE/03_SubSystem/18_SubSystem_18.awk" > OutShell;
	print "	RetCode=$?" > OutShell;
	print "	sleep $RetCode" > OutShell;
	print "" > OutShell;
	print "done" > OutShell;
	print "" > OutShell;
	# BREAKBitが3の場合、リレービットファイルに記載されている
	# 1件目のShellのTesseractの終了時刻のUNIX時刻を取得する。
	# StandbyStartより小さい値の場合、現在時刻を設定する。
	print "case \"$BREAKBit\" in" > OutShell;
	print "	\"3\")" > OutShell;
}

# ------------------------------------------------------------------------------------------------------------------------

function Infinity_Common04(){
	print "		;;" > OutShell;
	print "	*)" > OutShell;
	print "		START_TIME=`gawk -f AWKScripts/01_UPDATE/03_SubSystem/13_SubSystem_13.awk`" > OutShell;
	print "		;;" > OutShell;
	print "esac" > OutShell;
	print "" > OutShell;
}

# ------------------------------------------------------------------------------------------------------------------------

function RelayCheck(){
	if(ArraysCnt < 2){
		return;
	}
	print "while true" > OutShell;
	print "do" > OutShell;
	for(i in OutFileArrays){
		if(i == ArraysCnt){
			break;
		}
		print "ls "OutFileArrays[i][1]" > /dev/null 2>&1" > OutShell;
		print "RelayCheck_"i"=$?" > OutShell;
	}
	RelayCheckTex = "";
	for(i in OutFileArrays){
		if(i == ArraysCnt){
			break;
		}
		RelayCheckTex = RelayCheckTex"test $RelayCheck_"i" -eq 0 && ";
	}
	RelayCheckTex = RelayCheckTex" break";
	print RelayCheckTex > OutShell;
	# 1秒から7秒の間でsleep
	print "	od -A n -t u4 -N 4 /dev/urandom | sed 's/[^0-9]//g' | gawk -f AWKScripts/01_UPDATE/03_SubSystem/18_SubSystem_18.awk" > OutShell;
	print "	RetCode=$?" > OutShell;
	print "	sleep $RetCode" > OutShell;
	print "done" > OutShell;
}

# ------------------------------------------------------------------------------------------------------------------------

