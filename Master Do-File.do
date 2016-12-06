* Datenanalyse Dissertation: Master Do-File
* Autorin: Annina T. Hering
********************************************************************************
/* 
Daten: Version 29, SOEP, 2012, doi: http://dx.doi.org/10.5684/soep.v29.

Inhalt des Do-Files:
Schritt 1: Datensatz mit SOEPinfo generieren
	Schritt 2: Einheitliche Umbenennung von Variablen & Generierung Gap-Variablen
	Schritt 3: BIOCOUPLY und Partnerschaftsstatus zuspielen	
	Schritt 4: Partnercharakteristika hinzufügen
	Schritt 5: Stichprobe definieren
	Schritt 6: Variablen generieren
	Schritt 7: Längsschnittgewichtung
	Schritt 8: Lücke-FB, Missings füllen (Non-Response)& Flag-Variablen generieren
	Schritt 9: Umwandlung in long-format
	Schritt 10: Sample einschränken
	Schritt 11: Einkommensvariable generieren
	Schritt 12: Dauer-Variablen
	Schritt 13: Missings kontrollieren
	Schritt 14: Kontinuierliche Variablen in kategoriale Variablen ändern
	Schritt 15: Hazard function
	Schritt 16: Weitere Änderungen Variablen
	Schritt 17: Partnercharakteristika - Variablen generieren
	Schritt 18: Variablen für multivariate Analysen
	Schritt 19: Prekäre Erwerbsarbeit
	Schritt 20: Variablen Partnerschaft
	Schritt 21: Familienerweiterung
	Schritt 22: Finale Analysen Dissertationsmanuskript
	Schritt 23: Unicode-Umwandlung Stata 14

Übersicht über Do-Files, die ich mit diesem Master Do-File aufrufe:
	do Diss_Matching150717
	do Diss_RenameGaps150717
	do luecke_frage_biocouple150311	
	do Diss_biocouple150321 
	do Diss_spelltyp_partnerschaft150317
	do Diss_partnervariablen151022
	do Diss_Analyse_partner151022
	do luecke_fragebogen151019
	do Diss_Missings151027_aufgeraeumt
	do partnercharakteristika151126.do
	do familienerweiterung_aufbereitung151026_aufgeraeumt
	do familienerweiterung_aufbereitung_teilII_160212_aufgeraeumt
	do familienerweiterung_variablen160311_aufgeraeumt
	do komposition_stichproben
	do multi_partnerschaft160310
	do multi_befristung160315
	do multi_prekaer160202
	do multi_prekaritaetsvariable160311
	do multi_zweiteskind160311
	do multi_zweiteskind_einzelvariablen160310
	do multi_zweiteskind_prekaer160316
	
Hinweis Namensgebung Do-Files
	Datum im Namen vermerken, um Versionen zu kontrollieren

Hinweis Namensgebung Datensätze
	sample.dta: wide-Format mit allen Variablen
	sample_long_org: long-Format mit allen Variablen und allen Fällen
	sample_long: Familiengründung, eingeschränktes Sample
	sample_long_zweites: Zweites Kind, eingeschränktes Sample
	
*/
	
clear all

set more off, permanently

version 14.1	//STATA Version, unter der Do-Files verfasst wurden


set maxvar 10000, permanently
set segmentsize 1g, permanently
set matsize 11000, permanently

// Diese Ado-Files müssen installiert sein, damit der Do-File fehlerfrei durchlaufen kann
* net install st0085_1,  from("http://www.stata-journal.com/software/sj7-2") 
	//esttab-Befehl
* net install st0085_2,  from("http://www.stata-journal.com/software/sj14-2") replace 
	//Aktualisierung esttab
* ssc install estout, replace	
* net install dthaz, from("http://www.doyenne.com/stata")
	//Ich glaube, dass würde nur bei einem balanced Panel funktionierern
* net install "http://www.stata.com/users/kcrow/tab2xl"
* ssc install soepren
* ssc install coefplot, replace
* ssc install tabout, replace //Summary Tables publication-ready
* ssc install outreg, replace 
	//beinhaltet "frmttable", um Tabellen für Word zu gestalten	
* ssc install fitstat, replace //Fitstat für Logistische Regression
* net install gr0056 //marginscontplot
* ssc install fre, replace
* ssc install combomarginsplot



* Pfade für SOEPinfo Matching-Do-Files anpassen
global MY_IN_PATH   "\\mpifg\dfs\home\ann\Documents\SOEPv29\"
global MY_OUT_PATH  "\\mpifg\dfs\home\ann\Documents\Promotion\Analyse SOEP\Do-Files\Datensaetze\"
global MY_TEMP_PATH "C:\temp_stata\"
global MY_OUT_FILE  ${MY_OUT_PATH}new.dta

* Pfade für meine eigenen Do-Files festlegen
global my_data_path "\\mpifg\dfs\home\ann\Documents\SOEPv29\"
global my_save_path "C:\Stata_Datensaetze\"


global years "1990" "1991" "1992" "1993" "1994" "1995" "1996" "1997" "1998" "1999" "2000" "2001" "2002" "2003" "2004" "2005" "2006" "2007" "2008" "2009" "2010" "2011" "2012" 
global jahre "1995" "1996" "1997" "1998" "1999" "2000" "2001" "2002" "2003" "2004" "2005" "2006" "2007" "2008" "2009" "2010" "2011" "2012" 
global wave "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" "ba" "bb" "bc"
global wave_no "90" "91" "92" "93" "94" "95" "96" "97" "98" "99" "00" "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12"

global years84 "1984" "1985" "1986" "1987" "1988" "1989" "1990" "1991" "1992" "1993" "1994" "1995" "1996" "1997" "1998" "1999" "2000" "2001" "2002" "2003" "2004" "2005" "2006" "2007" "2008" "2009" "2010" "2011" "2012" 
global wave84 "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" "ba" "bb" "bc"

**** Arbeitsverzeichnis definieren: Hier Speicherort der Do-Files gewaehlt
cd "\\mpifg\dfs\home\ann\Documents\Promotion\Analyse SOEP\Do-Files"



*** Aktuelles Datum zur Kennzeichnung des Analyseoutputs
local c_date=c(current_date)
display "`c_date'"
global date=subinstr("`c_date'", " ", "_", .)
display "${date}"


