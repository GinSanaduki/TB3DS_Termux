#!/usr/bin/gawk -f
# 05_SubSystem_05.awk
# gawk -f AWKScripts/01_UPDATE/03_SubSystem/05_SubSystem_05.awk

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
	FS = "\t";
}

{
	split($2,Arrays,"、");
	len = length(Arrays);
	if(len < 2){
		print $1"\t"$2"\t"$3"\t"$4"\t"$4;
		delete Arrays;
		next;
	}
	for(i in Arrays){
		mat = match(Arrays[i],/教育職員免許状/);
		if(mat > 0){
			if(i == len){
				print $1"\t"$2"\t"$3"\t"$4"\t"$4;
				delete Arrays;
				next;
			} else {
				print $1"\t"$2"\t"$3"\t"$4"\t"Arrays[i + 1];
				delete Arrays;
				next;
			}
		}
	}
}

