# frozen_string_literal: true

def correlation_id
  SecureRandom.uuid
end

def job_name
  'ae67c64a-1d9e-459b-bde0-756eb73f36fe'
end

# Scenario: Upload a csv file and redirect to processing page
When('I upload a valid csv file') do
  allow(SecureRandom).to receive(:uuid).and_return(correlation_id)
  allow(CsvUploadService).to receive(:call).and_return(true)
  allow(RegisterCheckerApi).to receive(:register_job)
    .with('CAZ-2020-01-08-AuthorityID-8.csv', correlation_id)
    .and_return(job_name)

  allow(RegisterCheckerApi).to receive(:job_status)
    .with(job_name, correlation_id).and_return('RUNNING')

  attach_file(:file, csv_file('CAZ-2020-01-08-AuthorityID-8.csv'))
  click_button 'Upload'
end

When('I press refresh page link') do
  allow(RegisterCheckerApi).to receive(:job_status)
    .with(job_name, correlation_id).and_return('SUCCESS')

  click_link 'click here.'
end

Then('I am redirected to the Success page') do
  expect(page).to have_current_path(success_upload_index_path)
end

# Scenario: Upload a csv file and redirect to error page when api response not running or finished
When('I press refresh page link when api response not running or finished') do
  allow(RegisterCheckerApi).to receive(:job_status)
    .with(job_name, correlation_id).and_return('FAILURE')
  allow(RegisterCheckerApi).to receive(:job_errors)
    .with(job_name, correlation_id).and_return(['error'])
  click_link 'click here.'
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

  attach_file(:file, csv_file('CAZ-2020-01-08-AuthorityID-8.csv'))
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

# Scenario: Show processing page without uploaded csv file
When('I want go to processing page') do
  visit processing_upload_index_path
end

Then('I am redirected to the root page') do
  expect(page).to have_current_path(root_path)
end

def empty_csv_file(filename)
  File.join('spec', 'fixtures', 'files', 'csv', 'empty', filename)
end

def csv_file(filename)
  File.join('spec', 'fixtures', 'files', 'csv', filename)
end
