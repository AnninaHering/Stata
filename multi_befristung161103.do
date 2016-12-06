* Datenanalyse Dissertation: Sub Do-File multi_befristung161103
* Autorin: Annina T. Hering
********************************************************************************
//**//////////////////////////////////////////////////////////////////////////**
** Schritt 22: Finale Analysen Dissertationsmanuskript
//**//////////////////////////////////////////////////////////////////////////**
********************************************************************************
* Schritt 22.3.: Kapitel 7 Befristung: Multivariate Analysen
********************************************************************************
/* Übersicht:
	Schritt 22.3.1.: Gesamtdeutschland
	Schritt 22.3.2.: Nur für NEL
	Schritt 22.3.3.: Nur für Ehen
	Schritt 22.3.4.: Nur Westdeutschland
	Schritt 22.3.5.: Ostdeutschland
	Schritt 22.3.6.: Interaktionen Partnerschaftsstatus
	Schritt 22.3.7.: Metrische Modellierung für Anhang
	Schritt 22.3.8.: Befristung und Sorgen
	Schritt 22.3.9.: Interaktion Befristung und Sorgen Arbeitsplatzsicherheit 
	Schritt 22.3.10.: Interaktion Befristung und Sorgen ökonomische Situation
	Schritt 22.3.11.: Partnercharakteristika
	Schritt 22.3.12.: Tabellen für Manuskript
	Schritt 22.3.13.: Predictive Margins	
*/
	
*****************************************
* 22.3.1. Gesamtdeutschland
*****************************************
**************
*** 22.3.1.1. Gewichtet
**************
// Nummerierung der Modelle ("eststo xy") ist nicht durchgehend, fehlende Nummerierungen habe ich gelöscht, da ich sie nicht benötige

* Jobwechsel + Dummy Befristung
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb ib1.Hbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 ///
	flag_work_jobch flag_befr ///
	[pweight=lbclgewicht] if welle>=1995, vce(cl persnr)
eststo befr3b_02

* Jobwechsel + Dauer Befristung
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb ib1.Kbefr ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	flag_berufl_zwei flag_hinc flag_relpar flag_work flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995, vce(cl persnr)
eststo befr3c_02

logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 ///
	flag_work_jobch flag_befr ///
	[pweight=lbclgewicht] if welle>=1995, vce(cl persnr)
eststo befr3d_02 

	logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 ///
	flag_work_jobch flag_befr ///
	[pweight=lbclgewicht] if welle>=1995, vce(cl persnr)
	eststo befr3d_02b //Partnererwerbsstatus kontrolliert
	
**************
*** 22.3.1.2. Ohne Gewichtung
**************
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb 1.Hbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	flag_berufl_zwei flag_hinc flag_relpar  flag_gesamt2 ///
	flag_work_jobch flag_befr ///
	if welle>=1995, vce(cl persnr)
	eststo befr3b_02_ohne

logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb ib1.Kbefr ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	flag_berufl_zwei flag_hinc flag_relpar flag_work flag_gesamt2 ///
	flag_befr ///
	if welle>=1995, vce(cl persnr)
	eststo befr3c_02_ohne

logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 ///
	flag_work_jobch flag_befr ///
	if welle>=1995, vce(cl persnr)
	eststo befr3d_02_ohne	
	
	logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
		ib3.Irelpar ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
		ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
		ib0.partner_erwerb ///
		flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 ///
		flag_work_jobch flag_befr ///
		if welle>=1995, vce(cl persnr)
		eststo befr3d_02b_ohne //Partnererwerbsstatus kontrolliert

*****************************************
* 22.3.2. Nur für NEL
*****************************************
**************
*** 22.3.2.1. Gewichtung
**************		
// flag_relpar, flag_work, flag_work_jobch raus
* Jobwechsel + Dummy Befristung
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Hbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & Irelpar==2, vce(cl persnr)
eststo befr3b_02_nel

	logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
		ib0.erwerb ib1.Hbefr jobch_dum ib0.kum_arbeitslos_brose ///
		ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
		ib0.partner_erwerb ///
		flag_berufl_zwei flag_hinc flag_gesamt2 ///
		flag_befr ///
		[pweight=lbclgewicht] if welle>=1995 & Irelpar==2, vce(cl persnr)
	eststo befr3b_02_nel2

* Jobwechsel + Dauer Befristung
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & Irelpar==2, vce(cl persnr)
eststo befr3c_02_nel

logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & Irelpar==2, vce(cl persnr)
eststo befr3d_02_nel

	logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & Irelpar==2, vce(cl persnr)
	eststo befr3d_02b_nel //Partnererwerbsstatus kontrolliert, flag_work_jobch keine Fälle
	
	pwcompare Kbefr, effects
	matrix rename r(table_vs) pw_Kbefr_nel 
	
	margins Kbefr
	marginsplot, xlabel(0 "0" 1 "1" 2 "2" 3 "3" 4 ">4") ///
		subtitle ("Predictive Margins") ///
		title("Dauer Befristung für unverheiratete Frauen") ///
		xtitle("Jahre in Befristung") ///
		ytitle("Pr(Geburt des ersten Kindes)") ///
		yscale(range(0.3(0.05)0.25)) ///
		note ("SOEP v29 1995-2012, gewichtete Berechnungen") ///
		name(Kbefr_nel, replace) scheme(s2mono) noci

	margins Kbefr, pwcompare(effect)
	matrix rename r(table_vs) pw_margins_Kbefr_nel 
	
	* Interaktion Jobwechsel und West-Ost
	logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr jobch_dum##ib0.west ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & Irelpar==2, vce(cl persnr)
	eststo befr3d_02c_nel //Partnererwerbsstatus kontrolliert, flag_work_jobch keine Fälle
	
	
**************
*** 22.3.2.2. Ohne Gewichtung
**************		
* 
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Hbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	if welle>=1995 & Irelpar==2, vce(cl persnr)
eststo befr3b_02_nel_ohne

* Jobwechsel + Dauer Befristung
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	if welle>=1995 & Irelpar==2, vce(cl persnr)
eststo befr3c_02_nel_ohne

logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	if welle>=1995 & Irelpar==2, vce(cl persnr)
eststo befr3d_02_nel_ohne

	logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	if welle>=1995 & Irelpar==2, vce(cl persnr)
	eststo befr3d_02b_nel_ohne //Partnererwerbsstatus kontrolliert, flag_work_jobch keine Fälle

*****************************************
* 22.3.3. Nur für Ehe
*****************************************
**************
*** 22.3.3.1. Gewichtung
**************
// flag_relpar, flag_work, flag_work_jobch raus
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Hbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & Irelpar==3, vce(cl persnr)
eststo befr3b_02_ehe

	logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
		ib0.erwerb ib1.Hbefr jobch_dum ib0.kum_arbeitslos_brose ///
		ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
		ib0.partner_erwerb ///
		flag_berufl_zwei flag_hinc flag_gesamt2 ///
		flag_befr ///
		[pweight=lbclgewicht] if welle>=1995 & Irelpar==3, vce(cl persnr)
	eststo befr3b_02_ehe2

* Jobwechsel + Dauer Befristung
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & Irelpar==3, vce(cl persnr)
eststo befr3c_02_ehe

logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & Irelpar==3, vce(cl persnr)
eststo befr3d_02_ehe

	logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & Irelpar==3, vce(cl persnr)
	eststo befr3d_02b_ehe //Partnererwerbsstatus kontrolliert	
	
	pwcompare Kbefr, effects
	matrix rename r(table_vs) pw_Kbefr_ehe 
	
	margins Kbefr
	marginsplot, xlabel(0 "0" 1 "1" 2 "2" 3 "3" 4 ">4") ///
		subtitle ("Predictive Margins") ///
		title("Dauer Befristung für verheiratete Frauen") ///
		xtitle("Jahre in Befristung") ///
		ytitle("Pr(Geburt des ersten Kindes)") ///
		note ("SOEP v29 1995-2012, gewichtete Berechnungen") ///
		name(Kbefr_ehe, replace) scheme(s2mono) noci

	margins Kbefr, pwcompare(effect)
	matrix rename r(table_vs) pw_margins_Kbefr_ehe 
		
	
	* Interaktion Jobwechsel und West-Ost
	logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr jobch_dum##ib0.west ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & Irelpar==3, vce(cl persnr)
	eststo befr3d_02c_ehe //Partnererwerbsstatus kontrolliert	
	
**************
*** 22.3.3.2. ohne Gewichtung
**************	
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Hbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	if welle>=1995 & Irelpar==3, vce(cl persnr)
eststo befr3b_02_ehe_ohne

* Jobwechsel + Dauer Befristung
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	if welle>=1995 & Irelpar==3, vce(cl persnr)
eststo befr3c_02_ehe_ohne

logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	if welle>=1995 & Irelpar==3, vce(cl persnr)
eststo befr3d_02_ehe_ohne

	logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	if welle>=1995 & Irelpar==3, vce(cl persnr)
	eststo befr3d_02b_ehe_ohne //Partnererwerbsstatus kontrolliert

*****************************************
* 22.3.4. Westdeutschland
*****************************************
**************
*** 22.3.4.1. Alle 
**************
** Alle Partnerschaftsstadien
* Jobwechsel + Dummy Befristung
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb ib1.Hbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 ///
	flag_work_jobch flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & west==1, vce(cl persnr)
eststo befr3b_02_west

* Jobwechsel + Dauer Befristung
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb ib1.Kbefr ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	flag_berufl_zwei flag_hinc flag_relpar flag_work flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & west==1, vce(cl persnr)
eststo befr3c_02_west

logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 ///
	flag_work_jobch flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & west==1, vce(cl persnr)
eststo befr3d_02_west

	logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 ///
	flag_work_jobch flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & west==1, vce(cl persnr)
	eststo befr3d_02b_west //Partnererwerbsstatus kontrolliert
	
