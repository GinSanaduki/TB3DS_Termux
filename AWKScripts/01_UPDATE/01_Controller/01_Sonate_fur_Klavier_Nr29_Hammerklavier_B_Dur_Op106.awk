#! /usr/bin/gawk
# 01_Sonate_fur_Klavier_Nr29_Hammerklavier_B_Dur_Op106.awk
# gawk -f AWKScripts/01_UPDATE/01_Controller/01_Sonate_fur_Klavier_Nr29_Hammerklavier_B_Dur_Op106.awk -v HTTP_Command=CURL
# gawk -f AWKScripts/01_UPDATE/01_Controller/01_Sonate_fur_Klavier_Nr29_Hammerklavier_B_Dur_Op106.awk -v HTTP_Command=WGET

# ------------------------------------------------------------------------------------------------------------------------

# Copyright 2020 The TB3DS_Termux Project Authors, GinSanaduki.
# All rights reserved.
# Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
# TB3DS Scripts provides a function to obtain a list of disciplinary dismissal disposal.
# This Scripts needs GAWK(the GNU implementation of the AWK programming language) version 4.0 or later,
# Tesseract(Optical character recognition engine) version 4.0 or later developed by Google, Original author Ray Smith, Hewlett-Packard,
# Poppler(free software utility library for rendering Portable Document Format (PDF) documents) developed by freedesktop.org,
# and Termux(Android terminal emulator and Linux environment app that works directly with no rooting or setup required) 
# developed by Fredrik Fornwall, Henrik Grimler,  glow(Neo-Oli), Leonid Plyushch and others.

# ------------------------------------------------------------------------------------------------------------------------

@include "AWKScripts/01_UPDATE/02_CommonParts/01_Konzertouverture.awk";
@include "AWKScripts/01_UPDATE/02_CommonParts/02_Allegro.awk";
@include "AWKScripts/01_UPDATE/02_CommonParts/03_TelecommunicationControl.awk";
@include "AWKScripts/01_UPDATE/02_CommonParts/04_FileUtils.awk";

# ------------------------------------------------------------------------------------------------------------------------

BEGIN{
	if(HTTP_Command != "CURL" && HTTP_Command != "WGET"){
		print "Argument Invalid : CURL or WGET";
		exit 99;
	}
	print "Sonate fur Klavier Nr.29 Hammerklavier B-Dur Op.106 will commence shortly.";
	print "START Konzertouverture...";
	Konzertouverture();
	print "END Konzertouverture.";
	print "START Allegro...";
	Allegro();
	print "END Allegro.";
	print "That's all, folks...";
}

