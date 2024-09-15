def sign_in(user)
  path = new_case_manager_session_path
  path = new_dispute_analyst_session_path if user.dispute_analyst?
  visit path
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Log in'
end

def sign_up(user)
  path = visit new_case_manager_registration_path
  path = visit new_dispute_analyst_registration_path if user.dispute_analyst?
  fill_in 'First name', with: user.first_name
  fill_in 'Last name', with: user.last_name
  fill_in 'Age', with: user.age
  fill_in 'Date of birth', with: user.date_of_birth
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  fill_in 'Password confirmation', with: user.password_confirmation
  click_button 'Sign up'
end
