require 'rails_helper'

RSpec.describe "Admin Users", type: :system do
  let(:admin_user) { create(:user, admin: true) }
  let!(:site_setup) { create(:site_setup) }
  let!(:user) do
    create(:user,
           email: "test@example.com",
           name: "Test User",
           admin: true,
           super: false,
           roles: "Editor")
  end

  before do
    if ENV["DEBUG"].present?
      driven_by(:selenium_chrome)
    else
      driven_by(:selenium_chrome_headless)
    end

    login_as(admin_user)
  end

  describe "Index Page" do
    before { visit admin_users_path }

    it "displays the correct title" do
      expect(page).to have_title("Test - Admin Dashboard: Users")
    end

    it "lists all users with their attributes" do
      within ".scrollable-container" do
        expect(page).to have_content("test@example.com")
        expect(page).to have_content("Test User")
        expect(page).to have_content("Yes") # Admin
        expect(page).to have_content("No")  # Super
        expect(page).to have_content("Editor")
      end
    end

    it "renders action links for each user" do
      expect(page).to have_link("Edit", href: edit_admin_user_path(user))
      expect(page).to have_link("Delete", href: admin_destroy_user_path(user))
    end

    it "navigates to the new user page" do
      click_link "New User"
      expect(page).to have_current_path(new_admin_user_path)
    end
  end

  describe "New User Page" do
    before { visit new_admin_user_path }

    it "displays the correct title" do
      expect(page).to have_title("Test - Admin Dashboard: Users")
    end

    it "renders the form with required fields" do
      expect(page).to have_field("user[email]", type: "text")
      expect(page).to have_field("user[name]", type: "text")
      expect(page).to have_field("user[password]", type: "password")
      expect(page).to have_field("Admin", type: "checkbox")
      expect(page).to have_field("Super", type: "checkbox")
      expect(page).to have_field("Roles", type: "text")
    end

    it "creates a new user successfully" do
      fill_in "Email*", with: "new_user@example.com"
      fill_in "Name*", with: "New User"
      fill_in "Password*", with: "password123"
      check "Admin"
      fill_in "Roles", with: "Manager"
      click_button "Save User"

      expect(page).to have_current_path(admin_users_path)
      expect(page).to have_content("new_user@example.com")
      expect(page).to have_content("New User")
      expect(page).to have_content("Yes") # Admin
      expect(page).to have_content("Manager")
    end
  end

  describe "Edit User Page" do
    before { visit edit_admin_user_path(user) }

    it "displays the correct title" do
      expect(page).to have_title("Test - Admin Dashboard: Users")
    end

    it "pre-fills the form with existing data" do
      expect(page).to have_field("user[email]", with: "test@example.com")
      expect(page).to have_field("user[name]", with: "Test User")
      expect(page).to have_field("Admin", checked: true)
      expect(page).to have_field("Super", checked: false)
      expect(page).to have_field("Roles", with: "Editor")
    end

    it "updates a user successfully" do
      fill_in "user[name]", with: "Updated User"
      uncheck "Admin"
      click_button "Save User"

      expect(page).to have_current_path(admin_users_path)
      expect(page).to have_content("Updated User")
      expect(page).to have_content("No") # Admin
    end
  end

  describe "Show User Page" do
    before { visit admin_user_path(user) }

    it "displays the correct title" do
      expect(page).to have_title("Test - Admin Dashboard: Users")
    end

    it "shows the user's details" do
      expect(page).to have_content("test@example.com")
      expect(page).to have_content("Test User")
      expect(page).to have_content("Yes") # Admin
      expect(page).to have_content("No")  # Super
      expect(page).to have_content("Editor")
    end
  end

  describe "Delete User" do
    before { visit admin_users_path }

    it "deletes a user successfully" do
      click_link "Delete", href: admin_destroy_user_path(user)
      page.driver.browser.switch_to.alert.accept # Confirm alert
      expect(page).not_to have_content("test@example.com")
    end
  end
end