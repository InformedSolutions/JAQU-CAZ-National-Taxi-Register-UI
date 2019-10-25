#!/usr/bin/env ruby
require "csv"
require 'httparty'
require 'optparse'
require "aws-sdk-s3"
require 'dotenv/load'
require 'webdrivers'
require 'oauth2'
#require 'browserstack-fast-selenium'
Dotenv.load('.env')
require_relative 'features/commands/shared_commands'
$vccs_web_username = ENV['VCCS_WEB_USERNAME']
$vccs_web_password = ENV['VCCS_WEB_PASSWORD']

#turns off warning
$VERBOSE = nil

@@JOB_NAME= ''
@@NTR_CSV_FILE_NAME = 'CAZ-2020-01-08-100-5.csv'
@@NTR_API_FILE_NAME = 'api_data.txt'
@@RETRO_FILE_NAME = 'CAZ-2020-01-08-1.csv' 
@@MOD_GREEN_FILE_NAME = 'CAZ-2020-01-30-7.csv'
@@MOD_WHITE_FILE_NAME = 'CAZ-2020-01-30-6.csv'
@@NTR_API_UPLOAD_FILE_LOCATION = 'test-files/ntr/main/CAZ-2000-01-08-100-1.csv'
@@NTR_API_UPLOAD_FILE_NAME = 'CAZ-2000-01-08-100-1.csv'
@@BUCKET='jaqu-ntr-csv-bucket-dev'
@@JOB_URL=nil
@@COGNITO_ID=nil
@@UPPER_ALPHABET_ARRAY = ('A'..'Z').to_a
@@LOWER_ALPHABET_ARRAY = ('a'..'z').to_a
@@NUMBERS_ARRAY = ('1'..'9').to_a
@@LICENSING_AUTHORITY_A = 'Leeds'
@@LICENSING_AUTHORITY_B = 'Leeds'

def remove_newline(file_name)
    csv_text = File.read(file_name)
    new_csv_text = csv_text[0..-2]
    csv = File.open(file_name, 'w')
    csv.write new_csv_text
    csv.close
end



def vehicle_to_text_file(file, isLastItem, vrm, licenseStartDate, licenseEndDate, vehicleType, licensing_authority, reg, isWheelchairAccessible)
    file.puts'    {'
    file.puts'      "vrm": "' + vrm + '",'
    file.puts'      "start": "' + licenseStartDate.strftime("%Y") + '-' + licenseStartDate.strftime("%m") + '-' + licenseStartDate.strftime("%d") + '",'
    file.puts'      "end": "' + licenseEndDate.strftime("%Y") + '-' + licenseEndDate.strftime("%m") + '-' + licenseEndDate.strftime("%d") + '",'
    file.puts'      "taxiOrPHV": "' + vehicleType + '",'
    file.puts'      "licensingAuthorityName": "' + licensing_authority + '",'
    file.puts'      "licensePlateNumber": "' + reg + '",'
    file.puts'      "wheelchairAccessibleVehicle": ' + isWheelchairAccessible + ''
    if isLastItem == false
        file.puts'    },'
    else 
        file.puts'    }'  
    end  
end


def generate_ntr_vehicle
    vrm = make_valid_vrm
    reg = make_valid_reg
    vehicleType = ['taxi','PHV'].sample
    licensing_authority = [@@LICENSING_AUTHORITY_A,@@LICENSING_AUTHORITY_B].sample
    isWheelchairAccessible = ['true','false'].sample
    licenseStartDate = rand(Date.civil(1885, 01, 01)..Date.civil(2100, 12, 30))
    licenseEndDate = rand(licenseStartDate..Date.civil(2100, 12, 31))
    [vrm , licenseStartDate, licenseEndDate, vehicleType, licensing_authority, reg, isWheelchairAccessible]
end

def make_valid_vrm
    vrmp1 = @@UPPER_ALPHABET_ARRAY.shuffle[0,2].join
    vrmp2 = @@NUMBERS_ARRAY.shuffle[0,2].join
    vrmp3 = @@UPPER_ALPHABET_ARRAY.shuffle[0,3].join
    vrmp1 + vrmp2 + vrmp3
end


def make_valid_reg
    reg1 = @@LOWER_ALPHABET_ARRAY.shuffle[0,2].join
    reg2 = @@UPPER_ALPHABET_ARRAY.shuffle[0,3].join
    reg1 + reg2
end

