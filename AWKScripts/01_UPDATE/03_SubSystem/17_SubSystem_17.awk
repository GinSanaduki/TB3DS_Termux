#!/usr/bin/gawk -f
# 17_SubSystem_17.awk
# gawk -f AWKScripts/01_UPDATE/03_SubSystem/17_SubSystem_17.awk -v StandbyEnd=$StandbyEnd

BEGIN{
	StandbyEnd = StandbyEnd + 0;
	if(StandbyEnd <= systime()){
		exit;
	} else {
		exit 1;
	}
}

