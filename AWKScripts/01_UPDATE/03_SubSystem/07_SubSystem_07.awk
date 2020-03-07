#!/usr/bin/gawk -f
# 07_SubSystem_07.awk
# gawk -f AWKScripts/01_UPDATE/03_SubSystem/07_SubSystem_07.awk -v Mode=START
# gawk -f AWKScripts/01_UPDATE/03_SubSystem/07_SubSystem_07.awk -v Mode=END

BEGIN{
	if(Mode != "START" && Mode != "END"){
		print "Invalid Argument.";
		exit 99;
	}
}

{
	if(Mode == "START"){
		print "Starting Time : "strftime("%Y/%m/%d %H:%M:%S",systime())", Command : "$0;
	} else {
		print "End Time : "strftime("%Y/%m/%d %H:%M:%S",systime())", Command : "$0;
	}
}

