#!/usr/bin/gawk -f
# 09_SubSystem_09.awk
# gawk -f AWKScripts/01_UPDATE/03_SubSystem/09_SubSystem_09.awk

BEGIN{
	FS = "\t";
	EDITTXTFILELIST = "EditedHTML/EditTXTFileList_"strftime("%Y%m%d",systime())".txt";
	Cnt = 1;
	print "#!/bin/sh";
}

{
	Tex = $4;
	gsub("関係","",Tex);
	FName = $5;
	gsub("f.html","",FName);
	print "gawk \047/教育職員免許法\\(昭和24年法律第147号\\)|教育職員免許法第11条|教育職員免許法第10条第1項/,/^"Tex"/{if($0 == \""Tex"\"){exit 0;}else{if($0 != \"\"){print;}}}\047 TempEditedTXT/"FName".txt > EditedTXT/"FName".txt & ";
	print "foo"Cnt"pid=$!";
	Arrays[Cnt][1] = "wait $foo"Cnt"pid";
	Arrays[Cnt][2] = "echo $? > TempRetCode/RetCode_"FName".txt";
	Cnt++;
	print "EditedTXT/"FName".txt" > EDITTXTFILELIST;
}

END{
	for(i in Arrays){
		print Arrays[i][1];
		print Arrays[i][2];
	}
	print "exit 0";
}