**************
*** 22.3.4.2. Westdeutschland und nur Ehen 
**************	
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Hbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & west==1 & Irelpar==3, vce(cl persnr)
eststo befr3b_02_west_ehe

* Jobwechsel + Dauer Befristung
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & west==1 & Irelpar==3, vce(cl persnr)
eststo befr3c_02_west_ehe

logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & west==1 & Irelpar==3, vce(cl persnr)
eststo befr3d_02_west_ehe

	logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & west==1 & Irelpar==3, vce(cl persnr)
	eststo befr3d_02b_west_ehe //Partnererwerbsstatus kontrolliert	
	
	
**************
*** 22.3.4.3. Westdeutschland und nur NEL
**************	
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Hbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & west==1 & Irelpar==2, vce(cl persnr)
eststo befr3b_02_west_nel

* Jobwechsel + Dauer Befristung
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & west==1 & Irelpar==2, vce(cl persnr)
eststo befr3c_02_west_nel

logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & west==1 & Irelpar==2, vce(cl persnr)
eststo befr3d_02_west_nel

	logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & west==1 & Irelpar==2, vce(cl persnr)
	eststo befr3d_02b_west_nel //Partnererwerbsstatus kontrolliert	
	
*****************************************
* 22.3.5. Ostdeutschland
*****************************************
**************
*** 22.3.5.1. Alle Partnerschaftsstadien
**************
// raus: flag_work_jobch flag_work 
** 
* Jobwechsel + Dummy Befristung
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb ib1.Hbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & west==0, vce(cl persnr)
eststo befr3b_02_ost

* Jobwechsel + Dauer Befristung
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb ib1.Kbefr ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & west==0, vce(cl persnr)
eststo befr3c_02_ost

logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & west==0, vce(cl persnr)
eststo befr3d_02_ost

	logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & west==0, vce(cl persnr)
	eststo befr3d_02b_ost //Partnererwerbsstatus kontrolliert
	
**************
*** 22.3.5.2. Ostdtl und nur Ehen
**************
// raus: flag_befr flag_gesamt2 
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Hbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	flag_berufl_zwei flag_hinc ///
	[pweight=lbclgewicht] if welle>=1995 & west==0 & Irelpar==3, vce(cl persnr)
eststo befr3b_02_ost_ehe

* Jobwechsel + Dauer Befristung
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	flag_berufl_zwei flag_hinc ///
	[pweight=lbclgewicht] if welle>=1995 & west==0 & Irelpar==3, vce(cl persnr)
eststo befr3c_02_ost_ehe

logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	flag_berufl_zwei flag_hinc  ///
	[pweight=lbclgewicht] if welle>=1995 & west==0 & Irelpar==3, vce(cl persnr)
eststo befr3d_02_ost_ehe

	logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc ///
	[pweight=lbclgewicht] if welle>=1995 & west==0 & Irelpar==3, vce(cl persnr)
	eststo befr3d_02b_ost_ehe //Partnererwerbsstatus kontrolliert	

**************
*** 22.3.5.3. Ostdtl. und Nel
**************
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Hbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & west==0 & Irelpar==2, vce(cl persnr)
eststo befr3b_02_ost_nel

* Jobwechsel + Dauer Befristung
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & west==0 & Irelpar==2, vce(cl persnr)
eststo befr3c_02_ost_nel

logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & west==0 & Irelpar==2, vce(cl persnr)
eststo befr3d_02_ost_nel

	logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & west==0 & Irelpar==2, vce(cl persnr)
	eststo befr3d_02b_ost_nel //Partnererwerbsstatus kontrolliert	
	
	
*****************************************
* 22.3.6. Interaktionen Partnerschaftsstatus
*****************************************
**************
*** 22.3.6.1. Gesamtdeutschland
**************
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib3.Irelpar##ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_work_jobch_befr flag_hinc flag_gesamt2 ///
	[pweight=lbclgewicht] if welle>=1995 & !missing(ehevsnel), vce(cl persnr)	
	eststo int_relparprekaer03
	pwcompare Kbefr#Irelpar, effects
	matrix rename r(table_vs) pw_int_relparbefr03 
	
margins Kbefr#Irelpar
marginsplot, xlabel(0 "0" 1 "1" 2 "2" 3 "3" 4 ">4") ///
	plotdim(Irelpar, elabels(1 "Kohabitation" 2 "Ehe")) ///
	title ("Predictive Margins", size(medsmall)) ///
	xtitle("Jahre in Befristung") ///
	ytitle("Pr(Geburt des ersten Kindes)") ///
	note ("SOEP v29 1995-2012, gewichtete Berechnungen") ///
	text(0.18 0.45 "Typ Traditionell & Stabil", size(vsmall)) ///
	text(0.02 0.43 "Typ Modern & Stabil", size(vsmall)) ///
	text(-0.01 2.5 "Typ Modern & Unsicher", size(vsmall)) ///
	text(0.38 2.55 "Typ Traditionell & Unsicher", size(vsmall)) ///
	name(int_relparbefr03, replace) scheme(s2mono) 
	* raus: noci
	* Raus: title("Dauer Befristung * Partnerschaftsstatus") ///

margins Kbefr#Irelpar, pwcompare(effect)
matrix rename r(table_vs) pw_margins_int_relparbefr03 

	logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib3.Irelpar##ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_work_jobch_befr flag_hinc flag_gesamt2 ///
	if welle>=1995 & !missing(ehevsnel), vce(cl persnr)	
	eststo int_relparprekaer03_ohne //ungewichtet
	
	
* Grafische Darstellung der benötigten Abbildungen
// Hierbei handelt es sich um getrennte Modelle und keine Interaktion
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & Irelpar==2, vce(cl persnr)
	eststo befr3d_02b_nel //Partnererwerbsstatus kontrolliert, flag_work_jobch keine Fälle
	margins Kbefr, saving(file_nel, replace)
	
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & Irelpar==3, vce(cl persnr)
	eststo befr3d_02b_ehe //Partnererwerbsstatus kontrolliert	
	margins Kbefr, saving(file_ehe, replace)

combomarginsplot file_nel file_ehe, ///
	xlabel(0 "0" 1 "1" 2 "2" 3 "3" 4 ">4") ///
	subtitle ("Predictive Margins") ///
	title("Dauer der Befristung und Partnerschaftsstatus") ///
	labels ("Kohabitation" "Ehe") ///
	xtitle("Jahre in Befristung") ///
	ytitle("Pr(Geburt des ersten Kindes)") ///
	note ("SOEP v29 1995-2012, gewichtete Berechnungen") ///
	name(combi_befr, replace) scheme(s2mono) 
	* raus: noci
	
**************
*** 22.3.6.2. Westdeutschland
**************

logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib3.Irelpar##ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_work_jobch_befr flag_hinc flag_gesamt2 ///
	[pweight=lbclgewicht] if welle>=1995 & !missing(ehevsnel) & west==1, vce(cl persnr)	
	eststo int_relparprekaer03_west
	pwcompare Kbefr#Irelpar, effects
	matrix rename r(table_vs) pw_int_relparbefr03_west 
	
margins Kbefr#Irelpar
marginsplot, xlabel(0 "0" 1 "1" 2 "2" 3 "3" 4 ">4") ///
	plotdim(Irelpar, elabels(1 "Kohabitation" 2 "Ehe")) ///
	subtitle ("Predictive Margin für Westdeutschland") ///
	title("Dauer Befristung * Partnerschaftsstatus") ///
	xtitle("Jahre in Befristung") ///
	ytitle("Pr(Geburt des ersten Kindes)") ///
	note ("SOEP v29 1995-2012, gewichtete Berechnungen") ///
	name(int_relparbefr03_west, replace) scheme(s2mono) noci

margins Kbefr#Irelpar, pwcompare(effect)
matrix rename r(table_vs) pw_margins_int_relparbefr03_west 

**************
*** 22.3.6.3. Ostdeutschland
**************
* 
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib3.Irelpar##ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_work_jobch_befr flag_hinc flag_gesamt2 ///
	[pweight=lbclgewicht] if welle>=1995 & !missing(ehevsnel) & west==0, vce(cl persnr)	
	eststo int_relparprekaer03_ost
	pwcompare Kbefr#Irelpar, effects
	matrix rename r(table_vs) pw_int_relparbefr03_ost
	
margins Kbefr#Irelpar
marginsplot, xlabel(0 "0" 1 "1" 2 "2" 3 "3" 4 ">4") ///
	plotdim(Irelpar, elabels(1 "Kohabitation" 2 "Ehe")) ///
	subtitle ("Predictive Margin für Westdeutschland") ///
	title("Dauer Befristung * Partnerschaftsstatus") ///
	xtitle("Jahre in Befristung") ///
	ytitle("Pr(Geburt des ersten Kindes)") ///
	note ("SOEP v29 1995-2012, gewichtete Berechnungen") ///
	name(int_relparbefr03_ost, replace) scheme(s2mono) noci

margins Kbefr#Irelpar, pwcompare(effect)
matrix rename r(table_vs) pw_margins_int_relparbefr03_ost


*****************************************
* 22.3.7. Metrische Modellierung für Anhang
*****************************************
* Metrische Modellierung der Dauer der aktuellen Befristung
local speichern=1 
foreach dauervariable in "Tbefr" "Tbefr ln_Tbefr" "Tbefr qu_Tbefr" {
	
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb `dauervariable' jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 ///
	flag_work_jobch_befr ///
	[pweight=lbclgewicht] if welle>=1995, vce(cl persnr)
	eststo befr4c_`speichern'_02
	
local speichern=`speichern'+1
}
	
********************************************************************************
*****************************************
* 22.3.8. Befristung und Sorgen
*****************************************
**************
*** 22.3.8.1. Gesamtdeutschland
**************
* 
local speichern=1
foreach version in "a" "ew2" {
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb ib1.Isorgen_`version' jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_relpar flag_work_jobch flag_gesamt2 ///
	flag_sorgen_`version' ///
	[pweight=lbclgewicht] if welle>=1995, vce(cl persnr)
eststo befr5_`speichern'_02

pwcompare Isorgen_`version',effects
	
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb ib1.Kbefr_kurz ib1.Isorgen_`version' jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 ///
	flag_work_jobch flag_befr flag_sorgen_`version' ///
	[pweight=lbclgewicht] if welle>=1995, vce(cl persnr)
eststo befr5a_`speichern'_02

pwcompare Isorgen_`version',effects

local speichern=`speichern'+1	
}

