# Ahmet R Ozturk - biyoinformatiktr.blogspot.com
# 3 ile ait son bir yıllık hava durumu bilgisi, saatlik hava sıcaklıkları
# Komut ekranında veya terminalde alttaki ifadeleri yazıp, Enter'a basın:
# perl sicaklik_kaydet.pl
use strict;

use LWP::Simple;

my @liste = ('17128', '17060', '17195');	#Ankara, İstanbul, Kayseri


foreach my $sehirKodu (@liste) {
	print ">BASLIYOR: $sehirKodu\n";
	mkdir("./$sehirKodu") or print "klasor olusturulamadı: $!\n";
	chdir("./$sehirKodu") or print "klasore gecilemedi: $!\n";
	
	
	my @gunler = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
	for (my $yil=2013; $yil=<2013; $yil++){
		print "$yil\n";
		for (my $ay=1; $ay<13; $ay++){
			print "$ay\n";
			for (my $gun=1; $gun<=$gunler[$ay-1]; $gun++){
				my $url = "http://www.wunderground.com/history/station/$sehirKodu/$yil/$ay/$gun/DailyHistory.html?format=1";
				my $dosya = "$sehirKodu\_$yil\_$ay\_$gun";
				
				my $sonuc = getstore($url, $dosya);
				while($sonuc ne 200){
					sleep(2);
					print ">$sonuc\n";
					$sonuc = getstore($url, $dosya);
				}
				print "$sehirKodu\_$yil\_$ay\_$gun\n";
				
			}
		}
	}
	
	
	chdir("../") or print "bir ust klasore gecilemiyor: $!\n";
	print ">BITTI: $sehirKodu";
}


