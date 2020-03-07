#!/usr/bin/gawk -f
# gawk -f AWKScripts/01_UPDATE/03_SubSystem/03_SubSystem_03.awk

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
	cmd_base = "pdftoppm";
	option = "-png -r 450";
	PNGFileList = "EditedHTML/PNGFileList_"strftime("%Y%m%d",systime())".txt";
}

{

	Tex = $0;
	gsub(".pdf","",Tex);
	gsub("AcquiredPDF/","",Tex);
	HashFile = "PNGHash/"Tex".txt";
	
	# PDF変換後のPNGに対するハッシュ値ファイルの存在を確認
	print "#!/bin/sh" > "TempShell/"Tex".sh";
	print "FailBitField=0" > "TempShell/"Tex".sh";
	print "ls "HashFile" > /dev/null 2>&1" > "TempShell/"Tex".sh";
	print "RetCode01=$?" > "TempShell/"Tex".sh";
	
	# 正常終了の場合、ハッシュ値を検証
	FromFile = $0;
	ToFile = "ConvertedPNG/"Tex;
	ToFile_02 = "ConvertedPNG/"Tex"-1.png";
	ToFile_03 = "ConvertedPNG/"Tex".png";
	print ToFile_03 > PNGFileList;
	print "BitField=1" > "TempShell/"Tex".sh";
	print "test $RetCode01 -eq 0 && sha512sum --status -c "HashFile" > /dev/null 2>&1" > "TempShell/"Tex".sh";
	print "RetCode02=$?" > "TempShell/"Tex".sh";
	
	# RetCode01かRetCode02が0以外の場合、pdftoppmを実行
	cmd01 = "echo Convert START... : From "FromFile" , To "ToFile_03;
	cmd02 = cmd_base" "option" "FromFile" "ToFile" > /dev/null 2>&1";
	cmd03 = "mv "ToFile_02" "ToFile_03" > /dev/null 2>&1";
	cmd04 = "echo Convert Completed. : "ToFile_03;
	cmd05 = "sha512sum "ToFile_03" > "HashFile;
	print "test $RetCode01 -eq 0 -a $RetCode02 -eq 0 && BitField=0" > "TempShell/"Tex".sh";
	print "test $BitField -eq 0 && echo Convert Skipped. : "ToFile_03 > "TempShell/"Tex".sh";
	print "test $BitField -ne 0 && echo Convert START... : From "FromFile" , To "ToFile_03" && "cmd_base" "option" "FromFile" "ToFile" > /dev/null 2>&1" > "TempShell/"Tex".sh";
	print "RetCode03=$?" > "TempShell/"Tex".sh";
	print "test $BitField -ne 0 -a $RetCode03 -ne 0 && echo Convert Failed. : "ToFile_03" && FailBitField=1" > "TempShell/"Tex".sh";
	print "test $BitField -ne 0 -a $RetCode03 -eq 0 && mv "ToFile_02" "ToFile_03" > /dev/null 2>&1 && echo Convert Completed. : "ToFile_03" && sha512sum "ToFile_03" > "HashFile > "TempShell/"Tex".sh";
	print "echo $FailBitField > TempRetCode/RetCode_"Tex".txt" > "TempShell/"Tex".sh";
}

