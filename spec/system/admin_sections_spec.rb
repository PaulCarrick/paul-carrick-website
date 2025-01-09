require 'rails_helper'

RSpec.describe "Admin Sections", type: :system do
  def search_sections(description)
    visit admin_sections_path

    expect(page).to have_field(name: 'q[description_cont]')
    fill_in "q[description_cont]", with: description
    click_button "Search Sections"
  end

  let(:admin_user) { create(:user, access: "super") }
  let!(:site_setup) { SiteSetup.find_by(configuration_name: 'default') }
  let!(:image_file) do
    create(:image_file,
           name:        "test-image",
           caption:     "Test Caption",
           description: "Test Description",
           mime_type:   "image/jpeg",
           group:       "Test Group",
           slide_order: 1)
  end

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
    before { search_sections("Test Description") }

    it "displays the correct title" do
      expect(page).to have_title("#{site_setup.site_name} - Admin Dashboard: Sections")
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
      expect(page).to have_select("#{site_setup.site_name} - Admin Dashboard: Sections")
    end

    it "renders the form with required fields" do
      expect(page).to have_selector('h1', text: 'No Contents')
      expect(find('#contentType')).to be_present
      expect(find('#sectionName')).to be_present
      expect(find('#sectionOrder')).to be_present
      expect(find('#image')).to be_present
      expect(find('#link')).to be_present
      expect(find('div.ql-editor')).to be_present
      expect(page).to have_select('rowStyle')
      expect(page).to have_select('textMarginTop')
      expect(page).to have_select('textMarginLeft')
      expect(page).to have_select('textMarginBottom')
      expect(page).to have_select('textMarginRight')
      expect(page).to have_select('textBackgroundColor')
      expect(page).to have_button("Switch to HTML View **")
      expect(page).to have_button("Switch to Formatting Mode **")
      expect(page).to have_button("Save Section")
      expect(page).to have_button("Cancel")
    end

    it "creates a new section successfully" do
      find('#contentType').set("New Content Type")
      find('#contentType').set("New Section Name")
      find('#sectionOrder').set("2")
      find('#image').set("ImageFile:test-image")
      find('#link').set("https://new-example.com")
      fill_in_quill_editor("description", with: "This is a new Section.")
      find('#rowStyle').find('option[value="text-single"]').select_option
      find('#textMarginTop').find('option[value="mt-5"]').select_option
      find('#textMarginLeft').find('option[value="ms-5"]').select_option
      find('#textMarginBottom').find('option[value="mb-5"]').select_option
      find('#textMarginRight').find('option[value="me-5"]').select_option
      find('#textBackgroundColor').find('option[value="red"]').select_option
      click_button "Save Section"

      expect(page).to have_current_path(admin_sections_path)
      expect(page).to have_content("Section created successfully.")
      search_sections("This is a new Section.")
      expect(page).to have_content("New Content Type")
      expect(page).to have_content("New Section Name")
    end
  end

  describe "Edit Section Page" do
    before { visit edit_admin_section_path(section) }

    it "displays the correct title" do
      expect(page).to have_title("#{site_setup.site_name} - Admin Dashboard: Sections")
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
      expect(page).to have_title("#{site_setup.site_name} - Admin Dashboard: Sections")
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
