Given /^a user exists$/ do
  Factory.create(:user)
end
 
Given /^a user exists with login "(.+)" and password "(.+)"$/ do |login, password|
  Factory.create(:user, :login => login, :password => password, :password_confirmation => password)
end
 
Given /^I am logged in$/ do
  user = Factory.create(:user)
  visit "/login"
  fill_in "login", :with => "#{user.login}"
  fill_in "password", :with => "#{user.password}"
  click_button "Login"
end
 
Given /^I am logged in as "(.+)"$/ do |user|
  @user = Factory.create(:user, :login => user)
  visit "/login"
  fill_in "login", :with => "#{@user.login}"
  fill_in "password", :with => "#{@user.password}"
  click_button "Login"
end

Given /^I login as "(.+)"$/ do |user|
  Given %{I visit the login page}
  Given %{I fill in "Login" with "#{user}"}
  Given %{I fill in "Password" with "thedude"}
  Given %{I press "Login"}
end

Given /^I am logged in as an admin$/ do
  user = Factory.create(:admin)
  visit "/login"
  fill_in "login", :with => "#{user.login}"
  fill_in "password", :with => "#{user.password}"
  click_button "Login"
end