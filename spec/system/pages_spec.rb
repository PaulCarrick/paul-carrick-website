require 'rails_helper'

# This tests the React Code
RSpec.describe "Pages", type: :system do
  let!(:site_setup) { create(:site_setup) }
  let!(:text_page) { create(:page, name: "text_page", section: "text_page", title: "Text Page") }
  let!(:html_page) { create(:page, name: "html_page", section: "html_page", title: "HTML Page") }
  let!(:text_left) { create(:page, name: "text_left_page", section: "text_left", title: "Text Left Page") }
  let!(:text_section) { create(:section, :plain_text) }
  let!(:html_section) { create(:section, :plain_html) }
  let!(:text_left_section) { create(:section, :text_left) }
  let!(:paul_transparent) { create(:image_file, :paul_transparent) }

  before do
    if ENV["DEBUG"].present?
      driven_by(:selenium_chrome)
    else
      driven_by(:selenium_chrome_headless)
    end
  end

  describe "Renders a text Page" do
    before { visit page_path("text_page") }

    it "displays the text page correctly" do
      expect(page).to have_content(text_section.description)
    end
  end

  describe "Renders a html Page" do
    before { visit page_path("html_page") }

    it "displays the html page correctly" do
      rendered_html            = page.evaluate_script('document.querySelector(".col-12").innerHTML').strip
      expected_html            = "<div>#{html_section.description.strip}</div>"
      rendered_html_normalized = Nokogiri::HTML.fragment(rendered_html).to_html
      expected_html_normalized = Nokogiri::HTML.fragment(expected_html).to_html

      expect(rendered_html_normalized).to eq(expected_html_normalized)
    end
  end

  describe "Renders a text left Page" do
    before { visit page_path("text_left_page") }

    it "displays the text left page correctly" do
      rendered_html            = page.evaluate_script('document.querySelector(".col-8").innerHTML').strip
      expected_html            = "<div>#{text_left_section.description.strip}</div>"
      rendered_html_normalized = Nokogiri::HTML.fragment(rendered_html).to_html
      expected_html_normalized = Nokogiri::HTML.fragment(expected_html).to_html
      expect(rendered_html_normalized).to eq(expected_html_normalized)
      expect(page).to have_css('img.img-fluid')
    end
  end
end