*** Makros Variable-Labels für Word-Output 
global Rstandard "_cons "\emp{\i {\b Konstante}}" qu_hh1income "\emp{\i Quadriertes Äquivalenzeinkommen}" hh1income "\emp{\i Äquivalenzeinkommen}" 0.west "  Ostdeutschland" 1.west "  Westdeutschland" deutsch "\emp{\i kein Migrationshintergrund}""
global Rhazard "dum16_20 "  17-20 Jahre" dum21_25 "  21-25 Jahre" dum26_30 "  26-30 Jahre" dum36_45 "  36-42 Jahre""
global Rhazard_zweites "second0 "  <1 Befragungsjahr" second1 "  1 Befragungsjahr" second2 "  2 Befragungsjahre" second3 "  3 Befragungsjahre" second4 "  4 Befragungsjahre" second5 "  5 Befragungsjahre" second6 "  >6 Befragungsjahre""
global Rrelpar "0.Irelpar "  kein Partner" 1.Irelpar "  Partner außerhalb des Haushalts" 2.Irelpar "  Kohabitation" 3.Irelpar "  Ehe" 0.ehevsnel "  Kohabitation" 1.ehevsnel "  Ehe""
global Rwork "0.Iwork "In Ausbildung" 1.Iwork "Vollzeit" 2.Iwork "Teilzeit" 3.Iwork "Geringfügig beschäftigt" 4.Iwork "Arbeitslos" 5.Iwork "Nicht erwerbstätig""
global Rbil "0.Iberufl_zwei "  noch kein Abschluss" 1.Iberufl_zwei "  ohne Ausbildung" 2.Iberufl_zwei "  mit Ausbildung" 3.Iberufl_zwei "  FH-/Uni-Abschluss""
global Rbefr "Tbefr "linear" ln_Tbefr "logarithmiert" qu_Tbefr "quadriert" 0.Hbefr "Unbefristet" 1.Hbefr "Befristet" 0.work_AHbefr "Unbefristet" 1.work_AHbefr "Befristet" 2.work_AHbefr "in Ausbildung" 3.work_AHbefr "Arbeitslos gemeldet" 4.work_AHbefr "Nicht erwerbstätig" 0.work_befr "Unbefristet" 1.work_befr "Bis zu 1 Jahr" 2.work_befr "2 Jahre" 3.work_befr "3 Jahre" 4.work_befr "4 und mehr Jahre" 5.work_befr "in Ausbildung" 6.work_befr "Arbeitslos gemeldet" 7.work_befr "Nicht erwerbstätig" 0.Kbefr "  Unbefristet" 1.Kbefr "  1 Jahr" 2.Kbefr "  2 Jahre" 3.Kbefr "  3 Jahre" 4.Kbefr "  >4 Jahre" 0.Kbefr_kurz "  Unbefristet" 1.Kbefr_kurz "  1 Jahr" 2.Kbefr_kurz "  2 Jahre" 3.Kbefr_kurz "  >3 Jahre""
global Rjobch "jobch_dum "\emp{\i {\b Jobwechsel}}" 0.Ajobch "Kein Jobwechsel" 1.Ajobch "Jobwechsel" 2.Ajobch "kein Arbeitsvertrag" 0.work_Ajobch "Kein Jobwechsel" 1.work_Ajobch "Jobwechsel" 2.work_Ajobch "in Ausbildung" 3.work_Ajobch "Arbeitslos gemeldet" 4.work_Ajobch "Nicht erwerbstätig"""
global Rjobch "jobch_dum "\emp{\i {\b Jobwechsel}}" 0.Ajobch "Kein Jobwechsel" 1.Ajobch "Jobwechsel" 2.Ajobch "kein Arbeitsvertrag" 0.work_Ajobch "Kein Jobwechsel" 1.work_Ajobch "Jobwechsel" 2.work_Ajobch "in Ausbildung" 3.work_Ajobch "Arbeitslos gemeldet" 4.work_Ajobch "Nicht erwerbstätig""
global Rarbeitsmarkt "0.erwerb "  Erwerbstätig" 1.erwerb "  Arbeitslos, nicht erwerbstätig" 2.erwerb "  in Ausbildung" 0.kum_arbeitslos_brose "  keine" 1.kum_arbeitslos_brose "  geringe bis mittlere" 2.kum_arbeitslos_brose "  hohe""
global Rsorgen "1.Isorgen_a "  Große Sorgen" 2.Isorgen_a "  Einige Sorgen" 3.Isorgen_a "  keine Sorgen" 1.Isorgen_ew "  Große Sorgen" 2.Isorgen_ew "  Einige Sorgen" 3.Isorgen_ew "  keine Sorgen" 1.Isorgen_ew2 "  Große Sorgen" 2.Isorgen_ew2 "  Einige Sorgen" 3.Isorgen_ew2 "  keine Sorgen"" 
global Rpartnerwork "0.Ipartner_work2 "  in Ausbildung" 1.Ipartner_work2 "  Voll erwerbstätig" 2.Ipartner_work2 "  Teilzeitbeschäftigt" 3.Ipartner_work2 "  Unregelmäßig, geringfügig beschäftigt" 4.Ipartner_work2 "  Arbeitslos" 5.Ipartner_work2 "  Nicht erwerbstätig" 6.Ipartner_work2 "  keine Angabe" 0.partner_erwerb "  Erwerbstätig" 1.partner_erwerb "  Arbeitslos, nicht erwerbstätig" 2.partner_erwerb "  in Ausbildung" 3.partner_erwerb "  keine Angabe""
global Rpartnerbefr "0.Ipartner_work_AHbefr2 "  Unbefristet" 1.Ipartner_work_AHbefr2 "  Befristet" 2.Ipartner_work_AHbefr2 "  in Ausbildung" 3.Ipartner_work_AHbefr2 "  Arbeitslos" 4.Ipartner_work_AHbefr2 "  Nicht erwerbstätig" 5.Ipartner_work_AHbefr2 "  keine Angabe""
global Rpartnerjobch "0.Ipartner_jobch_dum2 "  Nein/kein Arbeitsvertrag" 1.Ipartner_jobch_dum2 "  Ja, Jobwechsel" 2.Ipartner_jobch_dum2 "  Keine Angabe" 0.partner_jobch_befr "  Unbefristet ohne Wechsel" 1.partner_jobch_befr "  Unbefristet mit Wechsel" 2.partner_jobch_befr "  Befristet ohne Wechsel" 3.partner_jobch_befr "  Befristet mit Wechsel" 4.partner_jobch_befr "  in Ausbildung" 5.partner_jobch_befr "  Arbeitslos" 6.partner_jobch_befr "  Nicht erwerbstätig" 7.partner_jobch_befr "  keine Angabe" 8.partner_jobch_befr "  Lat oder kein Partner""
global Rpartnerbil "0.Ipartner_bil2 "  (noch) kein Abschluss/Hauptschule" 1.Ipartner_bil2 "  Mittlere Reife" 2.Ipartner_bil2 "  (Fach-)Abitur" 3.Ipartner_bil2 "  keine Angabe" 0.Ipartner_berufl_zwei2 "  noch kein Abschluss" 1.Ipartner_berufl_zwei2 "  ohne Ausbildung" 2.Ipartner_berufl_zwei2 "  mit Ausbildung" 3.Ipartner_berufl_zwei2 "  FH-/Uni-Abschluss" 4.Ipartner_berufl_zwei2 "  keine Angabe""
global Rpartneralter "0.Ipartner_alter2 "  <20 Jahre" 1.Ipartner_alter2 "  21-25 Jahre" 2.Ipartner_alter2 "  26-30 Jahre" 3.Ipartner_alter2 "  31-35 Jahre" 4.Ipartner_alter2 "  >36 Jahre" 5.Ipartner_alter2 "  keine Angabe""
global kalenderzeit95 "1.kalenderzeit "  Wellen 1995-1999" 2.kalenderzeit "  Wellen 2000-2004" 3.kalenderzeit "  Wellen 2005-2009" 4.kalenderzeit "  Wellen 2010-2012""
global Rlohn "0.work_dauer_lohn "  2.-4. Quartil" 1.work_dauer_lohn "  1 Jahr 1. Quartil" 2.work_dauer_lohn "  2 Jahre" 3.work_dauer_lohn "  3+ Jahre" 4.work_dauer_lohn "  in Ausbildung" 5.work_dauer_lohn "  Arbeitslos gemeldet" 6.work_dauer_lohn "  Nicht erwerbstätig""
global Rprekaer "stunden_32 "\emp{\i {\b Vollzeit (>=32h)}}" stunden_35 "\emp{\i {\b Vollzeit(>=35h)}}" zeitarbeit_dummy "\emp{\i {\b In Zeitarbeit}}" dummy_gering "\emp{\i {\b Geringfügig oder unregelmäßig beschäftigt}}" 0.dauer_geringKK "  nicht betroffen" 1.dauer_geringKK "  1 Jahr" 2.dauer_geringKK "  >2 Jahre" dauer_gering "linear" ln_dauer_gering "logarithmiert" qu_dauer_gering "quadriert""
global RprekaerII "dauer_zeitarbeit "linear" ln_dauer_zeitarbeit "logarithmiert" qu_dauer_zeitarbeit "quadriert" dauer_teilzeit "linear" ln_dauer_teilzeit "logarithmiert" qu_dauer_teilzeit "quadriert" dauer_bruttoe "linear" ln_dauer_bruttoe "logarithmiert" qu_dauer_bruttoe "quadriert" 0.dauer_bruttoeK "  nicht betroffen" 1.dauer_bruttoeK "  1 Jahr" 2.dauer_bruttoeK "  2 Jahre" 3.dauer_bruttoeK "  3 Jahre" 4.dauer_bruttoeK "  >4 Jahre" dauer_brutto "linear" ln_dauer_brutto "logarithmiert" qu_dauer_brutto "quadriert" 0.dauer_bruttoK "  nicht betroffen" 1.dauer_bruttoK "  1 Jahr" 2.dauer_bruttoK "  2 Jahre" 3.dauer_bruttoK "  3 Jahre" 4.dauer_bruttoK "  >4 Jahre" dauer_hh "linear" ln_dauer_hh "logarithmiert" qu_dauer_hh "quadriert""
global Reinzelvar "0.teilzeit "  >32 Stunden" 1.teilzeit "  24-31 Stunden" 2.teilzeit "  <23 Stunden" 1.Qincome9512 "  1.Quartil" 2.Qincome9512 "  2.Quartil" 3.Qincome9512 "  3.Quartil" 4.Qincome9512 "  4.Quartil" 1.Qbruttostundenlohn "  1.Quartil" 2.Qbruttostundenlohn "  2.Quartil" 3.Qbruttostundenlohn "  3.Quartil" 4.Qbruttostundenlohn "  4.Quartil" 1.Qbruttoe "  1. Quartil" 2.Qbruttoe "  2. Quartil" 3.Qbruttoe "  3. Quartil" 4.Qbruttoe "  4. Quartil" 1.Qbrutto "  1. Quartil" 2.Qbrutto "  2. Quartil" 3.Qbrutto "  3. Quartil" 4.Qbrutto "  4. Quartil"" 
global Rzweites "0.alter_geb01K "  <21 Jahre" 1.alter_geb01K "  21-25 Jahre" 2.alter_geb01K "  26-30 Jahre" 3.alter_geb01K "  31-35 Jahre" 4.alter_geb01K "  >36 Jahre" 0.erwerb_zweites "  Erwerbstätig" 1.erwerb_zweites "  Elternzeit" 2.erwerb_zweites "  Arbeitslos, nicht erwerbstätig" 3.erwerb_zweites "  in Ausbildung" 0.work_zweites "  In Ausbildung" 1.work_zweites "  Vollzeit" 2.work_zweites "  Teilzeit" 3.work_zweites "  Geringfügig beschäftigt" 4.work_zweites "  Arbeitslos" 5.work_zweites "  Nicht erwerbstätig" 6.work_zweites "  Elternzeit""
global RzweitesII "0.erwerb_teilzeit "  >32 Stunden" 1.erwerb_teilzeit "  24-31 Stunden" 2.erwerb_teilzeit "  <23 Stunden" 3.erwerb_teilzeit "  Elternzeit" 4.erwerb_teilzeit "  Arbeitslos, nicht erwerbstätig" 5.erwerb_teilzeit "  in Ausbildung" 0.work_dauer_teilzeit_zweites "  >32 Stunden" 1.work_dauer_teilzeit_zweites "  1 Jahr Teilzeit" 2.work_dauer_teilzeit_zweites "  2 Jahre Teilzeit" 3.work_dauer_teilzeit_zweites "  >3 Jahre Teilzeit" 4.work_dauer_teilzeit_zweites "  Elternzeit" 5.work_dauer_teilzeit_zweites "  Arbeitslos, nicht erwerbstätig" 6.work_dauer_teilzeit_zweites "  in Ausbildung" 0.erwerb_teilzeit_erstes "  >32 Stunden" 1.erwerb_teilzeit_erstes "  24-31 Stunden" 2.erwerb_teilzeit_erstes "  <23 Stunden" 3.erwerb_teilzeit_erstes "  Arbeitslos, nicht erwerbstätig" 4.erwerb_teilzeit_erstes "  In Ausbildung" 0.work_dauer_teilzeit "  >32 Stunden" 1.work_dauer_teilzeit "  1 Jahr Teilzeit" 2.work_dauer_teilzeit "  2 Jahre Teilzeit" 3.work_dauer_teilzeit "  >3 Jahre Teilzeit" 4.work_dauer_teilzeit "  in Ausbildung" 5.work_dauer_teilzeit "  Arbeitslos, nicht erwerbstätig""
global Rbeziehung "beziehung "\emp{\i linear}" ln_beziehung "\emp{\i logarithmiert}" c.beziehung#c.beziehung "\emp{\i quadriert}" beziehung_hh "\emp{\i linear}" ln_beziehung_hh "\emp{\i logarithmiert}" c.beziehung_hh#c.beziehung_hh "\emp{\i quadriert}""
global Rpartnerzweites "0.partner_erwerb_zweites "  Erwerbstätig" 1.partner_erwerb_zweites "  Elternzeit" 2.partner_erwerb_zweites "  Arbeitslos, nicht erwerbstätig" 3.partner_erwerb_zweites "  in Ausbildung" 4.partner_erwerb_zweites "  keine Angabe" 0.partner_work_zweites "  In Ausbildung" 1.partner_work_zweites "  Vollzeit" 2.partner_work_zweites "  Teilzeit" 3.partner_work_zweites "  Geringfügig beschäftigt" 4.partner_work_zweites "  Arbeitslos" 5.partner_work_zweites "  Nicht erwerbstätig" 6.partner_work_zweites "  Elternzeit" 7.partner_work_zweites "  keine Angabe" 0.partner_erwerb_zwo "  Erwerbstätig/Elternzeit" 1.partner_erwerb_zwo "  Arbeitslos, nicht erwerbstätig" 2.partner_erwerb_zwo "  in Ausbildung" 3.partner_erwerb_zwo "  keine Angabe""
global Rflag "flag_berufl_zwei "Flag Bildungsabschluss" flag_work "Flag Erwerbsstatus" flag_hinc "Flag Haushaltseinkommen" flag_vebzeit "Flag vereinbarte Arbeitszeit" flag_work_jobch "Flag Erwerbsstatus & Jobwechsel" flag_work_befr "Flag Erwerbsstatus & Befristung" flag_work_jobch_befr "Flag Erwerbsstatus & Jobwechsel & Befristung" flag_befr "Flag Befristung" flag_relpar "Flag Partnerschaftsstatus" flag_gesamt "Flag Arbeitsmarkterfahrung" flag_gesamt2 "Flag Arbeitsmarkterfahrung" flag_labgro "Flag Individuelles Bruttoeinkommen" flag_zeitarbeit "Flag Zeitarbeit" firstprekaer4 "Flag erstes Befragungsjahr bereits prekär" firstprekaer6 "Erstes Befragungsjahr bereits prekär" firstprekaer7 "\emp{\i Erstes Befragungsjahr bereits prekär}"  aufstieg_prekaer7 "\emp{\i Vor Prekarität arbeitslos oder nicht erwerbstätig}" flag_sorgen_a "Flag Sorgen Arbeitsplatzverlust" flag_sorgen_a2 "Flag Sorgen Arbeitsplatzverlust" flag_sorgen_ew "Flag Sorgen eigene ökonomische Situation" flag_sorgen_ew2 "Flag Sorgen eigene ökonomische Situation""
global Rinteraktion "2.Irelpar#2.Kbeziehung_hh "  Kohabitation*2 Jahre" 2.Irelpar#3.Kbeziehung_hh "  Kohabitation*3 Jahre" 2.Irelpar#4.Kbeziehung_hh "  Kohabitation*4 Jahre" 2.Irelpar#5.Kbeziehung_hh "  Kohabitation*5 Jahre" 2.Irelpar#6.Kbeziehung_hh "  Kohabitation*6 Jahre" 2.Irelpar#7.Kbeziehung_hh "  Kohabitation*7 Jahre" 2.Irelpar#8.Kbeziehung_hh "  Kohabitation*8 Jahre" 2.Irelpar#9.Kbeziehung_hh "  Kohabitation*9 Jahre" 2.Irelpar#10.Kbeziehung_hh "  Kohabitation* >10 Jahre" 0.ehevsnel#1.Kbeziehung "  Kohabitation*1 Jahr" 0.ehevsnel#2.Kbeziehung "  Kohabitation*2 Jahre" 0.ehevsnel#3.Kbeziehung "  Kohabitation*3 Jahre" 0.ehevsnel#4.Kbeziehung "  Kohabitation*4 Jahre" 0.ehevsnel#5.Kbeziehung "  Kohabitation*5 Jahre" 0.ehevsnel#6.Kbeziehung "  Kohabitation*6 Jahre" 0.ehevsnel#7.Kbeziehung "  Kohabitation*7 Jahre" 0.ehevsnel#8.Kbeziehung "  Kohabitation*8 Jahre" 0.ehevsnel#9.Kbeziehung "  Kohabitation*9 Jahre" 0.ehevsnel#10.Kbeziehung "  Kohabitation* >10 Jahre" 0.ehevsnel#1.Kbeziehung_hh "  Kohabitation*1 Jahr" 0.ehevsnel#2.Kbeziehung_hh "  Kohabitation*2 Jahre" 0.ehevsnel#3.Kbeziehung_hh "  Kohabitation*3 Jahre" 0.ehevsnel#4.Kbeziehung_hh "  Kohabitation*4 Jahre" 0.ehevsnel#5.Kbeziehung_hh "  Kohabitation*5 Jahre" 0.ehevsnel#6.Kbeziehung_hh "  Kohabitation*6 Jahre" 0.ehevsnel#7.Kbeziehung_hh "  Kohabitation*7 Jahre" 0.ehevsnel#8.Kbeziehung_hh "  Kohabitation*8 Jahre" 0.ehevsnel#9.Kbeziehung_hh "  Kohabitation*9 Jahre" 0.ehevsnel#10.Kbeziehung_hh "  Kohabitation* >10 Jahre""
global RinteraktionI "1.dauer_prekaerK7_zweites#0.ehevsnel "  Kohabitation*1 Jahr" 2.dauer_prekaerK7_zweites#0.ehevsnel "  Kohabitation*2 Jahre" 3.dauer_prekaerK7_zweites#0.ehevsnel "  Kohabitation*3 Jahre" 4.dauer_prekaerK7_zweites#0.ehevsnel "  Kohabitation*4 Jahre" 5.dauer_prekaerK7_zweites#0.ehevsnel "  Kohabitation* >5 Jahre" 1.prekaer7_zweites#0.ehevsnel "  Kohabitation*Prekär" 2.Irelpar#0.dauer_prekaerK7 "  Kohabitation*nicht prekär" 2.Irelpar#2.dauer_prekaerK7 "  Kohabitation*2 Jahre" 2.Irelpar#3.dauer_prekaerK7 "  Kohabitation*3 Jahre" 2.Irelpar#4.dauer_prekaerK7 "  Kohabitation*4 Jahre" 2.Irelpar#5.dauer_prekaerK7 "  Kohabitation*>5 Jahre" 2.Irelpar#0.Kbefr "  Kohabitation*Unbefristet" 2.Irelpar#2.Kbefr "  Kohabitation*2 Jahre" 2.Irelpar#3.Kbefr "  Kohabitation*3 Jahre" 2.Irelpar#4.Kbefr "  Kohabitation* >4 Jahre" 2.Irelpar#1.Kbeziehung "  Kohabitation*1 Jahr" 2.Irelpar#2.Kbeziehung "  Kohabitation*2 Jahre" 2.Irelpar#3.Kbeziehung "  Kohabitation*3 Jahre" 2.Irelpar#4.Kbeziehung "  Kohabitation*4 Jahre" 2.Irelpar#5.Kbeziehung "  Kohabitation*5 Jahre" 2.Irelpar#6.Kbeziehung "  Kohabitation*6 Jahre" 2.Irelpar#7.Kbeziehung "  Kohabitation*7 Jahre" 2.Irelpar#8.Kbeziehung "  Kohabitation*8 Jahre" 2.Irelpar#9.Kbeziehung "  Kohabitation*9 Jahre" 2.Isorgen_a#0.Hbefr "  Einige Sorgen*Unbefristet" 2.Isorgen_ew2#0.Hbefr "  Einige Sorgen*Unbefristet" 3.Isorgen_a#0.Hbefr "  Keine Sorgen*Unbefristet" 3.Isorgen_ew2#0.Hbefr "  Keine Sorgen*Unbefristet""
global RinteraktionII "0.dauer_prekaerK7#1.west "  nicht prekär*Westdeutschland" 2.dauer_prekaerK7#1.west "  2 Jahre*Westdeutschland" 3.dauer_prekaerK7#1.west "  3 Jahre*Westdeutschland" 4.dauer_prekaerK7#1.west "  4 Jahre*Westdeutschland" 5.dauer_prekaerK7#1.west "  >5 Jahre*Westdeutschland"  1.dauer_prekaerK7K#1.west "  1 Jahr*Westdeutschland" 2.dauer_prekaerK7K#1.west "  2 Jahre*Westdeutschland" 3.dauer_prekaerK7K#1.west "  3 Jahre*Westdeutschland" 1.dauer_prekaerK7K#0.ehevsnel "  Kohabitation*1 Jahr" 2.dauer_prekaerK7K#0.ehevsnel "  Kohabitation*2 Jahre" 3.dauer_prekaerK7K#0.ehevsnel "  Kohabitation*>3 Jahre" 0.dauer_prekaerK7_zweitesK#1.west "  nicht prekär*Westdeutschland" 2.dauer_prekaerK7_zweitesK#1.west "  2 Jahre*Westdeutschland" 3.dauer_prekaerK7_zweitesK#1.west "  3 Jahre*Westdeutschland" 4.dauer_prekaerK7_zweitesK#1.west "  4 Jahre*Westdeutschland" 5.dauer_prekaerK7_zweitesK#1.west "  >5 Jahre*Westdeutschland"  1.dauer_prekaerK7_zweitesK#1.west "  1 Jahr*Westdeutschland." 2.dauer_prekaerK7_zweitesK#1.west "  2 Jahre*Westdeutschland" 3.dauer_prekaerK7_zweitesK#1.west "  3 Jahre*Westdeutschland" 1.dauer_prekaerK7_zweitesK#0.ehevsnel "  Kohabitation*1 Jahr" 2.dauer_prekaerK7_zweitesK#0.ehevsnel "  Kohabitation*2 Jahre" 3.dauer_prekaerK7_zweitesK#0.ehevsnel "  Kohabitation*>3 Jahre""



foreach var in "Isorgen_a" "Isorgen_ew2" {
	global Rinteraktion_`var' "1.dauer_prekaerK7_zweites#2.`var' "  1 Jahr*Einige Sorgen" 1.dauer_prekaerK7_zweites#3.`var' "  1 Jahr*Keine Sorgen" 2.dauer_prekaerK7_zweites#2.`var' "  2 Jahre*Einige Sorgen" 2.dauer_prekaerK7_zweites#3.`var' "  2 Jahre*Keine Sorgen"  3.dauer_prekaerK7_zweites#2.`var' "  3 Jahre*Einige Sorgen" 3.dauer_prekaerK7_zweites#3.`var' "  3 Jahre*Keine Sorgen" 4.dauer_prekaerK7_zweites#2.`var' "  4 Jahre*Einige Sorgen" 4.dauer_prekaerK7_zweites#3.`var' "  4 Jahre*Keine Sorgen" 5.dauer_prekaerK7_zweites#2.`var' "  5 Jahre*Einige Sorgen" 5.dauer_prekaerK7_zweites#3.`var' "  5 Jahre*Keine Sorgen" 1.prekaer7_zweites#2.`var' "  Prekär*Einige Sorgen" 1.prekaer7_zweites#3.`var' "  Prekär*Keine Sorgen" 2.`var'#0.dauer_prekaerK7 "  Einige Sorgen*NAV" 2.`var'#1.dauer_prekaerK7 "  Einige Sorgen*1 Jahr" 2.`var'#2.dauer_prekaerK7 "  Einige Sorgen*2 Jahre" 2.`var'#3.dauer_prekaerK7 "  Einige Sorgen # 3 Jahre" 2.`var'#4.dauer_prekaerK7 "  Einige Sorgen*4 Jahre" 2.`var'#5.dauer_prekaerK7 "  Einige Sorgen* >5 Jahre" 3.`var'#0.dauer_prekaerK7 "  Keine Sorgen*nicht prekär" 3.`var'#1.dauer_prekaerK7 "  Keine Sorgen*1 Jahr" 3.`var'#2.dauer_prekaerK7 "  Keine Sorgen*2 Jahre" 3.`var'#3.dauer_prekaerK7 "  Keine Sorgen*3 Jahre" 3.`var'#4.dauer_prekaerK7 "  Keine Sorgen*4 Jahre" 3.`var'#5.dauer_prekaerK7 "  Keine Sorgen* >5 Jahre" 2.`var'#0.Kbefr "  Einige Sorgen*Unbefristet" 2.`var'#2.Kbefr "  Einige Sorgen*2 Jahre" 2.`var'#3.Kbefr "  Einige Sorgen*3 Jahre" 2.`var'#4.Kbefr "  Einige Sorgen* >4 Jahre" 3.`var'#0.Kbefr "  Keine Sorgen*Unbefristet" 3.`var'#2.Kbefr "  Keine Sorgen*2 Jahre" 3.`var'#3.Kbefr "  Keine Sorgen*3 Jahre" 3.`var'#4.Kbefr "  Keine Sorgen* >4 Jahre" 2.`var'#0.Kbefr_kurz "  Einige Sorgen*Unbefristet" 2.`var'#2.Kbefr_kurz "  Einige Sorgen*2 Jahre" 2.`var'#3.Kbefr_kurz "  Einige Sorgen*3 Jahre" 2.`var'#4.Kbefr_kurz "  Einige Sorgen* >4 Jahre" 3.`var'#0.Kbefr_kurz "  Keine Sorgen*Unbefristet" 3.`var'#2.Kbefr_kurz "  Keine Sorgen*2 Jahre" 3.`var'#3.Kbefr_kurz "  Keine Sorgen*>3 Jahre" 3.`var'#4.Kbefr_kurz "  Keine Sorgen* >4 Jahre""
}

foreach var in "dauer_zeitarbeitK" "dauer_geringK" "dauer_hhK" "dauer_lohnK" "dauer_teilzeitK" {
	global R`var' "0.`var' "  nicht betroffen" 1.`var' "  1 Jahr" 2.`var' "  2 Jahre" 3.`var' "  >3 Jahre""
}

foreach var in "Kbeziehung" "Kbeziehung_hh" {
	global R`var' "0.`var' "  kein Partner" 1.`var' "  1 Jahr" 2.`var' "  2 Jahre" 3.`var' "  3 Jahre" 4.`var' "  4 Jahre" 5.`var' "  5 Jahre" 6.`var' "  6 Jahre" 7.`var' "  7 Jahre" 8.`var' "  8 Jahre" 9.`var' "  9 Jahre" 10.`var' "  >10 Jahre""
}

foreach var in "prekaer4" "prekaer5" "prekaer6" "prekaer7" "prekaer8" "prekaer9" {
	global R`var' "first`var' "\emp{\i Erstes Befragungsjahr bereits prekär}" aufstieg_`var' "\emp{\i Vor Prekarität arbeitslos oder nicht erwerbstätig}" aufstieg_`var'_zweites "\emp{\i Vor Prekarität arbeitslos oder nicht erwerbstätig}" dauer_`var' "\emp{\i linear}" ln_dauer_`var' "\emp{\i logarithmiert}" qu_dauer_`var' "\emp{\i quadriert}" c.dauer_`var'#c.dauer_`var' "\emp{\i quadriert}" dauer_`var'_zweites "\emp{\i linear}" ln_dauer_`var'_zweites "\emp{\i logarithmiert}" qu_dauer_`var'_zweites "\emp{\i quadriert}" c.dauer_`var'_zweites#c.dauer_`var'_zweites "\emp{\i quadriert}" 0.help_`var' "  Nicht prekär" 1.help_`var' "  Prekär" 0.`var'_zweites "  Nicht prekär" 1.`var'_zweites "  Prekär"" 
}

foreach var in "prekaerK4" "prekaerK5" "prekaerK6" "prekaerK7" "prekaerK8" "prekaerK9" {
	global R`var' "0.dauer_`var' "  nicht prekär" 1.dauer_`var' "  1 Jahr" 2.dauer_`var' "  2 Jahre" 3.dauer_`var' "  3 Jahre" 4.dauer_`var' "  4 Jahre" 5.dauer_`var' "  >5 Jahre" 0.dauer_`var'_zweites "  nicht prekär" 1.dauer_`var'_zweites "  1 Jahr" 2.dauer_`var'_zweites "  2 Jahre" 3.dauer_`var'_zweites "  3 Jahre" 4.dauer_`var'_zweites "  4 Jahre" 5.dauer_`var'_zweites "  >5 Jahre""
}

foreach var in "prekaerK7K" "prekaerK7_zweitesK" {
	global R`var' "0.dauer_`var' "  nicht prekär" 1.dauer_`var' "  1 Jahr" 2.dauer_`var' "  2 Jahre" 3.dauer_`var' "  >3 Jahre" 1.dauer_`var'#2.Isorgen_a "  1 Jahr*Einige Sorgen" 1.dauer_`var'#3.Isorgen_a "  1 Jahr*Keine Sorgen" 2.dauer_`var'#2.Isorgen_a "  2 Jahre*Einige Sorgen" 2.dauer_`var'#3.Isorgen_a "  2 Jahre*Keine Sorgen" 3.dauer_`var'#2.Isorgen_a "  >3 Jahre*Einige Sorgen" 3.dauer_`var'#3.Isorgen_a "  >3 Jahre*Keine Sorgen" 1.dauer_`var'#2.Isorgen_ew2 "  1 Jahr*Einige Sorgen" 1.dauer_`var'#3.Isorgen_ew2 "  1 Jahr*Keine Sorgen" 2.dauer_`var'#2.Isorgen_ew2 "  2 Jahre*Einige Sorgen" 2.dauer_`var'#3.Isorgen_ew2 "  2 Jahre*Keine Sorgen" 3.dauer_`var'#2.Isorgen_ew2 "  >3 Jahre*Einige Sorgen" 3.dauer_`var'#3.Isorgen_ew2 "  >3 Jahre*Keine Sorgen""
}



* Alle Label-Makros
global variablen_workshop "${Rstandard} ${Rwork} ${Rhazard} ${Rhazard_zweites} ${Rrelpar} ${Rbil} ${Rbefr} ${Rjobch} ${Rarbeitsmarkt} ${Rverlust} ${Rsorgen} ${Rsorgen_aII}  ${Rsorgen_aIII} ${Rsorgen_aIV} ${Rsorgen_aV} ${Rsorgen_aVI} ${Rrelparbefr} ${Rkinderhaben} ${RerfolgberufI} ${Rglueckehe} ${Rpr_kinder} ${Rpr_beruf} ${Rhakim2} ${Rhakim3} ${Rbefr_praefk} ${Rbefr_praefe} ${Rpraef_k} ${Rpraef_e} ${Rdauer_zeitarbeitK} ${Rdauer_geringK} ${Rdauer_hhK} ${Rdauer_lohnK} ${Rdauer_teilzeitK} ${Rpraef_k2} ${Rpraef_e2} ${RrelparbefrII} ${RrelparbefrIII} ${RrelparbefrIV} ${Rbefrjobch} ${Rpartnerwork} ${Rpartnerbefr} ${Rpartnerjobch} ${Rpartnerbil} ${Rpartneralter} ${kalenderzeit95} ${Rlohn} ${Rprekaer} ${RprekaerII} ${RprekaerIII} ${Reinzelvar} ${Rzweites} ${RzweitesII} ${RKbeziehung} ${RKbeziehung_hh} ${Rbeziehung} ${RKalterkohab} ${RKalterbez} ${RprekaerII} ${Rpartnerzweites} ${Rflag} ${Rprekaer4} ${Rprekaer5} ${Rprekaer6} ${Rprekaer7} ${Rprekaer8} ${Rprekaer9} ${RprekaerK4} ${RprekaerK5} ${RprekaerK6} ${RprekaerK7} ${RprekaerK8} ${RprekaerK9} ${Rinteraktion} ${Rinteraktion_Isorgen_a} ${Rinteraktion_Isorgen_ew2} ${RinteraktionI} ${RinteraktionII} ${RprekaerK7K} ${RprekaerK7_zweitesK} ${RprekaerK7II} &{prekaerK7_zweitesKII}"


*** Weitere Makros für Word-Output: Referenzkategorie
global refcat_sonstiges "dum16_20 "\emp{\i {\b Alter}{\line (Ref.: 31-35 Jahre)}}" 0.west "\emp{\i {\b Region}}" 0.Irelpar "\emp{\i {\b Partnerschaftsstatus}}" 0.ehevsnel "\emp{\i {\b Partnerschaftsstatus}}" 0.befr_rel2 "\emp{\i {\b Partnerschaftsstatus und Befristung}}" 0.befr_rel6 "\emp{\i {\b Partnerschaftsstatus und Befristung}}" 0.Iwork "\emp{\i {\b Erwerbsstatus}}" 0.Ibil "\emp{\i Schulische Bildungsausstattung}" 0.Iberufl_zwei "\emp{\i {\b Kontrollvariablen}{\line Berufliche Bildungsausstattung}}" 0.Hbefr "\emp{\i {\b Aktuelle Befristung}}" 0.work_AHbefr "\emp{\i {\b Aktuelle Befristung}}" 0.work_befr "\emp{\i {\b Dauer aktuelle Befristung}}" 0.Ajobch "\emp{\i Jobwechsel}" 0.work_Ajobch "\emp{\i Jobwechsel}" 0.jobch_befr "\emp{\i {\b Befristung + Jobwechsel}}" 0.jobch_befr2 "\emp{\i {\b Befristung + Jobwechsel}}" 1.kalenderzeit "\emp{\i Kalenderzeit}""  		  
global refcat_arbeitsmarkt "0.Hbefr "\emp{\i {\b Aktuelle Befristung}}" 0.kum_arbeitslos_brose "\emp{\i {\b Arbeitslosigkeitserfahrung}}" 0.AKDGarbeitslos "\emp{\i {\b Arbeitslosigkeitserfahrung}}" 0.erwerb "\emp{\i {\b Erwerbsstatus}}" 0.work_dauer_lohn "\emp{\i {\b Dauer Niedriglohn}}" 0.Kbefr "\emp{\i {\b Dauer der Befristung}}" 0.Kbefr_kurz "\emp{\i {\b Dauer der Befristung}}" Tbefr "\emp{\i {\b Dauer der aktuellen Befristung}}" 0.erwerb_teilzeit_erstes "\emp{\i {\b Erwerbsstatus und Wochenarbeitszeit}}" 0.work_dauer_teilzeit "\emp{\i {\b Erwerbsstatus und Dauer Teilzeitbeschäftigung}}""
global refcat_sorgen "0.tnz_verlust "\emp{\i Wahrscheinlichkeit Arbeitsplatzverlust}"  0.befr_verlust3 "\emp{\i Befristung und Wahrscheinlichkeit Arbeitsplatzverlust}" 0.befr_verlust4 "\emp{\i Befristung und Wahrscheinlichkeit Arbeitsplatzverlust}" 1.Isorgen_a "\emp{\i {\b Sorgen Arbeitsplatzsicherheit}}" 1.Isorgen_ew "\emp{\i {\b Sorgen eigene ökonomische Situation}}"  1.Isorgen_ew2 "\emp{\i {\b Sorgen eigene ökonomische Situation}}" 0.befr_sorgen_a "\emp{\i {\b Befristung und Sorgen Arbeitsplatzsicherheit}}"  0.befr_sorgen_a2 "\emp{\i {\b Befristung und Sorgen Arbeitsplatzsicherheit}}"  0.befr_sorgen_a3 "\emp{\i {\b Befristung und Sorgen Arbeitsplatzsicherheit}}"  0.befr_sorgen_a4 "\emp{\i {\b Befristung und Sorgen Arbeitsplatzsicherheit}}" 0.befr_sorgen_a5 "\emp{\i {\b Befristung und Sorgen Arbeitsplatzsicherheit}}" 0.Isorg_a "\emp{\i {\b Sorgen Arbeitsplatzsicherheit}}""  
global refcat_praef "0.kinderhaben "\emp{\i {\b Präferenzen}{\line Kinder haben}}"  0.erfolgberufI "\emp{\i Erfolg im Beruf}"  0.glueckehe "\emp{\i Glückliche Partnerschaft}"    0.pr_kinder "\emp{\i Kinder haben}"  0.pr_beruf "\emp{\i Erfolg im Beruf}" 0.hakim2 "\emp{\i {\b Familie- und Karrierepräferenzen}{\line Präferenztheorie (hakim2)}}"  0.hakim3 "\emp{\i Präferenztheorie (hakim3)}"  0.hakim "\emp{\i Präferenztheorie}"  0.befr_praefk "\emp{\i {\b Befristung und Präferenzen}{\line Aktuelle Befristung und Wichtigkeit Kinder}}"   0.praef_k "\emp{\i Dauer der Befristung und Wichtigkeit Kinder}"  0.praef_k2 "\emp{\i Dauer der Befristung und Wichtigkeit Kinder}"   0.befr_praefe "\emp{\i {\b Befristung und Präferenzen}{\line Aktuelle Befristung und Wichtigkeit beruflicher Erfolg}}"  0.praef_e "\emp{\i Dauer der Befristung und Wichtigkeit beruflicher Erfolg}"   0.praef_e2 "\emp{\i Dauer der Befristung und Wichtigkeit beruflicher Erfolg}" 0.befr_hakim24 "\emp{\i {\b Dauer der Befristung und Präferenzen}}""
global refcat_partner "0.Ipartner_work2 "\emp{\i Partner Erwerbsstatus}" 0.partner_erwerb "\emp{\i Erwerbsstatus des Partners}" 0.Ipartner_work_AHbefr2 "\emp{\i Partner Befristung}" 0.Ipartner_jobch_dum2 "\emp{\i Partner Jobwechsel}" 0.partner_jobch_befr "\emp{\i Partner Befr. & Jobwechsel}" 0.Ipartner_berufl_zwei2 "\emp{\i Partner berufliche Bildungsausstattung}" 0.Ipartner_bil2 "\emp{\i Partner schulische Bildungsausstattung}" 0.Ipartner_alter2 "\emp{\i Partner Alter}""
global refcat_zweites "second0 "\emp{\i {\b Befragungsjahre seit Geburt des 1. Kindes}{\line (Ref.: 2 Befragungsjahre)}}" 0.alter_geb01K "\emp{\i Alter bei Geburt des 1. Kindes}" 0.erwerb_zweites "\emp{\i {\b Erwerbsstatus}}" 0.work_zweites "\emp{\i {\b Erwerbsstatus}}" 0.erwerb_teilzeit "\emp{\i {\b Erwerbsstatus und Wochenarbeitszeit}}" 0.partner_work_zweites "\emp{\i Erwerbsstatus des Partners}" 0.partner_erwerb_zweites "\emp{\i Erwerbsstatus des Partners}" 0.partner_erwerb_zwo "\emp{\i Erwerbsstatus des Partners}" 0.work_dauer_teilzeit_zweites "\emp{\i {\b Erwerbsstatus und Dauer Teilzeitbeschäftigung}}""
global refcat_prekaer7 "0.help_prekaer7 "\emp{\i {\b Aktuelle Prekarität}}" dauer_prekaer7 "\emp{\i {\b Dauer Prekarität}}" 0.dauer_prekaerK7 "\emp{\i {\b Dauer Prekarität}}" 0.dauer_prekaerK7K "\emp{\i {\b Dauer Prekarität}}" dauer_prekaer7_zweites "\emp{\i {\b Dauer Prekarität}}" 0.dauer_prekaerK7_zweitesK "\emp{\i {\b Dauer Prekarität}}" 0.prekaer7_zweites "\emp{\i {\b Aktuelle Prekarität}}" 0.dauer_prekaerK7_zweites "\emp{\i {\b Dauer Prekarität}}""
global refcat_prekaer8 "0.prekaer8_zweites "\emp{\i {\b Aktuelle Prekarität}}""
global refcat_prekaer9 "0.help_prekaer9 "\emp{\i {\b Aktuelle Prekarität}}" 0.dauer_prekaerK9 "\emp{\i {\b Dauer aktuelle Prekarität}}" dauer_prekaer9 "\emp{\i {\b Dauer Prekarität}}" dauer_prekaer9_zweites "\emp{\i {\b Dauer Prekarität}}" 0.prekaer9_zweites "\emp{\i {\b Aktuelle Prekarität}}" 0.dauer_prekaerK9_zweites "\emp{\i {\b DauerPrekarität}}""
global refcat_prekaerII "dauer_teilzeit "\emp{\i {\b Dauer Teilzeitbeschäftigung}}" 0.dauer_teilzeitK "\emp{\i {\b Dauer Teilzeitbeschäftigung}}" 1.Qincome9512 "\emp{\i {\b Niedriges HH-Einkommen}}" 0.teilzeit "\emp{\i {\b Wochenarbeitszeit}}" 1.Qbruttostundenlohn "\emp{\i {\b Niedrigeinkommen}}" flag_berufl_zwei "\emp{\i {\b Flag-Variablen}}" dauer_gering "\emp{\i {\b Dauer geringfügig oder unregelmäßig beschäftigt}}" 0.dauer_geringK "\emp{\i {\b Dauer geringfügig oder unregelmäßig beschäftigt}}" 0.dauer_geringKK "\emp{\i {\b Dauer geringfügig oder unregelmäßig beschäftigt}}"  dauer_lohn "\emp{\i {\b Dauer Niedriglohn}}" 0.dauer_lohnK "\emp{\i {\b Dauer Niedriglohn}}" dauer_hh "\emp{\i {\b Dauer niedriges HH-Einkommen}}" 0.dauer_hhK "\emp{\i {\b Dauer niedriges HH-Einkommen}}""
global refcat_prekaerIII "dauer_zeitarbeit "\emp{\i {\b Dauer Zeitarbeit}}" 0.dauer_zeitarbeitK "\emp{\i {\b Dauer Zeitarbeit}}""
global refcat_prekaerIV "dauer_bruttoe "\emp{\i {\b Dauer Niedriglohn}}" 0.dauer_bruttoeK "\emp{\i {\b Dauer Niedriglohn}}" 1.Qbruttoe "\emp{\i {\b Quartile Bruttostundenlohn}}" dauer_brutto "\emp{\i {\b Dauer Niedrigeinkommen}}" 0.dauer_brutto "\emp{\i {\b Dauer Niedrigeinkommen}}" 1.Qbrutto "\emp{\i {\b Quartile Bruttoeinkommen}}" 0.dauer_bruttoK "\emp{\i {\b Dauer Niedrigeinkommen}}""
global refcat_beziehung "1.Kbeziehung "\emp{\i {\b Dauer der Beziehung}{\line kategorial}}" 1.Kbeziehung_hh "\emp{\i {\b Dauer des Zusammenlebens}{\line kategorial}}" 0.Kalterkohab "\emp{\i {\b Alter bei Kohabitationsbeginn}}" 0.Kalterbez "\emp{\i {\b Alter bei Beziehungsbeginn}}""
global refcat_interaktion "0.ehevsnel#c.beziehung "\emp{\i {\b Interaktion Partnerschaftsstatus * Dauer der Beziehung}}" 0.ehevsnel#1.Kbeziehung "\emp{\i {\b Interaktion Partnerschaftsstatus * Dauer der Beziehung}{\line (Ref.: Ehe & > 10 Jahr)}}" 0.ehevsnel#c.beziehung_hh "\emp{\i {\b Interaktion Partnerschaftsstatus * Dauer des Zusammenlebens}}" 0.ehevsnel#1.Kbeziehung_hh "\emp{\i {\b Interaktion Partnerschaftsstatus * Dauer des Zusammenlebens}{\line (Ref.: Ehe & >10 Jahr)}}" 0.ehevsnel#0.Kbefr "\emp{\i {\b Interaktion Partnerschaft * Dauer der aktuellen Befristung}{\line (Ref.: Kohabitation & 1 Jahr)}}" 0.ehevsnel#0.dauer_prekaerK4 "\emp{\i {\b Interaktion Partnerschaftsstatus * Dauer der Prekarität}}" 1.Isorgen_a#0.Kbefr "\emp{\i {\b Interaktion Befristung * Sorgen Arbeitsplatzsicherheit}{\line (Ref.: 1 Jahr befristet & große Sorgen)}}" 1.Isorgen_ew2#0.Kbefr "\emp{\i {\b Interaktion Befristung * Sorgen eigene ökonomische Situation}{\line (Ref.: 1 Jahr befristet & große Sorgen)}}""
global refcat_interaktionI "2.Isorgen_a#0.dauer_prekaerK7 "\emp{\i {\b Interaktion Prekarität * Sorgen Arbeitsplatzsicherheit}{\line (Ref.: 1 Jahr & Große Sorgen)}}" 2.Isorgen_ew2#0.dauer_prekaerK7 "\emp{\i {\b Interaktion Prekarität * Sorgen eigene ökonomische Situation}{\line (Ref.: 1 Jahr & Große Sorgen)}}" 0.ehevsnel#0.dauer_prekaerK7 "\emp{\i {\b Interaktion Prekarität * Partnerschaftsstatus}{\line (Ref.: Ehe & 1 Jahr prekär)}}""
global refcat_interaktionII "2.Irelpar#2.Kbeziehung_hh "\emp{\i {\b Interaktion Partnerschaftsstatus * Dauer des Zusammenlebens}{\line (Ref.: Ehe & 1 Jahr)}}" 1.dauer_prekaerK7_zweites#2.Isorgen_a "\emp{\i {\b Interaktion Dauer Prekarität * Sorgen Arbeitsplatzsicherheit}{\line (Ref.: NAV & Große Sorgen)}}" 1.dauer_prekaerK7_zweites#2.Isorgen_ew2 "\emp{\i {\b Interaktion Dauer Prekarität * Sorgen eigene ökon. Situation}{\line (Ref.: NAV & Große Sorgen)}}" 1.prekaer7_zweites#2.Isorgen_a "\emp{\i {\b Interaktion Prekarität * Sorgen Arbeitsplatzsicherheit}{\line (Ref.: NAV & Große Sorgen)}}" 1.prekaer7_zweites#2.Isorgen_ew2 "\emp{\i {\b Interaktion Prekarität * Sorgen eigene ökon. Situation}{\line (Ref.: NAV & Große Sorgen)}}""
global refcat_interaktionIII "1.dauer_prekaerK7_zweites#0.ehevsnel "\emp{\i {\b Interaktion Partnerschaftsstatus * Dauer Prekarität}{\line (Ref.: Ehe & NAV)}}" 1.prekaer7_zweites#0.ehevsnel "\emp{\i {\b Interaktion Partnerschaftsstatus #* Aktuelle Prekarität}{\line (Ref.: Ehe & NAV)}}" 2.Irelpar#0.dauer_prekaerK7 "\emp{\i {\b Interaktion Partnerschaftsstatus * Dauer Prekarität}{\line (Ref.: Ehe & 1 Jahr)}}" 2.Irelpar#0.Kbefr "\emp{\i {\b Interaktion Partnerschaftsstatus * Dauer der Befristung}{\line (Ref.: Ehe & 1 Jahr)}}" 2.Isorgen_a#0.Kbefr "\emp{\i {\b Interaktion Sorgen Arbeitsplatzsicherheit * Dauer der Befristung}{\line (Ref.: Große Sorgen & 1 Jahr}}" 2.Isorgen_ew2#0.Kbefr "\emp{\i {\b Interaktion Sorgen eigene ökonomische Situation * Dauer der Befristung}{\line (Ref.: Große Sorgen & 1 Jahr}}" 2.Isorgen_a#0.Kbefr_kurz "\emp{\i {\b Interaktion Sorgen Arbeitsplatzsicherheit * Dauer der Befristung}{\line (Ref.: 1 Jahr befristet & große Sorgen)}}" 2.Isorgen_ew2#0.Kbefr_kurz "\emp{\i {\b Interaktion Sorgen eigene ökonomische Situation * Dauer der Befristung}{\line (Ref.: 1 Jahr befristet & große Sorgen)}}" 2.Irelpar#1.Kbeziehung "\emp{\i {\b Interaktion Partnerschaftsstatus * Dauer der Beziehung}{\line (Ref.: Ehe & >10 Jahre)}}""
global refcat_interaktionIV "2.Isorgen_a#0.Hbefr "\emp{\i {\b Interaktion Sorgen Arbeitsplatzsicherheit * Aktueller Befristungsstatus}{\line (Ref.: Große Sorgen & Befristet}}" 2.Isorgen_ew2#0.Hbefr "\emp{\i {\b Interaktion Sorgen eigene ökonomische Situation * Aktueller Befristungsstatus}{\line (Ref.: Große Sorgen & Befristet}}" 0.dauer_prekaerK7#1.west "\emp{\i {\b Interaktion Dauer der Prekarität * Region}{\line (Ref.: 1 Jahr & Ostdeutschland)}}" 1.dauer_prekaerK7K#1.west "\emp{\i {\b Interaktion Dauer der Prekarität * Region}{\line (Ref.: Nicht prekär & Ostdeutschland)}}" 1.dauer_prekaerK7K#0.ehevsnel "\emp{\i {\b Interaktion Partnerschaftsstatus * Dauer Prekarität}{\line (Ref.: Ehe & NAV)}}" 1.dauer_prekaerK7_zweitesK#0.ehevsnel "\emp{\i {\b Interaktion Partnerschaftsstatus * Dauer der Prekarität}{\line (Ref.: Ehe & NAV)}}" 1.dauer_prekaerK7_zweitesK#1.west "\emp{\i {\b Interaktion Dauer der Prekarität * Region}{\line (Ref.: Nicht prekär & Ostdeutschland)}}" 1.dauer_prekaerK7_zweitesK#2.Isorgen_a "\emp{\i {\b Interaktion Dauer der Prekarität * Sorgen Arbeitsplatzsicherheit}{\line (Ref.: Nicht prekär & Große Sorgen)}}" 1.dauer_prekaerK7_zweitesK#2.Isorgen_ew2 "\emp{\i {\b Interaktion Dauer der Prekarität * Sorgen eigene ökonomische Situation}{\line (Ref.: Nicht prekär & Große Sorgen)}}""

global refcat "${refcat_sonstiges} ${refcat_sorgen} ${refcat_praef} ${refcat_partner} ${refcat_arbeitsmarkt} ${refcat_zweites} ${refcat_prekaer7} ${refcat_prekaer8} ${refcat_prekaer9} ${refcat_prekaerII} ${refcat_prekaerIII} ${refcat_prekaerIV} ${refcat_beziehung} ${refcat_interaktion} ${refcat_interaktionI} ${refcat_interaktionII} ${refcat_interaktionIII} ${refcat_interaktionIV}"

*** Notizen unter Tabellen
global addnote ""Quelle: SOEP v29 1995-2012, eigene, gewichtete Berechnungen. Standardfehler in Klammern, + p<0,1 * p<0,05 ** p<0,01 *** p<0,001." "Für imputierte Werte durch Flag-Variablen kontrolliert.""
	// Mit Umbruch. ""Do-File: `name_do_file'.do. Quelle: SOEP 1990-2012," "eigene, gewichtete Berechnungen.""
global addnote_bis2011 ""Quelle: SOEP v29 1995-2011, eigene, gewichtete Berechnungen. Standardfehler in Klammern, + p<0,1 * p<0,05 ** p<0,01 *** p<0,001." "Für imputierte Werte durch Flag-Variablen kontrolliert.""

global addnote_nichtgewichtet ""Quelle: SOEP v29 1995-2012, eigene, nicht (!) gewichtete Berechnungen. Standardfehler in Klammern, + p<0,1 * p<0,05 ** p<0,01 *** p<0,001." "Für imputierte Werte durch Flag-Variablen kontrolliert.""
	
global addnote_bis2011_nichtgewichtet ""Quelle: SOEP v29 1995-2011, eigene, nicht (!) gewichtete Berechnungen. Standardfehler in Klammern, + p<0,1 * p<0,05 ** p<0,01 *** p<0,001." "Für imputierte Werte durch Flag-Variablen kontrolliert.""


*** Definition von Funktion in Mata um Spaltenbreite in Excel Output festzulegen
// Unter Stata 13 klappt dieses mata nicht
// falls schonmal ausgeführt: mata: mata drop set_excel_col_width()
mata
	void set_excel_col_width(string path, col1, col2, width){
		class xl scalar b //äquivalent zu b=xl(), funktioniert hier in der Funktion aber nicht
		b.load_book(path)
		b.set_column_width(col1, col2, width)
	}
end


*** Hinweise zur Funktion von Loops: Loop innerhalb eines Loops
/* Die Buchstaben ü, ä, ö nicht verwenden!
Bsp. 1: foreach var in "educ" "ausb" {
			foreach welle of numlist 2003/2005 {
			foreach wave of numlist 2006/2008 {
				tab `var'`welle'
				tab `var'`wave'
			}
			}
		}
		Ergebnis: Wird erst für "educ" und dann für "ausb" ausgeführt
				  Für den 1. Wert (2., usw) des 2. Loops alle Werte des 3. Loops
		Fazit: Zwei Loops innerhalb eines anderen werden unverständlich

 Bsp. 2: 	local eins "2000 2001 2002"
			local zwei "2001 2002 2003"
		foreach var in "educ" "ausb" {
			foreach X of numlist 1/3 {
			local x: word `X' of `eins'
			local y: word `X' of `zwei'
				replace `var'`x'=`var'`y' if `var'`x'==.
			}
 		}
	Ergebnis: Lokals im 2. Loop sind gleich gestellt & dem 1. Loop unterstellt
   Fazit: Anstelle von 2 Loops innerhalb eines anderen Loops: Das hier machen

 Bsp. 3a: Ein Loop innerhalb eines anderes
			foreach welle of numlist  2000/2002 {
				foreach var in "educ" "ausb" {
					tab `var'`welle'
				} 
			}
		Ergebnis Ausgabe: educ2000 ausb2000 educ2001 ausb2001 educ2002 ausb2002

 Bsp. 3b: Ein Loop innerhalb eines anderes
			foreach var in "educ" "ausb" {
				foreach welle of numlist 2000/2002 {
					tab `var'`welle'
				}
			}
		Ergebnis Ausgabe: educ2000 educ2001 educ2002 ausb2000 ausb2002 ausb2002
*/

* WICHTIGE ERKENNTNIS:
	* by persnr (welle): generate westdeutschland=west[1] 
		* --> hier wird zwar in zweiter Ebene nach "welle" sortiert, 
		* diese aber bei der Variablengenerierung nicht beachtet
	* by persnr welle: ...
		* --> hier wird auch nach "persnr und welle" sortiert, allerdings die
		* "welle"-Variable bei der Variablengenerierung beachtet
		
*** Beispiel Arbeit mit Matritzen
/* Funktionsfähiges Bsp.:
logit mutter dum16_20 dum21_25 dum26_30 dum36_45 ///
	ib3.Irelpar ib0.erwerb ib0.summe_prekaerK4  ///
	ib3.Iberufl_zwei hh1income qu_hh1income west deutsch ///
	[pweight=lbclgewicht] if welle>=1995, vce(cl persnr)		
pwcompare summe_prekaerK4, effects 

return list
matrix list r(table_vs)
matrix list r(b_vs)
 
 
matrix rename r(table_vs) pw_summeK4 //ich benenne es um, da ich sonst nicht auf einzelne Zellen zugreifen kann
 
local title_table=r(cmdline)
putexcel A1=("`title_table'") A2=(" Referenkategorien") B2=("Koeffizient") /*
	*/ C2=("Standardfehler") D2=("p-Wert") E2=("Konfidenzintervall")  /*
	*/ F2=("Konfidenzintervall") /*
	*/ using "${my_save_path}pwcompare_summe_prekaerK4.xlsx", replace
		//nur an dieser Stelle ",replace", damit falls vorhanden, Datei überschrieben wird
		//Im Loop ist ",modify" notwendig, da immer neue Zellen dazu kommen

local cols=colsof(pw_summeK4) //rowsof(X), colsof(X) zählt Zeilen oder Spalten
local row=3 //damit mit dritter Zeile begonnen wird


forvalues i =1/`cols' {

	local b_Wert=pw_summeK4[1,`i']
	local se_Wert=pw_summeK4[2,`i']
	local p_Wert=pw_summeK4[4,`i']
	local konfu_Wert=pw_summeK4[5,`i']
	local konfo_Wert=pw_summeK4[6,`i']
	
	local spaltenname: colnames pw_summeK4 //es werden alle Spaltennamen ausgegeben
	local help_spaltenname "`spaltenname'" //Diese schreibe ich in ein neues Makro
	local s: word `i' of `help_spaltenname' //Mit jedem Loop-Durchgang wird ein Spaltenname weiter gerückt
	
	putexcel A`row'=("`s'") B`row'=(`b_Wert') C`row'=(`se_Wert') D`row'=(`p_Wert') /*
		*/ E`row'=(`konfu_Wert') F`row'=(`konfo_Wert') using "${my_save_path}pwcompare_summe_prekaerK4.xlsx", modify
		
	local row=`row'+1
}

* Quellenhinweis einfügen
local row=`row'+2
putexcel A`row'=("Quelle: SOEP v29 1995-2012; eigene, gewichtete Berechnungen") using "${my_save_path}pwcompare_summe_prekaerK4.xlsx", modify
*/

/* Hinweis Interpretation Output pwcompare mit Interaktionen:
	0vs0bn.Kbefr#2vs1bn.Isorgen_ew2: Hier werden unbefr.+2.Sorgen mit unbefr.+1.Sorgen verglichen
*/

//**//////////////////////////////////////////////////////////////////////////**
** Schritt 1: Datensatz mit SOEPinfo generieren
//**//////////////////////////////////////////////////////////////////////////**
* Immer noch Fehler in SOEPinfo: Datei phrf $bleib-Variablen teilweise doppelt (Stand 16.03.15)

do Diss_Matching150717

********************************************************************************
* Schritt 1.1.: Missings definieren
********************************************************************************
/* Die Ausprägungen (-5) und (-6) sind bisher in keiner Doku ausgewiesen. Nach
	einem Telefonat mit Peter Krause vom DIW weiß ich aber, dass wegen der
	Filterführung diese Frage nicht gestellt wurde. */
	
/* Aus den Jahren 1984-1989 möchte ich alle Variablen bis auf die Gewicht-
	ungsvariablen und netto$ löschen. Deshalb werde ich diese bereits umbenennen
	was ich für die anderen Variablen in dem Do-File "RenameGaps" mache.
	Die allgemeine Syntax "drop *84" funktioniert nicht mehr, sonst lösche
	ich auch direkt wieder die neu umbenannten Gewichtungsvariablen.
	Loop mit Umbenennung der Varibale funktioniert aus irgendeinem Grund
	nicht, wenn ich "years84" und "wave84" als locals (anstelle von 
	globals) definiere. */

generate apbleib=. //1. Welle, deshalb keine Bleibewahrscheinlichkeit

foreach X of numlist 1/29 {
	local yy: word `X' of "${years84}"
	local w: word `X' of "${wave84}"

	rename `w'phrf phrf`yy'
	rename `w'pbleib bleib`yy'
	rename `w'netto netto`yy'
}		

drop bleib1984 //Wieder löschen

foreach welle of numlist 84/89 {
	drop oeffd`welle' nation`welle' lfs`welle' is88`welle' nace`welle' ///
		egp`welle' i1hinc`welle' i2hinc`welle'  i3hinc`welle'  i4hinc`welle' ///
		i5hinc`welle'
}

drop ap*  //alle Variablen der Jahre 1984-89 entfernen
drop bp* 
drop cp*  
drop dp* 
drop ep* 
drop fp* 
drop ahhnr bhhnr chhnr dhhnr ehhnr fhhnr 
drop hhnr //sonst funktioniert reshape nachher nicht
drop avebzeit auebstd bvebzeit buebstd cvebzeit cuebstd dvebzeit duebstd ///
	evebzeit euebstd fvebzeit fuebstd
drop *zupan*
drop y1110184 y1110185 y1110186 y1110187 y1110188 y1110189
drop impgro84 impnet84 impgro85 impnet85 impgro86 impnet86 impgro87 ///
	impnet87 impgro88 impnet88 impgro89 impnet89
drop rp107e03 wp11719 bbp12719 rp107e02 wp11718 bbp12718 rp107e01 ///
	wp11717 bbp12717 hp1311 mp09e02 hp1312 mp09e03 hp1310 mp09e01 hp1301 ///
	mp09a01 rp107a01 wp11706 bbp12706 hp1302 mp09a02 rp107a03 ///
	wp11707 bbp12707 hp1304 mp09b01 rp107b01 wp11708 bbp12708 hp1305 mp09b02 ///
	rp107b03 wp11709 bbp12709 hp1318 mp09g01 rp107g01 wp11723 bbp12723 ///
	hp1320 mp09g03 rp107g03 wp11725 bbp12725 hp1319 mp09g02 rp107g02 wp11724 ///
	bbp12724 hp1322 mp09h01 rp107h01 wp11720 bbp12720 hp1324 mp09h03 ///
	rp107h03 wp11722 bbp12722 hp1323 mp09h02 rp107h02 wp11721 bbp12721 ///
	hp1334 mp09k01 rp107k01 wp11741 bbp12741 hp1336 mp09k03 rp107k03 wp11743 ///
	bbp12743 hp1335 mp09k02 rp107k02 wp11742 bbp12742 wp11710 bbp12710 ///
	wp11711 bbp12711 wp11712 bbp12712 wp11713 bbp12713 wp11726 bbp12726 ///
	wp11728 bbp12728 wp11727 bbp12727 wp11729 bbp12729 wp11731 bbp12731 ///
	wp11730 bbp12730 wp11735 bbp12735 wp11737 bbp12737 wp11736 bbp12736 ///
	wp11738 bbp12738 wp11740 bbp12740 wp11739 bbp12739 wp11501 bbp12501 ///
	wp11502 bbp12502 wp11503 bbp12503 gp98a02 ip96a02 kp98a02 mp06a02 ///
	rp106a02 wp11601 bbp12601 gp98a05 ip96a05 kp98a05 mp06b02 rp106b02 ///
	wp11602 bbp12602 gp98a08 ip96a08 kp98a08 mp06c02 rp106c02 wp11603 bbp12603
	//Alle soziale Netzwerk-Variablen löschen
drop wp11504 wp11505 wp11506 wp11507 wp11508 wp11513 wp11514 wp11515 ///
	wp11516 wp11517 wp11518 wp11519 wp11520 wp11604 wp11605 wp11606 wp11607 ///
	wp11608 wp11609 wp11610 wp11611 wp11612 wp11613 wp11614 wp11615 wp11616 ///
	wp11617 wp11618 wp11619 wp11620 wp11621 wp11701 wp11702 wp11732 wp11733 ///
	wp11734 //weitere soziale Netzwerkvariablen
drop  rp107f03 wp11716 bbp12716 rp107f02 wp11715 bbp12715 rp107f01 wp11714 ///
	bbp12714 hp1315 mp09f02 hp1316 mp09f03 hp1314 mp09f01 //Töchter	
drop wp11704 bbp12704 wp11703 bbp12703 hp1308 mp09c02 rp107c03 wp11705 ///
	bbp12705 hp1307 mp09c01 rp107c01 //frühere Ehepartner
drop  bh20g ch24g dh18g eh09g fh09g //Eigentumswohnung oder Mieter
drop *kzahl //Variablen, die ich doch nicht brauche
drop i111038*

save "${my_save_path}sample.dta", replace

mvdecode _all, mv(-1=.\-2=.a\-3=.\-5=.a\-6=.a)
* Dieser neue Code ist schneller

save  "${MY_OUT_FILE}", replace 
	//damit ich mit den bereits definierten Missings wieder neu beginnen kann
save "${my_save_path}sample.dta", replace

********************************************************************************
* Schritt 1.2.: Variablen noch händisch matchen
********************************************************************************
* ggf. Einwanderungsstatus (biimgrp) aus bioimmig --> persnr kommen mehrmals vor

* Anzahl der Beschäftigungswechsel bisher 
	//jobch$$: jährliche Infos, ob Wechsel
	//occmove: Zusammenfassung bisheriger Wechsel
use persnr occmove bioyear agefjob nojob using "${my_data_path}biojob.dta", clear
		save "${my_temp_path}temp_occmove.dta", replace
	mvdecode _all, mv(-1=.\-2=.a\-3=.\-5=.a\-6=.a)
		save "${my_temp_path}temp_occmove.dta", replace

use "${my_save_path}sample.dta", clear		
merge 1:1 persnr using "${my_temp_path}temp_occmove.dta", ///
	keepusing (persnr occmove bioyear agefjob nojob)
		keep if _merge==3 | _merge==1
		drop _merge

save "${my_save_path}sample.dta", replace
	erase "${my_temp_path}temp_occmove.dta"


save "${MY_OUT_FILE}", replace
save "${my_save_path}sample.dta", replace


//**//////////////////////////////////////////////////////////////////////////**
** Schritt 2: Einheitliche Umbenennung von Variablen & Generierung Gap-Variablen
//**//////////////////////////////////////////////////////////////////////////**
/* nicht benötigt und deshalb wieder entfernt: 
	- Präferenzen: erfolgberufI erfolgberufII weinkommen warbeit kinderhaben glueckehe wfamilie
	- Eigentum
*/

do Diss_RenameGaps150717

save "${my_save_path}sample_schritt2.dta", replace
save "${my_save_path}sample.dta", replace


//**//////////////////////////////////////////////////////////////////////////**
** Schritt 3:BIOCOUPLY, Partnerschaftsstatus, Dauervariablen Beziehung zuspielen
//**//////////////////////////////////////////////////////////////////////////**
/* Erst nachdem die Stichprobe definiert wurde, damit ich Berechnungen nur 
	für mein Sample mache.
	Die Analysen in einem getrennten Datensatz durchführen, damit auch Jahre
	vor der ersten Welle im Jahr 1990 aufgenommen werden. 
  PROBLEM: In v30 ist im Gegensatz zu v29 im Datensatz biocouply die Coupid
	nicht mehr enthalten. Darauf beruht aber mein folgender Do-File. Aus diesem
	Grund werde ich an dieser Stelle für die Daten zu biocouply auf die Daten
	v29 zurück greifen. Die Coupid ist bei v30 nur noch in biocouplm enthalten.
	Ich müsste die Infos also matchen.
	Biomarsy sieht in v30 auch etwas anders aus (beginy7 fehlt z.B) (DO TO später)
	*/

do luecke_frage_biocouple150311	
	
do Diss_biocouple150321 

do Diss_spelltyp_partnerschaft150317

use "${my_save_path}sample.dta", clear
merge 1:1 persnr using "${my_save_path}sample_biocouply_wide.dta"
	keep if _merge==3 | _merge==1
	drop _merge
save "${my_save_path}sample.dta", replace

save "${my_save_path}sample_schritt3.dta", replace
save "${my_save_path}sample.dta", replace

//**//////////////////////////////////////////////////////////////////////////**
** Schritt 4: Partnercharakteristika hinzufügen
//**//////////////////////////////////////////////////////////////////////////**
/* Wichtig, dies an dieser Stelle vorzunehmen, damit noch alle Partner im
	Datensatz enthalten sind und bei der Definition der Stichprobe nicht 
	entfernt werden */

* Männer bereits hier im Datensatz enthalten
keep persnr sex erstbefr letztbef couple* paar* sbil* ausb* emplst* labnet* ///
	vebzeit* befr* labgro* lfs* jobch* casmin* sbil* sform* bform* ///
	wform* hform* occmove netto* expue* exppt* expft* arbeitslos* ///
	psbilo* pbilo* psbila* pb01bil* pb02bil* pb03bil* pbbila* Irelpar* gebjahr ///
	fiktive_partnr* hhnr* erstbefr letztbef
save "${my_save_path}partner.dta", replace	

do Diss_partnervariablen151022
save "${my_save_path}partner.dta", replace	

do Diss_Analyse_partner151022 //Partner_variablen erstellen
save "${my_save_path}partner_wide.dta", replace

* Sample auf Frauen beschränken
use "${my_save_path}sample.dta", clear
keep if sex==2 //nur Frauen
save "${my_save_path}sample.dta", replace

* Männer mit Eigenschaften matchen
use "${my_save_path}sample.dta", clear
append using "${my_save_path}partner_wide.dta", ///
	keep (persnr sex hhnr* paar* couple* partner_netto* partner_bil* ///
	partner_berufl* partner_berufl_zwei* partner_expue* partner_gebjahr* ///
	partner_exppt* partner_expft* partner_work* ///
	partner_vebzeit* partner_labnet* partner_labgro* partner_lfs* ///
	partner_jobch* partner_befr* inkonsistenz_paar* erstbefr letztbef)
save "${my_save_path}sample.dta", replace


* Aus einer konstanten Variable eine kontinuierliche machen
//Gebjahr des Mannes ist zwar für jeden Mann gleich, kann aber mit Partnerwechsel auch anders werden

foreach welle in "${years}" {
	generate partner_gebjahr`welle'=partner_gebjahr
}

drop partner_gebjahr

* Partnercharakteristika den Frauen zuschreiben
foreach welle in "${years}" {
		* ? Was ist das? generate partnergefunden`welle'=.
	foreach var in "partner_bil" "partner_befr" "partner_berufl" "partner_berufl_zwei" "partner_expue" "partner_exppt" "partner_expft" "partner_work" "partner_vebzeit" "partner_labnet" "partner_labgro" "partner_jobch" "partner_netto" "partner_gebjahr" "partner_lfs" {
	sort hhnr`welle' paar`welle'

	bysort hhnr`welle' (paar`welle'): replace `var'`welle'=`var'`welle'[_n+1] if missing(`var'`welle') & ///
		persnr>paar`welle' & paar`welle'==persnr[_n+1] & ///
		missing(inkonsistenz_paar`welle'[_n+1])
	
	bysort hhnr`welle' (paar`welle'): replace `var'`welle'=`var'`welle'[_n-1] if missing(`var'`welle') & ///
		persnr<paar`welle' & paar`welle'==persnr[_n-1] & ///
		missing(inkonsistenz_paar`welle'[_n-1])	
		
	//Klappt auch ohne "bysort", da ich vorher schon sortiere und die Bedingung paar`welle'==persnr[_n-1]  verwende
	}
}

foreach welle in "${years}" {
	foreach var in "partner_bil" "partner_befr" "partner_berufl" "partner_berufl_zwei" "partner_expue" "partner_exppt" "partner_expft" "partner_work" "partner_vebzeit" "partner_labnet" "partner_labgro" "partner_jobch" "partner_netto" "partner_gebjahr" "partner_lfs" {
	sort hhnr`welle' paar`welle'

	bysort hhnr`welle' (paar`welle'): replace `var'`welle'=`var'`welle'[_n+1] if missing(`var'`welle') & ///
		persnr>paar`welle' & paar`welle'==persnr[_n+1] & ///
		inkonsistenz_paar`welle'[_n+1]==1	
	
	bysort hhnr`welle' (paar`welle'): replace `var'`welle'=`var'`welle'[_n-1] if missing(`var'`welle') & ///
		persnr<paar`welle' & paar`welle'==persnr[_n-1] & ///
		inkonsistenz_paar`welle'[_n-1]==1	
		
	//Klappt auch ohne "bysort", da ich vorher schon sortiere und die Bedingung paar`welle'==persnr[_n-1]  verwende
	}
}


//Inkonsistenzen-Probleme mit zwei Männern und der gleichen Partnerin können hier nicht mehr auftauchen
//da ich nur eine Partnernr zugeordnet habe. Welche (erste oder 2. Partnerschaft im Jahr), müsste ich überprüfen.

save "${my_save_path}sample_schritt4.dta", replace
save "${my_save_path}sample.dta", replace

//**//////////////////////////////////////////////////////////////////////////**
** Schritt 5: Stichprobe definieren
//**//////////////////////////////////////////////////////////////////////////**
keep if sex==2 //Datensatz auf Frauen beschränkt
keep if gebjahr>1969 & gebjahr<1995 //Ältere und zu junge Jahrgänge entfernen.
drop if sumkids>0 & missing(kidgeb01) //Jahr Geburt des Kindes fehlt
*drop if psample==2 | psample==4 //Ausländer & Zuwanderer ausschließen. 
*drop if migback!=1 //nur Personen ohne Migrationshintergrund

save "${my_save_path}sample.dta", replace	

	* An wieviel Wellen teilgenommen? Hilfsvariable, ob gültiger Fragebogen
		generate teilnahme=0
		foreach welle in "${years}" {
			replace teilnahme=teilnahme+1 if netto`welle'>=10 & netto`welle'<=19
			generate teilnahme`welle'=1 if netto`welle'>=10 & netto`welle'<=19
		}
	tab teilnahme
	
	* Wieviele Wellen zwischen Erst- und (derzeitiger) Letztbefragung?
	generate anzahlwellen=letztbef-erstbefr+1
	tab anzahlwellen
	
			
drop if teilnahme<1	//mind. 1 Personenfragebogen: 30 Fälle weg

* Wie viele Personen jede Welle?
foreach jahr in "${years}" {
	tab netto`jahr' if erstbefr<=`jahr' & letztbef>=`jahr'
}

save "${my_save_path}sample_schritt5.dta", replace
save "${my_save_path}sample.dta", replace	

//**//////////////////////////////////////////////////////////////////////////**
** Schritt 6: Variablen generieren
//**//////////////////////////////////////////////////////////////////////////**
********************************************************************************
* Schritt 6.1.: Abhängige Variable - Mutterschaft (1. Kind)
********************************************************************************

* Kinder vorhanden?
tab sumkids

* Weitere wichtige Informationen: Monat und Jahr der Geburt des 1. Kindes
sum kidgeb01
sum kidmon01

*** Abhängige Variable: Familiengründung
* Zeitpunkt der Empfängnis
generate empf_j=.
generate empf_m=.
	generate empf_help=kidmon01-9 
		//Zeitpunkt Empfängnis: -8 April, -7 Mai, -6 Juni, -5 Juli, -4 August, 
			//-3 September, -2 Oktober, -1 November, ///
			// 0 Dezember, 1 Januar, 2 Februar, 3 März
	replace empf_j=kidgeb01 if empf_help>=1
	replace empf_j=kidgeb01-1 if empf_help<1
	replace empf_j=kidgeb01 if kidmon01==. & sumkids>0 
		//keine Info Geburtsmonat: Jahr der Geburt eingefügt (725 Fälle)
	replace empf_m=1 if empf_help==1
	replace empf_m=2 if empf_help==2
	replace empf_m=3 if empf_help==3
	replace empf_m=4 if empf_help==-8
	replace empf_m=5 if empf_help==-7
	replace empf_m=6 if empf_help==-6
	replace empf_m=7 if empf_help==-5
	replace empf_m=8 if empf_help==-4
	replace empf_m=9 if empf_help==-3
	replace empf_m=10 if empf_help==-2
	replace empf_m=11 if empf_help==-1
	replace empf_m=12 if empf_help==0
	
	label variable empf_j "Jahr Empfängnis 1. Kind"
	label variable empf_m "Monat Empfängnis 1. Kind"
	label define empf_m ///
		   1   "[1] Januar" ///
           2   "[2] Februar" ///
           3   "[3] Maerz" ///
           4   "[4] April" ///
           5   "[5] Mai" ///
           6   "[6] Juni" ///
           7   "[7] Juli" ///
           8   "[8] August" ///
           9   "[9] September" ///
          10   "[10] Oktober" ///
          11   "[11] November" ///
          12   "[12] Dezember"
		label value empf_m empf_m
	tab1 empf_j empf_m if erstbefr<=empf_j
		

*Abhängige Variable, bei Jahresbasis
//Jahr 2012 stark rechtszensiert
foreach jahr in "${years}" { 
		generate mutter`jahr'=0
			replace mutter`jahr'=1 if empf_j==`jahr' & sumkids>0 
			//Problem mit zu langem Zeitraum von letzter Befragung bis Empfängnis bzw. dann Geburt
			label variable mutter`jahr' "Ereignis Empfängnis 1.Kind"
			}
			
tab1 mutter*

* Alternative Kodierung: Das Jahr vor der Geburt als Ereignis
//Nicht sinnvoll, da dann kaum Fälle für 2012
generate alt_kidgeb01=kidgeb01-1 
	
foreach jahr in "${years}" { 
	generate mother`jahr'=0
		replace mother`jahr'=1 if alt_kidgeb01==`jahr'
		label variable mother`jahr' "Alternative Kodierung: Ereignis Empfängnis"
}

tab1 mother*

* In welchem Alter Familiengründung? (Achtung ungewichtet)
generate gruendung=.
	replace gruendung= kidgeb01-gebjahr if !missing(kidgeb01)
	tab gruendung

*** Familienerweiterung
* 2. Kind
generate erw_j=.
generate erw_m=.
	generate erw_help=kidmon02-9 
		//Zeitpunkt Empfängnis: -8 April, -7 Mai, -6 Juni, -5 Juli, -4 August, 
			//-3 September, -2 Oktober, -1 November, ///
			// 0 Dezember, 1 Januar, 2 Februar, 3 März
	replace erw_j=kidgeb02 if erw_help>=1
	replace erw_j=kidgeb02-1 if erw_help<1
	replace erw_j=kidgeb02 if kidmon02==. & sumkids>0 
		//keine Info Geburtsmonat: Jahr der Geburt eingefügt (Wieviele Fälle?)
	replace erw_m=1 if erw_help==1
	replace erw_m=2 if erw_help==2
	replace erw_m=3 if erw_help==3
	replace erw_m=4 if erw_help==-8
	replace erw_m=5 if erw_help==-7
	replace erw_m=6 if erw_help==-6
	replace erw_m=7 if erw_help==-5
	replace erw_m=8 if erw_help==-4
	replace erw_m=9 if erw_help==-3
	replace erw_m=10 if erw_help==-2
	replace erw_m=11 if erw_help==-1
	replace erw_m=12 if erw_help==0
	
	label variable erw_j "Jahr Empfängnis 2. Kind"
	label variable erw_m "Monat Empfängnis 2. Kind"
	label value erw_m erw_m
	
	tab1 erw_j erw_m if erstbefr<=erw_j
	
	
* Abhängige Variable, bei Jahresbasis
//Jahr 2012 stark rechtszensiert
foreach jahr in "${years}" { 
		generate zweitesKind`jahr'=0
			replace zweitesKind`jahr'=1 if erw_j==`jahr' 
			label variable zweitesKind`jahr' "Ereignis Empfängnis 2. Kind"
			}
			
tab1 zweitesKind*

save "${my_save_path}sample_schrittabhvar.dta", replace
save "${my_save_path}sample.dta", replace	
	
********************************************************************************
* Schritt 6.2.: Unabhängige Variablen Familie
********************************************************************************
*****************************************
* 6.2.1. Partnerschaft
*****************************************	
tab1 Irelpar*
	
save "${my_save_path}sample.dta", replace	

*****************************************
* 6.2.2. Partnerschaftscharakteristika (in Schritt 3 gematcht)
*****************************************
save "${my_save_path}sample.dta", replace


save "${my_save_path}sample.dta", replace

********************************************************************************
* Schritt 6.3.: Unabhängige Variablen Arbeitsmarkt
********************************************************************************
*****************************************
* 6.3.1. Objektive Indikatoren
*****************************************
**************
*** 6.3.1.1. In Ausbildung
**************
*** Ja oder nein
/* Diese Variable entspricht der Ausprägung "in Ausbildung" von work. Da aber 
	in meinem Do-File teilweise auf diese Variable hier Bezug genommen wird, 
	lösche ich diese nicht. */

label define inausbildung ///
		0 "[0] Nicht in Ausbildung" ///
		1 "[1] In Ausbildung (versch. Arten)"
		
foreach welle in "${years}" { 
	generate inausbildung`welle'=.
		replace inausbildung`welle'=0 if arbeitslos`welle'==1
		replace inausbildung`welle'=1 if emplst`welle'==3 & missing(inausbildung`welle')
		replace inausbildung`welle'=1 if (!missing(sform`welle') | bform`welle'==1) & missing(inausbildung`welle')
		replace inausbildung`welle'=1 if !missing(hform`welle') & missing(inausbildung`welle')
		replace inausbildung`welle'=1 if wform`welle'==1 & (missing(emplst`welle')| emplst`welle'==3 | emplst`welle'==5) & missing(inausbildung`welle')
		replace inausbildung`welle'=1 if emplst`welle'==6 //Behindertenwerkstatt
		replace inausbildung`welle'=0 if wform`welle'==1 & emplst`welle'==1 & missing(inausbildung`welle')
		replace inausbildung`welle'=0 if wform`welle'==1 & emplst`welle'==2 & missing(inausbildung`welle')
		replace inausbildung`welle'=0 if wform`welle'==1 & emplst`welle'==4 & missing(inausbildung`welle')
		replace inausbildung`welle'=1 if ausb`welle'==1 & missing(inausbildung`welle')
		replace inausbildung`welle'=0 if emplst`welle'==1 & missing(inausbildung`welle')
		replace inausbildung`welle'=0 if emplst`welle'==2 & missing(inausbildung`welle')
		replace inausbildung`welle'=0 if emplst`welle'==4 & missing(inausbildung`welle')
		replace inausbildung`welle'=0 if emplst`welle'==5 & missing(inausbildung`welle')
		replace inausbildung`welle'=1 if lfs`welle'==3
		
		
	label variable inausbildung`welle' "In Ausbildung `welle'"
	label values inausbildung`welle' inausbildung
	tab inausbildung`welle' if erstbefr<=`welle' & letztbef>=`welle'
}

	
*** Differenziert nach Form der derzeitigen Ausbildung: 2 Kategorien
* Ich könnte das noch wesentlich detaillierter machen (siehe z.B.bcp1006/bcp1007)
label define ausbform ///
	0 "[0] nicht in Ausbildung" ///
	1 "[1] allgemeinbildende Schule" ///
	2 "[2] Lehre, Hochschulen, Weiterbildung"
	
foreach welle in "${years}" { 
	generate ausbform`welle'=0 if inausbildung`welle'==0
		replace ausbform`welle'=1 if ausb`welle'==1 & !missing(sform`welle') & inausbildung`welle'==1
		replace ausbform`welle'=2 if ausb`welle'==1 & missing(sform`welle') & inausbildung`welle'==1
	label values ausbform`welle' ausbform
	label variable ausbform`welle' "Art der derzeitigen Ausbildung `welle'"
	tab ausbform`welle'
}	

*** Differenziert nach Form der derzeitigen Ausbildung: 4 Kategorien
label define ausbform4 ///
	0 "[0] nicht in Ausbildung" ///
	1 "[1] allgemeinbildende Schule" ///
	2 "[2] Hochschulen" ///
	3 "[3] Lehre, berufliche Ausbildung" ///
	4 "[4] berufliche Weiterbildung/Umschulung"
	
foreach welle in "${years}" { 
	generate ausb2form`welle'=0 if inausbildung`welle'==0
		replace ausb2form`welle'=1 if ausb`welle'==1 & !missing(sform`welle') & inausbildung`welle'==1
		replace ausb2form`welle'=2 if ausb`welle'==1 & !missing(hform`welle') & inausbildung`welle'==1
		replace ausb2form`welle'=3 if ausb`welle'==1 & bform`welle'==1 & inausbildung`welle'==1
		replace ausb2form`welle'=4 if ausb`welle'==1 & wform`welle'==1 & inausbildung`welle'==1
	label values ausb2form`welle' ausbform4
	label variable ausb2form`welle' "Art der derzeitigen Ausbildung `welle'"
	tab ausb2form`welle'
}	

save "${my_save_path}sample.dta", replace

**************
*** 6.3.1.2. Erwerbsstatus
**************
// Um "nicht Erwerbstätige" genauer differenzieren zu können: lfs$	
/* Für Übersicht, wer in Kategorie "nicht erwerbstätig" enthalten ist:
	Siehe Dokumentation generierte Variablen $phgen zu lfs$.
	Die folgenden Bedingungen werden zur Generierung des Erwerbsstatus angewendet
	Wenn arbeitslos gemeldet, dann als arbeitlos kodiert, auch wenn noch
	(geringfügig) erwerbstätig. 
	Wenn beim Erwerbsstatus selbst als "in Ausbildung" bezeichnet, dann auch
	 so kodiert.
	Wenn derzeit in Ausbildung (ausb) und Schulbildung (sform): in Ausbildung.
	Wenn derzeit in Ausbildung (ausb) und Berufl. Bil. (bform): in Ausbildung.
	Wenn derzeit in Ausbildung (ausb) und Hochschule (hform): in Ausbildung.
	Wenn derzeit in Ausbildung (ausb) und Weiterbil/Umschulung (wform), dann
		nicht (!) "in Ausbildung", wenn Erwerbstyp bei emplst angegeben.
	*/

	** Zunächst klären, in welchem Verhältnis die Variablen zueinander stehen
// Wenn ausb$==1, dann auch Art der Ausbildung spezifiziert
foreach welle in "${years}" { 
	tab ausb`welle' if missing(sform`welle') & missing(bform`welle') & /*
	*/ missing(hform`welle') & missing(wform`welle'), mis
}

** Arbeitslos gemeldete Personen, sind immer wieder teilweise Erwerbstätig,
// insbesondere geringfügig beschäftigt, allerdings ordne ich auch solche
// Personen der Kategorie "arbeitslos" zu"
foreach welle in "${years}" { 
	tab emplst`welle' if arbeitslos`welle'==1
}

** Erwerbsstatus und Ausbildung
foreach welle in "${years}" { 
	tab emplst`welle' if ausb`welle'==1
}
	
** Erwerbsstatus generieren	
label define work ///
        0   "[0] in Ausbildung" ///
        1   "[1] Voll erwerbstätig" ///
        2   "[2] Teilzeitbeschäftigung" ///
        3   "[3] Unregelmäßig, geringfügig beschäftigt" ///
		4	"[4] Arbeitslos gemeldet" ///
		5   "[5] Nicht erwerbstätig" 

		
foreach welle in "${years}" { 
	generate work`welle'=.
		replace work`welle'=4 if arbeitslos`welle'==1
		replace work`welle'=0 if emplst`welle'==3 & missing(work`welle')
		replace work`welle'=0 if (!missing(sform`welle') | bform`welle'==1) & missing(work`welle')
		replace work`welle'=0 if !missing(hform`welle')  & missing(work`welle')
		replace work`welle'=0 if wform`welle'==1 & (missing(emplst`welle')| emplst`welle'==3 | emplst`welle'==5) & missing(work`welle')
		replace work`welle'=1 if wform`welle'==1 & emplst`welle'==1 & missing(work`welle')
		replace work`welle'=2 if wform`welle'==1 & emplst`welle'==2 & missing(work`welle')
		replace work`welle'=3 if wform`welle'==1 & emplst`welle'==4 & missing(work`welle')
		replace work`welle'=0 if emplst`welle'==6 //Behindertenwerkstatt
		replace work`welle'=0 if ausb`welle'==1 & missing(work`welle') 
			//falls es eine Angabe bei "ausb" gibt und bei "$form" nicht
		replace work`welle'=1 if emplst`welle'==1 & missing(work`welle')
		replace work`welle'=2 if emplst`welle'==2 & missing(work`welle')
		replace work`welle'=3 if emplst`welle'==4 & missing(work`welle')
		replace work`welle'=5 if emplst`welle'==5 & missing(work`welle')
		// Bedingung "& missing(work`welle')", damit nicht umkodiert wird
		replace work`welle'=0 if work`welle'==5 & lfs`welle'==3 //Differenzierung von "not working"
		replace work`welle'=4 if work`welle'==5 & lfs`welle'==6 //Differenzierung von "not working"
	label variable work`welle' "Erwerbsstatus`welle'"
	label values work`welle' work
	tab work`welle'		
	
	*Überprüfen, ob inausbildung und work übereinstimmen
	tab inausbildung`welle' if work`welle'==0
	tab work`welle' if inausbildung`welle'==1
}	

* Überprüfen meiner Kodierungen
// Fehlende Werte insbesondere durch Lücke-Erhebung: Ggf. mit Spelldaten später füllen (weiß noch nicht, ob es den Aufwand Wert ist)
foreach welle in "${years}" { 
	tab1 ausb`welle' emplst`welle' lfs`welle' vebzeit`welle' /*
		*/ if missing(work`welle') & erstbefr<=`welle' & letztbef>=`welle', mis
}
		

save "${my_save_path}sample.dta", replace

**************
*** 6.3.1.3. Definition von Selbstständigen
**************
//Ggf. beim Erwerbsstatus in eine gesonderte Kategorie
//Absolute Zahlen wirken sehr niedrig

label define selbststaendig 0 "[0] Nicht selbstständig" 1 "[1] Selbstständig"

foreach welle in "${years}" { 
	generate selfemp`welle'=0
		replace selfemp`welle'=1 if !missing(self`welle') 
	label variable selfemp`welle' "Selbstständig ja/nein `welle'"
	label values selfemp`welle' selbststaendig
}

foreach welle of numlist 1997/2012 {
	replace selfemp`welle'=1 if help_self`welle'==3
}

save "${my_save_path}sample.dta", replace


**************
*** 6.3.1.4. Leiharbeit/Zeitarbeit (ab 2005)
**************	
* FEHLER IN DATENSATZ: komische (-6) Ausprägungen im Jahr 2012

recode zeitarbeit* (-6=.)

tab1 zeitarbeit2001 //Beispielhaft

save "${my_save_path}sample.dta", replace

**************
*** 6.3.1.5. Befristung der Beschäftigung
**************	
* FEHLER IM DATENSATZ: -6 Werte?
* Filter-Variable: Jahre 1990-1994 Filterfrage

label define filter_befr ///
	0 "[0] Frage nicht erhalten" ///
	1 "[1] Frage gesehen"

foreach welle in "${years}" { 
	generate filter_befr`welle'=0
	label variable filter_befr`welle' "Filterfrage: Befristung `welle'"
	label values filter_befr`welle' filter_befr
}

foreach welle of numlist 1990/1994 { 
		replace filter_befr`welle'=1 if jobch`welle'==4 | jobch`welle'==5
}

foreach welle of numlist 1995/2012 { 
		replace filter_befr`welle'=1
		replace filter_befr`welle'=0 if emplst`welle'==5 //nicht erwerbstätig
}


save "${my_save_path}sample.dta", replace

**************
*** 6.3.1.6. Überstunden 
**************	
sum uebstd2010 //Beispielhaft

save "${my_save_path}sample.dta", replace

**************
*** 6.3.1.7. Beschäftigungswechsel und Betriebszugehörigkeit
**************	
* jobch$ verwenden und nicht erwtyp$ (siehe Dokumentation $phgen)
* Variablenanpassungen: siehe Schritt 13
tab jobch2000
tab erwzeit2000

**************
*** 6.3.1.8. Arbeitslosigkeit
**************	
* Als Ausprägung von work$ und aus der Variable expue$
* Variablengenerierungen: siehe Schritt 13

save "${my_save_path}sample_objektiv_arbeitsmarkt.dta", replace
save "${my_save_path}sample.dta", replace


*****************************************
* 6.3.2. Subjektive Indikatoren Unsicherheit
*****************************************
/* Warum haben so wenige Personen zu Beginn der 1990er Jahre diese Fragen
	beantwortet? Ich sehe keinen Filter im Fragebogen. */
	// Antwort: Es sind nur wenige Erwerbstätig. Aber warum?
**************
* 6.3.2.1. Wahrscheinlichkeit Arbeitsplatzverlust ("Cognitive job insecurity")
**************
* Ab 1999 werden Prozente abgefragt
tab1 verlust_alt1998 verlust_neu1999

** Gaps füllen
* Kodierung 1990-1998
local jahre "1995 1997"
local mayo "1994 1996"
local ketchup "1996 1998"

foreach var in "verlust_alt" {
	foreach X of numlist 1/2 {
		local w: word `X' of `jahre'
		local r: word `X' of `mayo'
		local g: word `X' of `ketchup'
		
		
		replace `var'`w'=`var'`r' if !missing(`var'`r') & erstbefr<=`w' & /*
			*/ letztbef>=`w' & work`w'>0 & work`w'<4
		
		replace `var'`w'=`var'`g' if !missing(`var'`g') & missing(`var'`r') & /*
			*/ erstbefr<=`w' & letztbef>=`w' & work`w'>0 & work`w'<4		
	}
}

* Kodierung 1999-2012
local jahre "2000 2002 2004 2006 2008 2010"
local erdbeer "1999 2001 2003 2005 2007 2009"
local eis "2001 2003 2005 2007 2009 2011"

foreach var in "verlust_neu" {
	foreach X of numlist 1/6 {
		local w: word `X' of `jahre'
		local r: word `X' of `erdbeer'
		local g: word `X' of `eis'
		
		
		replace `var'`w'=`var'`r' if !missing(`var'`r') & erstbefr<=`w' & /*
			*/ letztbef>=`w' & work`w'>0 & work`w'<4
		
		replace `var'`w'=`var'`g' if !missing(`var'`g') & missing(`var'`r') & /*
			*/ erstbefr<=`w' & letztbef>=`w' & work`w'>0 & work`w'<4		
	}
}

foreach welle in "2011" "2012" {
	replace verlust_neu`welle'=verlust_neu2009 if !missing(verlust_neu2009) & /*
		*/ erstbefr<=`welle' & letztbef>=`welle' & work`welle'>0 & work`welle'<4
}

* Neue Variable generieren, d.h. Variablen miteinander vereinen
foreach welle in "${years}" { 
	generate verlust`welle'=.
	label variable verlust`welle' "Wahrschheinlichkeit Verlust Arbeit, zusammengefasst `welle'"
	label values verlust`welle' op3702
}

foreach welle of numlist 1990/1998 {
	replace verlust`welle'=verlust_alt`welle'
}

foreach welle of numlist 1999/2012 {
	replace verlust`welle'=1 if verlust_neu`welle'>=80 & verlust_neu`welle'<=100
	replace verlust`welle'=4 if verlust_neu`welle'>=0 & verlust_neu`welle'<=20
	replace verlust`welle'=2 if verlust_neu`welle'>=50 & verlust_neu`welle'<=70 
	replace verlust`welle'=3 if verlust_neu`welle'>=30 & verlust_neu`welle'<=40 
}

tab1 verlust*

save "${my_save_path}sample.dta", replace

**************
* 6.3.2.2. gleichwertige Stelle bei Verlust ("Employment/labour m. insecurity")
**************
tab1 chance_stelle* 

** Gaps füllen
local jahre "1993 1996 1998"
local schoko "1992 1995 1997"
local pudding "1994 1997 1999"

foreach var in "chance_stelle" {
	foreach X of numlist 1/3 {
		local w: word `X' of `jahre'
		local r: word `X' of `schoko'
		local g: word `X' of `pudding'
		
		
		replace `var'`w'=`var'`r' if !missing(`var'`r') & erstbefr<=`w' & /*
			*/ letztbef>=`w' & work`w'>0 & work`w'<4
		
		replace `var'`w'=`var'`g' if !missing(`var'`g') & missing(`var'`r') & /*
			*/ erstbefr<=`w' & letztbef>=`w' & work`w'>0 & work`w'<4		
	}
}

* Richtung wechseln, da in allen anderen Variablen niedrige Werte negativ sind
label define chance_stelle ///
	0 "[0] trifft nicht zu" ///
	1 "[1] praktisch unmöglich" ///
	2 "[2] Schwierig" ///
	3 "[3] Leicht"

foreach welle in "${years}" { 
	recode chance_stelle`welle'(1=3)(2=2)(3=1)(else=.)
		label values chance_stelle`welle' chance_stelle
	tab1 chance_stelle`welle'
}

save "${my_save_path}sample.dta", replace

**************
* 6.3.2.3. Sorgen um allgemeine ökonomische Situation
**************
tab1 sorgen_aw*

**************
* 6.3.2.4. Sorgen um eigene wirtschaftliche Situation
**************
tab1 sorgen_ew*

**************
* 6.3.6.5. Sorgen um Sicherheit des Arbeitsplatzes ("Affective job i./overall risk of jobb-loss worries")
**************
tab1 sorgen_a*

**************
* 6.3.2.6. Zufriedenheit mit HH-Einkommen
**************
tab1 sorgen_hh*


save "${my_save_path}sample_subjektiv_arbeitsmarkt.dta", replace
save "${my_save_path}sample.dta", replace


********************************************************************************
* Schritt 6.4.: Kontrollvariablen
********************************************************************************
*****************************************
* 6.4.1. Nettoäquivalenzeinkommen des Haushaltes
*****************************************
* (Siehe OECD Definition im aktuellsten Armutsbericht von 2008 auf Seite 17)
*  Variablen ahinc$ werden ab dem Jahr 2012 nicht weiter fortgeführt.
/* Diese Variable erst nach dem Füllen der Missings generieren, da sonst
	anstelle des Nettoäquivalent gewichteten Einkommens nur das HH-Einkommen
	imputiert wird. */

* Neue imputierte HH-Nettoeinkommen-Variable hat keine Werte für 1990-1994
foreach welle of numlist 1990/1994 {
	foreach wert of numlist 1/5 {
		replace i`wert'hinc`welle'=hinc`welle' if missing(i`wert'hinc`welle')
	}
}


save "${my_save_path}sample.dta", replace	

*****************************************
* 6.4.2. Individuelles Einkommen
*****************************************
foreach welle in "${years}" { 
	sum labnet`welle', d
	sum labgro`welle',d
}

*****************************************
* 6.4.3. West-Ostdeutschland
*****************************************
* Konstante Variable in Schritt 13 generiert

	label define west ///
		0 "[0] Osten" ///
		1 "[1] Westen" 	
	
foreach welle in "${years}" { 
		generate west`welle'=sampreg`welle'
		replace west`welle'=0 if west`welle'==2
		label variable west`welle' "Stichprobenregion `welle'"
		label values west`welle' west	
	tab west`welle' sampreg`welle' //Überprüfen, ob richtig kodiert
}	

* Überprüfen, ob die gleiche Ausprägung wie die CNEF-Variable "L11102$$"
* Ja, und deshalb werde ich diese Variable auch nicht ins Long-Format nehmen
foreach welle in "${years}" { 
	tab west`welle' region`welle'
}

	
save "${my_save_path}sample.dta", replace
	
*****************************************
* 6.4.4. Bildungsausstattung: Vom SOEP generierte Schulabschlüsse
*****************************************
* Original Variablenname im SOEP: psbil$

tab1 sbil2010 //bsp.

label define soepbil /*
	*/ 0 "[0] noch kein Abschluss" /*
	*/ 1 "[1] kein Abschluss/Hauptschule" /*
	*/ 2 "[2] Mittlere Reife" /*
	*/ 3 "[3] (Fach-) Abitur" /*
	*/ 4 "[4] keine Angabe"


foreach welle in "${years}" {
	generate bil`welle'=.
		replace bil`welle'=0 if sbil`welle'==7
		replace bil`welle'=1 if sbil`welle'==6 | sbil`welle'==1
		replace bil`welle'=2 if sbil`welle'==2 | sbil`welle'==5 //auch anderer Abschluss
		replace bil`welle'=3 if sbil`welle'==3 | sbil`welle'==4
	label variable bil`welle' "Schulbildung nach gen.SOEP Var. `welle'"
	label values bil`welle' soepbil
}

tab1 psbilo2010 pbilo2010 psbila2010 pb01bil2010 pb02bil2010 pbbila2010 if missing(bil2010)

* Berufliche Bildungsausstattung
tab casmin2010

label define berufl /*
	*/ 0 "[0] noch kein Abschluss" /*
	*/ 1 "[1] kein Abschluss/Hauptschule ohne Ausbildung" /*
	*/ 2 "[2] kein Abschluss(Hauptschule mit Ausbildung" /*
	*/ 3 "[3] Mittlere Reife ohne Ausbildung" /*
	*/ 4 "[4] Mittlere Reife mit Ausbildung" /*
	*/ 5 "[5] (Fach-)Abitur ohne Ausbildung" /*
	*/ 6 "[6] (Fach-)Abitur mit Ausbildung" /*
	*/ 7 "[7] FH-/Uni-Abschluss" /*
	*/ 8 "[8] keine Angabe" 

foreach welle in "${years}" {
	generate berufl`welle'=.
		replace berufl`welle'=0 if casmin`welle'==0
		replace berufl`welle'=1 if casmin`welle'==1 | casmin`welle'==2
		replace berufl`welle'=2 if casmin`welle'==3
		replace berufl`welle'=3 if casmin`welle'==4
		replace berufl`welle'=4 if casmin`welle'==5
		replace berufl`welle'=5 if casmin`welle'== 6
		replace berufl`welle'=6 if casmin`welle'==7
		replace berufl`welle'=7 if casmin`welle'==8 | casmin`welle'==9
	label variable berufl`welle' "Berufliche Bildungsausstattung"
	label values berufl`welle' berufl
}
tab berufl2010

label define berufl_zwei /*
	*/ 0 "[0] noch kein Abschluss" /*
	*/ 1 "[1] ohne Ausbildung" /*
	*/ 2 "[2] mit Ausbildung" /*
	*/ 3 "[3] FH-/Uni-Abschluss" /*
	*/ 4 "[4] keine Angabe" 
	
foreach welle in "${years}" {
	generate berufl_zwei`welle'=.
		replace berufl_zwei`welle'=0 if casmin`welle'==0
		replace berufl_zwei`welle'=1 if casmin`welle'==1 | casmin`welle'==2 | casmin`welle'==4 | casmin`welle'==6 
		replace berufl_zwei`welle'=2 if casmin`welle'==3 | casmin`welle'==5 | casmin`welle'==7 
		replace berufl_zwei`welle'=3 if casmin`welle'==8 | casmin`welle'==9			
	label variable berufl_zwei`welle' "Berufl. Bildungsausstattung, kurz"
	label values berufl_zwei`welle' berufl_zwei
}
tab berufl_zwei2010

*****************************************
* 6.4.5. Migrationshintergrund
*****************************************	

generate deutsch=0 if migback==2 | migback==3 | migback==4
		replace deutsch=1 if migback==1
		label define deutsch ///
		0   "[0] direkter/indirekter Migrationshintergrund" ///
		1   "[1] kein Migrationshintergrund" 
	 label values deutsch deutsch
	 tab deutsch 
	 
save "${my_save_path}sample.dta", replace

*****************************************
* 6.4.6. Kohortenzugehörigkeit (1970-1994)
*****************************************
* Oder für Kalenderperiode kontrollieren?

generate kohorte7074=0
	replace kohorte7074=1 if gebjahr>1969 & gebjahr<1975 //Kohorten 1970-1974
	tab kohorte7074

generate kohorte7579=0
	replace kohorte7579=1 if gebjahr>1974 & gebjahr<1980 //Kohorten 1975-1979
	tab kohorte7579 gebjahr

generate kohorte8084=0
	replace kohorte8084=1 if gebjahr>1979 & gebjahr<1985
	tab kohorte8084 gebjahr
		
generate kohorte8589=0
	replace kohorte8589=1 if gebjahr>1984 & gebjahr<1990
	tab kohorte8589 gebjahr
	
generate kohorte9094=0
	replace kohorte9094=1 if gebjahr>1989 & gebjahr<1995 
	//Die Fallzahlen dürften sehr niedrig sein, ggf. anders kodieren
	tab kohorte9094 gebjahr

*****************************************
* 6.4.7. Hilfsvariable: Wieviele Jahre Lücke?
*****************************************

generate luecke=0
foreach welle in "${years}" {
	replace luecke=0+1 if netto`welle'==31| netto`welle'==61| netto`welle'==62
}

tab luecke


save "${my_save_path}sample_schritt_variablen.dta", replace
save "${my_save_path}sample.dta", replace

//**//////////////////////////////////////////////////////////////////////////**
* Schritt 7: Längsschnittgewichtung
//**//////////////////////////////////////////////////////////////////////////**
/* Basisjahr ist NICHT die Erstbefragung, sondern das Jahr des Starts des
	Beobachtungszeitraums. */
	
/* 	Bleibewahrscheinlichkeit im Lückejahr auf 1 gesetzt: ggf. zurück setzen.
	Was mit anderen Ausfällen netto>=30? Auch Bleibew. auf 1 setzen? */	
foreach welle of numlist 1985(1)2012 {
	generate help_bleib`welle'=bleib`welle'
		replace help_bleib`welle'=1 if netto`welle'==31 //Lückenacherhebung
}

********************************************************************************
* Schritt 7.1.: Basisjahr= Start Beobachtungszeitraum bzw. Erstbefragung
********************************************************************************
*****************************************
* 7.1.1. 1990 (G)- 2012 (BC)
*****************************************
* Längsschnittvariable generieren und das Querschnittsgewicht des Basisjahres einfügen
foreach welle of numlist 1990(1)2012 {
	generate gbclgewicht`welle'=.
		replace gbclgewicht`welle'=phrf`welle' if erstbefr==`welle'
		// Nach Start des Beobachtungszeitraums: Basisjahr=Erstbebfr
}

replace gbclgewicht1990=phrf1990 if erstbefr<1990 
	//VOR Beobachtungszeitraum: Basisjahr=Start Beobachtungszeitraum

* Längsschnittgewicht für die Folgejahre generieren
local torte "1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011"
local kuchen "1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012"

foreach X of numlist 1/22 {
	local e: word `X' of `torte'
	local f: word `X' of `kuchen'

	replace gbclgewicht`f'=gbclgewicht`e'*help_bleib`f' if erstbefr<`f'& letztbef>=`f'
}

* Personen, die zwar in der Variable "Netto" auftauchen, aber ein Missing beim Gewicht haben, einheitlich auf 0 setzen
//Manche haben ein Missing
foreach welle of numlist 1990(1)2012 {
	replace gbclgewicht`welle'=0 if missing(gbclgewicht`welle') & !missing(netto`welle')
}

sum gbclgewicht*
		
*****************************************
* 7.1.2. 1995 (L)- 2012 (BC)
*****************************************
* "lbc" steht für die Wellen L (1995) bis BC (2012)

* Längsschnittvariable generieren und das Querschnittsgewicht des Basisjahres einfügen
foreach welle of numlist 1995(1)2012 {
	generate lbclgewicht`welle'=.
		replace lbclgewicht`welle'=phrf`welle' if erstbefr==`welle'
		// Nach Start des Beobachtungszeitraums: Basisjahr=Erstbebfr
}

replace lbclgewicht1995=phrf1995 if erstbefr<1995 
	//VOR Beobachtungszeitraum: Basisjahr=Start Beobachtungszeitraum
	

* Längsschnittgewicht für die Folgejahre generieren
local erdbeer "1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011"
local eis "1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012"

foreach X of numlist 1/17 {
	local c: word `X' of `erdbeer'
	local d: word `X' of `eis'

	replace lbclgewicht`d'=lbclgewicht`c'*help_bleib`d' if erstbefr<`d'& letztbef>=`d'
}

* Personen, die zwar in der Variable "Netto" auftauchen, aber ein Missing beim Gewicht haben, einheitlich auf 0 setzen
//Manche haben ein Missing
foreach welle of numlist 1995(1)2012 {
	replace lbclgewicht`welle'=0 if missing(lbclgewicht`welle') & !missing(netto`welle')
}

sum lbclgewicht*

*****************************************
* 7.1.3. 2000 (Q)- 2012 (BC)
*****************************************
// Das hier brauche ich eigentlich nicht, war nur ein Versuch um meine Beobachtung
// zu bestätigen, dass im Jahr des Starts der Beobachtung einige Fälle das Gewicht
// 0 bekommen, während diese Personen in anderen Gewichtungsvariablen einfach ein
// Missing haben.

* Längsschnittvariable generieren und das Querschnittsgewicht des Basisjahres einfügen
foreach welle of numlist 2000(1)2012 {
	generate qbclgewicht`welle'=.
		replace qbclgewicht`welle'=phrf`welle' if erstbefr==`welle'
		// Nach Start des Beobachtungszeitraums: Basisjahr=Erstbebfr
}

replace qbclgewicht2000=phrf2000 if erstbefr<2000 
	//VOR Beobachtungszeitraum: Basisjahr=Start Beobachtungszeitraum
	

* Längsschnittgewicht für die Folgejahre generieren
local erdbeer "2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011"
local eis "2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012"

foreach X of numlist 1/12 {
	local c: word `X' of `erdbeer'
	local d: word `X' of `eis'

	replace qbclgewicht`d'=qbclgewicht`c'*help_bleib`d' if erstbefr<`d'& letztbef>=`d'
}

* Personen, die zwar in der Variable "Netto" auftauchen, aber ein Missing beim Gewicht haben, einheitlich auf 0 setzen
//Manche haben ein Missing
foreach welle of numlist 2000(1)2012 {
	replace qbclgewicht`welle'=0 if missing(qbclgewicht`welle') & !missing(netto`welle')
}

sum qbclgewicht*


*****************************************
* 7.1.4. 1995 (L)- 2010 (BA)
*****************************************

* Längsschnittvariable generieren und das Querschnittsgewicht des Basisjahres einfügen
foreach welle of numlist 1995(1)2010 {
	generate lbalgewicht`welle'=.
		replace lbalgewicht`welle'=phrf`welle' if erstbefr==`welle'
		// Nach Start des Beobachtungszeitraums: Basisjahr=Erstbebfr
}

replace lbalgewicht1995=phrf1995 if erstbefr<1995 
	//VOR Beobachtungszeitraum: Basisjahr=Start Beobachtungszeitraum
	

* Längsschnittgewicht für die Folgejahre generieren
local erdbeer "1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009"
local eis "1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010"

foreach X of numlist 1/12 {
	local c: word `X' of `erdbeer'
	local d: word `X' of `eis'

	replace lbalgewicht`d'=lbalgewicht`c'*help_bleib`d' if erstbefr<`d'& letztbef>=`d'
}

* Personen, die zwar in der Variable "Netto" auftauchen, aber ein Missing beim Gewicht haben, einheitlich auf 0 setzen
//Manche haben ein Missing
foreach welle of numlist 1995(1)2010 {
	replace lbalgewicht`welle'=0 if missing(lbalgewicht`welle') & !missing(netto`welle')
}

sum lbalgewicht*

save "${my_save_path}sample_schritt7.dta", replace
save "${my_save_path}sample.dta", replace

//**//////////////////////////////////////////////////////////////////////////**
** Schritt 8: Lücke-FB, Missings füllen (Non-Response)&Flag-Variablen generieren
//**//////////////////////////////////////////////////////////////////////////**
********************************************************************************
* 8.1.: Lücke-FB Angaben einfügen
********************************************************************************
do luecke_fragebogen151019

use "${my_save_path}sample.dta", clear
merge 1:1 persnr using "${my_save_path}luecken_matching.dta", ///
	keepusing (persnr work_luecke* heirat_monat* zusammenzug_monat* leftjob*)
		keep if _merge==3 | _merge==1
		drop _merge

save "${my_save_path}sample_schritt_luecken.dta", replace
save "${my_save_path}sample.dta", replace

*** Flag-Variable für Lücke-Informationen erstellen
foreach welle in "${years}" {
	generate flag_work_luecke`welle'=0
		replace flag_work_luecke`welle'=1 if missing(work`welle') & /*
			*/ !missing(work_luecke`welle')
}

*** Durch Lückefragen ersetze Variablen in die Work-Variable einfügen
foreach welle in "${years}" {
	replace work`welle'=work_luecke`welle'
}

*** Lücke Info in Partnerschaftsvar. einfügen
foreach welle in "${years}" {
	generate flag_relpar_luecke`welle'=0
		replace flag_relpar_luecke`welle'=1 if flag_relpar`welle'==1 & /*
		*/ !missing(heirat_monat`welle') & heirat_monat`welle'>=1
	
	replace Irelpar`welle'=3 if flag_relpar`welle'==1 & !missing(heirat_monat`welle') & heirat_monat`welle'>=1
	replace flag_relpar`welle'=0 if flag_relpar_luecke`welle'==1
	
	tab Irelpar`welle' if flag_relpar_luecke`welle'==1
}

foreach welle in "${years}" {
	replace flag_relpar_luecke`welle'=1 if flag_relpar`welle'==1 & /*
		*/ !missing(zusammenzug_monat`welle') & zusammenzug_monat`welle'>=1
	
	replace Irelpar`welle'=2 if flag_relpar`welle'==1 & /*
		*/ !missing(zusammenzug_monat`welle') & zusammenzug_monat`welle'>=1
	replace flag_relpar`welle'=0 if flag_relpar_luecke`welle'==1
	
	tab Irelpar`welle' if flag_relpar_luecke`welle'==1
}

* Jobwechselvariablen
// Ich generiere an dieser Stelle kein Ijobch, da ich dann die ganze Syntax wieder ändern muss

tab1 leftjob*

foreach welle in "${years}" {
	generate flag_jobch_luecke`welle'=0
		replace flag_jobch_luecke`welle'=1 if (leftjob`welle'==1 | leftjob`welle'==2) & work`welle'>=1 & work`welle'<=3
	tab flag_jobch_luecke`welle'
	replace jobch`welle'=2 if leftjob`welle'==2 & (missing(jobch`welle')| jobch`welle'==3) & work`welle'>=1 & work`welle'<=3
	replace jobch`welle'=4 if leftjob`welle'==1 & (missing(jobch`welle')| jobch`welle'==3) & work`welle'>=1 & work`welle'<=3
}

save "${my_save_path}sample_schritt_luecken2.dta", replace
save "${my_save_path}sample.dta", replace

********************************************************************************
* 8.2.: Missings und Flag-Variablen
********************************************************************************
* Jobch und erwzeit macht inhaltlich keinen Sinn
* Partnercharakteristika bisher nicht beachtet
* Partnerschaftsstatus wurde bereits in Schritt 5 bearbeitet
* Misstable gibt Übersicht über fehlende Werte, mit ",gen(miss_var)" Dummys

do Diss_Missings151027_aufgeraeumt

use "${my_save_path}sample.dta", clear
merge 1:1 persnr using "${my_save_path}sample_help.dta", ///
	keepusing (persnr I* imp_* mis2_* summis* imp2_* flag_* )
		keep if _merge==3 | _merge==1
		drop _merge

*** Übersicht über Variablen mit fehlenden Werten
* Diese Variablen wurden direkt mit imputierten Variablen generiert, deshalb keine Missings
foreach welle in "${years}" {
	generate HFrelpar`welle'=Irelpar`welle' if imp2_relpar`welle'==0 //imp_relpar=plausibel imputiert, flag_relpar beinhaltet imp und imp2
	generate HFhinc`welle'=Ihinc`welle' if flag_hinc`welle'==0
	generate HFlabnet`welle'=Ilabnet`welle' if flag_labnet`welle'==0
	generate HFlabgro`welle'=Ilabgro`welle' if flag_labgro`welle'==0
}

* Auflistung der Missings
foreach welle in "${years}" {
	misstable summarize bil`welle' berufl_zwei`welle' work`welle' west`welle' /*
		*/ cpi`welle' sorgen_hh`welle' ausb`welle'  /*
		*/ kinder014`welle' selfemp`welle' expue`welle' expft`welle'  /*
		*/ exppt`welle' HFrelpar`welle' HFhinc`welle' /*
		*/ if erstbefr<=`welle' & letztbef>=`welle', all	
}

foreach welle in "${years}" {
	misstable summarize befr`welle' uebstd`welle' jobch`welle' erwzeit`welle' /*
		*/ vebzeit`welle' sorgen_ew`welle' sorgen_a`welle' verlust`welle'  /*
		*/ chance_stelle`welle' HFlabnet`welle' HFlabgro`welle' /*
		*/ if work`welle'>0 & work`welle'<4 & erstbefr<=`welle' & letztbef>=`welle', all	
}

foreach welle in "${years}" {
	misstable summarize partner_bil`welle' partner_berufl_zwei`welle' /*
		*/ partner_befr`welle' partner_expue`welle' partner_gebjahr`welle' /*
		*/ partner_exppt`welle' partner_expft`welle' partner_work`welle' /*
		*/ partner_vebzeit`welle' partner_labnet`welle' partner_labgro`welle' /*
		*/ partner_jobch`welle' /*
		*/ if Irelpar`welle'>1 & Irelpar`welle'<3 & erstbefr<=`welle' & letztbef>=`welle', all	
}


misstable summarize agefjob nojob occmove, all

tab migback if migback==4 //keine Info über Migrationshintergrund

save "${my_save_path}sample_schritt_missings.dta", replace
save "${my_save_path}sample.dta", replace

//**//////////////////////////////////////////////////////////////////////////**
* Schritt 9: Umwandlung in long-format
//**//////////////////////////////////////////////////////////////////////////**
* Für die Analyse relevante Variablen in long-format umwandeln
* ACHTUNG: AB HIER überprüfen, ob überall die Bedingung "bysort persnr(welle)"

* Wie viele Personen jede Welle und wie viele Lücken/ohne FB?
foreach jahr in "${years}" {
	tab netto`jahr' if erstbefr<=`jahr' & letztbef>=`jahr'
}


keep persnr hhnr* mutter* zweitesKind*  /// *Abhängige Var.	
	gebjahr empf_j erw_j kidgeb* ///
	Irelpar*  bio1* bio2*  /// * Partnerschhaft
	beziehung* beziehung_hh* ehe* nel* LatvorEhe* LatvorNel* NelvorEhe* ///
	Trelpar* Drelpar* heirat_mon* heirat_monat* ///
	partner_netto* partner_bil* partner_berufl* /// *Partnercharakteristika
	partner_berufl_zwei* partner_expue* partner_exppt* partner_expft* ///
	partner_work* partner_vebzeit* partner_labnet* partner_labgro* ///
	partner_jobch* partner_befr* partner_gebjahr* partner_lfs* /// 
	Iwork* Ibefr* Izeitarbeit* Iuebstd* Iexpue* expft* exppt* /// * Arbeitsmarkt
	occmove jobch* Ierwzeit* Ivebzeit* Iverlust_alt* Iverlust_neu* Iverlust* ///
	Ichance_stelle* Isorgen_aw* Isorgen_ew* Isorgen_a* Isorgen_hh* lfs* ///
	zarbeit* ///
	phrf* bleib* help_bleib* lbclgewicht* gbclgewicht* lbalgewicht* qbclgewicht* /// * Gewichtung
	west* selfemp* deutsch cpi* /// * Kontrollvariablen
	Ibil1* Ibil2* Ii* Ihinc* Ihhlinc* hhgr* Ikinder014* ///
	Iinausbildung* Iausbform* Iausb2form* Iberufl* Iberufl_zwei* ///
	bioyear sumkids netto* Ilabnet* Ilabgro* erstbefr letztbef /// * Hilfsvar.
	couple*  paar* filter_befr* kohorte7074 imp_* imp2_* /// 
	flag_* kohorte7579 kohorte8084 kohorte8589 kohorte9094 partnr* ///
	agefjob nojob migback psample gap_*
	
	*armutsschwelle* Qincome* Pincome* partner_Qincome* partner_QBincome* partner_Pincome* partner_PBincome*
 
save "${my_save_path}sample_wide.dta", replace

reshape long hhnr mutter zweitesKind  /// * Abhängige Var.
	Irelpar LatvorEhe NelvorEhe LatvorNel  /// * Partnerschhaft
	beziehung beziehung_hh ehe nel Trelpar Drelpar heirat_mon heirat_monat ///
	partner_netto partner_bil partner_berufl /// *Partnercharakteristika
	partner_berufl_zwei partner_expue partner_exppt partner_expft ///
	partner_work partner_vebzeit partner_labnet partner_labgro ///
	partner_jobch partner_befr partner_gebjahr partner_lfs /// 
	Iwork Ibefr Ivebzeit jobch Ierwzeit lfs zarbeit /// * Arbeitsmarkt
	Iuebstd Izeitarbeit Iexpue expft exppt Isorgen_hh Isorgen_a ///
	Iverlust_alt Iverlust_neu Iverlust Ichance_stelle Isorgen_aw Isorgen_ew ///
	phrf bleib help_bleib lbclgewicht gbclgewicht lbalgewicht qbclgewicht /// * Gewichtung
	west Iinausbildung Iausbform Iausb2form cpi /// * Kontrollvar.
	Ibil Iberufl Iberufl_zwei  selfemp hhgr Ikinder014 Ilabnet Ilabgro Ihhlinc ///
	Ii1hinc Ii2hinc Ii3hinc Ii4hinc Ii5hinc Ihinc ///
	///
	///
	netto filter_befr partnr couple paar bio /// * Hilfsvar.
	///
	imp_befr imp_hinc imp_i1hinc imp_i2hinc imp_ausbform imp_berufl imp_berufl_zwei ///
	imp_ausb2form imp_i3hinc imp_i4hinc imp_i5hinc imp_inausbildung  ///
	imp_kinder014 imp_relpar imp_couple imp_paar imp_expue ///
	imp_bil imp_bez imp_uebstd imp_vebzeit imp_erwzeit ///
	imp_work imp_zeitarbeit imp_sorgen_aw imp_sorgen_hh imp_chance_stelle ///
	imp_verlust_alt imp_verlust_neu imp_verlust imp_sorgen_a imp_sorgen_ew ///
	imp_labnet imp_labgro imp_hhlinc imp2_labnet imp2_labgro ///
	imp2_ausbform imp2_ausb2form imp2_befr	imp2_bil ///
	imp2_hinc imp2_i1hinc imp2_i2hinc imp2_i3hinc imp2_berufl imp2_berufl_zwei ///
	imp2_i4hinc imp2_i5hinc imp2_inausbildung imp2_kinder014 ///
	imp2_chance_stelle imp2_relpar imp2_expue imp2_erwzeit ///
	imp2_sorgen_a imp2_sorgen_aw imp2_sorgen_ew imp2_sorgen_hh imp2_uebstd ///
	imp2_vebzeit imp2_verlust imp2_verlust_alt imp2_verlust_neu ///
	imp2_work imp2_zeitarbeit imp2_hhlinc ///
	///
	flag_befr flag_bil flag_hinc flag_i1hinc flag_i2hinc ///
	flag_i3hinc flag_i4hinc flag_i5hinc flag_inausbildung flag_ausbform ///
	flag_ausb2form flag_relpar flag_uebstd flag_labnet flag_labgro ///
	flag_vebzeit flag_work flag_zeitarbeit flag_verlust_alt flag_verlust_neu ///
	flag_verlust flag_chance_stelle flag_sorgen_a flag_sorgen_ew flag_erwzeit ///
	flag_sorgen_aw flag_sorgen_hh flag_kinder014 flag_expue flag_hhlinc ///
	flag_work_luecke flag_berufl flag_berufl_zwei flag_relpar_luecke ///
	flag_jobch_luecke ///
	gap_verlust_alt gap_verlust_neu  ///  Gap-Flag
	gap_chance_stelle ///
	,i(persnr) j(welle)

save "${my_save_path}sample_long_org.dta", replace
// Unter dem Namen "sample_long_org.dta" unverändert im Long-Format
	
save "${my_save_path}sample_schritt9.dta", replace
save "${my_save_path}sample_long_org.dta", replace


//**//////////////////////////////////////////////////////////////////////////**
* Schritt 10: Sample einschränken
//**//////////////////////////////////////////////////////////////////////////**
********************************************************************************
* 10.1.: Getrennte Datensätze für Familiengründung, 2. Kind
********************************************************************************

* Familiengründung
use "${my_save_path}sample_long_org.dta", replace
drop if erstbefr>empf_j & empf_j!=.
save "${my_save_path}sample_long.dta", replace

* Familienerweiterung: 2. Kind
use "${my_save_path}sample_long_org.dta", replace
drop if sumkids==0
drop if erstbefr>erw_j & erw_j!=.
save "${my_save_path}sample_long_zweites.dta", replace

	generate info=.
		replace info=1 if erstbefr<=empf_j //Infos schon von 1. Geburt vorhanden
		replace info=0 if erstbefr>empf_j // Panelaufnahme nach 1. Geburt
		tab info, mis
save "${my_save_path}sample_long_zweites.dta", replace

	

*** Zunächst mit der FAMILIENGRÜNDUNG fortsetzen:
use "${my_save_path}sample_long.dta", replace

********************************************************************************
* 10.2.: "Normales Sample": "Leere" und unnötige Wellen entfernen
********************************************************************************
generate sample=1
	replace sample=0 if welle<erstbefr //Wellen vor der ersten Befragung
	replace sample=0 if welle>letztbef //Wellen nach der letzten Befragung
	replace sample=0 if empf_j<welle //Wellen nach dem ersten Kind

* Nach Überprüfung von "sample", nicht erwünschte Zeilen entfernen
drop if welle<erstbefr
drop if welle>letztbef
drop if empf_j<welle

* Befragung mit unter 17 Jahren löschen
generate alter=welle-gebjahr

drop if alter<17

save "${my_save_path}sample_long.dta", replace

********************************************************************************
* 10.3.: Stichprobe einschränken mit Hilfe von Variable "netto"
********************************************************************************
bysort persnr (mutter): generate Hmutter=mutter[_N]
	//Kennzeichnen, wenn in späteren Wellen irgendwann Mutter wird

*****************************************
* 10.3.1.: Hilfsvariablen, die die erste und letzte Welle (=letzte Zeile) kennzeichnen
*****************************************
bysort persnr (welle): generate nummerierung=_n
bysort persnr (welle): generate teilnahme=_N
bysort persnr (welle): generate Hfirst=1 if _n==1
bysort persnr (welle): generate Hlast=1 if _n==_N

save "${my_save_path}sample_long.dta", replace	
	
*****************************************
* 10.3.2. Fälle ausschließen, wenn nur an einer Welle teilgenommen?
*****************************************
// Nein, ich habe mich dagegen entschieden
* Macht es Sinn, Fälle drin zu lassen, die nur an einer Welle teilgenommen haben?
* Wenn netto=17 & nur eine Welle, dann auch nicht vollständiger FB, da Sonder-FB
replace sample=0 if teilnahme==1 & netto==17
replace sample=0 if teilnahme==1 & netto==30
	
*drop if Hlast==1 & netto==17 //(107 Fälle, 2 Events)
	
*****************************************
* 10.3.3. Netto Variable: Ohne Personeninterview oder Lückefragebogen
*****************************************
tab netto if erstbefr==welle //Erstbefr==aktiver FB ausgefüllt

* Wie viele Wellen sind von Ausfällen betroffen? Weniger als 2% alle Fälle
/* 	[30] Personen in Brutto-HHen ohne P.Int |        261
	[31] Realisierte Nacherhebung (_LUECKE) |        563
	[61] Nacherhobene Luecke ohne HH-Bezug |          2
	[81] Vormals Befragte(ERSTBEF) ohne akt |         13
	[88] Rueckkehrer - (zuvor Wegzug Auslan |          9
	[89] Rueckkehrer - (zuvor Ausfaelle [90 |          3 */
	
tab netto

* An welcher Stelle im Panel wird kein P-FB mehr ausgefüllt?
tab nummerierung if netto>=30 //insbesondere erste Jahre des Panels
tab Hlast if netto>=30

* Wenn ich Fälle ab einem Ausfall netto>=30 ausschließen würde, wären das 48 Events
// anscheinend Fülle Frauen in der Schwangerschaft häufig den FB nicht aus
tab netto mutter if netto>=30

*** Wenn netto>=30 in der ersten Welle: Keine Events
tab netto mutter if Hfirst==1 & netto>=30 


*****************************************
* 10.3.4. Lückeinfos in Lücken einfügen: Lohnt sich das? 
*****************************************
/* Lücke-Daten liegen im Spellformat vor, diese zu bearbeiten dauert
	wahrscheinlich einige Zeit. Do-File dafür könnte ich hier finden:
	http://www.diw.de/de/diw_01.c.465288.de/spelljobs.html */
/* Habe ich in Schritt 8 für eine ausgewählte Zahl an Variablen gemacht. */	

tab1 Iwork flag_work if netto==31
	
save "${my_save_path}sample_long.dta", replace 
	
*****************************************
* 10.3.5. Falls ich Fälle gelöscht habe: einige Variablen neu generieren
*****************************************
drop nummerierung teilnahme Hfirst Hlast
bysort persnr (welle): generate nummerierung=_n
bysort persnr (welle): generate teilnahme=_N
bysort persnr (welle): generate Hfirst=1 if _n==1
bysort persnr (welle): generate Hlast=1 if _n==_N


save "${my_save_path}sample_schritt10.dta", replace 
save "${my_save_path}sample_long.dta", replace 

//**//////////////////////////////////////////////////////////////////////////**
** Schritt 11: Einkommensvariable generieren
//**//////////////////////////////////////////////////////////////////////////**
/* Die Operationalisierung dieser Variable kann erst nach der Impution der
	Missings erfolgen, da ansonsten bei späterer Imputation anstelle des
	äquivalentgewichteten Einkommens nur das ungewichtete HH-Einkommen 
	imputiert werden würde. */

********************************************************************************
* 11.1.: OECD Äquivalentgewichtetes HH-Nettoeinkommen
********************************************************************************
*****************************************
* 11.1. Lineaere Modellierung, d.h. absolute Höhe des Einkommens
*****************************************
foreach wert of numlist 1/5 {
	generate hh`wert'income=.
foreach jahr of numlist 1990/2012 {		
		replace hh`wert'income= /*
		*/ Ii`wert'hinc/(1+((hhgr-Ikinder014-1)*0.5) + (Ikinder014*0.3)) /*
		*/ if welle==`jahr' & imp2_i`wert'hinc==0 & !missing(hhgr)
	label variable hh`wert'income "OECD Äquivalentgewichtetes HH-Nettoeinkommen" 
	
	sum hh`wert'income if welle==`jahr', d
	}
}

generate imp_hhincome=0
	replace imp_hhincome=1 if imp_i1hinc==1 | imp_kinder014==1
	
* letzte Missings füllen
foreach wert of numlist 1/5 {
	generate imp2_hh`wert'income=0
		replace imp2_hh`wert'income=1 if missing(hh`wert'income)
foreach jahr in "${jahre}" {
	sum hh`wert'income if welle==`jahr' & imp2_i`wert'hinc==0 [aw=phrf], d
	replace hh`wert'income=r(mean) if missing(hh`wert'income) & welle==`jahr'
}
}

*****************************************
* 11.2. Logarithmierte Modellierung
*****************************************
generate ln_einkommen=hh1income+1 //logarithmiert, 1 addieren, da kein Log. von 0 existiert
	replace ln_einkommen=ln(ln_einkommen)

*****************************************
* 11.3. Quadrierte Modellierung
*****************************************
sum hh1income [aw=gbclgewicht] if gbclgewicht>0, d //nur in Reg. verwendete Fälle	
generate ceinkommen=hh1income-r(mean)

generate ceinkommen2=ceinkommen^2
	
*****************************************
* 11.4. In Quartilen dargestellt
*****************************************
label define Qincome ///
	1 "[1] 1. Quartil" 2 "[2] 2. Quartil" 3 "[3] 3. Quartil" 4 "[4] 4. Quartil"

* Mit Querschnittsgewichtung
generate Qincome9012=.
	foreach jahr of numlist 1990/2012 {
	sum hh1income if welle==`jahr' & imp2_hh1income==0 [aw=phrf], d
		replace Qincome9012=1 if hh1income<=r(p25) & imp2_hh1income==0 & welle==`jahr'
		replace Qincome9012=2 if hh1income>r(p25) & hh1income<=r(p50) & imp2_hh1income==0 & welle==`jahr'
		replace Qincome9012=3 if hh1income>r(p50) & hh1income<=r(p75) & imp2_hh1income==0 & welle==`jahr'
		replace Qincome9012=4 if hh1income>r(p75) & imp2_hh1income==0 & welle==`jahr'
		replace Qincome9012=3 if welle==`jahr' & (missing(Qincome9012) | imp2_hh1income==1)
	* pctile HQ9012=Ihh9012income [aw=lbclgewicht], nquantiles (4) 
	}
label values Qincome9012 Qincome
tab Qincome9012 

* Mit Längsschnittgewichtung
generate Qincome9012l=.
	foreach jahr of numlist 1990/2012 {
	sum hh1income if welle==`jahr' & imp2_hh1income==0 [aw=gbclgewicht], d
		replace Qincome9012l=1 if hh1income<=r(p25) & imp2_hh1income==0 & welle==`jahr'
		replace Qincome9012l=2 if hh1income>r(p25) & hh1income<=r(p50) & imp2_hh1income==0 & welle==`jahr'
		replace Qincome9012l=3 if hh1income>r(p50) & hh1income<=r(p75) & imp2_hh1income==0 & welle==`jahr'
		replace Qincome9012l=4 if hh1income>r(p75) & imp2_hh1income==0 & welle==`jahr'
		replace Qincome9012l=3 if welle==`jahr' & (missing(Qincome9012l) | imp2_hh1income==1)
	* pctile HQ9012l=Ihh9012lincome [aw=lbclgewicht], nquantiles (4) 
	}
label values Qincome9012l Qincome
tab Qincome9012l 

* Mit Querschnittsgewichtung
generate Qincome9512=.
	foreach jahr of numlist 1995/2012 {
	sum hh1income if welle==`jahr' & imp2_hh1income==0 [aw=phrf], d
		replace Qincome9512=1 if hh1income<=r(p25) & welle==`jahr'
		replace Qincome9512=2 if hh1income>r(p25) & hh1income<=r(p50) & welle==`jahr'
		replace Qincome9512=3 if hh1income>r(p50) & hh1income<=r(p75) & welle==`jahr'
		replace Qincome9512=4 if hh1income>r(p75)  & welle==`jahr'
	* pctile HQ9512=Ihh9512income [aw=lbclgewicht], nquantiles (4) 
	}
label values Qincome9512 Qincome
tab Qincome9512 [aw=lbclgewicht]
/* Imputiertes Einkommen wird nicht verwendet zur Berechnung der Quartile, aber
	das imputierte Einkommen wird nachher entsprechend den Quartilen zugeordnet */


*****************************************
* 11.5. Armutsschwelle
*****************************************
// Mir ist aufgefallen, dass im SOEP Personen mit niedrigem Einkommen
// unterrepräsentiert sind. Im Jahr 2008 laut Destatis 15% betroffen, ///
// ungewichtet im SOEP 5,3%, gewichtet 13,9%
label define armutsschwelle ///
	0 "[0] Mehr als 60% des Medianeinkommens" ///
	1 "[1] Weniger als 60% des Medianeinkommens"

foreach wert of numlist 1/5 {
	generate armutsschwelle`wert'=0
		foreach jahr of numlist 1990/2012 {
			sum hh`wert'income if welle==`jahr' & imp2_hh`wert'income==0 [aw=phrf], d
			replace armutsschwelle`wert'=1 if hh`wert'income<(r(p50)*0.6) & ///
			imp2_hh`wert'income==0 & welle==`jahr'
	}
	label values armutsschwelle`wert' armutsschwelle		
}


generate armutsschwelle9512=0
	foreach jahr of numlist 1995/2012 {
		sum hh1income if welle==`jahr' & imp2_hh1income==0 [aw=phrf], d
			replace armutsschwelle9512=1 if hh1income<(r(p50)*0.6) & ///
			imp2_hh1income==0 & welle==`jahr'
}
label values armutsschwelle9512 armutsschwelle		
tab armutsschwelle9512

********************************************************************************
* 11.2.: Verschiedende Einkommensvariablen zur Prekaritätsanalyse
********************************************************************************
*****************************************
* 11.2.1. Armutsschwelle individuelles Bruttoerwerbseinkommen/Bruttostundenlöhne
*****************************************
// Ab 1995 berechnet, ich könnte ab 1984

* Armutsschwelle individuelles Bruttoerwerbseinkommen/Bruttostundenlöhne
tab Iwork flag_labgro //Auszubildende, Arbeitslose und NE alle auf 0

generate Qieinkommen=0 if welle>=1995
foreach welle of numlist 1995/2012 {
	sum Ilabgro if flag_labgro==0 & welle==`welle' [aw=phrf], d
		replace Qieinkommen=1 if Ilabgro<=r(p25) & flag_labgro==0 & welle==`welle'
		replace Qieinkommen=2 if Ilabgro>r(p25) & Ilabgro<=r(p50) & flag_labgro==0 & welle==`welle'
		replace Qieinkommen=3 if Ilabgro>r(p50) & Ilabgro<=r(p75) & flag_labgro==0 & welle==`welle'
		replace Qieinkommen=4 if Ilabgro>r(p75) & flag_labgro==0 & welle==`welle'
		replace Qieinkommen=3 if welle==`welle' & (missing(Ilabgro) | flag_labgro==1)
}
//ist es so sinnvoll, Personen tnz in Quartil 3 zu packen??

label values Qieinkommen Qincome
tab Qieinkommen

* Falls weniger als Vollzeit gearbeitet wird, könnte der Bruttollohn allein die Stellung in Verteilung verfälschen

*****************************************
* 11.2.2. Niedrigeinkommen
*****************************************
* sum nur für Personen ohne Imputation. Danach aber auch imputierte Werte 
* richtig zuordnen. Durch flag_labgro dürfte das kein Problem darstellen
generate Qbrutto=0 if welle>=1995
generate quartil25=.
generate quartil50=.
generate quartil75=.
foreach welle of numlist 1995/2012 {
	sum Ilabgro if flag_labgro==0 & welle==`welle' & (Iwork==1  | Iwork==2 | Iwork==3) [aw=phrf], d
		replace Qbrutto=1 if Ilabgro<=r(p25) & welle==`welle' & (Iwork==1  | Iwork==2 | Iwork==3)
		replace Qbrutto=2 if Ilabgro>r(p25) & Ilabgro<=r(p50)& welle==`welle' & (Iwork==1  | Iwork==2 | Iwork==3) 
		replace Qbrutto=3 if Ilabgro>r(p50) & Ilabgro<=r(p75) & welle==`welle' & (Iwork==1  | Iwork==2 | Iwork==3)
		replace Qbrutto=4 if Ilabgro>r(p75) & welle==`welle' & (Iwork==1  | Iwork==2 | Iwork==3)
		replace Qbrutto=3 if welle==`welle' & (missing(Ilabgro) | (Iwork==0  | Iwork==4 | Iwork==5))
	replace quartil25=r(p25) if welle==`welle'
	replace quartil50=r(p50) if welle==`welle'
	replace quartil75=r(p75) if welle==`welle'	
}

label values Qbrutto Qincome
tab Qbrutto
tab Qbrutto if flag_labgro==0 & (Iwork==1  | Iwork==2 | Iwork==3)
tab1 quartil*

*****************************************
* 11.2.3. Niedriglohn
*****************************************
// Stundenlohn definieren

generate stunde_b=0
	replace stunde_b=Ilabgro/((Ivebzeit/5)*21) if Iwork>0 & Iwork<4
	sum stunde_b if Iwork>0 & Iwork<4 [aw=lbclgewicht], d
	
generate ln_stunde_b=stunde_b+1
	replace ln_stunde_b=ln(ln_stunde_b)

generate stunde_n=0
	replace stunde_n=Ilabnet/((Ivebzeit/5)*21) if Iwork>0 & Iwork<4
	sum stunde_n if Iwork>0 & Iwork<4 [aw=lbclgewicht], d
	
generate ln_stunde_n=stunde_n+1
	replace ln_stunde_n=ln(ln_stunde_n)
	

// Berechnung DIW verwendet:
*http://www.diw.de/documents/publikationen/73/diw_01.c.428112.de/13-39.pdf
generate bruttostundenlohn=0
	replace bruttostundenlohn=Ilabgro/(Ivebzeit*4.3) if Iwork>0 & Iwork<4
sum bruttostundenlohn if Iwork>0 & Iwork<4 [aw=lbclgewicht], d
	

* Dann Niedriglohn definieren
generate Qbruttoe=0 if welle>=1995
generate quartil25_2=.
generate quartil50_2=.
generate quartil75_2=.
foreach welle of numlist 1995/2012 {
	sum bruttostundenlohn if flag_labgro==0 & flag_vebzeit==0 & welle==`welle' & (Iwork==1  | Iwork==2 | Iwork==3) [aw=phrf], d
		replace Qbruttoe=1 if bruttostundenlohn<=r(p25) & welle==`welle' & (Iwork==1  | Iwork==2 | Iwork==3)
		replace Qbruttoe=2 if bruttostundenlohn>r(p25) & bruttostundenlohn<=r(p50)& welle==`welle' & (Iwork==1  | Iwork==2 | Iwork==3)
		replace Qbruttoe=3 if bruttostundenlohn>r(p50) & bruttostundenlohn<=r(p75) & welle==`welle' & (Iwork==1  | Iwork==2 | Iwork==3)
		replace Qbruttoe=4 if bruttostundenlohn>r(p75) & welle==`welle' & (Iwork==1  | Iwork==2 | Iwork==3)
		replace Qbruttoe=3 if welle==`welle' & (missing(bruttostundenlohn) | (Iwork==0  | Iwork==4 | Iwork==5))
	replace quartil25_2=r(p25) if welle==`welle'
	replace quartil50_2=r(p50) if welle==`welle'
	replace quartil75_2=r(p75) if welle==`welle'	
}

tab Qbruttoe if flag_labgro==0 & flag_vebzeit==0 & (Iwork==1  | Iwork==2 | Iwork==3)
tab1 quartil*_2

tab Qbrutto Qbruttoe if flag_labgro==0 & flag_vebzeit==0 & (Iwork==1  | Iwork==2 | Iwork==3)


********************************************************************************
* 11.3.: Einkommen (Varianten, die ich nicht verwendet habe)
********************************************************************************
recode hh1income (0/1299.99=0 "[0] unter 1300 Euro") /*
		*/ (1300/2600=1 "[1] 1300-2600 Euro") /*
		*/ (2600.001/3600=2 "[2] 2600-3600 Euro") /*
		*/ (3600.001/max=3 "[3] 3600 und mehr") /*
		*/ , generate(destatis_einkommen)
tab destatis_einkommen mutter , row col

recode hh1income (0/799.99=0 "[0] unter 800 Euro") /*
		*/ (800/1500=1 "[1] 800-1500 Euro") /*
		*/ (1500.001/2500=2 "[2] 1500-2500 Euro") /*
		*/ (2500.001/max=3 "[3] 2500 und mehr") /*
		*/ , generate(brose_einkommen)
tab brose_einkommen mutter , row col

recode hh1income (0/499.99=0 "[0] unter 500 Euro") /*
		*/ (500/800=1 "[1] 500-800 Euro") /*
		*/ (800.001/1100=2 "[2] 800-1100 Euro") /*
		*/ (1100.001/1400=3 "[3] 1100-1400 Euro") /*
		*/ (1400.001/1700=4 "[4] 1400-1700 Euro") /*
		*/ (1700.001/2000=5 "[5] 1700-2000 Euro") /*
		*/ (2000.001/2300=6 "[6] 2000-2300 Euro") /*
		*/ (2300.001/2600=7 "[7] 2300-2600 Euro") /*
		*/ (2600.001/max=8 "[8] 2600 Euro und mehr") /*
		*/ , generate(annina_einkommen)
tab annina_einkommen mutter , row col

recode stunde_b (0=0 "[0] Tnz")(0.0001/8.49=1 "[1] weniger als Mindeslohns (8.50)") /*
	*/ (8.50/12=2 "[2] 8.50 bis 12 Euro")(12.0001/15=3 "[3] 12-15 Euro") /*
	*/ (15.0001/18=4 "[4]15-18 Euro")(18.0001/21=5 "[5] 18-21 Euro") /*
	*/ (21.0001/max=6 "[6] 21 Euro und mehr"), generate(annina_stunde)
tab annina_stunde mutter , row col
	
	
save "${my_save_path}sample_schritt11.dta", replace 
save "${my_save_path}sample_long.dta", replace


//**//////////////////////////////////////////////////////////////////////////**
** Schritt 12: Dauer-Variablen
//**//////////////////////////////////////////////////////////////////////////**
* Variablenbezeichnungen: (H=Help, T=Total, L=Lifecycle, D=Duration)
	*Hvar:Hilfsdummys
	*Tvar:kumulierte Zahl an Jahren in VAR (aktueller Zustand)
	*Lvar:kumulierte Zahl an Jahren in VAR (auch wenn derzeit anderer Zustand)
	*Dvar:kumulierte Zahl an Jahren im Verhältnis zu einer anderen Variable
********************************************************************************
* 12.1. Dauer Befristung 
********************************************************************************
/* Aufgrund fehlender Werte bei der Variable zur Befristung ist die Dauer in 
	Befristung ggf. unterschätzt.
	Dbefr nicht sinnvoll generierbar, da Gesamterfahrung inkonsistent: Problem, 
	dass Arbeitsmarkterfahrung sehr genau und Dauer der Befristung nur auf 
	Jahresbasis erfasst wird 
	Lbefr wäre sehr verzerrt für Personen mit kurzem Beobachtungsfenster
	*/
	
recode Ibefr (1=1 "[1]Befristet" )(2=0 "[0] Unbefristet")(3=0), generate (Hbefr) 
	replace Hbefr=0 if (Iwork==0 | Iwork==4 | Iwork==5) //jegliche Form von Ausbildung
	replace Hbefr=0 if flag_befr==1 //In Befristung imputierte Jahre ungültig!
	label variable Hbefr "Dummy Befristung, imputiert alle unbefristet"


generate Tbefr=0
		bysort persnr (welle): replace Tbefr=1 if Hbefr==1 & Hbefr[_n-1]!=1 
			//1. Jahr in Befristung
		bysort persnr (welle): replace Tbefr=Tbefr[_n-1]+1 if Hbefr==1 & ///
			Hbefr[_n-1]==1 //Folgejahre
		label variable Tbefr "Seit wieviel Jahren aktuell in Befristung?"
		
** Kodierungen mit der Kategorie "Tnz"
label define AHbefr 0 "[0] Unbefristet" 1 "[1] Befristet" 2 "[2] trifft nicht zu"

generate AHbefr=Hbefr
	replace AHbefr=2 if (Iwork==0 | Iwork==4 | Iwork==5)
	label variable AHbefr "Aktuelle Befristung, Tnz als Kategorie"
	label values AHbefr AHbefr

	

* Überprüfen, wie Jahre aufsummiert werden. Wenn Zwischenjahre anders, dann
* beginnt wieder bei 1, so wie ich das gerne hätte
sort persnr welle
list persnr welle Ibefr Tbefr Hbefr Iwork imp_befr in 1/1000 if Iwork>0 & Iwork<4 
	
********************************************************************************
* 12.2. Jobwechsel 
********************************************************************************
* Unterschätze Werte, wenn noch kein Biografiefragebogen ausgefüllt
generate Hfilter=1 if bioyear==.
* occmove: Information aus dem Biografiefragebogen
* jobch: Information aus jährlichen Wellen
* Ergänzung [_n] wird nicht benötigt, ist nur für's Verständnis

recode occmove (1=0)(2=1)(3=2)(missing=.), generate(occmove_num)
recode jobch (1=0 "[0] Nein")(2=0)(3=0)(4=1 "[1] Ja")(5=0)(missing=.), generate(jobch_num)
	replace jobch_num=0 if missing(jobch_num) & Iwork==0 & flag_work==0
	replace jobch_num=0 if missing(jobch_num) & (Iwork==4 | Iwork==5) & flag_work==0
		// Imputation beruht auf Plausibilitäten, deshalb keine echten Missings
generate imp2_jobch=0
	replace imp2_jobch=1 if missing(jobch_num)

replace jobch_num=0 if missing(jobch_num) //echtes Missing
	
generate flag_jobch=0
	replace flag_jobch=1 if imp2_jobch==1
		
		//Annahme, wenn keine Angabe, dann kein Wechsel
		//Für folgende Additionen dürfen keine Missings vorhanden sein
tab jobch_num if (Iinausbildung[_n-1]==1 | Iwork[_n-1]==4 | Iwork[_n-1]==5) & persnr==persnr[_n-1]
		// Viele der beobachteten Jobwechsel aus der Ausbildung/Arbeitslosigkeit
		
* Mit "tnz"-Kategorie	
tab jobch_num // Missing und tnz auf "[0]Nein"
label define Ajobch ///
	0 "[0] Nein" ///
	1 "[1] Ja" ///
	2 "[2] kein Arbeitsvertrag"

generate Ajobch= jobch_num //Aktueller Jobwechsel --> Nicht erwerbst.
	replace Ajobch=2 if Iwork==0 | Iwork>=4
	label variable Ajobch "Aktueller Jobwechsel, mit Kategorie Tnz"
	label values Ajobch Ajobch
	tab Ajobch

*******
* Gesamter Lebenslauf: Kumulierte Zahl der Jobwechsel
*******
* Reihenfolge muss unbedingt eingehalten werden!
/* Schwierigkeit: Die occmove-Variable wird erst im Bio-FB erhoben. Wenn der 
	Bio-FB erst in späteren Wellen erhoben wurde, bedarf dies besonderer
	Berücksichtigung.
	Vorgehen: jobch_num-Werte zuordnen, dann Anpassungen mit occmove_num in
	Abhängigkeit davon, wann BIO-FB erhoben wurde */
	
bysort persnr (welle): generate Hsum=sum(jobch_num)
bysort persnr (welle): generate Hbioyear=welle-bioyear /*
	*/ if _n==1 & !missing(bioyear)
	//0:Bioyear im ersten Jahr des Panels, positiv:Bioyear vor dem ersten Jahr
	//negativ: Bioyear irgendwann im Laufe des Panels
bysort persnr (welle): replace Hbioyear=Hbioyear[1] 
//Wert aus Welle 1 in alle Wellen

generate Hjobch=0
	* Kein Bio-FB ausgefüllt oder missing(occmove_num)
	bysort persnr (welle): replace Hjobch=jobch_num[_n] if missing(occmove_num)
	
	* Bioyear vor 1. Welle
	bysort persnr (welle): replace Hjobch=jobch_num[_n] if Hbioyear>0
		//alle Fälle _n>1: nur diesen Zusatz brauche ich nicht, da im nächsen
		//Schritt _n==1 angepasst wird
	bysort persnr (welle): replace Hjobch=jobch_num[_n]+occmove_num if /*
		*/ Hbioyear>0 & _n==1 & !missing(occmove_num) 
		//in 1. Welle Information zu vergangenen Wechseln integrieren
	
	* Bioyear in 1. Welle, dann in folgenden Wellen nichts mehr mit occmove_num
	bysort persnr (welle): replace Hjobch=jobch_num[_n] if Hbioyear==0
	bysort persnr (welle): replace Hjobch=jobch_num[_n]+occmove_num if /*
		*/ Hbioyear==0 & _n==1 & !missing(occmove_num)
	
	* Bioyear erst in späterer Welle
	bysort persnr (welle): replace Hjobch=jobch_num[_n] if /*
		*/ Hbioyear<0 & !missing(occmove_num)
		bysort persnr (welle): generate HHjobch=occmove_num-Hsum if /*
		*/ Hsum<occmove_num & Hbioyear<0 & /* 
		*/ (welle==bioyear |(welle<bioyear & Hlast==1)) & !missing(occmove_num)
		//(welle<bioyear & Hlast==1): Jahr des Bio-FB ist nicht in Sample
		//in diesem Jahr, wo dann der Bio-FB erhoben wird, Differenz berechnen	
		bysort persnr (HHjobch): replace HHjobch=HHjobch[1] 
		bysort persnr (welle): replace Hjobch=Hjobch[_n]+HHjobch /*
			*/ if _n==1 & !missing(HHjobch) & Hbioyear<0
		
* Jobwechsel kumuliert über den gesamten Lebenslauf
bysort persnr (welle): generate Ljobch=sum(Hjobch)
	label variable Ljobch "Gesamter Lebenslauf: Kumulierte Zahl der Jobwechsel"
	tab Ljobch, mis

* Überprüfung auf Plausbilität
tab Ljobch if jobch_num==1, mis //alles zugeordnet
tab1 persnr Ljobch if occmove_num>0 & !missing(occmove_num) /*
	*/ & Hlast==1 & Ljobch==0 //alles zugeordnet

* Vor Korrekturen waren diese folgenden 4 Fälle fehlerhaft, d.h. das Jahr des 
* Bio-FB lag nicht im Sample (Mutterschaft vorher oder wegen anderer Bedingung
* aus dem Sample ausgeschlossen), sodass die Bedingung welle==bioyear nicht zutreffen 
* konnte und Infos aus occmove_num nicht zugespielt wurden
list persnr welle Ljobch Hbioyear jobch_num Hjobch occmove_num Hsum HHjobch  /*
	*/ bioyear if persnr==2869702 | persnr==3050901 | persnr==3073602 | /*
	*/ persnr==3443803
	
*drop occmove jobch

save "${my_save_path}sample_long.dta", replace

********************************************************************************
* 12.3. Arbeitslosigkeit
********************************************************************************
/* Gesamterfahrung ist auf monatlicher Basis erhoben, die Befristungsvariable
	ist nur jährlich verfügbar.*/
	
*** Arbeitsmarkterfahrung: Missings füllen
generate Larbeitslos=Iexpue
	label variable Larbeitslos "Gesamter Lebenslauf: Kum. Zahl an Jahren in Arbeitslosigkeit `welle'"

generate Iexppt=exppt //Teilzeit
	replace Iexppt=0 if missing(exppt)
generate flag_exppt=0
	replace flag_exppt=1 if missing(exppt)
	
generate Iexpft=expft //Vollzeit
	replace Iexpft=0 if missing(expft)
generate flag_expft=0
	replace flag_expft=1 if missing(expft)	
	
label variable Iexppt "Arbeitsmarkterfahrung Teilzeit"
label variable Iexpft "Arbeitsmarkterfahrung Vollzeit"


*** Arbeitslosigkeitserfahrung im Verhältnis zum Alter
generate Darbeitslos=(Larbeitslos*100)/(welle-gebjahr+1)
	replace Darbeitslos=round(Darbeitslos,1)

*** Vollzeit- und Teilzeiterfahrung im Verhhältnis zum Alter
generate Dvollzeit=(Iexpft*100)/(welle-gebjahr+1)
	replace Dvollzeit=round(Dvollzeit,1)
generate Dteilzeit=(Iexppt*100)/(welle-gebjahr+1)
	replace Dteilzeit=round(Dteilzeit,1)
	

*** Gesamtarbeitsmarkterfahrung modellieren
//Problem, dass dieses monatsgenau erhoben wurde und damit nicht völlig kompatibel mit Jahresinfo
generate gesamt=Iexpue+Iexppt+Iexpft
generate flag_gesamt=0
	replace flag_gesamt=1 if missing(Iexpue) | missing(exppt) | missing(expft)
tab gesamt

tab gesamt Tbefr if gesamt<Tbefr 
generate Igesamt=gesamt
	replace Igesamt=1 if Igesamt>0 & Igesamt<=1 & gesamt<Tbefr 
	replace Igesamt=2 if Igesamt>1 & Igesamt<=2 & gesamt<Tbefr
	replace Igesamt=3 if Igesamt>2 & Igesamt<=3 & gesamt<Tbefr
	replace Igesamt=4 if Igesamt>3 & Igesamt<=4 & gesamt<Tbefr
	replace Igesamt=5 if Igesamt>4 & Igesamt<=5 & gesamt<Tbefr
	replace Igesamt=6 if Igesamt>5 & Igesamt<=6 & gesamt<Tbefr
	replace Igesamt=7 if Igesamt>6 & Igesamt<=7 & gesamt<Tbefr	
	replace Igesamt=8 if Igesamt>7 & Igesamt<=8 & gesamt<Tbefr
	
	replace Igesamt=1 if gesamt==0 & flag_work==0 & Iwork>=1 & Iwork<=4
		// Wenn derzeit erwerbstätig oder arbeitslos, auf 1 aufrunden
tab Igesamt Tbefr if Igesamt<Tbefr //nur noch 15 Fälle, das kann ich ignorieren

*** Arbeitsmarkterfahrung im Verhältnis zur Gesamtarbeitsmarkterfahrung
generate D2arbeitslos=(Larbeitslos*100)/(Igesamt) if Igesamt>=Tbefr
	replace D2arbeitslos=100 if Igesamt<Tbefr
	replace D2arbeitslos=0 if Igesamt==0 & Larbeitslos==0
	tab D2arbeitslos

*** Dauer der aktuellen Arbeitslosigkeit
generate Harbeitslos=1 if Iwork==4 & flag_work==0 //keine imputierten Werte
generate Tarbeitslos=0
	bysort persnr (welle): replace Tarbeitslos=1 if Harbeitslos==1 & missing(Harbeitslos[_n-1]) 
		//1. Jahr Arbeitslosigkeit
	bysort persnr (welle): replace Tarbeitslos=Tarbeitslos[_n-1]+1 if Harbeitslos==1 & /*
		*/ Harbeitslos[_n-1]==1 //folgende Jahre Arbeitslosigkeit
		label variable Tarbeitslos "Dauer der aktuellen Arbeitslosigkeit"

list persnr welle Harbeitslos Iwork Tarbeitslos in 1/1000
//Überprüfen, dass auch nur die aktuelle Arbeitslosigkeitsphase summiert wird
//gutes Bsp. ist persnr==53904


* Neuer Versuch: Runden
// Gesamtarbeitsmarkterfahrung
generate DGarbeitslos=(Larbeitslos*100)/(gesamt)
	replace DGarbeitslos=0 if gesamt==0
	tab DGarbeitslos
replace DGarbeitslos=round(DGarbeitslos,1) //ohne Kommastellen
	// round(var,.1): auf eine Stelle nach dem Komma gerundet
	tab DGarbeitslos
	
generate DGvollzeit=(Iexpft*100)/gesamt
	replace DGvollzeit=0 if gesamt==0
	tab DGvollzeit
replace DGvollzeit=round(DGvollzeit,1)
	tab DGvollzeit
	
generate DGteilzeit=(Iexppt*100)/gesamt
	replace DGteilzeit=0 if gesamt==0
	tab DGteilzeit
replace DGteilzeit=round(DGteilzeit,1)
	tab DGteilzeit

save "${my_save_path}sample_long.dta", replace


********************************************************************************
* 12.4.: Dauer der Beziehung
********************************************************************************
/* Iin Schritt 5 verlegt */


********************************************************************************
* 12.5.: Dauer-Variablen logarithmieren und teilweise quadrieren
********************************************************************************
* Arbeitslosigkeit/Arbeitsmarkterfahrung
foreach var in "Larbeitslos" "Darbeitslos" "Tarbeitslos" "Dvollzeit" "Dteilzeit" "DGarbeitslos" "DGvollzeit" "DGteilzeit" {

	generate ln_`var'=`var'+1
		replace ln_`var'=ln(ln_`var')
		
	generate qu_`var'=`var'^2
}


*  Befristung
generate ln_Tbefr=Tbefr+1
	replace ln_Tbefr=ln(ln_Tbefr)
	
generate qu_Tbefr=Tbefr^2

* Überstunden
generate ln_Iuebstd=Iuebstd+1
	replace ln_Iuebstd=ln(ln_Iuebstd)

* Dauer in Beziehung, innerhalb des HH 
// In Schritt 5 generiert
generate ln_Trelpar=Trelpar+1
	replace ln_Trelpar= ln(ln_Trelpar)

generate ln_Drelpar=Drelpar+1
	replace ln_Drelpar= ln(ln_Drelpar)

* Dauer der aktuellen Beziehung, innerhalb des HH 
// In Schritt 5 generiert
generate ln_beziehung_hh=beziehung_hh+1
	replace ln_beziehung_hh= ln(ln_beziehung_hh)
	
generate qu_beziehung_hh=beziehung_hh^2

* Dauer der aktuellen Beziehung, auch LAT
// In Schritt 5 generiert
generate ln_beziehung=beziehung+1
	replace ln_beziehung= ln(ln_beziehung)
	
generate qu_beziehung=beziehung^2
	
* Dauer der aktuellen Ehe
// In Schritt 5 generiert
generate ln_ehe=ehe+1
	replace ln_ehe=ln(ln_ehe)
	
generate qu_ehe=ehe^2
	
* Dauer der aktuellen NEL
//In Schritt 5 generieret
generate ln_nel=nel+1
	replace ln_nel=ln(ln_nel)
	
generate qu_nel=nel^2

* Weitere Dauer-Variablen zur Beziehung
//In Schritt 5 generieret
generate ln_NelvorEhe=NelvorEhe+1
	replace ln_NelvorEhe=ln(ln_NelvorEhe)
	
generate qu_NelvorEhe=NelvorEhe^2
	
generate ln_LatvorEhe=LatvorEhe+1
	replace ln_LatvorEhe=ln(ln_LatvorEhe)
	
generate qu_LatvorEhe=LatvorEhe^2

generate ln_LatvorNel=LatvorNel+1
	replace ln_LatvorNel=ln(ln_LatvorNel)
	
generate qu_LatvorNel=LatvorNel^2

* Kumulierte Zahl der Jobwechsel
generate ln_jobch=Ljobch+1
	replace ln_jobch=ln(ln_jobch)

* Jahre beim selben Arbeitgeber
generate ln_erwzeit=Ierwzeit+1
	replace ln_erwzeit=ln(ln_erwzeit) 
	
generate qu_erwzeit=Ierwzeit^2

* Einkommen
foreach wert of numlist 1/5 {
	generate ln_hh`wert'income=hh`wert'income+1
		replace ln_hh`wert'income=ln(ln_hh`wert'income)
	generate ln_Ii`wert'hinc=Ii`wert'hinc+1
		replace ln_Ii`wert'hinc=ln(ln_Ii`wert'hinc)
		
	generate qu_hh`wert'income=hh`wert'income^2
}

save "${my_save_path}sample_schritt12.dta", replace
save "${my_save_path}sample_long.dta", replace


//**//////////////////////////////////////////////////////////////////////////**
** Schritt 13: Missings kontrollieren
//**//////////////////////////////////////////////////////////////////////////**
********************************************************************************
* 13.1. Änderungen oder Fehlerbehebung
********************************************************************************
*****************************************
* 13.1.1. Befristung
*****************************************
/* In den Jahren 1990-1994 Filtervariablen und dies beim Imputieren beachten */

tab flag_befr filter_befr if welle<1995

foreach var in "Hbefr" "Tbefr" {
	replace `var'=0 if filter_befr==0
}	

tab1 imp_befr imp2_befr flag_befr if filter_befr==0

replace imp_befr=0 if filter_befr==0 
replace imp2_befr=0 if filter_befr==0 
replace flag_befr=0 if filter_befr==0


tab flag_befr filter_befr if welle<1995

save "${my_save_path}sample_long.dta", replace

*****************************************
* 13.1.2. Partnerschaft und flag_*
*****************************************
/* Durch Plausibilitäten und die Welleninfo wie Biocouply habe ich Missings 
	gefüllt. Diese habe ich in imp_relpar gekennzeichnet, sollte diese aber in
	flag_relpar nicht kennzeichnen, da es sich nicht um "echte Missings" 
	handelt. */

replace flag_relpar=0 if imp_relpar==1

save "${my_save_path}sample_long.dta", replace

********************************************************************************
* 13.2. Flag-Variablen
********************************************************************************
/* Für alle relevanten Variablen Flag-Variable gebildet? */

foreach var in "jobch" "relpar" "ausbform" "ausb2form" "bil" "befr" "chance_stelle" "kinder014" "sorgen_a" "sorgen_aw" "sorgen_ew" "sorgen_hh" "verlust" "verlust_alt" "verlust_neu" "work" "zeitarbeit" "uebstd" "vebzeit" "expue" "hinc" "i1hinc" "i2hinc" "i3hinc" "i4hinc" "i5hinc" {
	tab1 flag_`var'
	tab mutter flag_`var' [aw=lbclgewicht]
}
	//Beachten: Nicht bei allen flag_Variablen gibt es Ereignisse
	
save "${my_save_path}sample_schritt13.dta", replace
save "${my_save_path}sample_long.dta", replace


//**//////////////////////////////////////////////////////////////////////////**
** Schritt 14: Kontinuierliche Variablen in kategoriale Variablen ändern
//**//////////////////////////////////////////////////////////////////////////**
*** Das betrifft die folgenden Variablen:
	// beziehung_hh beziehung 
	// Tarbeitslos Darbeitslos Larbeitslos
	// Tbefr erwzeit Ljobch 
********************************************************************************
*** Schritt 14.1.: Partnerschaft
********************************************************************************
*****************************************
* 14.1.1. Dauer Beziehung
*****************************************	
**** Gesamter Lebenslauf: Jahre in Ehe/NEL in einem HH 
// D*-Variablen momentan nicht behandelt
// Die Trennungswahrscheinlichkeit antizipierend: Eckhard (2010:74), die ersten 9 Jahre einzeln

foreach var in "relpar" {
	tab T`var' [aw=lbclgewicht]
	recode T`var' (0=0 "[0] kein Partner")(1=1)(2=2)(3=3)(4=4)(5=5)(6=6) ///
		(7=7)(8=8)(9=9)(10/14=10 "[10] 10-14")(15/max=11 "15+"), generate (K`var')
}

**** Aktuelle Partnerschaft: Jahre in Ehe/NEL/LAT, und jeweiliger Beziehungsstatus vorher 
foreach var in "beziehung" "beziehung_hh" "nel" "ehe" "LatvorEhe" "LatvorNel" "NelvorEhe" {
	tab `var' [aw=lbclgewicht]
	
	recode `var' (0=0 "[0] kein Partner")(1=1)(2=2)(3=3)(4=4)(5=5)(6=6) ///
	(7=7)(8=8)(9=9)(10/max=10 "[10] 10 und mehr Jahre"), generate (K`var')
	
	recode `var' (0=0 "[0] kein Partner")(1=1)(2=2)(3=3)(4=4)(5=5)(6=6)(7=7) ///
	(8/max=8 "[8] 8+ Jahre"), generate(KK`var')		
}
                      
save "${my_save_path}sample_long.dta", replace

********************************************************************************
*** Schritt 14.2.: Arbeitsmarkt
********************************************************************************
*****************************************
* 14.2.1. Befristung
*****************************************	
**** Dauer der aktuellen Befristung
// Wichtig: Kategorie "4 und mehr" gebildet, auch wenn die Personen mit 7 und 
// mehr Jahren gar keine Kinder bekommen. Es sind 15 Ausreißer gegenüber 101
// Fällen zwischen 4 und 6 Jahren. Wenn ich die 15 Personen nicht dazu fasse,
// müsste ich sie rauswerfen, da kein Ereignis
* In jeder Kategorie muss mindestens 1 Ereignis vorkommen

* Verteilung anschauen
tab Tbefr mutter if (Iwork==1 | Iwork==2 | Iwork==3), row col
tab Tbefr if (Iwork==1 | Iwork==2 | Iwork==3) & Tbefr>0
tab persnr if Tbefr>6 & (Iwork==1 | Iwork==2 | Iwork==3) & !missing(Tbefr) //15 Personen länger als 6 Jahre befristet (und kein Kind)
tab persnr if Tbefr==12 & (Iwork==1 | Iwork==2 | Iwork==3) & !missing(Tbefr) // 0 Personen
tab persnr if Tbefr==11 & (Iwork==1 | Iwork==2 | Iwork==3) & !missing(Tbefr) //1 Personen
tab persnr if Tbefr==10 & (Iwork==1 | Iwork==2 | Iwork==3) & !missing(Tbefr) //1 Personen 
tab persnr if Tbefr==9 & (Iwork==1 | Iwork==2 | Iwork==3) & !missing(Tbefr) //1 Personen
tab persnr if Tbefr==8 & (Iwork==1 | Iwork==2 | Iwork==3) & !missing(Tbefr) //6 Personen 
tab persnr if Tbefr==7 & (Iwork==1 | Iwork==2 | Iwork==3) & !missing(Tbefr) //6 Personen 
tab persnr if Tbefr==6 & (Iwork==1 | Iwork==2 | Iwork==3) & !missing(Tbefr) //17 Personen 
tab persnr if Tbefr==5 & (Iwork==1 | Iwork==2 | Iwork==3) & !missing(Tbefr) //25 Personen
tab persnr if Tbefr==4 & (Iwork==1 | Iwork==2 | Iwork==3) & !missing(Tbefr) //59 Personen
tab persnr if Tbefr==3 & (Iwork==1 | Iwork==2 | Iwork==3) & !missing(Tbefr) //126
tab persnr if Tbefr==2 & (Iwork==1 | Iwork==2 | Iwork==3)& !missing(Tbefr) //378
tab persnr if Tbefr==1 & (Iwork==1 | Iwork==2 | Iwork==3) & !missing(Tbefr) //1147

tab Tbefr if (Iwork==1 | Iwork==2 | Iwork==3)
tab Tbefr if (Iwork==1 | Iwork==2 | Iwork==3) [aw=lbclgewicht]
tab Tbefr mutter if (Iwork==1 | Iwork==2 | Iwork==3) [aw=lbclgewicht], row col
tab Tbefr mutter if (Iwork==1 | Iwork==2 | Iwork==3) & Hlast==1 [aw=lbclgewicht], row col

* kategoriale Variable generieren
recode Tbefr (0=0 "[0] Unbefristet")(1=1 "[1] Bis zu 1 Jahr") /*
	*/ (2=2 "[2] 2 Jahre")(3=3 "[3] 3 Jahre") /*
	*/ (4/max=4 "[4] 4 und mehr Jahre"), generate (Kbefr)
	replace Kbefr=0 if filter_befr==0 & welle<1995
	replace Kbefr=0 if flag_befr==1
	
recode Tbefr (0=0 "[0] Unbefristet")(1=1 "[1] Bis zu 1 Jahr") /*
	*/ (2=2 "[2] 2 Jahre")(3/max=3 "[3] > 3 Jahre") , generate (Kbefr_kurz)
	replace Kbefr_kurz=0 if filter_befr==0 & welle<1995
	replace Kbefr_kurz=0 if flag_befr==1
	
* Kodierung mit Kategorie "Tnz"
label define AKbefr ///
	0 "[0] Unbefristet" /// 
    1 "[1] Bis zu 1 Jahr" ///
    2 "[2] 2 Jahre" ///
    3 "[3] 3 Jahre" ///
    4 "[4] > 4 Jahre" ///
	5 "[5] trifft nicht zu"

generate AKbefr=Kbefr
	replace AKbefr=5 if (Iwork==0 | Iwork==4 | Iwork==5)
	label variable AKbefr "Dauer Befristung, Tnz als Kategorie"
	label values AKbefr AKbefr
	tab AKbefr

*****************************************
* 14.2.2. Arbeitslosigkeit
*****************************************	 
recode Larbeitslos (0=0 "[0]Noch nie arbeitslos") /*
	*/ (0.1/0.5=1 "[1] Kleine Lücke: Bis 0.5")(0.6/1=2 "[2] Lücke bis zu 1 Jahr") /*
	*/ (1.1/2=3 "[3] Zw. 1 und 2 Jahren")(2.1/max=4 "[4] Mehr als 2 Jahre") /*
	*/ if !missing(Larbeitslos), generate (KLarbeitslos)
	
	* Mit "tnz"-Kategorie
	label define  AKLarbeitslos ///
	0 "[0]Noch nie arbeitslos" ///
    1 "[1] Kleine Lücke: Bis 0.5" ///
    2 "[2] Lücke bis zu 1 Jahr" ///
	3 "[3] Zw. 1 und 2 Jahren" ///
	4 "[4] Mehr als 2 Jahre" ///
	5 "[5] Noch nie erwerbstätig"

	generate AKLarbeitslos=KLarbeitslos
		replace AKLarbeitslos=5 if Iexpue==0 & flag_expue==0 & Iexpft==0 & flag_expft==0 & Iexppt==0 & flag_exppt==0
		label variable AKLarbeitslos "Kum. Jahre Arbeitslos, mit Kategorie Tnz"
		label values AKLarbeitslos AKLarbeitslos
		tab AKLarbeitslos

recode Tarbeitslos (0=0 "[0] Nicht arbeitslos") (1=1 "[1] 1 Jahr arbeitslos") /*
	*/ (2/max=2 "[2] 2 und mehr Jahre arbeitslos") if !missing(Tarbeitslos), /*
	*/ generate (KTarbeitslos)
	
	* Mit "tnz"-Kategorie
	label define AKTarbeitslos ///
	0 "[0] Nicht arbeitslos" ///
	1 "[1] 1 Jahr arbeitslos" ///
	2 "[2] 2 und mehr Jahre arbeitslos" ///
	3 "[3] Noch nie erwerbstätig"
	
	generate AKTarbeitslos=KTarbeitslos
		replace AKTarbeitslos=3 if Iexpue==0 & flag_expue==0 & Iexpft==0 & flag_expft==0 & Iexppt==0 & flag_exppt==0
		label variable AKTarbeitslos "Dauer aktuelle Arbeitslosigkeit, mit Kategorie Tnz"
		label values AKTarbeitslos AKTarbeitslos
		tab AKTarbeitslos
	
recode D2arbeitslos (0=0 "[0] Nicht arbeitslos")(0.01/10=1 "[1] Bis 10 %") /*
	*/ (10.001/25=2 "[2] 10-25 %")(25.0001/50=3 "[3] 25-50 %")/*
	*/ (50.01/99.999=4 "[4] 50-99%")(100=5 "[5] 100%"), generate (KD2arbeitslos)
	
recode DGarbeitslos (0=0 "[0] Nicht arbeitslos")(0.01/10=1 "[1] Bis 10 %") /*
	*/ (10.001/25=2 "[2] 10-25 %")(25.0001/50=3 "[3] 25-50 %")/*
	*/ (50.01/99.999=4 "[4] 50-99%")(100=5 "[5] 100%"), generate (KDGarbeitslos)
	
	* Mit "tnz"-Kategorie
	label define AKDGarbeitslos ///
	0 "[0] Noch nie arbeitslos" ///
	1 "[1] Bis 10 %" ///
	2 "[2] 10-25 %" ///
	3 "[3] 25-50 %" ///
	4 "[4] 50-99%" ///
	5 "[5] 100%" ///
	6 "[6] Noch nie erwerbstätig"
	
	generate AKDGarbeitslos=KDGarbeitslos
		replace AKDGarbeitslos=6 if Iexpue==0 & flag_expue==0 & Iexpft==0 & flag_expft==0 & Iexppt==0 & flag_exppt==0
	label variable AKDGarbeitslos "Kum. Jahre Arbeitslosigkeit im Verhältnis zur Gesamtarbeitsmarkterfahrung	"
	label values AKDGarbeitslos AKDGarbeitslos
	tab AKDGarbeitslos	

*****************************************
* 14.2.3. Jobwechsel
*****************************************
tab Ljobch mutter

recode Ljobch (0=0 "[0]Kein Wechsel bisher")(1=1)(2=2) /*
	*/ (3/max=3 "[3]3 und mehr Wechsel") if !missing(Ljobch), generate (Kjobch)
	
* Mit "tnz"-Kategorie
label define AKjobch ///
	0 "[0] Kein Wechsel bisher" ///
	1 "[1] 1 Wechsel" ///
	2 "[2] 2 Wechsel" ///
	3 "[3] 3 und mehr Wechsel" ///
	4 "[4] Noch nie erwerbstätig"
	
generate AKjobch= Kjobch
	replace AKjobch=4 if Iexpue==0 & flag_expue==0 & Iexpft==0 & flag_expft==0 & Iexppt==0 & flag_exppt==0 & Kjobch==0
		//man kann auch schon gewechselt haben, wenn derzeit Selbstständig oder Arbeitlos
		// Bedingung Igesamt=0 überschreibt solche Fälle, wo Angaben für Kjobch vorliegen
	label variable AKjobch "Kum. Zahl Jobwechsel im Lebenslauf, mit Kategorie Tnz"
	label values AKjobch AKjobch
	tab AKjobch


*****************************************
* 14.2.4. Zeitarbeit
*****************************************
* Sehr wenige Fälle
label define Azeit ///
	0 "[0] kein Arbeitsvertrag" ///
	1 "[1] Ja" ///
	2 "[2] Nein"

generate Azeit =Izeitarbeit
	replace Azeit=0 if (Iwork==0 | Iwork==4 | Iwork==5)
	label variable Azeit "Zeitarbeit, mit Kategorie Tnz"
	label values Azeit Azeit
	tab Azeit
	
	
generate zeitarbeit_dummy=0
	replace zeitarbeit_dummy=1 if Azeit==1
label variable zeitarbeit_dummy "Zeitarbeit==1, ohne Azubis"
tab zeitarbeit_dummy


save "${my_save_path}sample_schritt14.dta", replace
save "${my_save_path}sample_long.dta", replace

//**//////////////////////////////////////////////////////////////////////////**
** Schritt 15: Hazard function
//**//////////////////////////////////////////////////////////////////////////**
* Erkenntnis: Baseline nach Wellen macht keinen Sinn, da eigentlich in jedem
	* Jahr die selbe Zahl der Kinder geboren werden sollte, außer wenn ein Krieg
	* oder so ausbrechen würde
* Choose the functional form for the baseline hazard function (=Verweildauer)
* --> Jenkins Lesson 6
* Non-Parametic baseline: Create duration-interval-specific dummy variable 
* Check whether events occur at each 'welle' --> refine the grouping

tab gebjahr empf_j	
	
tab alter mutter [aw=lbclgewicht], col //NICHT in jedem Alter werden Kinder geboren
							//deshalb tab alter, gen (newvar) nicht möglich)
generate alter2=alter*alter
							
* Dummy Variablen generieren
recode alter (16/20=1 "[1] ja") (nonmiss=0 "[0] nein"), into(dum16_20) 
recode alter (21/25=1 "[1] ja") (nonmiss=0 "[0] nein"), into(dum21_25)
recode alter (26/30=1 "[1] ja") (nonmiss=0 "[0] nein"), into(dum26_30)
recode alter (31/35=1 "[1] ja") (nonmiss=0 "[0] nein"), into(dum31_35)
recode alter (36/45=1 "[1] ja") (nonmiss=0 "[0] nein"), into(dum36_45)


save "${my_save_path}sample_schrittHazard.dta", replace
save "${my_save_path}sample_long.dta", replace	

//**//////////////////////////////////////////////////////////////////////////**
** Einschub: Kontrolle, ob keine Wellen fehlen --> Alles gut!
//**//////////////////////////////////////////////////////////////////////////**

bysort persnr (welle): generate kontrolle=_n
tab kontrolle

bysort persnr (welle): generate Hkontrolle=welle[1] + kontrolle[_n]-1
tab Hkontrolle

tab Hkontrolle welle
tab persnr if Hkontrolle!=welle

//**//////////////////////////////////////////////////////////////////////////**
** Schritt 16: Weitere Änderungen Variablen
//**//////////////////////////////////////////////////////////////////////////**
********************************************************************************
* 16.1.: Befristung
********************************************************************************
* Befristung
label define work_befr ///
	0 "[0] Unbefristet" /// 
    1 "[1] Bis zu 1 Jahr" ///
    2 "[2] 2 Jahre" ///
    3 "[3] 3 Jahre" ///
    4 "[4] 4 und mehr Jahre" ///
	5 "[5] in Ausbildung" ///
	6 "[6] Arbeitslos gemeldet" ///
	7 "[7] Nicht erwerbstätig" 	
	
generate work_befr=AKbefr
	replace work_befr=5 if Iwork==0
	replace work_befr=6 if Iwork==4
	replace work_befr=7 if Iwork==5
	label values work_befr work_befr
tab work_befr 


label define work_AHbefr /*
	*/ 0 "[0] Unbefristet" 1 "[1] Befristet" 2 "[2] in Ausbildung" /*
	*/ 3 "[3] Arbeitslos gemeldet" 4 "[4] Nicht erwerbstätig"
	
generate work_AHbefr=AHbefr
	replace work_AHbefr=2 if Iwork==0
	replace work_AHbefr=3 if Iwork==4
	replace work_AHbefr=4 if Iwork==5
	label values work_AHbefr work_AHbefr
tab work_AHbefr 

********************************************************************************
* 16.2.: Jobwechsel
********************************************************************************
* Jobwechsel
label define work_Ajobch 0 "[0] Nein" 1 "[1] Ja" 2 "[2] in Ausbildung" /*
	*/ 3 "[3] Arbeitslos gemeldet" 4 "[4] Nicht erwerbstätig"
	
generate work_Ajobch=Ajobch
	replace work_Ajobch=2 if Iwork==0
	replace work_Ajobch=3 if Iwork==4 
	replace work_Ajobch=4 if Iwork==5
	label values work_Ajobch work_Ajobch
tab work_Ajobch 


recode Ajobch (0=0 "[0] Nein/kein Arbeitsvertrag")(1=1 "[1] Ja")(2=0), generate(jobch_dum)
tab jobch_dum 


********************************************************************************
* 16.4.: Kalenderzeit
********************************************************************************
* Kalenderzeit
recode welle (1990/1991=1 "[1] 1990-1991")(nonmiss=0), into(zeit9091)
recode welle (1992/1995=2) (nonmiss=0), into(zeit9295)
recode welle (1996/2000=3) (nonmiss=0), into(zeit9600)
recode welle (2001/2005=4) (nonmiss=0), into(zeit0105)
recode welle (2006/2010=5) (nonmiss=0), into(zeit0610)
recode welle (2011/2012=6) (nonmiss=0), into(zeit1112)

recode welle (1990/1991=1 "[1] 1990-1991")(nonmiss=0), into(periode9091)
recode welle (1992/1998=2) (nonmiss=0), into(periode9298)
recode welle (1999/2005=3) (nonmiss=0), into(periode9905)
recode welle (2006/2012=4) (nonmiss=0), into(periode0612)

generate kalenderzeit9094=0
	replace kalenderzeit9094=1 if welle>=1990 & welle<=1994
generate kalenderzeit9599=0
	replace kalenderzeit9599=1 if welle>=1995 & welle<=1999
generate kalenderzeit0005=0
	replace kalenderzeit0005=1 if welle>=2000 & welle<=2005
generate kalenderzeit0612=0
	replace kalenderzeit0612=1 if welle>=2006 & welle<=2012

********************************************************************************
* 16.5.: Migrationshintergrund
********************************************************************************
replace deutsch=1 if missing(deutsch) //keine Info bei 65 Zeilen (51 Personen)


********************************************************************************
* 16.6.: Subjektive Sorgen
********************************************************************************

foreach var in "a" "ew" {
label define Isorg_`var' 0 "[0] in Ausbildung, Arbeitslos, Nicht erwerbstätig, Missing" ///
	1 "[1] Große Sorgen" 2 "[2] Einige Sorgen" 3 "[3] keine Sorgen"
	
generate Isorg_`var'=Isorgen_`var'
	replace Isorg_`var'=0 if Iwork==0 | Iwork==4 | Iwork==5 | imp2_sorgen_`var'==1
label values Isorg_`var' Isorg_`var'
tab Isorg_`var'

}


save "${my_save_path}sample_schritt16.dta", replace
save "${my_save_path}sample_long.dta", replace

//**//////////////////////////////////////////////////////////////////////////**
** Schritt 17: Partnercharakteristika - Variablen generieren
//**//////////////////////////////////////////////////////////////////////////**

do partnercharakteristika151126.do
save "${my_save_path}sample_long.dta", replace

label define partner_alter ///
	0 "[0] 16-20 Jahre" ///
	1 "[1] 21-25 Jahre" ///
	2 "[2] 26-30 Jahre" ///
	3 "[3] 31-35 Jahre" ///
	4 "[4] 36 und älter" ///
	5 "[5] keine Angabe" ///
	6 "[6] Lat oder kein Partner"
	
generate partner_alter_metr=welle-partner_gebjahr
label variable partner_alter_metr "Alter des Partners, metrisch"
	
generate partner_alter=.
	replace partner_alter=0 if partner_alter_metr>=16 & partner_alter_metr<=20 
	replace partner_alter=1 if partner_alter_metr>=21 & partner_alter_metr<=25 
	replace partner_alter=2 if partner_alter_metr>=26 & partner_alter_metr<=30 
	replace partner_alter=3 if partner_alter_metr>=31 & partner_alter_metr<=35 
	replace partner_alter=4 if partner_alter_metr>=36 & !missing(partner_alter_metr) 
	replace partner_alter=5 if missing(partner_alter_metr) & (Irelpar==2 | Irelpar==3)
	replace partner_alter=6 if (Irelpar==0 | Irelpar==1)
label values partner_alter partner_alter
label variable partner_alter "Alter des Partners, kategorial"
tab partner_alter	

sum partner_alter_metr [aw=lbclgewicht] if lbclgewicht>0 & welle>=1995, d
generate partner_calter=partner_alter_metr-r(mean)
	replace partner_calter=r(mean) if missing(partner_calter)

generate partner_alter_qu=partner_calter^2

sum partner_alter_metr [aw=lbclgewicht] if lbclgewicht>0 & welle>=1995, d	
generate partner_alter_ln=partner_alter_metr
	replace partner_alter_ln=r(mean) if missing(partner_alter_ln)
	replace partner_alter_ln=ln(partner_alter_ln)
	
generate missing_partner_alter=0
	replace missing_partner_alter=1 if partner_alter==5
	replace missing_partner_alter=1 if partner_alter==6
	//Diesen Hilfsdummy brauche ich zur Kontrolle, wenn ich metrisches Alter des Partners verwenden will
	
	
generate Irel_mis_par_alter=.
	replace Irel_mis_par_alter=1 if Irelpar==0 | Irelpar==1
	replace Irel_mis_par_alter=2 if Irelpar==2
	replace Irel_mis_par_alter=3 if Irelpar==3
	replace Irel_mis_par_alter=4 if partner_alter==5
tab Irel_mis_par_alter


label define Ipartner_berufl_zwei ///
	0 "[0] noch kein Abschluss" ///
	1 "[1] ohne Ausbildung" ///
	2 "[2] mit Ausbildung" ///
	3 "[3] FH-/Uni-Abschluss" ///
	4 "[4] keine Angabe" ///
	5 "[5] Lat oder kein Partner"
label values Ipartner_berufl_zwei Ipartner_berufl_zwei

label define Ipartner_workM ///
	0 "[0] in Ausbildung" ///
	1 "[1] Voll erwerbstätig" ///
	2 "[2] Teilzeitbeschäftigung" ///
	3 "[3] Unregelmäßig, geringfügig beschäftigt" ///
	4 "[4] Arbeitslos gemeldet" ///
	5 "[5] Nicht erwerbstätig" ///
	6 "[6] keine Angabe"
	
label define partner_erwerb ///
	0 "[0] Erwerbstätig" ///
	1 "[1] Arbeitslos, nicht erwerbstätig" ///
	2 "[2] in Ausbildung" ///
	3 "[3] keine Angabe"
	
label define partner_work_AHbefrM ///
	0  "[0] Unbefristet" ///
	1  "[1] Befristet" ///
	2  "[2] in Ausbildung" ///
    3  "[3] Arbeitslos gemeldet" ///
    4  "[4] Nicht erwerbstätig" ///
	5  "[5] keine Angabe"
	
label define partner_jobch_dumM ///
	 0  "[0] Nein/ kein Arbeitsvertrag" ///
	 1  "[1] Ja, Jobwechsel" ///
     2  "[2] Keine Angabe"
	 
label define Ipartner_bilM ///
	 0  "[0] noch kein Abschluss" ///
     1  "[1] kein Abschluss/Hauptschule" ///
     2  "[2] Mittlere Reife" ///
     3  "[3] (Fach-) Abitur" ///
     4  "[4] keine Angabe" 
	 
	label define Ipartner_bilM_kurz ///
	 0  "[0] (noch) kein Abschluss/Hauptschule" ///
     1  "[1] Mittlere Reife" ///
     2  "[2] (Fach-) Abitur" ///
     3  "[3] keine Angabe" 

label define Ipartner_alterM ///
	 0  "[0] 16-20 Jahre" ///
     1  "[1] 21-25 Jahre" ///
     2  "[2] 26-30 Jahre" ///
     3  "[3] 31-35 Jahre" ///
     4  "[4] 36 und älter" ///
     5  "[5] keine Angabe"


generate Ipartner_berufl_zwei2=Ipartner_berufl_zwei //Wegen Multikollinearität umkodieren
	replace Ipartner_berufl_zwei2=4 if Ipartner_berufl_zwei==5
label values Ipartner_berufl_zwei2 Ipartner_berufl_zwei
	
generate Ipartner_work2=Ipartner_work //Wegen Multikollinearität umkodieren
	replace Ipartner_work2=6 if Ipartner_work2==7
label values Ipartner_work2 Ipartner_workM

generate partner_erwerb=.
	replace partner_erwerb=0 if Ipartner_work2==1 | Ipartner_work2==2 | Ipartner_work2==3
	replace partner_erwerb=1 if Ipartner_work2==4 | Ipartner_work2==5
	replace partner_erwerb=2 if Ipartner_work2==0
	replace partner_erwerb=3 if Ipartner_work2==6
	label values partner_erwerb partner_erwerb
	label variable partner_erwerb "Erwerbsstatus Partner, kurz"

generate Ipartner_work_AHbefr2=partner_work_AHbefr
	replace Ipartner_work_AHbefr2=5 if partner_work_AHbefr==6
label values Ipartner_work_AHbefr2 partner_work_AHbefrM
	
generate Ipartner_jobch_dum2=partner_jobch_dum
	replace Ipartner_jobch_dum2=2 if partner_jobch_dum==3
label values Ipartner_jobch_dum2 partner_jobch_dumM

generate Ipartner_bil2=Ipartner_bil
	recode Ipartner_bil2 (0=0)(1=0)(2=1)(3=2)(4=3)(5=3)
label values Ipartner_bil2 Ipartner_bilM_kurz 

generate Ipartner_alter2=partner_alter
	replace Ipartner_alter2=5 if partner_alter==6
label values Ipartner_alter2 Ipartner_alterM

save "${my_save_path}sample_schritt17.dta", replace
save "${my_save_path}sample_long.dta", replace


//**//////////////////////////////////////////////////////////////////////////**
** Schritt 18: Variablen für multivariate Analysen 
//**//////////////////////////////////////////////////////////////////////////**
********************************************************************************
* Schritt 18.1.: Arbeitslosigkeit
********************************************************************************
label define kum_arbeitslos_brose ///
	0 "[0] noch nie arbeitslos" ///
	1 "[1] Bis zu 16% arbeitslos" ///
	2 "[2] Mehr als 16% arbeitslos"

generate kum_arbeitslos_brose=.
	replace kum_arbeitslos_brose=1 if DGarbeitslos<=16
	replace kum_arbeitslos_brose=2 if DGarbeitslos>16
	replace kum_arbeitslos_brose=0 if DGarbeitslos==0
label values kum_arbeitslos_brose kum_arbeitslos_brose
tab kum_arbeitslos_brose

sum DGarbeitslos [aw=lbclgewicht] if Iwork>0 & welle>=1995, d
generate kum_arbeitslos=.
	replace kum_arbeitslos=1 if DGarbeitslos<=10
	replace kum_arbeitslos=2 if DGarbeitslos>10
	replace kum_arbeitslos=0 if DGarbeitslos==0
	replace kum_arbeitslos_=0 if Iwork==0
tab kum_arbeitslos

********************************************************************************
* Schritt 18.2.: Alter 
********************************************************************************
* Kategoriale Variable
label define kat_alter 1 "[1] 17-20 Jahre" 2 "[2] 21-25 Jahre" 3 "[3] 26-30 Jahre" ///
	4 "[4] 31-35 Jahre" 5 "[5] 36-42 Jahre"
	
generate kat_alter=alter
	recode kat_alter (15/20=1)(21/25=2)(26/30=3)(31/35=4)(36/45=5)
label variable kat_alter "Altersgruppen"
label values kat_alter kat_alter
tab kat_alter

* Alter zentrieren
// Achtung, Mittelwert nur von den Fällen berechnen, die auch in der Regression
// genutzt werden

summarize alter [aw=lbclgewicht] if lbclgewicht>0 & welle>=1995, d
generate calter=alter-r(mean) 
tab calter [aw=lbclgewicht]

generate calter2=calter^2

* Alter logarithmieren
generate ln_calter=ln(calter) //da man nicht 0 sein kann, muss ich auch nicht +1 rechnen

********************************************************************************
* Schritt 18.3.: Flag-Variablen
********************************************************************************
* Problem mit Flag-Variablen
/* flag_jobch und flag_befr gleichzeitig in Modell funktioniert nicht, nur wenn 
	ich flag_work raus nehme. Flag_work und flag_jobch sind quasi die gleichen
	Fälle. */

generate flag_work_jobch=0
	replace flag_work_jobch=1 if flag_work==1 | flag_jobch==1
tab flag_work_jobch

generate flag_work_jobch_befr=0
	replace flag_work_jobch_befr=1 if flag_work==1 | flag_jobch==1 | flag_befr==1
tab flag_work_jobch_befr

generate flag_work_befr=0
	replace flag_work_befr=1 if flag_work==1 | flag_befr==1
tab flag_work_befr

generate flag_jobch_befr=0
	replace flag_jobch_befr=1 if flag_jobch==1 | flag_befr==1
tab flag_jobch_befr


* Gesamtarbeitsmarkterfahrung alternative Flag-Variable
// Wenn ich Ausbildung, sollte nicht in flag auf 1 gesetzt werden
generate flag_gesamt2=flag_gesamt
	replace flag_gesamt2=0 if flag_gesamt==1 & Iwork==0

********************************************************************************
* Schritt 18.4.: Erwerbsstatus (Kurzform)
********************************************************************************
* Erwerbsstatus vereinfacht
label define erwerb ///
	0 "[0] Erwerbstätig" ///
	1 "[1] Arbeitslos, nicht erwerbstätig" ///
	2 "[2] in Ausbildung"
	
generate erwerb=0 if Iwork==1  | Iwork==2 | Iwork==3
	replace erwerb=1 if Iwork==4 | Iwork==5
	replace erwerb=2 if Iwork==0
label values erwerb erwerb
tab erwerb

********************************************************************************
* Schritt 18.5.: Partnerschaftsstatus
********************************************************************************
label define ehevsnel 0 "[0] Nichteheliche Lebensgemeinschaft" 1 "[1] Ehe" 

generate ehevsnel=.
	replace ehevsnel=0 if Irelpar==2
	replace ehevsnel=1 if Irelpar==3
label values ehevsnel ehevsnel
tab ehevsnel

********************************************************************************
* Schritt 18.6.: Partnercharakteristika
********************************************************************************
generate partner_jobch_dummy=0
	replace partner_jobch_dummy=1 if partner_jobch_dum==1
	
generate Irelpar_ehe=0
	replace Irelpar_ehe=1 if Irelpar==3
	
generate Irelpar_nel=0
	replace Irelpar_nel=1 if Irelpar==2


********************************************************************************
* Schritt 18.7.: Hilfsvariablen Arbeitsmarkt operationalisieren
********************************************************************************
* Dummy Ausbildung (benötigt für metrische Variablen in Modellen)
recode Iwork (0=1 "[1] in Ausbildung")(else=0 "[0] nicht in Ausbildung"), generate(dummy_ausbildung)
label variable dummy_ausbildung "In Ausbildung"
tab dummy_ausbildung

* Dummy Arbeitslos/N.e. (benötigt für metrische Variablen in Modellen)
recode Iwork (4=1 "Arbeitslos/N.e.")(5=1)(else=0 "[0] Alles andere"), generate(dummy_arbeitslos)
label variable dummy_arbeitslos "Arbeitslos oder nicht Erwerbstätig"
tab dummy_arbeitslos

* Geringfügig beschäftigt
generate dummy_gering=0
	replace dummy_gering=1 if Iwork==3
label variable dummy_gering "Geringfügig, unregelmäßig beschäftigt"
tab dummy_gering

* Stundenzahl/Teilzeit
// nur über die Stundenzahl definieren, nicht über Iwork
generate stunden_35=0
	replace stunden_35=1 if Ivebzeit<35 & Iwork>0
	
generate stunden_32=0
	replace stunden_32=1 if Ivebzeit<32 & Iwork>0
	
label define teilzeit ///
	0 "[0] 32 und mehr Stunden" ///
	1 "[1] 24-31 Stunden" ///
	2 "[2] Bis zu 23 Stunden"
	
generate teilzeit=0 //Tnz muss durch Erwerbsstatus-Variable kontrolliert werden
	replace teilzeit=1 if Ivebzeit>23 & Ivebzeit<32 & Iwork>0 & Iwork<4
	replace teilzeit=2 if Ivebzeit<24 & Iwork>0 & Iwork<4
label values teilzeit teilzeit
tab teilzeit
	
generate ln_Ivebzeit=Ivebzeit+1
	replace ln_Ivebzeit=ln(ln_Ivebzeit)
	
generate qu_Ivebzeit=Ivebzeit^2

********************************************************************************
* Schritt 18.8.: Subjektive Variablen
********************************************************************************
generate Isorgen_a2=Isorgen_a
	replace Isorgen_a2=3 if flag_sorgen_a==1
	label values Isorgen_a2 qp11810 
tab Isorgen_a2

generate Isorgen_ew2=Isorgen_ew
	replace Isorgen_ew2=3 if flag_sorgen_ew==1
	label values Isorgen_ew2 qp11802  
tab Isorgen_ew2 //Nur "keine Sorgen" eingesetzt für Missings

generate flag_sorgen_ew2=flag_sorgen_ew
	//damit mein Loop später funktioniert
	
	
save "${my_save_path}sample_schritt18.dta", replace
save "${my_save_path}sample_long.dta", replace

//**//////////////////////////////////////////////////////////////////////////**
** Schritt 19: Prekäre Erwerbsarbeit
//**//////////////////////////////////////////////////////////////////////////**
********************************************************************************
* Schritt 19.1.: Prekarität
********************************************************************************
/* 	Variable "+1", wenn eine der folgenden Eigenschaften auftritt:
	- Befristung
	- weniger als 35h/Woche
	- Niedriglohn/Armutsgrenze: HH-Einkommen und Bruttostundenlohn im 1. Quartil
	- Leiharbeit/Zeitarbeit (ohne imputierte Werte)
	- geringfügig beschäftigt
  Arbeitslosigkeit nicht mehr dazu, da keine Erwerbstätigkeit
*/

* Um 1. Befragung im meinem Beobachtungsfenster zu definieren
bysort persnr (welle): generate help_n1995=_n

*****************************************
* 19.1.1. Definition Prekarität 
*****************************************
* Für jeder Version/Idee von Prekarität generiere ich eine Variable
local prekaer7="Iwork>0 & (Iwork==3|Hbefr==1|(Ivebzeit<32 & Iwork>0 & Iwork<4)|(Azeit==1 & flag_zeitarbeit==0)|Qincome9012==1| (Qbruttoe==1 & Iwork>0 & Iwork<4))"
	// entspricht einer Abwandlung von prekaer4
	// Bruttostundenlohn, nur wenn erwerb==0; andere Variable für Bruttostundenlohn
local prekaer8="Iwork>0 & (Hbefr==1|(Ivebzeit<32 & Iwork>0 & Iwork<4)| Qincome9012==1| (Qbruttoe==1 & Iwork>0 & Iwork<4))"
	// Nur Befristung, Teilzeit, niedriges Einkommen: Diese Einzelvariablen signifikanten Effekt + Niedriglohn (auch leicht signifikant)
local prekaer9="Iwork>0 & (Iwork==3|Hbefr==1|(Azeit==1 & flag_zeitarbeit==0)|Qincome9012==1| (Qbruttoe==1 & Iwork>0 & Iwork<4))"
	// Ohne Teilzeit für Analysen zur Geburt des zweiten Kindes


foreach zahl of numlist 7/9 {
	generate help_prekaer`zahl'=0
		replace help_prekaer`zahl'=1 if `prekaer7' & `zahl'==7
		replace help_prekaer`zahl'=1 if `prekaer8' & `zahl'==8
		replace help_prekaer`zahl'=1 if `prekaer9' & `zahl'==9
	tab help_prekaer`zahl'	
}

		
* Dummy, erste Beobachtung bereits prekär
// Kontrolle für Linkszensierung und mögliche Unterschätzung der Dauer der Prekarität
foreach zahl of numlist 7/9 {
	generate firstprekaer`zahl'=0
		replace firstprekaer`zahl'=1 if help_prekaer`zahl'==1 & help_n1995==1
	tab firstprekaer`zahl'
}

* Aufstieg innerhalb Prekarität: Von Arbeitslosigkeit zu andere Form
//nur wenige Fälle
foreach zahl of numlist 7/9 {
	generate aufstieg_prekaer`zahl'=0
		bysort persnr (welle): replace aufstieg_prekaer`zahl'=1 if (Iwork[_n-1]==4 | Iwork[_n-1]==5) /*
			*/ & Iwork>0 & Iwork<4 & help_prekaer`zahl'==1
		//derzeit noch prekär, aber vorher arbeitslos bzw. nicht erwerbstätig
	label variable aufstieg_prekaer`zahl' "Vorher arbeitslos/n.e., jetzt prekär beschäftigt"
	tab aufstieg_prekaer`zahl'	
} 


*****************************************
* 19.1.2. Dauer aktuelle Prekarität 
*****************************************
* Metrische Variablen
foreach zahl of numlist 7/9 {
	generate dauer_prekaer`zahl'=0
	bysort persnr (welle): replace dauer_prekaer`zahl'=1 if help_prekaer`zahl'==1 & (erstbefr==welle | help_n1995==1)
	bysort persnr (welle): replace dauer_prekaer`zahl'=dauer_prekaer`zahl'[_n-1] + 1 if help_prekaer`zahl'==1 & help_n1995>1
label variable dauer_prekaer`zahl' "Dauer aktuelle Prekarität"
tab dauer_prekaer`zahl'

generate ln_dauer_prekaer`zahl'=dauer_prekaer`zahl'+1
	replace ln_dauer_prekaer`zahl'=ln(ln_dauer_prekaer`zahl')
	
generate qu_dauer_prekaer`zahl'=dauer_prekaer`zahl'^2

}

* kategoriale Variablen
label define dauer_prekaer ///
	0 "[0] NAV" ///
	1 "[1] 1 Jahr" ///
	2 "[2] 2 Jahre" ///
	3 "[3] 3 Jahre" ///
	4 "[4] 4 Jahre" ///
	5 "[5] > 5 Jahre" 

foreach zahl of numlist 7/9 {
generate dauer_prekaerK`zahl'=0 if Iwork==0 //Muss kontrolliert werden durch Erwerbsstatus-Variable
	replace dauer_prekaerK`zahl'=0 if dauer_prekaer`zahl'==0 & Iwork!=0
	replace dauer_prekaerK`zahl'=1 if dauer_prekaer`zahl'==1
	replace dauer_prekaerK`zahl'=2 if dauer_prekaer`zahl'==2
	replace dauer_prekaerK`zahl'=3 if dauer_prekaer`zahl'==3
	replace dauer_prekaerK`zahl'=4 if dauer_prekaer`zahl'==4
	replace dauer_prekaerK`zahl'=5 if dauer_prekaer`zahl'>=5 & !missing(dauer_prekaer`zahl')
label variable dauer_prekaerK`zahl' "Dauer aktuelle Prekarität, kategorial"
label values dauer_prekaerK`zahl' dauer_prekaer
tab dauer_prekaerK`zahl'
}


********************************************************************************
* Schritt 19.2.: Dauer aktueller Prekaritätsstatus Einzelindikatoren
********************************************************************************
label define dauer ///
	0 "[0] nicht betroffen" ///
	1 "[1] 1 Jahr" ///
	2 "[2] 2 Jahre" ///
	3 "[3] 3 + Jahre"
	
label define dauer4 ///
	0 "[0] nicht betroffen" ///
	1 "[1] 1 Jahr" ///
	2 "[2] 2 Jahre" ///
	3 "[3] 3 Jahre" ///
	4 "[4] 4+ Jahre"

* Zeitarbeit
generate dauer_zeitarbeit=0
	bysort persnr (welle): replace dauer_zeitarbeit=1 if Azeit==1 & (erstbefr==welle | help_n1995==1)
	bysort persnr (welle): replace dauer_zeitarbeit=dauer_zeitarbeit[_n-1] + 1 if Azeit==1  & help_n1995>1
label variable dauer_zeitarbeit "Dauer aktuelle Zeitarbeitsphase"
tab dauer_zeitarbeit

recode dauer_zeitarbeit (0=0)(1=1)(2=2)(3=3)(4/max=3), generate(dauer_zeitarbeitK)
label values dauer_zeitarbeitK dauer
tab dauer_zeitarbeitK

generate ln_dauer_zeitarbeit=dauer_zeitarbeit+1
	replace ln_dauer_zeitarbeit=ln(ln_dauer_zeitarbeit)
	
generate qu_dauer_zeitarbeit=dauer_zeitarbeit^2

* Befristung
//ln_ und qu_ bereits in Schritt 13 generiert
tab Tbefr

recode Tbefr (0=0)(1=1)(2=2)(3=3)(4/max=3), generate(dauer_befrK)
	label values dauer_befrK dauer
tab dauer_befrK
	

* Geringfügig
generate dauer_gering=0
	bysort persnr (welle): replace dauer_gering=1 if dummy_gering==1 & (erstbefr==welle | help_n1995==1)
	bysort persnr (welle): replace dauer_gering=dauer_gering[_n-1] + 1 if dummy_gering==1  & help_n1995>1
label variable dauer_gering "Dauer aktuelle geringfügige/unregelmäßige Beschäftigung"
tab dauer_gering

generate ln_dauer_gering=dauer_gering+1
	replace ln_dauer_gering=ln(ln_dauer_gering)
	
generate qu_dauer_gering=dauer_gering^2

recode dauer_gering (0=0)(1=1)(2=2)(3=3)(4/max=3), generate(dauer_geringK)
	label values dauer_geringK dauer
tab dauer_geringK

recode dauer_gering (0=0)(1=1)(2=2)(3/max=2), generate(dauer_geringKK)
tab dauer_geringKK


* HH-Einkommen
generate dauer_hh=0
	bysort persnr (welle): replace dauer_hh=1 if Qincome9512==1 & (erstbefr==welle | help_n1995==1)
	bysort persnr (welle): replace dauer_hh=dauer_hh[_n-1] + 1 if Qincome9512==1  & help_n1995>1
label variable dauer_hh "Dauer aktuell 1. Quartil HH-NettoÄquivalenzeinkommen"
tab dauer_hh

generate ln_dauer_hh=dauer_hh+1
	replace ln_dauer_hh=ln(ln_dauer_hh)
	
generate qu_dauer_hh=dauer_hh^2

recode dauer_hh (0=0)(1=1)(2=2)(3=3)(4/max=3), generate(dauer_hhK)
	label values dauer_hhK dauer
tab dauer_hhK

* Niedriges Bruttoeinkommen
generate dauer_brutto=0
	bysort persnr (welle): replace dauer_brutto=1 if Qbrutto==1 & (erstbefr==welle | help_n1995==1)
	bysort persnr (welle): replace dauer_brutto=dauer_brutto[_n-1] + 1 if Qbrutto==1  & help_n1995>1
label variable dauer_brutto "Dauer aktuell 1. Quartil Bruttomonatslohn"
tab dauer_brutto

generate ln_dauer_brutto=dauer_brutto+1
	replace ln_dauer_brutto=ln(ln_dauer_brutto)
	
generate qu_dauer_brutto=dauer_brutto^2

recode dauer_brutto (0=0)(1=1)(2=2)(3=3)(4/max=4), generate(dauer_bruttoK)
	label values dauer_bruttoK dauer4
tab dauer_bruttoK

* Niedriglohn
generate dauer_bruttoe=0
	bysort persnr (welle): replace dauer_bruttoe=1 if Qbruttoe==1 & (erstbefr==welle | help_n1995==1)
	bysort persnr (welle): replace dauer_bruttoe=dauer_bruttoe[_n-1] + 1 if Qbruttoe==1  & help_n1995>1
label variable dauer_bruttoe "Dauer aktuell 1. Quartil Bruttostundenlohn"
tab dauer_bruttoe

generate ln_dauer_bruttoe=dauer_bruttoe+1
	replace ln_dauer_bruttoe=ln(ln_dauer_bruttoe)
	
generate qu_dauer_bruttoe=dauer_bruttoe^2

recode dauer_bruttoe (0=0)(1=1)(2=2)(3=3)(4/max=4), generate(dauer_bruttoeK)
	label values dauer_bruttoeK dauer4
tab dauer_bruttoeK



* Teilzeit
// neu generiert, nur für Erwerbstätige
generate dauer_teilzeit=0
	bysort persnr (welle): replace dauer_teilzeit=1 if Ivebzeit<32 & Iwork>0 & Iwork<4 & (erstbefr==welle | help_n1995==1)
	bysort persnr (welle): replace dauer_teilzeit=dauer_teilzeit[_n-1] + 1 if Ivebzeit<32 & Iwork>0 & Iwork<4 & help_n1995>1
label variable dauer_teilzeit "Dauer aktuelle Teilzeitphase"
tab dauer_teilzeit Iwork


generate ln_dauer_teilzeit=dauer_teilzeit+1
	replace ln_dauer_teilzeit=ln(ln_dauer_teilzeit)
	
generate qu_dauer_teilzeit=dauer_teilzeit^2

recode dauer_teilzeit (0=0)(1=1)(2=2)(3=3)(4/max=3), generate(dauer_teilzeitK)
	label values dauer_teilzeitK dauer
tab dauer_teilzeitK Iwork


label define work_dauer_teilzeit ///
	0 "[0] Mehr als 32 Stunden" ///
	1 "[1] 1 Jahr in Teilzeit" ///
	2 "[2] 2 Jahre" ///
	3 "[3] 3+ Jahre" ///
	4 "[4] in Ausbildung" ///
	5 "[5] Arbeitslos, nicht erwerbstätig"
	
generate work_dauer_teilzeit=.
	replace work_dauer_teilzeit=0 if teilzeit==0
	replace work_dauer_teilzeit=1 if dauer_teilzeit==1
	replace work_dauer_teilzeit=2 if dauer_teilzeit==2
	replace work_dauer_teilzeit=3 if dauer_teilzeit>=3 & !missing(dauer_teilzeit)
	replace work_dauer_teilzeit=4 if Iwork==0
	replace work_dauer_teilzeit=5 if Iwork==4 | Iwork==5
label values work_dauer_teilzeit work_dauer_teilzeit
tab work_dauer_teilzeit

save "${my_save_path}sample_schritt19.dta", replace
save "${my_save_path}sample_long.dta", replace


//**//////////////////////////////////////////////////////////////////////////**
** Schritt 20: Variablen Partnerschaft
//**//////////////////////////////////////////////////////////////////////////**
********************************************************************************
* Schritt 20.1.: Variablen generieren
********************************************************************************
*****************************************
* 20.1.1. Dauer der Beziehung
*****************************************
tab1 Kbeziehung Kbeziehung_hh Kehe Knel
sum beziehung beziehung_hh ln_beziehung ehe nel ln_ehe ln_nel ln_beziehung_hh LatvorNel ln_LatvorNel LatvorEhe NelvorEhe

* Dauer aktuelle Beziehung
// Multikollinearität für "kein Partner"
generate KbeziehungM=Kbeziehung
	replace KbeziehungM=3 if Kbeziehung==0
label values KbeziehungM Kbeziehung
tab KbeziehungM

** Dauer Lat der aktuellen Beziehung
generate lat=.
	replace lat=LatvorNel if LatvorNel!=. & LatvorNel>0
	replace lat=LatvorEhe if LatvorEhe!=. & LatvorEhe>0
	replace lat=beziehung if beziehung!=. & beziehung>0 & Irelpar==1
	replace lat=0 if Irelpar==0 //kein Partner
	replace lat=0 if missing(lat) //In Partnerschaft ohne Wissen um LAT-Dauer
tab lat

** Dauer Nel der aktuellen Beziehung
generate nel_relation=beziehung_hh if Irelpar==2
	replace nel_relation=beziehung_hh-ehe if Irelpar==3
	replace nel_relation=0 if missing(nel_relation)
tab nel_relation

save "${my_save_path}sample_schritt20.dta", replace
save "${my_save_path}sample_long.dta", replace


//**//////////////////////////////////////////////////////////////////////////**
** Schritt 21: Familienerweiterung
//**//////////////////////////////////////////////////////////////////////////**	
/* Übersicht:
	In familienerweiterung_aufbereitung
		Schritt 21.1. Vorarbeiten: "Leere" und unnötige Wellen entfernen, Hilfsvariablen
	In familienerweiterung_aufbereitung_teilII
		Schritt 21.2. Aus DO-FILE "Diss-Analyse" (Schritt 11-20)
	In familienerweiterung_variablen
		Schritt 21.3. Wichtige Einschränkungen am Sample
		Schritt 21.4. Hazard Baseline für Familienerweiterung
		Schritt 21.5. Längsschnittgewicht für die Zeit ab der Geburt des 1. Kindes
		Schritt 21.6. Benötigte Variablen allgemein
		Schritt 21.7. Benötigte Variablen Prekarität
*/

do familienerweiterung_aufbereitung151026_aufgeraeumt

do familienerweiterung_aufbereitung_teilII_160212_aufgeraeumt
save "${my_save_path}sample_zweites_aufbereitet.dta", replace
save "${my_save_path}sample_zweites.dta", replace
	
do familienerweiterung_variablen160311_aufgeraeumt
save "${my_save_path}sample_zweites.dta", replace

	
//**//////////////////////////////////////////////////////////////////////////**
** Schritt 22: Finale Analysen Dissertationsmanuskript
//**//////////////////////////////////////////////////////////////////////////**
* Hilfe zu Putexcel: http://www.stata.com/manuals14/pputexceladvanced.pdf

use "${my_save_path}sample_long.dta", clear

*** Fallzahlen gesamt
tab mutter
tab mutter [aw=lbclgewicht]

tab nummerierung
tab nummerierung if lbclgewicht!=0 //Zahl der Frauen, die in Analyse eingehen

	* Nur Ehen
	tab mutter [aw=lbclgewicht] if Irelpar==3
	tab nummerierung if lbclgewicht!=0 & Irelpar==3 //Zahl der Frauen, die in Analyse eingehen

	* Nur Nel
	tab mutter [aw=lbclgewicht] if Irelpar==2
	tab nummerierung if lbclgewicht!=0 & Irelpar==2 //Zahl der Frauen, die in Analyse eingehen
	
	* Lat, Ehe und Nel zusammen für Kapitel 6
	tab mutter [aw=lbclgewicht] if Irelpar>0
	tab nummerierung if lbclgewicht!=0 & Irelpar>0 //Zahl der Frauen, die in Analyse eingehen


* Anteil NEL an Geburten
tab Irelpar mutter if west==1, row col //Westdeutschland
tab Irelpar mutter if west==0, row col //Ostdeutschland

tab Irelpar mutter if west==1 [aw=lbclgewicht], row col //Westdeutschland
tab Irelpar mutter if west==0 [aw=lbclgewicht], row col //Ostdeutschland

* Selbstständige 
tab selfemp Iwork [aw=lbclgewicht] 
tab selfemp erwerb [aw=lbclgewicht] 

tab mutter selfemp [aw=lbclgewicht], row col
tab nummerierung if lbclgewicht!=0 & selfemp==1


* Durchschnittliche Dauer von Arbeitslosigkeit?
// Darüber kann ich nicht legitimieren, weshalb ich die Operationalisierung von Brose verwendet habe
sum DGarbeitslos if kum_arbeitslos_brose >0 & welle>=1995 [aw=lbclgewicht], d



********************************************************************************
* Schritt 22.1.: Komposition der Stichproben (1. und 2. Kind)
********************************************************************************
do komposition_stichproben

		
********************************************************************************
* Schritt 22.2.: Kapitel 6 Partnerschaften
********************************************************************************
use "${my_save_path}sample_long.dta", clear
	
do multi_partnerschaft161103 //Geburt des ersten Kindes
* multi_partnerschaft160310 //Abgabeversion

********************************************************************************
* Schritt 22.3.: Kapitel 7 Befristung
********************************************************************************

tab Hbefr if erwerb==0 [aw=lbclgewicht]
	tab Hbefr if erwerb==0 
	
tab mutter Kbefr_kurz [aweight=lbclgewicht] if Isorgen_a==1 & welle>=1995, row col
tab mutter Kbefr_kurz [aweight=lbclgewicht] if Isorgen_a==2 & welle>=1995, row col
tab mutter Kbefr_kurz [aweight=lbclgewicht] if Isorgen_a==3 & welle>=1995, row col


	
*****************************************
* 22.3.1. Multivariate Analysen
*****************************************
do multi_befristung161103
* Abgabeversion: multi_befristung160315

********************************************************************************
* Schritt 22.4.: Kapitel 8 Prekarität: Einzelvariablen
********************************************************************************
label define erwerb_teilzeit_erstes ///
	0 "[0] 32 und mehr Stunden" ///
	1 "[1] 24-31 Stunden" ///
	2 "[2] Bis zu 23 Stunden" ///
	3 "[3] Arbeitslos, nicht erwerbstätig" ///
	4 "[4] in Ausbildung"
	
generate erwerb_teilzeit_erstes=.
	replace erwerb_teilzeit_erstes=0 if teilzeit==0
	replace erwerb_teilzeit_erstes=1 if teilzeit==1
	replace erwerb_teilzeit_erstes=2 if teilzeit==2
	replace erwerb_teilzeit_erstes=3 if Iwork==4 | Iwork==5
	replace erwerb_teilzeit_erstes=4 if Iwork==0
	label values erwerb_teilzeit_erstes erwerb_teilzeit_erstes
tab erwerb_teilzeit_erstes

save "${my_save_path}sample_long.dta", replace

do multi_prekaer160202 // Erstes Kind

********************************************************************************
* Schritt 22.4.(b): Kapitel 8 Prekarität: Prekaritätsvariable
********************************************************************************
do multi_prekaritaetsvariable161102 // Erstes Kind
* do multi_prekaritaetsvariable160311 //Abgabeversion
	
********************************************************************************
* Schritt 22.5. (a) + (b): Zu allen Kapiteln - die Geburt des zweiten Kindes
********************************************************************************
estimates clear //gespeicherte Ergebnisse löschen, da Speicher sonst voll läuft (max. 300)

use "${my_save_path}sample_zweites.dta", clear

do multi_zweiteskind161103 //Kapitel 6, Abgabeversion: multi_zweiteskind160311

do multi_zweiteskind_einzelvariablen160310 // Kapitel 8: Einzelvariablen
do multi_zweiteskind_prekaer160616_angepasst // Kapitel 8: Prekaritätsvariable

* Fallzahlen
// nur NEL/Verheiratet
tab zweitesKind if (Irelpar==2 | Irelpar==3) & welle<2012 & partner_erwerb_zwo<3 [aw=lbclgewichtFE]
tab nummerierung if (Irelpar==2 | Irelpar==3) & welle<2012 & partner_erwerb_zwo<3 & lbclgewichtFE!=0 //Zahl der Frauen, die in Analyse eingehen


* Selbstständige 
tab selfemp Iwork [aw=lbclgewichtFE] if welle<2012 & partner_erwerb_zwo<3
tab selfemp erwerb [aw=lbclgewichtFE] if welle<2012 & partner_erwerb_zwo<3

tab zweitesKind selfemp [aw=lbclgewichtFE] if welle<2012 & partner_erwerb_zwo<3, row col
tab nummerierung if lbclgewichtFE!=0 & selfemp==1 & welle<2012 & partner_erwerb_zwo<3


tab dauer_prekaerK7 jobch_dum if  welle<2012 & partner_erwerb_zwo<3 & erwerb==0 [aw=lbclgewichtFE], row col
tab dauer_prekaerK7 kum_arbeitslos_brose if  welle<2012 & partner_erwerb_zwo<3 & erwerb==0 & AKDGarbeitslos<6 [aw=lbclgewichtFE], row col

tab dauer_prekaerK7_zweites jobch_dum if  welle<2012 & partner_erwerb_zwo<3 & erwerb==0 [aw=lbclgewichtFE], row col
tab dauer_prekaerK7_zweites kum_arbeitslos_brose if  welle<2012 & partner_erwerb_zwo<3 & erwerb==0 & AKDGarbeitslos<6 [aw=lbclgewichtFE], row col


*  Zusammenhang Prekarität und Jobwechsel
// nur Erwerbstätige
tab dauer_prekaerK7 jobch_dum [aw=lbclgewichtFE] if welle>=1995 & welle<2012 & partner_erwerb_zwo<3 & erwerb==0 & AKDGarbeitslos<6, row col

*  Zusammenhang Prekarität und Arbeitslosigkeitserfahrung
// nur Erwerbstätige
tab dauer_prekaerK7 kum_arbeitslos_brose [aw=lbclgewichtFE] if welle>=1995 & welle<2012 & partner_erwerb_zwo<3 & erwerb==0 & AKDGarbeitslos<6, row col
	

	
//**//////////////////////////////////////////////////////////////////////////**
** Schritt 23: Unicode-Umwandlung Stata 14
//**//////////////////////////////////////////////////////////////////////////**
/* Für Version 14	
cd "C:\Stata_Datensaetze\" / cd "\\mpifg\dfs\home\ann\Documents\Promotion\Analyse SOEP\Do-Files"

unicode analyze name.dta/do

unicode encoding set latin1
unicode translate name.dta/do
 	
*/
