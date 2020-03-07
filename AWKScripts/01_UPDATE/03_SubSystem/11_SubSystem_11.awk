#!/usr/bin/gawk -f
# 11_SubSystem_11.awk
# gawk -f AWKScripts/01_UPDATE/03_SubSystem/11_SubSystem_11.awk

BEGIN{
	print "#!/bin/sh";
	COMPRESSION_DIR="GeneratedFile_"strftime("%Y%m%d",systime());
	Cnt = 1;
}

{
	Tex = $0;
	gsub("/","_",Tex);
	print "cp -P "$0" "COMPRESSION_DIR"/"$0" & ";
	print "foo"Cnt"pid=$!";
	Arrays[Cnt][1] = "wait $foo"Cnt"pid";
	Arrays[Cnt][2] = "echo $? > TempRetCode/RetCode_"Tex".txt";
	Cnt++;
}

END{
	for(i in Arrays){
		print Arrays[i][1];
		print Arrays[i][2];
	}
	print "exit 0";
}

