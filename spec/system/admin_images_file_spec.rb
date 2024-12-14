require 'rails_helper'

RSpec.describe "Admin Image Files", type: :system do
  let(:admin_user) { create(:user, admin: true) }
  let!(:site_setup) { create(:site_setup) }
  let!(:image_file) do
    create(:image_file,
           name:        "Test Image",
           caption:     "Test Caption",
           description: "Test Description",
           mime_type:   "image/jpeg",
           group:       "Test Group",
           slide_order: 1)
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
    before { visit admin_image_files_path }

    it "displays the correct title" do
      expect(page).to have_title("Test - Admin Dashboard: Image Files")
    end

    it "lists all image files with their attributes" do
      expect(page).to have_content("Test Image")
      expect(page).to have_content("Test Caption")
      expect(page).to have_content("Test Group")
      expect(page).to have_content("1")
    end

    it "renders action links for each image file" do
      expect(page).to have_link("Edit", href: edit_admin_image_file_path(image_file))
      expect(page).to have_link("Delete", href: "#{admin_image_file_path(image_file)}/delete")
    end

    it "navigates to the new image file page" do
      click_link "New Image"
      expect(page).to have_current_path(new_admin_image_file_path)
    end
  end

  describe "New Page" do
    before { visit new_admin_image_file_path }

    it "displays the correct title" do
      expect(page).to have_title("Test - Admin Dashboard: Image Files")
    end

    it "creates a new image file" do
      fill_in "image_file[name]", with: "New Image"
      attach_file "image_file[image]", Rails.root.join("spec/fixtures/files/sample.jpg")
      select "JPEG", from: "Mime Type"
      fill_in "image_file[group]", with: "New Group"
      fill_in "image_file[slide_order]", with: 2
      fill_in "image_file[caption]", with: "New Caption"
      fill_in_trix_editor("rtf-description", with: "New Description")
      click_button "Save Image"

      expect(page).to have_current_path(admin_image_files_path)
      expect(page).to have_content("New Image")
    end
  end

  describe "Edit Page" do
    before { visit edit_admin_image_file_path(image_file) }

    it "displays the correct title" do
      expect(page).to have_title("Test - Admin Dashboard: Image Files")
    end

    it "pre-fills the form with existing data" do
      expect(page).to have_field("image_file[name]", with: "Test Image")
      expect(page).to have_field("image_file[caption]", with: "Test Caption")
      expect(page).to have_field("image_file[group]", with: "Test Group")
    end

    it "updates an image file successfully" do
      fill_in "image_file[caption]", with: "New Caption"
      click_button "Save Image"

      expect(page).to have_current_path(admin_image_files_path)
      expect(page).to have_content("Image File updated successfully.")
    end
  end

  describe "Delete Functionality" do
    before { visit admin_image_files_path }

    it "deletes an image file successfully" do
      click_link "Delete", href: "#{admin_destroy_image_file_path(image_file)}"
      page.driver.browser.switch_to.alert.accept # Confirm alert
      expect(page).not_to have_content("Test Image")
    end
  end
end
