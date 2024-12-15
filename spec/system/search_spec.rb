require 'rails_helper'

RSpec.describe "Search Page", type: :system do
  let!(:site_setup) { create(:site_setup) }
  let!(:test_page) { create(:page, name: "coding", section: "coding", title: "Discussions on coding") }
  let!(:matching_page) {
    create(:section,
           content_type:  "coding",
           description:   "A matching description about Ruby",
           section_order: 1)
  }
  let!(:non_matching_page) {
    create(:section,
           content_type:  "coding",
           description:   "Python is popular",
           section_order: 2)
  }

  before do
    if ENV["DEBUG"].present?
      driven_by(:selenium_chrome)
    else
      driven_by(:selenium_chrome_headless)
    end
  end

  describe "Visiting the Search Page" do
    before { visit new_search_path }

    it "displays the correct page title" do
      expect(page).to have_title("Test - Search")
    end

    it "displays the search form" do
      expect(page).to have_selector("form")
      expect(page).to have_field("Search site pages for")
      expect(page).to have_button("Search Site Pages")
    end
  end

  describe "Submitting the Search Form" do
    before { visit new_search_path }

    context "when a matching description is found" do
      it "displays the results" do
        fill_in "Search site pages for", with: "Ruby"
        click_button "Search Site Pages"
        expect(page).to have_content("A matching description about Ruby")
        expect(page).not_to have_content("Python is popular")
      end
    end

    context "when no matching description is found" do
      it "displays no results" do
        fill_in "Search site pages for", with: "Python"
        click_button "Search Site Pages"

        expect(page).not_to have_content("A matching description about Ruby")
      end
    end
  end
end
