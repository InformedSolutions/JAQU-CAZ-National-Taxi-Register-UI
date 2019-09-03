require "csv"

#turns off warning
$VERBOSE = nil


@@FILE_NAME= 'CAZ-2020-01-08-100-1.csv'
@@NUM_OF_ROWS=10000

def create_csv(num_of_rows=@@NUM_OF_ROWS)
    puts 'Generating csv with: ' + num_of_rows.to_s + ' rows'
    CSV.open(@@FILE_NAME, "wb") do |csv|
        upperAlphabetArray = ('A'..'Z').to_a
        lowerAlphabetArray = ('a'..'z').to_a
        numbersArray = ('1'..'9').to_a
        for i in 1..num_of_rows do
            vrnp1 = upperAlphabetArray.shuffle[0,2].join
            vrnp2 = numbersArray.shuffle[0,2].join
            vrnp3 = upperAlphabetArray.shuffle[0,3].join
            reg1 = lowerAlphabetArray.shuffle[0,2].join
            reg2 = upperAlphabetArray.shuffle[0,3].join
            vehicleType = ['taxi','PHV'].sample
            caz = ['Leeds','Birmingham'].sample
            isWheelchairAccessible = ['true','false'].sample
            licenseStartDate = rand(Date.civil(1885, 01, 01)..Date.civil(2100, 12, 30))
            licenseEndDate = rand(licenseStartDate..Date.civil(2100, 12, 31))
            csv << [vrnp1 + vrnp2 + vrnp3 , licenseStartDate, licenseEndDate, vehicleType, caz, reg1 + reg2, isWheelchairAccessible]
        end
    end

    # take off the new line character
    text = File.read(@@FILE_NAME)
    text = text[0..-2]
    file = File.open(@@FILE_NAME, 'w+')
    file.write text
    file.close
end

create_csv
