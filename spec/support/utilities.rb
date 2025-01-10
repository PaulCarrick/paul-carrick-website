module Utilities
  def select_option_from_dropdown(dropdown_selector, option_text)
    find(dropdown_selector).click
    find(:css, "[id]", id: /react-select-.*-option-.*/, text: option_text).click
  end

  def shutdown
    Capybara.current_session.driver.quit if Capybara.current_session&.driver&.browser
    exit
  end
end
