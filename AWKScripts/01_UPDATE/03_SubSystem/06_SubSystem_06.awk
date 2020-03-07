#!/usr/bin/gawk -f
# 06_SubSystem_06.awk
# gawk -f AWKScripts/01_UPDATE/03_SubSystem/06_SubSystem_06.awk

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
	cmd = "uname -a";
	while(cmd | getline esc){
		break;
	}
	close(cmd);
	split(esc,escArrays);
	OS_Name = escArrays[length(escArrays)];
	if(OS_Name == "Android"){
		cmd = "cat /proc/cpuinfo | fgrep 'CPU part' | wc -l";
		while(cmd | getline PhysicalCPU){
			break;
		}
		close(cmd);
		exit PhysicalCPU - 1;
	} else {
		cmd = "cat /proc/cpuinfo | fgrep 'cpu cores' | uniq";
		while(cmd | getline PhysicalCores){
			break;
		}
		close(cmd);
		split(PhysicalCores,PhysicalCoresArrays,":");
		PhysicalCores = PhysicalCoresArrays[2];
		gsub(" ","",PhysicalCores);
		cmd = "cat /proc/cpuinfo | fgrep 'physical id' | sort | uniq | wc -l";
		while(cmd | getline PhysicalCPU){
			break;
		}
		close(cmd);
		exit PhysicalCores * PhysicalCPU + 1;
	}
}

