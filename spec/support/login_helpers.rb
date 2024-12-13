module LoginHelpers
  def user_login(email: 'test@paul-carrick.com', password: 'Help4Testing!')
    visit '/'
    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: password
    click_on 'Log in'
  end
end
