require 'rails_helper'

RSpec.describe "Admin Sections", type: :system do
  let(:admin_user) { create(:user, access: "super") }
  let!(:site_setup) { SiteSetup.find_by(configuration_name: 'default') }
  let!(:section) do
    create(:section,
           content_type:  "Test Content Type",
           section_name:  "Test Section Name",
           section_order: 1,
           image:         "test_image.jpg",
           link:          "https://example.com",
           formatting:    "{ \"row_class\": \"single-line\" }",
           description:   "<p>Test Description</p>")
  end

  before do
    if ENV["DEBUG"].present? || ENV["RSPEC_DEBUG"].present?
      driven_by(:selenium_chrome)
    else
      driven_by(:selenium_chrome_headless)
    end

    login_as(admin_user)
  end

  describe "Index Page" do
    before { visit admin_sections_path }

    it "displays the correct title" do
      expect(page).to have_title("Test - Admin Dashboard: Sections")
    end

    it "lists all sections with their attributes" do
      within ".auto-size" do
        expect(page).to have_content("Test Content Type")
        expect(page).to have_content("Test Section Name")
        expect(page).to have_content("1")
        expect(page).to have_content("test_image.jpg")
        expect(page).to have_content("https://example.com")
        expect(page).to have_content("row_class: single-line")
        expect(page).to have_content("Test Description")
      end
    end

    it "renders action links for each section" do
      expect(page).to have_link("Edit", href: edit_admin_section_path(section))
      expect(page).to have_link("Delete", href: "#{admin_section_path(section)}/delete")
    end

    it "navigates to the new section page" do
      click_link "New Section"
      expect(page).to have_current_path(new_admin_section_path)
    end
  end

  describe "New Section Page" do
    before { visit new_admin_section_path }

    it "displays the correct title" do
      expect(page).to have_title("Test - Admin Dashboard: Sections")
    end

    it "renders the form with required fields" do
      expect(page).to have_field("section[content_type]", type: "text")
      expect(page).to have_field("Section Name", type: "text")
      expect(page).to have_field("Section Order", type: "number")
      expect(page).to have_field("ImageFile file path", type: "text")
      expect(page).to have_field("URL", type: "text")
      expect(page).to have_field("Formatting", type: "textarea")
    end

    it "creates a new section successfully" do
      fill_in "section[content_type]", with: "New Content Type"
      fill_in "Section Name", with: "New Section Name"
      fill_in "Section Order", with: 2
      fill_in "ImageFile file path", with: "new_image.jpg"
      fill_in "URL", with: "https://new-example.com"
      fill_in "Formatting", with: "row_class: text-left"
      fill_in_trix_editor("rtf-description", with: "New Description")
      click_button "Create Section"

      expect(page).to have_current_path(admin_sections_path)
      expect(page).to have_content("New Content Type")
      expect(page).to have_content("New Section Name")
    end
  end

  describe "Edit Section Page" do
    before { visit edit_admin_section_path(section) }

    it "displays the correct title" do
      expect(page).to have_title("Test - Admin Dashboard: Sections")
    end

    it "pre-fills the form with existing data" do
      expect(page).to have_field("section[content_type]", with: "Test Content Type")
      expect(page).to have_field("Section Name", with: "Test Section Name")
      expect(page).to have_field("Section Order", with: "1")
      expect(page).to have_field("ImageFile file path", with: "test_image.jpg")
      expect(page).to have_field("URL", with: "https://example.com")
      expect(page).to have_field("Formatting", with: "row_class: single-line")
    end

    it "updates a section successfully" do
      fill_in "Section Name", with: "Updated Section Name"
      click_button "Update Section"

      expect(page).to have_current_path(admin_sections_path)
      expect(page).to have_content("Section updated successfully.")
    end
  end

  describe "Show Section Page" do
    before { visit admin_section_path(section) }

    it "displays the correct title" do
      expect(page).to have_title("Test - Admin Dashboard: Sections")
    end

    it "shows the section details" do
      expect(page).to have_content("Test Content Type")
      expect(page).to have_content("Test Section Name")
      expect(page).to have_content("1")
      expect(page).to have_content("test_image.jpg")
      expect(page).to have_content("https://example.com")
      expect(page).to have_content("{\"row_class\":\"single-line\"}")
      expect(page).to have_content("Test Description")
    end
  end
end