def generate_ntr_csv(invalidItems, validItems)
    puts 'Generating ntr csv with ' + invalidItems.to_s + ' invalid items and ' + validItems.to_s + ' valid items.'
    if defined?(@@FILE_NAME) == nil
        @@FILE_NAME = 'CAZ-2020-01-08-100-5.csv'
    end
    puts 'creating file ' + @@FILE_NAME
    CSV.open(@@FILE_NAME, "wb") do |csv|

        for i in 1..invalidItems do
            option = Random.rand(0..6)
            vehicleData = generate_ntr_vehicle
            case option
            when 0
                vehicleData[0] = '$ABBA$'
            when 1
                vehicleData[1] = 'Last Tuesday'
            when 2
                vehicleData[2] = 'Next Tuesday'
            when 3
                vehicleData[3] = '#13'
            when 4
                vehicleData[4] = ''
            when 5
                vehicleData[5] = 'AAA999A'
            when 6
                vehicleData[6] = 'Dunno'
            end
            csv << vehicleData  
        end
 
        for i in 1..validItems do
            csv << generate_ntr_vehicle
        end

    end
    remove_newline(@@FILE_NAME)
    puts 'CSV generated'
end




def generate_ntr_api_file(numOfRows)
    puts 'Generating a file with ' + numOfRows.to_s + ' data items'
    if defined?(@@FILE_NAME) == nil
        @@FILE_NAME = @@NTR_API_FILE_NAME
    end
    puts 'Creating file ' + @@FILE_NAME
    File.open(@@FILE_NAME, "w") do |file|
        file.puts '{'
        file.puts '  "vehicleDetails": ['
        for i in 1..numOfRows do
            vehicle_data = generate_ntr_vehicle
            isLastItem = (i == numOfRows)
            vehicle_to_text_file(file, isLastItem, *vehicle_data)
        end
        file.puts'  ]'
        file.puts'}'
    end
    puts 'API file generated'
end




def generate_ntr_files(numOfRows)
    puts 'Generating a csv and a file with ' + numOfRows.to_s + ' data items'
    csv = CSV.open(@@NTR_CSV_FILE_NAME, "wb")
    file = File.open(@@NTR_API_FILE_NAME, "w")
    file.puts '{'
    file.puts '  "vehicleDetails": ['
    for i in 1..numOfRows do
        vrm = make_valid_vrm
        reg = make_valid_reg
        vehicleType = ['taxi','PHV'].sample
        licensing_authority = [@@LICENSING_AUTHORITY_A,@@LICENSING_AUTHORITY_B].sample
        isWheelchairAccessible = ['true','false'].sample
        licenseStartDate = rand(Date.civil(1885, 01, 01)..Date.civil(2100, 12, 30))
        licenseEndDate = rand(licenseStartDate..Date.civil(2100, 12, 31))
        csv << [vrm, licenseStartDate, licenseEndDate, vehicleType, licensing_authority, reg, isWheelchairAccessible]
        isLastItem = (i == numOfRows)
        vehicle_to_text_file(file, isLastItem, vrm, licenseStartDate, licenseEndDate, vehicleType, licensing_authority, reg, isWheelchairAccessible)
    end
    file.puts'  ]'
    file.puts'}'
    file.close
    csv.close
    remove_newline(@@NTR_CSV_FILE_NAME)
    puts 'CSV and API files generated'
end




def generate_retrofit_csv(numOfRows)
    puts 'Generating retro csv with: ' + numOfRows.to_s + ' rows'
    if defined?(@@FILE_NAME) == nil
        @@FILE_NAME = @@RETRO_FILE_NAME
    end
    puts 'creating file ' + @@FILE_NAME
    CSV.open(@@FILE_NAME, "wb") do |csv|
        for i in 1..numOfRows do
            vrm = make_valid_vrm
            licenseStartDate = rand(Date.civil(1885, 01, 01)..Date.civil(2100, 12, 30))
            csv << [vrm , "category-1", "model-1", licenseStartDate]
        end
    end
    remove_newline(@@FILE_NAME)
    puts 'CSV generated'
end



def generate_mod_white_csv(numOfRows)
    puts 'Generating MOD csv with: ' + numOfRows.to_s + ' rows'
    if defined?(@@FILE_NAME) == nil
        @@FILE_NAME = @@MOD_WHITE_FILE_NAME
    end
    puts 'creating file ' + @@FILE_NAME
    CSV.open(@@FILE_NAME, "wb") do |csv|
        for i in 1..numOfRows do
            vrm = make_valid_vrm
            csv << [vrm]
        end
    end
    remove_newline(@@FILE_NAME)
    puts 'CSV generated'
