module ApplicationHelper
  require 'nokogiri'
  include Pagy::Frontend

  def truncate_html(html, max_length)
    # Parse the HTML
    doc = Nokogiri::HTML::DocumentFragment.parse(html)

    # Initialize a counter and a truncated HTML string
    truncated_html = ''
    char_count = 0

    # Traverse nodes recursively
    doc.traverse do |node|
      break if char_count >= max_length

      if node.text?
        # If the node is a text node, truncate its content if needed
        remaining_length = max_length - char_count
        truncated_content = node.content[0, remaining_length]
        truncated_html << Nokogiri::HTML::DocumentFragment.parse(truncated_content).to_html
        char_count += truncated_content.length
      elsif node.element?
        # If the node is an element, add the opening tag and recurse
        truncated_html << "<#{node.name}#{node.attributes.map { |k, v| " #{k}='#{v}'" }.join}>"
      end
    end

    # Close any open tags to ensure valid HTML
    truncated_doc = Nokogiri::HTML::DocumentFragment.parse(truncated_html)
    truncated_doc.to_html
  end

  def sortable_column(display_name, column)
    # Determine the current sort direction for the column
    current_direction = (params[:sort] == column && params[:direction] == "asc") ? "desc" : "asc"

    # Choose the arrow based on the current direction
    arrow = if params[:sort] == column
      params[:direction] == "asc" ? "↓" : "↑"
    else
      "" # No arrow if the column is not sorted
    end

    # Generate the sortable link with the arrow
    link_to "#{display_name} #{arrow}".html_safe,
            admin_blogs_path(sort: column, direction: current_direction),
            class: "text-dark text-decoration-none"
  end

  def action_links(resource, edit_path, delete_path = nil)
    delete_path ||= resource
    content_tag(:div, class: "action-links") do
      [
        link_to("Edit",
                edit_path,
                class: "btn btn-sm btn-primary me-2",
                style: "max-height: 2em;"),
        link_to("Delete",
                delete_path,
                method: :delete,
                data: { confirm: "Are you sure?" },
                class: "btn btn-sm btn-danger",
                style: "max-height: 2em;")
      ].join.html_safe
    end
  end
end