**************
*** 22.3.8.2. Westdeutschland
**************
* 
local speichern=1
foreach version in "a" "ew2" {
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb ib1.Isorgen_`version' jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_relpar flag_work_jobch flag_gesamt2 ///
	flag_sorgen_`version' ///
	[pweight=lbclgewicht] if welle>=1995 & west==1, vce(cl persnr)
eststo befr5_`speichern'_02_west

pwcompare Isorgen_`version',effects
	
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb ib1.Kbefr_kurz ib1.Isorgen_`version' jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 ///
	flag_work_jobch flag_befr flag_sorgen_`version' ///
	[pweight=lbclgewicht] if welle>=1995 & west==1, vce(cl persnr)
eststo befr5a_`speichern'_02_west

pwcompare Isorgen_`version',effects

local speichern=`speichern'+1	
}

**************
*** 22.3.8.3. Ostdeutschland
**************
*
// raus: flag_work_jobch
local speichern=1
foreach version in "a" "ew2" {
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb ib1.Isorgen_`version' jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 ///
	flag_sorgen_`version' ///
	[pweight=lbclgewicht] if welle>=1995 & west==0, vce(cl persnr)
eststo befr5_`speichern'_02_ost

pwcompare Isorgen_`version',effects
	
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb ib1.Kbefr_kurz ib1.Isorgen_`version' jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 ///
	flag_befr flag_sorgen_`version' ///
	[pweight=lbclgewicht] if welle>=1995 & west==0, vce(cl persnr)
eststo befr5a_`speichern'_02_ost

pwcompare Isorgen_`version',effects

local speichern=`speichern'+1	
}

**************
*** 22.3.8.4. Gesamtdeutschland Ehen
**************
* 
// raus: flag_work_jobch 
local speichern=1
foreach version in "a" "ew2" {
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Isorgen_`version' jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_sorgen_`version' ///
	[pweight=lbclgewicht] if welle>=1995 & Irelpar==3, vce(cl persnr)
eststo befr5_`speichern'_02_ehe

pwcompare Isorgen_`version',effects
	
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr_kurz ib1.Isorgen_`version' jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr flag_sorgen_`version' ///
	[pweight=lbclgewicht] if welle>=1995 & Irelpar==3, vce(cl persnr)
eststo befr5a_`speichern'_02_ehe

pwcompare Isorgen_`version',effects

local speichern=`speichern'+1	
}

**************
*** 22.3.8.5. Gesamtdeutschland NEL
**************
* 
// raus: flag_work_jobch 
local speichern=1
foreach version in "a" "ew2" {
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Isorgen_`version' jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_sorgen_`version' ///
	[pweight=lbclgewicht] if welle>=1995 & Irelpar==2, vce(cl persnr)
eststo befr5_`speichern'_02_nel

pwcompare Isorgen_`version',effects
	
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr_kurz ib1.Isorgen_`version' jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr flag_sorgen_`version' ///
	[pweight=lbclgewicht] if welle>=1995 & Irelpar==2, vce(cl persnr)
eststo befr5a_`speichern'_02_nel

pwcompare Isorgen_`version',effects

local speichern=`speichern'+1	
}
	
*****************************************
* 22.3.9. Interaktion Befristung und Sorgen Arbeitsplatzsicherheit
*****************************************
**************
*** 22.3.9.1. Gesamtdeutschland
**************	
* 
local speichern=1
foreach version in "a" {

logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb  ///
	ib1.Isorgen_`version'##ib1.Kbefr_kurz ///
	jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 ///
	flag_work_jobch flag_befr flag_sorgen_`version' ///
	[pweight=lbclgewicht] if welle>=1995, vce(cl persnr)		
	eststo befr5d_`speichern'_02 //Kontrolle Erwerbsstatus Partner
	
	pwcompare Kbefr_kurz#Isorgen_`version', effects
	matrix rename r(table_vs) pw_befr5d_`speichern'_02
		
	margins Kbefr_kurz#Isorgen_`version', pwcompare(effects)
	matrix rename r(table_vs) pw_margins_befr5d_`speichern'_02
	
local speichern=`speichern'+1	
}

**************
*** 22.3.9.2. Nur Ehen
**************	
* 
// raus: flag_work_jobch 
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb  ///
	ib1.Isorgen_a##ib1.Kbefr_kurz ///
	jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr flag_sorgen_a ///
	[pweight=lbclgewicht] if welle>=1995 & Irelpar==3, vce(cl persnr)		
	eststo befr5d_1_02_ehe
	
	pwcompare Kbefr_kurz#Isorgen_a, effects
	matrix rename r(table_vs) pw_befr5d_1_02_ehe
	
	margins Kbefr_kurz#Isorgen_a //kommt zu gleichen Ergebnissen (marginsplot schlecht dargestellt): margins Kbefr_kurz#Isorgen_a, pwcompare(effects)
	marginsplot, xlabel(0 "0" 1 "1" 2 "2" 3 ">3") ///
		plotdim(Isorgen_a, elabels(1 "Große Sorgen" 2 "Einige Sorgen" 3 "Keine Sorgen")) ///
		title ("Predictive Margins für Ehen", size(medsmall)) ///
		xtitle("Jahre in Befristung") ///
		ytitle("Pr(Geburt des ersten Kindes)") ///
		ylabel(0(0.1)0.6) ///
		note ("SOEP v29 1995-2012, gewichtete Berechnungen") ///
		name(befr5d_1_02_ehe, replace) scheme(s2mono) 
		* raus: noci
		* raus: title("Befristung * Sorgen Arbeitsplatzsicherheit") ///
		
	margins Kbefr_kurz#Isorgen_a, pwcompare(effects)
	matrix rename r(table_vs) pw_margins_befr5d_1_02_ehe
	
		

**************
*** 22.3.9.3. Nur Kohabitation
**************	
* Nicht verwendet, da zu geringe Fallzahlen
// raus: flag_work_jobch 
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb  ///
	ib1.Isorgen_a##ib1.Kbefr_kurz ///
	jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr flag_sorgen_a ///
	[pweight=lbclgewicht] if welle>=1995 & Irelpar==2, vce(cl persnr)		
	eststo befr5d_1_02_nel

	pwcompare Kbefr_kurz#Isorgen_a, effects
	matrix rename r(table_vs) pw_befr5d_1_02_nel
		
	margins Kbefr_kurz#Isorgen_a, pwcompare(effects)
	matrix rename r(table_vs) pw_margins_befr5d_1_02_nel

**************
*** 22.3.9.4. Nur Westen
**************	