end



def generate_mod_green_csv(numOfRows)
    puts 'Generating MOD csv with: ' + numOfRows.to_s + ' rows'
    if defined?(@@FILE_NAME) == nil
        @@FILE_NAME = @@MOD_GREEN_FILE_NAME
    end
    puts 'creating file ' + @@FILE_NAME
    CSV.open(@@FILE_NAME, "wb") do |csv|
        for i in 1..numOfRows do
            vrm1 = make_valid_vrm
            option = Random.rand(1..3)
            case option
            when 1
                csv << [vrm1]
            when 2  
                csv << [nil, vrm1]
            when 3
                vrm2 = make_valid_vrm
                csv << [vrm1, vrm2] 
            end
        end
    end
    remove_newline(@@FILE_NAME)
    puts 'CSV generated'
end




def upload_file_with_selenium(service, filename)
    @screenshot_path = './screenshots/'+ ENV['SCREENSHOT_TYPE'] +'/gtd/'
    options = Selenium::WebDriver::Chrome::Options.new
    #options.add_argument('--headless')
    options.add_option(:detach, true)
    $driver = Selenium::WebDriver.for :chrome, options: options
    $wait = Selenium::WebDriver::Wait.new(timeout: 500)
    if service.eql? 'ntr'
        @base_url = ENV['BASEURL_NTR']
        if filename.eql? nil
            filename = @@NTR_CSV_FILE_NAME
        end
    elsif service.eql? 'retro'
        @base_url = ENV['BASEURL_RETRO']
        if filename.eql? nil
            filename = @@RETRO_FILE_NAME
        end
    elsif service.eql? 'mod_green'
        @base_url = ENV['BASEURL_MOD']
        if filename.eql? nil
            filename = @@MOD_GREEN_FILE_NAME
        end
    elsif service.eql? 'mod_white'
        @base_url = ENV['BASEURL_MOD']
        if filename.eql? nil
            filename = @@MOD_WHITE_FILE_NAME
        end
        $driver.get(@base_url)
        $driver.manage.add_cookie(opts={name:'seen_cookie_message', value: 'true'})
        SharedCommands.login_with_credentials(ENV['WHITE_MOD_VALID_USERNAME'], ENV['WHITE_MOD_VALID_PASSWORD'])
        SharedCommands.upload_file(File.expand_path(filename))

        return
    end

    $driver.get(@base_url)
    $driver.manage.add_cookie(opts={name:'seen_cookie_message', value: 'true'})
    SharedCommands.login_with_credentials
    SharedCommands.upload_file(File.expand_path(filename))
    $driver.quit
end



def upload_csv
    puts 'Uploading file to s3 with metadata'
    s3 = Aws::S3::Resource.new(region:'eu-west-2')
    obj = s3.bucket(@@BUCKET).object(@@NTR_API_UPLOAD_FILE_NAME)
    new_metadata = {'uploader-id' => @@COGNITO_ID}

    obj.upload_file(@@NTR_API_UPLOAD_FILE_LOCATION, metadata:new_metadata)
end

def initiate_register_job
    puts 'initiating register job'
    body = { 
        s3Bucket: @@BUCKET,
        filename: @@NTR_API_UPLOAD_FILE_NAME
    }

    headers = { 
    "Content-Type" =>"application/json",
    "X-Correlation-ID" => @@COGNITO_ID
    }

    response = HTTParty.post(
        @@JOB_URL, 
        body: body.to_json,
        headers: headers
    )
    
    body = JSON.parse(response.body)
    @@JOB_NAME = body['jobName']
end

def poll_status_job(job_name=@@JOB_NAME)
    headers = {
        "X-Correlation-ID" => @@COGNITO_ID
    }
    loop do 
        response = HTTParty.get(
            @@JOB_URL + '/'+ job_name,
            headers: headers
        )
        break if response.body.include? 'SUCCESS' or response.body.include? 'FAILURE'
    end 

    response = HTTParty.get(
        @@JOB_URL + '/'+ job_name,
        headers: headers
    )
    puts response.body
end

def upload_to_api()
    # if defined?(@@FILE_NAME) == nil
    #     @@FILE_NAME = @@NTR_API_UPLOAD_FILE_NAME
    # end
    upload_csv()
    initiate_register_job()
    poll_status_job()
end

