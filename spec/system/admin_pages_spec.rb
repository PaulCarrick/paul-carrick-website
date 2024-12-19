require 'rails_helper'

RSpec.describe "Admin Pages", type: :system do
  let(:admin_user) { create(:user, access: "super") }
  let!(:site_setup) { create(:site_setup) }
  let!(:page_record) do
    create(:page,
           name: "Test Page",
           section: "Test Section",
           title: "Test Title",
           access: "Public")
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
    before { visit admin_pages_path }

    it "displays the correct title" do
      expect(page).to have_title("Test - Admin Dashboard: Pages")
    end

    it "lists all pages with their attributes" do
      within ".scrollable-container" do
        expect(page).to have_content("Test Page")
        expect(page).to have_content("Test Section")
        expect(page).to have_content("Test Title")
        expect(page).to have_content("Public")
      end
    end

    it "renders action links for each page" do
      expect(page).to have_link("Edit", href: edit_admin_page_path(page_record))
      expect(page).to have_link("Delete", href: "#{admin_page_path(page_record)}/delete")
    end

    it "navigates to the new page form" do
      click_link "New page"
      expect(page).to have_current_path(new_admin_page_path)
    end
  end

  describe "New Page" do
    before { visit new_admin_page_path }

    it "displays the correct title" do
      expect(page).to have_title("Test - Admin Dashboard: Pages")
    end

    it "renders the form with required fields" do
      expect(page).to have_field("page[name]", type: "text")
      expect(page).to have_field("Section", type: "text")
      expect(page).to have_field("Title", type: "text")
      expect(page).to have_field("Access", type: "text")
    end

    it "creates a new page successfully" do
      fill_in "page[name]", with: "New Page"
      fill_in "Section", with: "New Section"
      fill_in "Title", with: "New Title"
      fill_in "Access", with: "Private"
      click_button "Save Page"

      expect(page).to have_current_path(admin_pages_path)
      expect(page).to have_content("New Page")
      expect(page).to have_content("Private")
    end
  end

  describe "Edit Page" do
    before { visit edit_admin_page_path(page_record) }

    it "displays the correct title" do
      expect(page).to have_title("Test - Admin Dashboard: Pages")
    end

    it "pre-fills the form with existing data" do
      expect(page).to have_field("page[name]", with: "Test Page")
      expect(page).to have_field("Section", with: "Test Section")
      expect(page).to have_field("Title", with: "Test Title")
      expect(page).to have_field("Access", with: "Public")
    end

    it "updates the page successfully" do
      fill_in "Title", with: "Updated Title"
      click_button "Save Page"

      expect(page).to have_current_path(admin_pages_path)
      expect(page).to have_content("Updated Title")
    end
  end

  describe "Show Page" do
    before { visit admin_page_path(page_record) }

    it "displays the correct title" do
      expect(page).to have_title("Test - Admin Dashboard: Pages")
    end

    it "shows the page details" do
      expect(page).to have_content("Test Page")
      expect(page).to have_content("Test Section")
      expect(page).to have_content("Test Title")
      expect(page).to have_content("Public")
    end
  end

  describe "Delete Functionality" do
    before { visit admin_pages_path }

    it "deletes an page successfully" do
      click_link "Delete", href: "#{admin_destroy_page_path(page_record)}"
      page.driver.browser.switch_to.alert.accept # Confirm alert
      expect(page).not_to have_content("Test Page")
    end
  end
end
