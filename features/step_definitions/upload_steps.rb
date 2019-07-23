# frozen_string_literal: true

# Scenario: Upload a csv file and redirect to processing page
When('I upload a valid csv file') do
  allow(CsvUploadService).to receive(:call).and_return(true)
  allow(Connection::RegisterCheckerApi).to receive(:register_job)
    .with('CAZ-2020-01-08-AuthorityID-4321.csv')
    .and_return('ae67c64a-1d9e-459b-bde0-756eb73f36fe')

  mock_job_status(success: false, in_progress: true)

  attach_file(:file, csv_file('CAZ-2020-01-08-AuthorityID-4321.csv'))
  click_button 'Upload'
end

When('I press refresh page link') do
  mock_job_status(success: true, in_progress: false)

  click_link 'click here.'
end

Then('I am redirected to the Success page') do
  expect(page).to have_current_path(success_upload_index_path)
end

# Scenario: Upload a csv file and redirect to error page when csv file has invalid structure
When('I press refresh page link when csv file has invalid structure') do
  error_msg = 'Invalid format of VRM in row 13'
  mock_job_status(success: false, in_progress: false, invalid_csv: true, errors: [error_msg])

  click_link 'click here.'
end

# Scenario: Upload a csv file whose name is not compliant with the naming rules
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

# Scenario: Upload a csv file when frontend api cannot start validation
When('I upload a csv file which is too large') do
  allow(CsvUploadService).to receive(:call).and_return(true)
  allow(Connection::RegisterCheckerApi).to receive(:register_job)
    .with('CAZ-2020-01-08-AuthorityID-4321.csv')
    .and_return('ae67c64a-1d9e-459b-bde0-756eb73f36fe')
  error_msg = 'Uploaded file is too large'
  mock_job_status(success: false, in_progress: false, invalid_csv: false, errors: [error_msg])

  attach_file(:file, csv_file('CAZ-2020-01-08-AuthorityID-4321.csv'))
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

def mock_job_status(success: false, in_progress: false, invalid_csv: false, errors: [])
  allow(ProcessingJobService).to receive(:call)
    .with(job_uuid: 'ae67c64a-1d9e-459b-bde0-756eb73f36fe')
    .and_return(
      OpenStruct.new(
        success?: success,
        in_progress?: in_progress,
        invalid_csv?: invalid_csv,
        errors: errors
      )
    )
end
