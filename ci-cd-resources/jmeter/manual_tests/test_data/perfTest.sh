# echo '******************run 1**************'
# ruby gtd.rb --ntrapi $1
# ruby gtd.rb --upldntrapibody
# echo '******************run 2**************'
# ruby gtd.rb --ntrapi $1
# ruby gtd.rb --upldntrapibody
# echo '******************run 3**************'
# ruby gtd.rb --ntrapi $1
# ruby gtd.rb --upldntrapibody

# ruby gtd.rb -f CAZ-2020-01-02-Birmingham-10000 --ntrcsv 0,10000
# ruby gtd.rb -f CAZ-2020-01-02-Leeds-10000 --ntrcsv 0,10000

# ruby gtd.rb --upldntr CAZ-2020-01-02-Birmingham-10000.csv

# ruby gtd.rb -f CAZ-2020-01-02-Leeds-100000.csv -la Leeds --ntrcsv 0,100000
ruby ../../gtd.rb -f CAZ-2020-01-01-TorridgeDistrictCouncil-10000.csv -l TorridgeDistrictCouncil --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-WestLindseyDistrictCouncil-10000.csv -l WestLindseyDistrictCouncil --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-TunbridgeWellsBoroughCouncil-10000.csv -l TunbridgeWellsBoroughCouncil --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-WestOxfordshireDistrictCouncil-10000.csv -l WestOxfordshireDistrictCouncil --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-UttlesfordDistrictCouncil-10000.csv -l UttlesfordDistrictCouncil --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-WestSuffolkCouncil-10000.csv -l WestSuffolkCouncil --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-ValeofWhiteHorseDistrictCouncil-10000.csv -l ValeofWhiteHorseDistrictCouncil --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-WinchesterCityCouncil-10000.csv -l WinchesterCityCouncil --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-WarwickDistrictCouncil-10000.csv -l WarwickDistrictCouncil --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-WokingBoroughCouncil-10000.csv -l WokingBoroughCouncil --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-WatfordBoroughCouncil-10000.csv -l WatfordBoroughCouncil --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-WorcesterCityCouncil-10000.csv -l WorcesterCityCouncil --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-WaverleyBoroughCouncil-10000.csv -l WaverleyBoroughCouncil --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-WorthingBoroughCouncil-10000.csv -l WorthingBoroughCouncil --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-WealdenDistrictCouncil-10000.csv -l WealdenDistrictCouncil --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-WychavonDistrictCouncil-10000.csv -l WychavonDistrictCouncil --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-WellingboroughBoroughCouncil-10000.csv -l WellingboroughBoroughCouncil --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-WycombeDistrictCouncil-10000.csv -l WycombeDistrictCouncil --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-WelwynHatfieldBoroughCouncil-10000.csv -l WelwynHatfieldBoroughCouncil --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-WyreBoroughCouncil-10000.csv -l WyreBoroughCouncil --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-WestDevonDistrictCouncil-10000.csv -l WestDevonDistrictCouncil --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-WyreForestDistrictCouncil-10000.csv -l WyreForestDistrictCouncil --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-Council1-10000.csv -l Council1 --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-Council2-10000.csv -l Council2 --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-Council3-10000.csv -l Council3 --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-Council4-10000.csv -l Council4 --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-Council5-10000.csv -l Council5 --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-Leeds-10000.csv -l Leeds --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-Birmingham-10000.csv -l Birmingham --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-Cambridge-10000.csv -l Cambridge --ntrcsv 0,10000
ruby ../../gtd.rb -f CAZ-2020-01-01-London-10000.csv -l London --ntrcsv 0,10000

# echo '******************run 1**************'
# ruby gtd.rb --ntrcsv 0,$1
# ruby gtd.rb --upldntr $2
# echo '******************run 3**************'
# ruby gtd.rb --ntrcsv 0,$1
# ruby gtd.rb --upldntr CAZ-2020-01-08-100-5.csv
# echo '******************run 4**************'
# ruby gtd.rb --ntrcsv 0,$2
# ruby gtd.rb --upldntr CAZ-2020-01-08-100-5.csv
# echo '******************run 5**************'
# ruby gtd.rb --ntrcsv 0,$2
# ruby gtd.rb --upldntr CAZ-2020-01-08-100-5.csv
# echo '******************run 6**************'
# ruby gtd.rb --ntrcsv 0,$2
# ruby gtd.rb --upldntr CAZ-2020-01-08-100-5.csv
