module Utilities
  require "nokogiri"
  require "htmlbeautifier"

  def self.truncate_html(html, max_length)
    # Parse the HTML
    doc = Nokogiri::HTML::DocumentFragment.parse(html)
    truncated_html = ""
    char_count = 0

    doc.traverse do |node|
      break if char_count >= max_length

      if node.text?
        remaining_length = max_length - char_count
        truncated_content = node.content[0, remaining_length]
        truncated_html << Nokogiri::HTML::DocumentFragment.parse(truncated_content).to_html
        char_count += truncated_content.length
      elsif node.element?
        truncated_html << "<#{node.name}#{node.attributes.map { |k, v| " #{k}='#{v}'" }.join}>"
      end
    end

    truncated_doc = Nokogiri::HTML::DocumentFragment.parse(truncated_html)
    truncated_doc.to_html
  end

  def self.pretty_print_json(text, html = true)
    return unless text.present?

    if html
      results = JSON.pretty_generate(JSON.parse(text)).gsub(/^(\s+)/) { |match| "&nbsp;&nbsp;&nbsp;&nbsp;" * (match.size / 2) }

      results.gsub("\n", "<br>")
    else
      JSON.pretty_generate(JSON.parse(text)).gsub(/^(\s+)/) { |match| "    " * (match.size / 2) }
    end
  end

  def self.pretty_print_html(html)
    return unless html.present?

    HtmlBeautifier.beautify(html)
  end
end
