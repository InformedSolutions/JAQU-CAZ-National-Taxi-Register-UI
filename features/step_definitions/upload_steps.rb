# frozen_string_literal: true

# Scenario: Upload a csv file and redirect to processing page
When('I upload a valid csv file') do
  allow_any_instance_of(Aws::S3::Object).to receive(:upload_file).and_return(true)
  allow(Connection::RegisterCheckerApi).to receive(:register_job)
    .with('CAZ-2020-01-08-AuthorityID-4321.csv')
    .and_return('ae67c64a-1d9e-459b-bde0-756eb73f36fe')

  attach_file(:file, csv_file('CAZ-2020-01-08-AuthorityID-4321.csv'))
  click_button 'Upload'
end

Then('I am redirected to the Success page') do
  expect(page).to have_current_path(success_upload_index_path)
end

#  Scenario: Upload a csv file whose name is not compliant with the naming rules
When('I upload a csv file whose name format is invalid #1') do
  attach_file(:file, empty_csv_file('сAZ-2020-01-08-AuthorityID-4321.csv'))
  click_button 'Upload'
end

When('I upload a csv file whose name format is invalid #2') do
  attach_file(:file, empty_csv_file('CAZ-01-08-2020-AuthorityID-4321.csv'))
  click_button 'Upload'
end

When('I upload a csv file whose name format is invalid #3') do
  attach_file(:file, empty_csv_file('CAZ-2020-01--4321.csv'))
  click_button 'Upload'
end

When('I upload a csv file whose name format is invalid #4') do
  attach_file(:file, empty_csv_file('CAZ-2020-01-08-AuthorityID-.csv'))
  click_button 'Upload'
end

When('I upload a csv file whose name format is invalid #5') do
  attach_file(:file, empty_csv_file('CAZ-2020-01-08-Auth_orityID-4321.csv'))
  click_button 'Upload'
end

When('I upload a csv file whose name format is invalid #6') do
  attach_file(:file, empty_csv_file('cCAZ-2020-01-08-AuthorityID-4321.CSV'))
  click_button 'Upload'
end

# Scenario: Upload a csv file format that is not .csv or .CSV
When('I upload a csv file whose format that is not .csv or .CSV') do
  attach_file(:file, empty_csv_file('CAZ-2020-01-08-AuthorityID-4321.xlsx'))
  click_button 'Upload'
end

# Upload a valid csv file during error is encountered writing to S3
When('I upload a csv file during error on S3') do
  allow_any_instance_of(Aws::S3::Object).to receive(:upload_file).and_return(false)

  attach_file(:file, csv_file('CAZ-2020-01-08-AuthorityID-4321.csv'))
  click_button 'Upload'
end

When('I upload a csv file with invalid number of values') do
  attach_file(:file, csv_file('CAZ-2020-01-08-AuthorityID-1.csv'))
  click_button 'Upload'
end

When('I upload a csv file with header row') do
  attach_file(:file, csv_file('CAZ-2020-01-08-AuthorityID-2.csv'))
  click_button 'Upload'
end

When('I upload a csv file with semicolons') do
  attach_file(:file, csv_file('CAZ-2020-01-08-AuthorityID-3.csv'))
  click_button 'Upload'
end

When('I upload a csv file with comma for the last field') do
  attach_file(:file, csv_file('CAZ-2020-01-08-AuthorityID-4.csv'))
  click_button 'Upload'
end

When('I upload a csv file with invalid order of values') do
  attach_file(:file, csv_file('CAZ-2020-01-08-AuthorityID-5.csv'))
  click_button 'Upload'
end

When('I upload a csv file with spaces between field values and separating commas') do
  attach_file(:file, csv_file('CAZ-2020-01-08-AuthorityID-6.csv'))
  click_button 'Upload'
end

When('I upload a csv file with pound, dollar and hash characters') do
  attach_file(:file, csv_file('CAZ-2020-01-08-AuthorityID-7.csv'))
  click_button 'Upload'
end

def empty_csv_file(filename)
  File.join('spec', 'fixtures', 'files', 'csv', 'empty', filename)
end

def csv_file(filename)
  File.join('spec', 'fixtures', 'files', 'csv', filename)
end
