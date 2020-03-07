#!/usr/bin/gawk -f
# 08_SubSystem_08.awk
# gawk -f AWKScripts/01_UPDATE/03_SubSystem/08_SubSystem_08.awk

BEGIN{
	Cnt = 1;
}

{
	Tex = $0;
	Tex2 = Tex;
	gsub("ConvertedTXT","TempEditedTXT",Tex);
	gsub("ConvertedTXT/","",Tex2);
	print "sed \047$d\047 "$0" | gawk \047{gsub(\" \",\"\"); print;}\047 > "Tex" & ";
	print "foo"Cnt"pid=$!";
	Arrays[Cnt][1] = "wait $foo"Cnt"pid";
	Arrays[Cnt][2] = "echo $? > TempRetCode/RetCode_"Tex2;
	Cnt++;
}

END{
	for(i in Arrays){
		print Arrays[i][1];
		print Arrays[i][2];
	}
	print "exit 0";
}

