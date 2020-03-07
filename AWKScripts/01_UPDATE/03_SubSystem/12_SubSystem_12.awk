#!/usr/bin/gawk -f
# 12_SubSystem_12.awk
# gawk -f AWKScripts/01_UPDATE/03_SubSystem/12_SubSystem_12.awk -v StandbyStart=$StandbyStart

BEGIN{
	StandbyStart = StandbyStart + 0;
	if(StandbyStart < 1){
		StandbyStart = systime();
	}
}

{
	$0 = $0 + 0;
	if(StandbyStart >= $0){
		print StandbyStart;
	} else {
		print;
	}
	exit;
}