local speichern=1
foreach version in "a" {

logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb  ///
	ib1.Isorgen_`version'##ib1.Kbefr_kurz ///
	jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 ///
	flag_work_jobch flag_befr flag_sorgen_`version' ///
	[pweight=lbclgewicht] if welle>=1995 & west==1, vce(cl persnr)		
	eststo befr5d_`speichern'_02_west //Kontrolle Erwerbsstatus Partner
	
	pwcompare Kbefr_kurz#Isorgen_`version', effects
	matrix rename r(table_vs) pw_befr5d_`speichern'_02_west
	
	margins Kbefr_kurz#Isorgen_`version' //identisch, nur marginsplot geht nicht: margins Kbefr_kurz#Isorgen_`version', pwcompare(effects)
	marginsplot, xlabel(0 "0" 1 "1" 2 "2" 3 ">3") ///
		plotdim(Isorgen_`version', elabels(1 "Große Sorgen" 2 "Einige Sorgen" 3 "Keine Sorgen")) ///
		title ("Predictive Margins für Westdeutschland", size(medsmall)) ///
		xtitle("Jahre in Befristung") ///
		ytitle("Pr(Geburt des ersten Kindes)") ///
		note ("SOEP v29 1995-2012, gewichtete Berechnungen") ///
		name(befr5d_`speichern'_02_west, replace) scheme(s2mono) 
		* raus: noci
		* raus: title("Befristung * Sorgen Arbeitsplatzsicherheit") ///
		
	margins Kbefr_kurz#Isorgen_`version', pwcompare(effects)
	matrix rename r(table_vs) pw_margins_befr5d_`speichern'_02_west
	
local speichern=`speichern'+1	
}

**************
*** 22.3.9.5. Nur Osten
**************	
* Nicht verwendet, da zu geringe Fallzahlen
local speichern=1
foreach version in "a" {

logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb  ///
	ib1.Isorgen_`version'##ib1.Kbefr_kurz ///
	jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 ///
	flag_work_jobch flag_befr flag_sorgen_`version' ///
	[pweight=lbclgewicht] if welle>=1995 & west==0, vce(cl persnr)		
	eststo befr5d_`speichern'_02_ost //Kontrolle Erwerbsstatus Partner
	
	pwcompare Kbefr_kurz#Isorgen_`version', effects
	matrix rename r(table_vs) pw_befr5d_`speichern'_02_ost
		
	margins Kbefr_kurz#Isorgen_`version', pwcompare(effects)
	matrix rename r(table_vs) pw_margins_befr5d_`speichern'_02_ost
	
local speichern=`speichern'+1	
}
	
*****************************************
* 22.3.10. Interaktion Befristung und Sorgen ökonomische Situation
*****************************************
**************
*** 22.3.10.1. Gesamtdeutschland
**************
* 
local speichern=2
foreach version in "ew2" {

logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb  ///
	ib1.Isorgen_`version'##ib1.Kbefr_kurz ///
	jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 ///
	flag_work_jobch flag_befr flag_sorgen_`version' ///
	[pweight=lbclgewicht] if welle>=1995, vce(cl persnr)		
	eststo befr5d_`speichern'_02 //Kontrolle Erwerbsstatus Partner
	
	pwcompare Kbefr_kurz#Isorgen_`version', effects
	matrix rename r(table_vs) pw_befr5d_`speichern'_02
		
	margins Kbefr_kurz#Isorgen_`version', pwcompare(effects)
	matrix rename r(table_vs) pw_margins_befr5d_`speichern'_02
	
local speichern=`speichern'+1	
}

**************
*** 22.3.10.2. Nur Ehen
**************
* 
// raus: flag_work_jobch 
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb  ///
	ib1.Isorgen_ew2##ib1.Kbefr_kurz ///
	jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr flag_sorgen_ew2 ///
	[pweight=lbclgewicht] if welle>=1995 & Irelpar==3, vce(cl persnr)		
	eststo befr5d_2_02_ehe
	
	pwcompare Kbefr_kurz#Isorgen_ew2, effects
	matrix rename r(table_vs) pw_befr5d_2_02_ehe
	
	margins Kbefr_kurz#Isorgen_ew2
	marginsplot, xlabel(0 "0" 1 "1" 2 "2" 3 ">3") ///
		plotdim(Isorgen_ew2, elabels(1 "Große Sorgen" 2 "Einige Sorgen" 3 "Keine Sorgen")) ///
		title ("Predictive Margins für Ehen", size(medsmall)) ///
		xtitle("Jahre in Befristung") ///
		ytitle("Pr(Geburt des ersten Kindes)") ///
		yscale(range(0(0.1)0.6)) ///
		ylabel(0(0.1)0.6) ///
		note ("SOEP v29 1995-2012, gewichtete Berechnungen") ///
		name(befr5d_`speichern'_02_ehe, replace) scheme(s2mono) 
		* raus: noci
		* raus: title("Befristung * Sorgen ökonomische Situation") ///
		* Dieselbe Y-Achse wie für Variable Isorgen_a eingebaut
		
	margins Kbefr_kurz#Isorgen_ew2, pwcompare(effects)
	matrix rename r(table_vs) pw_margins_befr5d_2_02_ehe

**************
*** 22.3.10.3. Nur für Kohabitationen
**************
* Nicht verwendet, da zu geringe Fallzahlen
// raus: flag_work_jobch 
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb  ///
	ib1.Isorgen_ew2##ib1.Kbefr_kurz ///
	jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_gesamt2 ///
	flag_befr flag_sorgen_ew2 ///
	[pweight=lbclgewicht] if welle>=1995 & Irelpar==2, vce(cl persnr)		
	eststo befr5d_2_02_nel
	
	pwcompare Kbefr_kurz#Isorgen_ew2, effects
	matrix rename r(table_vs) pw_befr5d_2_02_nel
	
	margins Kbefr_kurz#Isorgen_ew2, pwcompare(effects)
	matrix rename r(table_vs) pw_margins_befr5d_2_02_nel
	
**************
*** 22.3.10.4. Nur Westen
**************
* 
local speichern=2
foreach version in "ew2" {

logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb  ///
	ib1.Isorgen_`version'##ib1.Kbefr_kurz ///
	jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 ///
	flag_work_jobch flag_befr flag_sorgen_`version' ///
	[pweight=lbclgewicht] if welle>=1995 & west==1, vce(cl persnr)		
	eststo befr5d_`speichern'_02_west
	
	pwcompare Kbefr_kurz#Isorgen_`version', effects
	matrix rename r(table_vs) pw_befr5d_`speichern'_02_west
	
	margins Kbefr_kurz#Isorgen_`version'
	marginsplot, xlabel(0 "0" 1 "1" 2 "2" 3 ">3") ///
		plotdim(Isorgen_`version', elabels(1 "Große Sorgen" 2 "Einige Sorgen" 3 "Keine Sorgen")) ///
		title ("Predictive Margins für Westdeutschland", size(medsmall)) ///
		xtitle("Jahre in Befristung") ///
		ytitle("Pr(Geburt des ersten Kindes)") ///
		note ("SOEP v29 1995-2012, gewichtete Berechnungen") ///
		name(befr5d_`speichern'_02_west, replace) scheme(s2mono) 
		* raus: noci
		* raus: title("Befristung * Sorgen ökonomische Situation") ///
		
	margins Kbefr_kurz#Isorgen_`version', pwcompare(effects)
	matrix rename r(table_vs) pw_margins_befr5d_`speichern'_02_west
	
local speichern=`speichern'+1	
}

**************
*** 22.3.10.5. Nur Osten
**************
* Nicht verwendet, da zu geringe Fallzahlen
// raus: flag_work_jobch 
local speichern=2
foreach version in "ew2" {

logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb  ///
	ib1.Isorgen_`version'##ib1.Kbefr_kurz ///
	jobch_dum ib0.kum_arbeitslos_brose ///
	ib3.Iberufl_zwei hh1income qu_hh1income deutsch ///
	ib0.partner_erwerb ///
	flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 ///
	flag_befr flag_sorgen_`version' ///
	[pweight=lbclgewicht] if welle>=1995 & west==0, vce(cl persnr)		
	eststo befr5d_`speichern'_02_ost
	
	pwcompare Kbefr_kurz#Isorgen_`version', effects
	matrix rename r(table_vs) pw_befr5d_`speichern'_02_ost
		
	margins Kbefr_kurz#Isorgen_`version', pwcompare(effects)
	matrix rename r(table_vs) pw_margins_befr5d_`speichern'_02_ost
	
local speichern=`speichern'+1	
}


*****************************************
* 22.3.11. Partnercharakteristika
*****************************************
**************
*** 22.3.11.1. Gesamtdeutschland
**************
local speichern=1
foreach partnereigenschaft in "partner_erwerb" "Ipartner_work2" "Ipartner_berufl_zwei2" "Ipartner_work_AHbefr2" "Ipartner_jobch_dum2" "Ipartner_bil2" "Ipartner_alter2" {
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib1.`partnereigenschaft' ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	flag_berufl_zwei flag_hinc flag_relpar flag_gesamt ///
	flag_work_jobch flag_befr ///
	[pweight=lbclgewicht] if welle>=1995, vce(cl persnr)
eststo befr3d_02_partner`speichern'

pwcompare `partnereigenschaft', effects

local speichern=`speichern'+1
}

**************
*** 22.3.11.2. Nur in Ehen
**************
* 
// raus: flag_relpar  flag_work_jobch 
local speichern=1
foreach partnereigenschaft in "partner_erwerb" "Ipartner_work2" "Ipartner_berufl_zwei2" "Ipartner_work_AHbefr2" "Ipartner_jobch_dum2" "Ipartner_bil2" "Ipartner_alter2" {
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib1.`partnereigenschaft' ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	flag_berufl_zwei flag_hinc flag_gesamt ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & Irelpar==3, vce(cl persnr)
eststo befr3d_02_partner_ehe`speichern'

pwcompare `partnereigenschaft', effects

local speichern=`speichern'+1
}

**************
*** 22.3.11.3. Nur in Kohabitationen
**************
* 
// raus: flag_relpar flag_work_jobch 
local speichern=1
foreach partnereigenschaft in "partner_erwerb" "Ipartner_work2" "Ipartner_berufl_zwei2" "Ipartner_work_AHbefr2" "Ipartner_jobch_dum2" "Ipartner_bil2" "Ipartner_alter2" {
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib0.erwerb ib1.Kbefr jobch_dum ib0.kum_arbeitslos_brose ///
	ib1.`partnereigenschaft' ///
	ib3.Iberufl_zwei hh1income qu_hh1income ib0.west deutsch ///
	flag_berufl_zwei flag_hinc flag_gesamt ///
	flag_befr ///
	[pweight=lbclgewicht] if welle>=1995 & Irelpar==2, vce(cl persnr)
eststo befr3d_02_partner_nel`speichern'

pwcompare `partnereigenschaft', effects

local speichern=`speichern'+1
}
	
********************************************************************************
*****************************************
* 22.3.12. Tabellen für Manuskript
*****************************************
**************
*** 22.3.12.1. Befristungeffekt allgemein: Eine Tabelle mit West, Ost, NEL, Ehe, Interaktion NEL und Ehe
**************
esttab befr3d_02b_west befr3d_02b_ost befr3b_02_ehe2 befr3d_02b_ehe befr3b_02_nel2 befr3d_02b_nel int_relparprekaer03 ///
	using tab_Befristung_neu${date}.rtf, ///
	nonumbers nodepvars nonotes wide ///
	stats(aic bic N, fmt(%3,2f %3,0f) labels("AIC" "BIC" "N")) ///
    varwidth(20) modelwidth(2 3) b(%3,2f) se(%3,2f) gaps ///
    starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	refcat (${refcat}, label(" ")) ///
	order (dum16_20 dum21_25 dum26_30 dum36_45 0.Irelpar 1.Irelpar 2.Irelpar /*
		*/ 3.Irelpar /*
		*/ 0.erwerb 1.erwerb 2.erwerb  /*
		*/ 0.Hbefr 1.Hbefr /*
		*/ 0.Kbefr 1.Kbefr 2.Kbefr 3.Kbefr 4.Kbefr /*
		*/ 2.Irelpar#0.Kbefr 2.Irelpar#2.Kbefr 2.Irelpar#3.Kbefr /*
		*/ 2.Irelpar#4.Kbefr /*
		*/ jobch_dum /*
		*/ 0.kum_arbeitslos_brose 1.kum_arbeitslos_brose 2.kum_arbeitslos_brose /*
		*/ 0.west 1.west /* 
		*/ 0.Iberufl_zwei 1.Iberufl_zwei 2.Iberufl_zwei 3.Iberufl_zwei /*
		*/ hh1income qu_hh1income deutsch /*
		*/ 0.partner_erwerb 1.partner_erwerb 2.partner_erwerb 3.partner_erwerb /*
		*/ flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 /*
		*/ flag_befr flag_work_jobch_befr) ///
	substitute("\fonttbl{\f0\fnil Times New Roman" "\fonttbl{\f0\fnil Calibri" "\fs20" "\fs12" "\fs24" "\fs13" "mutter" " ") ///
    title ("Tab. 1: Die Geburt des ersten Kindes: Die Befristung der Beschäftigung (${S_DATE})") ///
	mtitle("\emp{(1){\line Westen}}" "\emp{(2){\line Osten}}" "\emp{(3){\line Ehe}}" "\emp{(4){\line Ehe}}" "\emp{(5){\line Kohabitation}}" "\emp{(6){\line Kohabitation}}" "\emp{(7){\line Interaktion}}") ///			
	varlabels (${variablen_workshop}) ///
    addnote(${addnote})
	
	unicode convertfile tab_Befristung_neu${date}.rtf tab_Befristung_neu_conv${date}.rtf, dstencoding(ISO-8859-1) replace
	erase tab_Befristung_neu${date}.rtf

**************
*** 22.3.12.2. Befristung und Sorgen
**************
* 
// Für Westdeutschland und Ehe getrennt, da hier Fallzahlen ausreichen	
esttab befr5a_1_02_west befr5d_1_02_west befr5a_2_02_west befr5d_2_02_west /*
	*/ befr5a_1_02_ehe befr5d_1_02_ehe befr5a_2_02_ehe befr5d_2_02_ehe ///
	using tab_Befristung_sorgen_west_ehe${date}.rtf, replace ///
	nonumbers nodepvars nonotes wide ///
	stats(aic bic N, fmt(%3,2f %3,0f) labels("AIC" "BIC" "N")) ///
    varwidth(15) modelwidth(2 3) b(%3,2f) se(%3,2f) gaps ///
    starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	refcat (${refcat}, label(" ")) ///
	order (dum16_20 dum21_25 dum26_30 dum36_45 0.Irelpar 1.Irelpar 2.Irelpar /*
		*/ 3.Irelpar /*
		*/ 0.erwerb 1.erwerb 2.erwerb  /*
		*/ jobch_dum /*
		*/ 0.Kbefr_kurz 1.Kbefr_kurz 2.Kbefr_kurz 3.Kbefr_kurz /*
		*/ 1.Isorgen_a 2.Isorgen_a 3.Isorgen_a /* 
		*/ 1.Isorgen_ew2 2.Isorgen_ew2 3.Isorgen_ew2 /* 
		*/ 2.Isorgen_a#0.Kbefr_kurz 2.Isorgen_a#2.Kbefr_kurz 2.Isorgen_a#3.Kbefr_kurz /*
		*/ 3.Isorgen_a#0.Kbefr_kurz 3.Isorgen_a#2.Kbefr_kurz /*
		*/ 3.Isorgen_a#3.Kbefr_kurz  /*
		*/ 2.Isorgen_ew2#0.Kbefr_kurz 2.Isorgen_ew2#2.Kbefr_kurz 2.Isorgen_ew2#3.Kbefr_kurz /*
		*/ 3.Isorgen_ew2#0.Kbefr_kurz 3.Isorgen_ew2#2.Kbefr_kurz /*
		*/ 3.Isorgen_ew2#3.Kbefr_kurz  /*
		*/ 0.kum_arbeitslos_brose 1.kum_arbeitslos_brose 2.kum_arbeitslos_brose /*
		*/ 0.west 1.west /*
		*/ 0.Iberufl_zwei 1.Iberufl_zwei 2.Iberufl_zwei 3.Iberufl_zwei /*
		*/ hh1income qu_hh1income deutsch /*
		*/ 0.partner_erwerb 1.partner_erwerb 2.partner_erwerb 3.partner_erwerb /*
		*/ flag_berufl_zwei flag_hinc flag_relpar flag_work_jobch flag_gesamt2 /*
		*/ flag_sorgen_a flag_sorgen_ew2  flag_befr) ///
	drop (1.Isorgen_a#0.Kbefr_kurz 1.Isorgen_a#1.Kbefr_kurz 1.Isorgen_a#2.Kbefr_kurz /*
		*/ 1.Isorgen_a#3.Kbefr_kurz 2.Isorgen_a#1.Kbefr_kurz /*
		*/ 3.Isorgen_a#1.Kbefr_kurz /*
		*/ 1.Isorgen_ew2#0.Kbefr_kurz 1.Isorgen_ew2#1.Kbefr_kurz 1.Isorgen_ew2#2.Kbefr_kurz /*
		*/ 1.Isorgen_ew2#3.Kbefr_kurz 2.Isorgen_ew2#1.Kbefr_kurz /*
		*/ 3.Isorgen_ew2#1.Kbefr_kurz) ///
	substitute("\fonttbl{\f0\fnil Times New Roman" "\fonttbl{\f0\fnil Calibri" "\fs20" "\fs12" "\fs24" "\fs13" "mutter" " ") ///
    title ("Tab. 3: Die Geburt des ersten Kindes: Befristung und Sorgen (${S_DATE})") ///
	mtitle("\emp{(1){\line Westen}}" "\emp{(2){\line Westen}}" "\emp{(3){\line Westen}}" "\emp{(4){\line Westen}}" "\emp{(5){\line Ehe}}" "\emp{(6){\line Ehe}}" "\emp{(7){\line Ehe}}" "\emp{(8){\line Ehe}}" "(9)" "(10)" "(11)" "(12)" "(13)" "(14)") ///
	varlabels (${variablen_workshop}) ///
    addnote(${addnote})
	
	unicode convertfile tab_Befristung_sorgen_west_ehe${date}.rtf tab_Befristung_sorgen_west_ehe_conv${date}.rtf, dstencoding(ISO-8859-1) replace
	erase tab_Befristung_sorgen_west_ehe${date}.rtf

**************
*** 22.3.12.3. Anhang: Gesamtdeutschland: Befristung und Sorgen
**************	
* Hier werden alle relevanten Ergebnisse zu Gesamtdeutschland dargestellt.
esttab befr3b_02 befr3d_02 befr3d_02b int_relparprekaer03 befr5a_1_02 befr5d_1_02 befr5a_2_02 befr5d_2_02 ///
	using tab_Befristung_gesamtdtl${date}.rtf, replace ///
	nonumbers nodepvars nonotes wide ///
	stats(aic bic N, fmt(%3,2f %3,0f) labels("AIC" "BIC" "N")) ///
    varwidth(20) modelwidth(2 3) b(%3,2f) se(%3,2f) gaps ///
    starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	refcat (${refcat}, label(" ")) ///
	order (dum16_20 dum21_25 dum26_30 dum36_45 0.Irelpar 1.Irelpar 2.Irelpar /*
		*/ 3.Irelpar /*
		*/ 0.erwerb 1.erwerb 2.erwerb  /*
		*/ 0.Hbefr 1.Hbefr /*
		*/ 0.Kbefr 1.Kbefr 2.Kbefr 3.Kbefr 4.Kbefr /*
		*/ 2.Irelpar#0.Kbefr 2.Irelpar#2.Kbefr 2.Irelpar#3.Kbefr /*
		*/ 2.Irelpar#4.Kbefr /*
		*/ 0.Kbefr_kurz 1.Kbefr_kurz 2.Kbefr_kurz 3.Kbefr_kurz /*
		*/ 1.Isorgen_a 2.Isorgen_a 3.Isorgen_a /* 
		*/ 1.Isorgen_ew2 2.Isorgen_ew2 3.Isorgen_ew2 /* 
		*/ 2.Isorgen_a#0.Kbefr_kurz 2.Isorgen_a#2.Kbefr_kurz 2.Isorgen_a#3.Kbefr_kurz /*
		*/ 3.Isorgen_a#0.Kbefr_kurz 3.Isorgen_a#2.Kbefr_kurz /*
		*/ 3.Isorgen_a#3.Kbefr_kurz  /*
		*/ 2.Isorgen_ew2#0.Kbefr_kurz 2.Isorgen_ew2#2.Kbefr_kurz 2.Isorgen_ew2#3.Kbefr_kurz /*
		*/ 3.Isorgen_ew2#0.Kbefr_kurz 3.Isorgen_ew2#2.Kbefr_kurz /*
		*/ 3.Isorgen_ew2#3.Kbefr_kurz  /*
		*/ jobch_dum /*
		*/ 0.kum_arbeitslos_brose 1.kum_arbeitslos_brose 2.kum_arbeitslos_brose /*
		*/ 0.west 1.west /* 
		*/ 0.Iberufl_zwei 1.Iberufl_zwei 2.Iberufl_zwei 3.Iberufl_zwei /*
		*/ hh1income qu_hh1income deutsch /*
		*/ 0.partner_erwerb 1.partner_erwerb 2.partner_erwerb 3.partner_erwerb /*
		*/ flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 /*
		*/ flag_befr flag_work_jobch flag_work_jobch_befr) ///
	drop (3.Irelpar#0.Kbefr 3.Irelpar#1.Kbefr 3.Irelpar#2.Kbefr /*
		*/ 3.Irelpar#3.Kbefr 3.Irelpar#4.Kbefr 2.Irelpar#1.Kbefr /*
		*/ 1.Isorgen_a#0.Kbefr_kurz 1.Isorgen_a#1.Kbefr_kurz 1.Isorgen_a#2.Kbefr_kurz /*
		*/ 1.Isorgen_a#3.Kbefr_kurz 2.Isorgen_a#1.Kbefr_kurz /*
		*/ 3.Isorgen_a#1.Kbefr_kurz /*
		*/ 1.Isorgen_ew2#0.Kbefr_kurz 1.Isorgen_ew2#1.Kbefr_kurz 1.Isorgen_ew2#2.Kbefr_kurz /*
		*/ 1.Isorgen_ew2#3.Kbefr_kurz 2.Isorgen_ew2#1.Kbefr_kurz /*
		*/ 3.Isorgen_ew2#1.Kbefr_kurz) ///
	substitute("\fonttbl{\f0\fnil Times New Roman" "\fonttbl{\f0\fnil Calibri" "\fs20" "\fs12" "\fs24" "\fs13" "mutter" " ") ///
    title ("Tab. 1: Die Geburt des ersten Kindes: Die Befristung der Beschäftigung (${S_DATE})") ///
	mtitle("(1)" "(2)" "(3)" "(4)" "\emp{(5){\line Sorgen}}" "\emp{(6){\line Sorgen}}" "\emp{(7){\line Sorgen}}" "\emp{(8){\line Sorgen}}" "(9)" "(10)" "(11)" "(12)" "(13)" "(14)") ///			
	varlabels (${variablen_workshop}) ///
    addnote(${addnote})
	
	unicode convertfile tab_Befristung_gesamtdtl${date}.rtf tab_Befristung_gesamtdtl_conv${date}.rtf, dstencoding(ISO-8859-1) replace
	erase tab_Befristung_gesamtdtl${date}.rtf
	
			// ohne Gewichtung
	esttab befr3b_02_ohne befr3c_02_ohne befr3d_02_ohne befr3d_02b_ohne int_relparprekaer03_ohne ///
	using tab_Befristung_ungewichtet${date}.rtf, ///
	nonumbers nodepvars nonotes wide ///
	stats(aic bic N, fmt(%3,2f %3,0f) labels("AIC" "BIC" "N")) ///
    varwidth(20) modelwidth(2 3) b(%3,2f) se(%3,2f) gaps ///
    starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	refcat (${refcat}, label(" ")) ///
	order (dum16_20 dum21_25 dum26_30 dum36_45 0.Irelpar 1.Irelpar 2.Irelpar /*
		*/ 3.Irelpar /*
		*/ 0.erwerb 1.erwerb 2.erwerb  /*
		*/ 0.Hbefr 1.Hbfr /*
		*/ 0.Kbefr 1.Kbefr 2.Kbefr 3.Kbefr 4.Kbefr /*
		*/ 2.Irelpar#0.Kbefr 2.Irelpar#2.Kbefr 2.Irelpar#3.Kbefr /*
		*/ 2.Irelpar#4.Kbefr /*
		*/ jobch_dum /*
		*/ 0.kum_arbeitslos_brose 1.kum_arbeitslos_brose 2.kum_arbeitslos_brose /*
		*/ west /* 
		*/ 0.Iberufl_zwei 1.Iberufl_zwei 2.Iberufl_zwei 3.Iberufl_zwei /*
		*/ hh1income qu_hh1income deutsch /*
		*/ 0.partner_erwerb 1.partner_erwerb 2.partner_erwerb 3.partner_erwerb /*
		*/ flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 /*
		*/ flag_befr flag_work flag_work_jobch flag_work_jobch_befr) ///
	drop (3.Irelpar#0.Kbefr 3.Irelpar#1.Kbefr 3.Irelpar#2.Kbefr /*
		*/ 3.Irelpar#3.Kbefr 3.Irelpar#4.Kbefr 2.Irelpar#1.Kbefr) ///
	substitute("\fonttbl{\f0\fnil Times New Roman" "\fonttbl{\f0\fnil Calibri" "\fs20" "\fs14" "\fs24" "\fs15" "mutter" " ") ///
    title ("Tab. 1: Anhang - Die Geburt des ersten Kindes: Die Befristung der Beschäftigung (nicht gewichtet) (${S_DATE})") ///
	mtitle("(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)" "(10)" "(11)" "(12)" "(13)" "(14)") ///			
	varlabels (${variablen_workshop}) ///
    addnote(${addnote_nichtgewichtet})
	
	unicode convertfile tab_Befristung_ungewichtet${date}.rtf tab_Befristung_ungewichtet_conv${date}.rtf, dstencoding(ISO-8859-1) replace
	erase tab_Befristung_ungewichtet${date}.rtf
	

	
**************
*** 22.3.12.4. Anhang, metrische Modellierung der Dauer der Befristung
**************		
* 
esttab befr4c_1_02 befr4c_2_02 befr4c_3_02 ///
	using tab_Anhang_Befristung_metrisch${date}.rtf, ///
	nonumbers nodepvars nonotes wide ///
	stats(aic bic N, fmt(%3,2f %3,0f) labels("AIC" "BIC" "N")) ///
    varwidth(25) modelwidth(2 3) b(%3,2f) se(%3,2f) gaps ///
    starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	refcat (${refcat}, label(" ")) ///
	order (dum16_20 dum21_25 dum26_30 dum36_45 0.Irelpar 1.Irelpar 2.Irelpar /*
		*/ 3.Irelpar /*
		*/ 0.erwerb 1.erwerb 2.erwerb  /*
		*/ Tbefr ln_Tbefr qu_Tbefr /*
		*/ jobch_dum /*
		*/ 0.kum_arbeitslos_brose 1.kum_arbeitslos_brose 2.kum_arbeitslos_brose /*
		*/ 0.west 1.west  /*
		*/ 0.Iberufl_zwei 1.Iberufl_zwei 2.Iberufl_zwei 3.Iberufl_zwei /*
		*/ hh1income qu_hh1income deutsch /*
		*/ 0.partner_erwerb 1.partner_erwerb 2.partner_erwerb 3.partner_erwerb /*
		*/ flag_berufl_zwei flag_hinc flag_relpar /*
		*/ flag_gesamt2 flag_work_jobch_befr) ///
	substitute("\fonttbl{\f0\fnil Times New Roman" "\fonttbl{\f0\fnil Calibri" "\fs20" "\fs12" "\fs24" "\fs13" "mutter" " ") ///
    title ("Tab. 1: Anhang - Die Geburt des erstesn Kindes: Metrische Modellierung zur Dauer der Befristung (${S_DATE})") ///
	mtitle("(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)" "(10)" "(11)" "(12)" "(13)" "(14)") ///			
	varlabels (${variablen_workshop}) ///
    addnote(${addnote})
	
	unicode convertfile tab_Anhang_Befristung_metrisch${date}.rtf tab_Anhang_Befristung_metrisch_conv${date}.rtf, dstencoding(ISO-8859-1) replace
	erase tab_Anhang_Befristung_metrisch${date}.rtf
	
**************
*** 22.3.12.5. Partnercharakteristika
**************	
* Alle	
esttab befr3d_02_partner1 befr3d_02_partner2 befr3d_02_partner4 /*
	*/  befr3d_02_partner5 befr3d_02_partner3 befr3d_02_partner6 /*
	*/ befr3d_02_partner7 ///
	using tab_Befristung_partnercharakteristika${date}.rtf, replace ///
	nonumbers nodepvars nonotes wide ///
	stats(aic bic N, fmt(%3,2f %3,0f) labels("AIC" "BIC" "N")) ///
    varwidth(20) modelwidth(2 3) b(%3,2f) se(%3,2f) gaps ///
    starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	refcat (${refcat}, label(" ")) ///
	order (dum16_20 dum21_25 dum26_30 dum36_45 0.Irelpar 1.Irelpar 2.Irelpar /*
		*/ 3.Irelpar /*
		*/ 0.erwerb 1.erwerb 2.erwerb  /*
		*/ 0.Kbefr 1.Kbefr 2.Kbefr 3.Kbefr 4.Kbefr /*
		*/ 0.partner_erwerb 1.partner_erwerb 2.partner_erwerb 3.partner_erwerb /*
		*/ 0.Ipartner_work2 1.Ipartner_work2 2.Ipartner_work2 3.Ipartner_work2 /*
		*/ 4.Ipartner_work2 5.Ipartner_work2 6.Ipartner_work2 /*
		*/ 0.Ipartner_work_AHbefr2 1.Ipartner_work_AHbefr2 /*
		*/ 2.Ipartner_work_AHbefr2 3.Ipartner_work_AHbefr2 /*
		*/ 4.Ipartner_work_AHbefr2 5.Ipartner_work_AHbefr2 /*
		*/ 0.Ipartner_jobch_dum2 1.Ipartner_jobch_dum2 2.Ipartner_jobch_dum2 /*
		*/ 0.Ipartner_berufl_zwei2 1.Ipartner_berufl_zwei2 /*
		*/ 2.Ipartner_berufl_zwei2 3.Ipartner_berufl_zwei2 /*
		*/ 4.Ipartner_berufl_zwei2 /*
		*/ 0.Ipartner_bil2 1.Ipartner_bil2 2.Ipartner_bil2 3.Ipartner_bil2 /*
		*/ 4.Ipartner_bil2 /*
		*/ 0.Ipartner_alter2 1.Ipartner_alter2 2.Ipartner_alter2 /*
		*/ 3.Ipartner_alter2 4.Ipartner_alter2 5.Ipartner_alter2 /*
		*/ jobch_dum /*
		*/ 0.kum_arbeitslos_brose 1.kum_arbeitslos_brose 2.kum_arbeitslos_brose /*
		*/ 0.west 1.west  /*
		*/ 0.Iberufl_zwei 1.Iberufl_zwei 2.Iberufl_zwei 3.Iberufl_zwei /*
		*/ hh1income qu_hh1income deutsch /*
		*/ flag_berufl_zwei flag_hinc flag_relpar flag_gesamt /*
		*/ flag_work_jobch flag_befr ) ///
   	substitute("\fonttbl{\f0\fnil Times New Roman" "\fonttbl{\f0\fnil Calibri" "\fs20" "\fs12" "\fs24" "\fs13" "mutter" " ") ///
    title ("Tab. 1: Anhang - Die Geburt des ersten Kindes: Befristung der Beschäftigung und Partnercharakteristika, ohne Differenzierung nach Region oder Partnerschaftsstatus (${S_DATE})") ///
	mtitle("(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)" "(10)" "(11)" "(12)" "(13)" "(14)") ///			
	varlabels (${variablen_workshop}) ///
    addnote(${addnote})
	
	unicode convertfile tab_Befristung_partnercharakteristika${date}.rtf tab_Befristung_partnercharakteristika_conv${date}.rtf, dstencoding(ISO-8859-1) replace
	erase tab_Befristung_partnercharakteristika${date}.rtf
	
* Nur Ehen
esttab befr3d_02_partner_ehe1 befr3d_02_partner_ehe2 befr3d_02_partner_ehe4 /*
	*/  befr3d_02_partner_ehe5 befr3d_02_partner_ehe3 befr3d_02_partner_ehe6 /*
	*/ befr3d_02_partner_ehe7 ///
	using tab_Befristung_partnercharakteristika_ehe${date}.rtf, replace ///
	nonumbers nodepvars nonotes wide ///
	stats(aic bic N, fmt(%3,2f %3,0f) labels("AIC" "BIC" "N")) ///
    varwidth(20) modelwidth(2 3) b(%3,2f) se(%3,2f) gaps ///
    starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	refcat (${refcat}, label(" ")) ///
	order (dum16_20 dum21_25 dum26_30 dum36_45  /*
		*/ 0.erwerb 1.erwerb 2.erwerb  /*
		*/ 0.Kbefr 1.Kbefr 2.Kbefr 3.Kbefr 4.Kbefr /*
		*/ 0.partner_erwerb 1.partner_erwerb 2.partner_erwerb 3.partner_erwerb /*
		*/ 0.Ipartner_work2 1.Ipartner_work2 2.Ipartner_work2 3.Ipartner_work2 /*
		*/ 4.Ipartner_work2 5.Ipartner_work2 6.Ipartner_work2 /*
		*/ 0.Ipartner_work_AHbefr2 1.Ipartner_work_AHbefr2 /*
		*/ 2.Ipartner_work_AHbefr2 3.Ipartner_work_AHbefr2 /*
		*/ 4.Ipartner_work_AHbefr2 5.Ipartner_work_AHbefr2 /*
		*/ 0.Ipartner_jobch_dum2 1.Ipartner_jobch_dum2 2.Ipartner_jobch_dum2 /*
		*/ 0.Ipartner_berufl_zwei2 1.Ipartner_berufl_zwei2 /*
		*/ 2.Ipartner_berufl_zwei2 3.Ipartner_berufl_zwei2 /*
		*/ 4.Ipartner_berufl_zwei2 /*
		*/ 0.Ipartner_bil2 1.Ipartner_bil2 2.Ipartner_bil2 3.Ipartner_bil2 /*
		*/ 4.Ipartner_bil2 /*
		*/ 0.Ipartner_alter2 1.Ipartner_alter2 2.Ipartner_alter2 /*
		*/ 3.Ipartner_alter2 4.Ipartner_alter2 5.Ipartner_alter2 /*
		*/ jobch_dum /*
		*/ 0.kum_arbeitslos_brose 1.kum_arbeitslos_brose 2.kum_arbeitslos_brose /*
		*/ 0.west 1.west  /*
		*/ 0.Iberufl_zwei 1.Iberufl_zwei 2.Iberufl_zwei 3.Iberufl_zwei /*
		*/ hh1income qu_hh1income deutsch /*
		*/ flag_berufl_zwei flag_hinc flag_gesamt flag_befr ) ///
   	substitute("\fonttbl{\f0\fnil Times New Roman" "\fonttbl{\f0\fnil Calibri" "\fs20" "\fs12" "\fs24" "\fs13" "mutter" " ") ///
    title ("Tab. 1: Anhang - Die Geburt des ersten Kindes für Frauen in Ehe: Befristung der Beschäftigung und Partnercharakteristika (${S_DATE})") ///
	mtitle("\emp{(1){\line Ehe}}" "\emp{(2){\line Ehe}}" "\emp{(3){\line Ehe}}" "\emp{(4){\line Ehe}}" "\emp{(5){\line Ehe}}" "\emp{(6){\line Ehe}}" "\emp{(7){\line Ehe}}" "(8)" "(9)" "(10)" "(11)" "(12)" "(13)" "(14)") ///			
	varlabels (${variablen_workshop}) ///
    addnote(${addnote})
	
	unicode convertfile tab_Befristung_partnercharakteristika_ehe${date}.rtf tab_Befristung_partnercharakteristika_ehe_conv${date}.rtf, dstencoding(ISO-8859-1) replace
	erase tab_Befristung_partnercharakteristika_ehe${date}.rtf
	
* Nur Kohabitationen
esttab befr3d_02_partner_nel1 befr3d_02_partner_nel2 befr3d_02_partner_nel4 /*
	*/  befr3d_02_partner_nel5 befr3d_02_partner_nel3 befr3d_02_partner_nel6 /*
	*/ befr3d_02_partner_nel7 ///
	using tab_Befristung_partnercharakteristika_nel${date}.rtf, replace ///
	nonumbers nodepvars nonotes wide ///
	stats(aic bic N, fmt(%3,2f %3,0f) labels("AIC" "BIC" "N")) ///
    varwidth(20) modelwidth(4 3) b(%3,2f) se(%3,2f) gaps ///
    starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	refcat (${refcat}, label(" ")) ///
	order (dum16_20 dum21_25 dum26_30 dum36_45  /*
		*/ 0.erwerb 1.erwerb 2.erwerb  /*
		*/ 0.Kbefr 1.Kbefr 2.Kbefr 3.Kbefr 4.Kbefr /*
		*/ 0.partner_erwerb 1.partner_erwerb 2.partner_erwerb 3.partner_erwerb /*
		*/ 0.Ipartner_work2 1.Ipartner_work2 2.Ipartner_work2 3.Ipartner_work2 /*
		*/ 4.Ipartner_work2 5.Ipartner_work2 6.Ipartner_work2 /*
		*/ 0.Ipartner_work_AHbefr2 1.Ipartner_work_AHbefr2 /*
		*/ 2.Ipartner_work_AHbefr2 3.Ipartner_work_AHbefr2 /*
		*/ 4.Ipartner_work_AHbefr2 5.Ipartner_work_AHbefr2 /*
		*/ 0.Ipartner_jobch_dum2 1.Ipartner_jobch_dum2 2.Ipartner_jobch_dum2 /*
		*/ 0.Ipartner_berufl_zwei2 1.Ipartner_berufl_zwei2 /*
		*/ 2.Ipartner_berufl_zwei2 3.Ipartner_berufl_zwei2 /*
		*/ 4.Ipartner_berufl_zwei2 /*
		*/ 0.Ipartner_bil2 1.Ipartner_bil2 2.Ipartner_bil2 3.Ipartner_bil2 /*
		*/ 0.Ipartner_alter2 1.Ipartner_alter2 2.Ipartner_alter2 /*
		*/ 3.Ipartner_alter2 4.Ipartner_alter2 5.Ipartner_alter2 /*
		*/ jobch_dum /*
		*/ 0.kum_arbeitslos_brose 1.kum_arbeitslos_brose 2.kum_arbeitslos_brose /*
		*/ 0.west 1.west  /*
		*/ 0.Iberufl_zwei 1.Iberufl_zwei 2.Iberufl_zwei 3.Iberufl_zwei /*
		*/ hh1income qu_hh1income deutsch /*
		*/ flag_berufl_zwei flag_hinc flag_gesamt flag_befr ) ///
   	substitute("\fonttbl{\f0\fnil Times New Roman" "\fonttbl{\f0\fnil Calibri" "\fs20" "\fs12" "\fs24" "\fs13" "mutter" " ") ///
    title ("Tab. 1: Anhang - Die Geburt des ersten Kindes für Frauen in Kohabitationen: Befristung der Beschäftigung und Partnercharakteristika (${S_DATE})") ///
	mtitle("\emp{(1){\line Kohabitation}}" "\emp{(2){\line Kohabitation}}" "\emp{(3){\line Kohabitation}}" "\emp{(4){\line Kohabitation}}" "\emp{(5){\line Kohabitation}}" "\emp{(6){\line Kohabitation}}" "\emp{(7){\line Kohabitation}}" "(8)" "(9)" "(10)" "(11)" "(12)" "(13)" "(14)") ///			
	varlabels (${variablen_workshop}) ///
    addnote(${addnote})
	
	unicode convertfile tab_Befristung_partnercharakteristika_nel${date}.rtf tab_Befristung_partnercharakteristika_nel_conv${date}.rtf, dstencoding(ISO-8859-1) replace
	erase tab_Befristung_partnercharakteristika_nel${date}.rtf	

	
**************
*** 22.3.12.6. Gesamtdtl. sowie Ehe und Nel ohne Partnercharakteristika
**************	
esttab befr3d_02b befr3b_02_ehe befr3d_02_ehe befr3b_02_nel befr3d_02_nel ///
	using tab_Befristung_anhang${date}.rtf, ///
	nonumbers nodepvars nonotes wide ///
	stats(aic bic N, fmt(%3,2f %3,0f) labels("AIC" "BIC" "N")) ///
    varwidth(20) modelwidth(2 3) b(%3,2f) se(%3,2f) gaps ///
    starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	refcat (${refcat}, label(" ")) ///
	order (dum16_20 dum21_25 dum26_30 dum36_45 0.Irelpar 1.Irelpar 2.Irelpar /*
		*/ 3.Irelpar /*
		*/ 0.erwerb 1.erwerb 2.erwerb  /*
		*/ 0.Hbefr 1.Hbefr /*
		*/ 0.Kbefr 1.Kbefr 2.Kbefr 3.Kbefr 4.Kbefr /*
		*/ jobch_dum /*
		*/ 0.kum_arbeitslos_brose 1.kum_arbeitslos_brose 2.kum_arbeitslos_brose /*
		*/ 0.west 1.west /* 
		*/ 0.Iberufl_zwei 1.Iberufl_zwei 2.Iberufl_zwei 3.Iberufl_zwei /*
		*/ hh1income qu_hh1income deutsch /*
		*/ 0.partner_erwerb 1.partner_erwerb 2.partner_erwerb 3.partner_erwerb /*
		*/ flag_berufl_zwei flag_hinc flag_relpar flag_gesamt2 /*
		*/ flag_befr) ///
	substitute("\fonttbl{\f0\fnil Times New Roman" "\fonttbl{\f0\fnil Calibri" "\fs20" "\fs12" "\fs24" "\fs13" "mutter" " ") ///
    title ("Tab. 1: Anhang - Die Geburt des ersten Kindes: Die Befristung der Beschäftigung (${S_DATE})") ///
	mtitle("\emp{(1){\line Gesamtdeutschland}}" "\emp{(2){\line Ehe}}" "\emp{(3){\line Ehe}}" "\emp{(4){\line Kohabitation}}" "\emp{(5){\line Kohabitation}}") ///			
	varlabels (${variablen_workshop}) ///
    addnote(${addnote})
	
	unicode convertfile tab_Befristung_anhang${date}.rtf tab_Befristung_anhang_conv${date}.rtf, dstencoding(ISO-8859-1) replace
	erase tab_Befristung_anhang${date}.rtf
	
********************************************************************************
*****************************************
* 22.3.13. Predictive Margins
*****************************************
*pwcompare
* ich berechne nur noch predictive Margins in der probability metric, kein pwcompare xy, effects

matrix dir //Namen gespeicherter Matrizen auflisten lassen

foreach modell in  "5d_1_02_ehe" "5d_1_02_west" "5d_2_02_ehe" "5d_2_02_west" {
foreach variable in  "margins_befr"  {

putexcel set "${my_save_path}pwcompare_`variable'`modell'${date}.xlsx", replace
		//nur an dieser Stelle ",replace", damit falls vorhanden, Datei überschrieben wird
		//Im Loop ist ",modify" notwendig, da immer neue Zellen dazu kommen
putexcel A1=(" Predictive Marings:`variable'`modell'") A2=("Referenzkategorien") B2=("Koeffizient") /*
	*/ C2=("Standardfehler") D2=("p-Wert") E2=("Konfidenzintervall")  /*
	*/ F2=("Konfidenzintervall") 
putexcel (A2:F2), bold border(bottom) hcenter font("Calibri",8) 
putexcel (A2:F2), border(top)
putexcel (E2:F2), merge hcenter

mata: set_excel_col_width("${my_save_path}pwcompare_`variable'`modell'${date}.xlsx", 1, 1, 25)
mata: set_excel_col_width("${my_save_path}pwcompare_`variable'`modell'${date}.xlsx", 2, 2, 8)
mata: set_excel_col_width("${my_save_path}pwcompare_`variable'`modell'${date}.xlsx", 3, 3, 10)
mata: set_excel_col_width("${my_save_path}pwcompare_`variable'`modell'${date}.xlsx", 4, 4, 7)
mata: set_excel_col_width("${my_save_path}pwcompare_`variable'`modell'${date}.xlsx", 5, 5, 7)
mata: set_excel_col_width("${my_save_path}pwcompare_`variable'`modell'${date}.xlsx", 6, 6, 7)

local cols=colsof(pw_`variable'`modell') //rowsof(X), colsof(X) zählt Zeilen oder Spalten
local row=3 //damit mit dritter Zeile begonnen wird


forvalues i =1/`cols' {

	local b_Wert=pw_`variable'`modell'[1,`i']
		local b_Wert: display %9.4f `b_Wert'
	local se_Wert=pw_`variable'`modell'[2,`i']
		local se_Wert: display %9.4f `se_Wert'
	local p_Wert=pw_`variable'`modell'[4,`i']
		local p_Wert: display %9.4f `p_Wert'
	local konfu_Wert=pw_`variable'`modell'[5,`i']
		local konfu_Wert: display %9.4f `konfu_Wert'
	local konfo_Wert=pw_`variable'`modell'[6,`i']
		local konfo_Wert: display %9.4f `konfo_Wert'
	
	local spaltenname: colnames pw_`variable'`modell' //es werden alle Spaltennamen ausgegeben
	local help_spaltenname "`spaltenname'" //Diese schreibe ich in ein neues Makro
	local s: word `i' of `help_spaltenname' //Mit jedem Loop-Durchgang wird ein Spaltenname weiter gerückt
	
	putexcel set "${my_save_path}pwcompare_`variable'`modell'${date}.xlsx", modify
	putexcel A`row'=("`s'") B`row'=(`b_Wert') C`row'=(`se_Wert') D`row'=(`p_Wert') /*
		*/ E`row'=(`konfu_Wert') F`row'=(`konfo_Wert')
	putexcel (A`row'), left font("Calibri",8) // Schriftart, -größe anpassen	
	putexcel (B`row':F`row'), hcenter font("Calibri",8) // Schriftart, -größe und Ausrichtung anpassen
		
	local row=`row'+1
	}

* Quellenhinweis einfügen
local row=`row'+1
local row_nachunten=`row'+1
putexcel set "${my_save_path}pwcompare_`variable'`modell'${date}.xlsx", modify
putexcel (A`row':F`row_nachunten'), merge left font("Calibri",7)
putexcel A`row'=("Quelle: SOEP v29 1995-2012; eigene, gewichtete Berechnungen. Es sind nur Werte dargestellt, die einen p-Wert von 0,1 oder kleiner haben."), txtwrap
}
}


foreach modell in "_relparbefr03"  {
foreach variable in  "margins_int"  {

putexcel set "${my_save_path}pwcompare_`variable'`modell'${date}.xlsx", replace
		//nur an dieser Stelle ",replace", damit falls vorhanden, Datei überschrieben wird
		//Im Loop ist ",modify" notwendig, da immer neue Zellen dazu kommen
putexcel A1=(" Predictive Marings:`variable'`modell'") A2=("Referenzkategorien") B2=("Koeffizient") /*
	*/ C2=("Standardfehler") D2=("p-Wert") E2=("Konfidenzintervall")  /*
	*/ F2=("Konfidenzintervall") 
putexcel (A2:F2), bold border(bottom) hcenter font("Calibri",8) 
putexcel (A2:F2), border(top)
putexcel (E2:F2), merge hcenter

mata: set_excel_col_width("${my_save_path}pwcompare_`variable'`modell'${date}.xlsx", 1, 1, 30)
mata: set_excel_col_width("${my_save_path}pwcompare_`variable'`modell'${date}.xlsx", 2, 2, 10)
mata: set_excel_col_width("${my_save_path}pwcompare_`variable'`modell'${date}.xlsx", 3, 3, 10)
mata: set_excel_col_width("${my_save_path}pwcompare_`variable'`modell'${date}.xlsx", 4, 4, 10)
mata: set_excel_col_width("${my_save_path}pwcompare_`variable'`modell'${date}.xlsx", 5, 5, 10)
mata: set_excel_col_width("${my_save_path}pwcompare_`variable'`modell'${date}.xlsx", 6, 6, 10)

local cols=colsof(pw_`variable'`modell') //rowsof(X), colsof(X) zählt Zeilen oder Spalten
local row=3 //damit mit dritter Zeile begonnen wird


forvalues i =1/`cols' {

	local b_Wert=pw_`variable'`modell'[1,`i']
		local b_Wert: display %9.4f `b_Wert'
	local se_Wert=pw_`variable'`modell'[2,`i']
		local se_Wert: display %9.4f `se_Wert'
	local p_Wert=pw_`variable'`modell'[4,`i']
		local p_Wert: display %9.4f `p_Wert'
	local konfu_Wert=pw_`variable'`modell'[5,`i']
		local konfu_Wert: display %9.4f `konfu_Wert'
	local konfo_Wert=pw_`variable'`modell'[6,`i']
		local konfo_Wert: display %9.4f `konfo_Wert'
	
	local spaltenname: colnames pw_`variable'`modell' //es werden alle Spaltennamen ausgegeben
	local help_spaltenname "`spaltenname'" //Diese schreibe ich in ein neues Makro
	local s: word `i' of `help_spaltenname' //Mit jedem Loop-Durchgang wird ein Spaltenname weiter gerückt
	
	putexcel set "${my_save_path}pwcompare_`variable'`modell'${date}.xlsx", modify
	putexcel A`row'=("`s'") B`row'=(`b_Wert') C`row'=(`se_Wert') D`row'=(`p_Wert') /*
		*/ E`row'=(`konfu_Wert') F`row'=(`konfo_Wert')
	putexcel (A`row'), left font("Calibri",8) // Schriftart, -größe anpassen	
	putexcel (B`row':F`row'), hcenter font("Calibri",8) // Schriftart, -größe und Ausrichtung anpassen
		
	local row=`row'+1
	}

* Quellenhinweis einfügen
local row=`row'+1
local row_nachunten=`row'+1
putexcel set "${my_save_path}pwcompare_`variable'`modell'${date}.xlsx", modify
putexcel (A`row':F`row_nachunten'), merge left font("Calibri",7)
putexcel A`row'=("Quelle: SOEP v29 1995-2012; eigene, gewichtete Berechnungen. Es sind nur Werte dargestellt, die einen p-Wert von 0,1 oder kleiner haben."), txtwrap
}
}

