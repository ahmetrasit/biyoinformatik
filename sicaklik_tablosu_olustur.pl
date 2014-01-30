# Ahmet R Ozturk - biyoinformatiktr.blogspot.com
# 3 ile ait son bir yıllık hava durumu bilgisi, saatlik hava sıcaklıkları
# sicaklik_kaydet.pl programı çalıştırıldıktan sonra bu program çalıştırılmalıdır.
# sicaklik_kaydet.pl ile ayni klasorde yer almalıdır
# Komut ekranında veya terminalde alttaki ifadeleri yazıp, Enter'a basın:
# perl sicaklik_tablosu_olustur.pl

use strict;

use LWP::Simple;

my %sehirler = (
'17060'=>'Istanbul',
'17128'=>'Ankara',
'17195'=>'Kayseri');




my @liste = sort keys %sehirler;





foreach my $sehirKodu (@liste) {

	my %saatler;
	my %kayitlar;

	next if ($sehirKodu =~ /^$/);
	my $zaman = time();
	
	chdir("./$sehirKodu") or print "klasore gecilemiyor: $!\n";
	

	my @gunler = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
	for (my $yil=2013; $yil=<2013; $yil++){
		for (my $ay=1; $ay<13; $ay++){
			for (my $gun=1; $gun<=$gunler[$ay-1]; $gun++){

				my $dosya = "$sehirKodu\_$yil\_$ay\_$gun";
				open(RD, $dosya) or print ">>$dosya acilamiyor: $!\n";
				while(<RD>){
					next if (/^\s*$/);
					my ($saat, $temp) = split(/,/);
					my ($birinci, $ikinci) = $saat =~ /^(\d+:\d+)\s+(\w\w)/;
					my ($sa_, $dk_) = split(/\:/, $birinci);
					$sa_ = $sa_ + 12 if ($ikinci =~ /PM/ and $sa_ < 12);
					$saat = "$sa_:$dk_";
					$saatler{$saat}++;
					$kayitlar{"$sehirKodu\_$yil\_$ay\_$gun\_$saat"} = $temp if ($temp > -50);
				}
				
				
			}
		}
	}
	
	
	chdir("../") or print "ust klasore gecilemiyor: $!\n";
	
	open(WR, ">$sehirKodu\_$sehirler{$sehirKodu}\_kayitlar.txt") or print ">>Yazma hatasi: $sehirKodu  $!\n";
	my @saatler = sort keys %saatler;
	unshift @saatler, "DATE";
	$saatler{"DATE"} = 4000;
		
	foreach my $saat(@saatler){
		next if ($saatler{$saat} < 4000);
		next if ($saat =~ /^(Time)|(No)/);
		next if ($saat =~ /^:$/);
		print WR "$saat";
		my @gunler = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
		for (my $yil=2013; $yil=<2013; $yil++){
			for (my $ay=1; $ay<13; $ay++){
				for (my $gun=1; $gun<=$gunler[$ay-1]; $gun++){
					if ($saat =~ /^DATE$/){
						print WR "\t" . "$yil-$ay-$gun";
					}else {
						print WR "\t" . $kayitlar{"$sehirKodu\_$yil\_$ay\_$gun\_$saat"};
					}
				}
			}
		}
		print WR "\n";
	}
	close WR;
	
	print ">BITTI:\t$count\t$sehirKodu\t" . (time() - $zaman) . " saniye surdu.\n\n";
}


