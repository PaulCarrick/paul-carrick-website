module Utilities
  def shutdown
    Capybara.current_session.driver.quit if Capybara.current_session&.driver&.browser
    exit
  end
end
