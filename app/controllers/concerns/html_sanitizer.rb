module HtmlSanitizer
  extend ActiveSupport::Concern

  private

  require "nokogiri"

  def sanitize_html(html_string)
    # Parse the HTML string with Nokogiri
    doc = Nokogiri::HTML::DocumentFragment.parse(html_string)

    # Allowed tags
    allowed_tags = %w[br p a b i h1 h2 h3 h4 h5 div section button title li ul ]

    # Traverse through the nodes
    doc.traverse do |node|
      # If the node is an element and not in the allowed tags, remove it
      if node.element? && !allowed_tags.include?(node.name)
        node.replace(node.content) # Replace the tag with its text content
      end
    end

    # Return the sanitized HTML as a string
    doc.to_html
  end
end