def upload_to_api_via_body()
    body = File.read("api_data.txt")

        
    client = OAuth2::Client.new(
    ENV['CLIENT_ID'], 
    ENV['CLIENT_SECRET'], 
    site: ENV['BASEURL_NTR_OAUTH'], 
    token_url: "oauth2/token"
    )

    token = client.client_credentials.get_token()
    
    headers = { 
        "Content-Type" =>"application/json",
        "X-Correlation-ID" => SharedCommands.ntr_sub_id,
        "x-api-key" => SharedCommands.ntr_sub_id,
        "Authorization " => 'Bearer ' + token.token
    }
        t1 = Time.now
        queryAnswer = HTTParty.post(ENV['BASEURL_NTR_API'] + '/v1/scheme-management/taxiphvdatabase',
            :headers => headers,
            :body => body)
        t2 = Time.now
        
        puts queryAnswer.body

        delta = t2 - t1
        puts delta
    end





# This hash will hold all of the options
# parsed from the command-line by
# OptionParser.
options = {}
optparse = OptionParser.new do|opts|
# TODO: Put command-line options here
# This displays the help screen, all programs are
# assumed to have this option.
    opts.on( '-h', '--help', 'Display this screen' ) do
        puts opts
        exit
    end

    opts.on('-f [FILENAME]',"Set the name of the file to be generated (MUST BE WRITTEN IN FRONT OF ANY OTHER COMMANDS)") do |file_name|
        @@FILE_NAME = file_name
    end

    opts.on('-l [LICENCEAUTH',"Set the la (MUST BE WRITTEN IN FRONT OF ANY OTHER COMMANDS)") do |licence_auth|
        @@LICENSING_AUTHORITY_A = licence_auth
        @@LICENSING_AUTHORITY_B = licence_auth
    end

    opts.on('--ntrcsv [INVALID],[VALID]',"Generate [INVALID] invalid and [VALID] valid taxi data items in CSV form") do |input|
        if input == nil
            generate_ntr_csv(0,5)
        else
            invalid_items, valid_items = input.split(",")
            generate_ntr_csv(invalid_items.to_i, valid_items.to_i)
        end
    end

    opts.on('--ntrapi [NUMBER]',"Generate [NUMBER] valid taxi data items in a text file, ready for API upload") do |number|
        if number == nil
            generate_ntr_api_file(5)
        else
            generate_ntr_api_file(number.to_i)
        end
    end

    opts.on('--ntrboth [NUMBER]',"Generate [NUMBER] valid taxi data items in both CSV and API form") do |number|
        if number == nil
            generate_ntr_files(5)
        else
            generate_ntr_files(number.to_i)
        end
    end

    opts.on('--retro [NUMBER]',"Generate [NUMBER] valid retrofitted vehicle data items in CSV form") do |number|
    if number == nil
        generate_retrofit_csv(5)
        else
            generate_retrofit_csv(number.to_i)
        end
    end

    opts.on('--modwhite [NUMBER]',"Generate [NUMBER] valid white category Ministry of Defence vehicle data items in CSV form") do |number|
        if number == nil
            generate_mod_white_csv(5)
        else
            generate_mod_white_csv(number.to_i)
        end
    end

    opts.on('--modgreen [NUMBER]',"Generate [NUMBER] valid green category Ministry of Defence vehicle data items in CSV form") do |number|
        if number == nil
            generate_mod_green_csv(5)
        else
            generate_mod_green_csv(number.to_i)
        end
    end

    opts.on('--upldntr [FILENAME]', 'Uploads the [FILENAME] csv to the NTR') do |filename|
        upload_file_with_selenium('ntr', filename)
    end

    opts.on('--upldretro [FILENAME]', 'Uploads the [FILENAME] csv to the Retrofit service') do |filename|
        upload_file_with_selenium('retro', filename) 
    end

    opts.on('--upldmodg [FILENAME]', 'Uploads the [FILENAME] csv to the MOD green service') do |filename|
        upload_file_with_selenium('mod_green', filename)
    end

    opts.on('--upldmodw [FILENAME]', 'Uploads the [FILENAME] csv to the MOD white service') do |filename|
        upload_file_with_selenium('mod_white', filename)
    end

    opts.on('--upldntrapi', 'Uploads a CSV via the NTR API system') do
        upload_to_api()
    end

    opts.on('--upldntrapibody', 'Uploads a CSV via the NTR API system') do
        upload_to_api_via_body()
    end



end
# Parse the command-line. Remember there are two forms
# of the parse method. The 'parse' method simply parses
# ARGV, while the 'parse!' method parses ARGV and removes
# any options found there, as well as any parameters for
# the options. What's left is the list of files to resize.
optparse.parse!
