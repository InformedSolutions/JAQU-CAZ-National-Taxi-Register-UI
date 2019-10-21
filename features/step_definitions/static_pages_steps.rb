# frozen_string_literal: true

When('I press Accessibility link') do
  within('footer.govuk-footer') do
    click_link 'Accessibility'
  end
end

When('I press Cookies link') do
  within('footer.govuk-footer') do
    click_link 'Cookies'
  end
end

When('I press Privacy policy link') do
  within('footer.govuk-footer') do
    click_link 'Privacy policy'
  end
end
