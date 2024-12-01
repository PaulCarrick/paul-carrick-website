module ApplicationHelper
  def sortable_column(display_name, column, model_path_name, custom_class: "text-dark text-decoration-none")
    # Determine the current sort direction for the column
    current_direction = (params[:sort] == column && params[:direction] == "asc") ? "desc" : "asc"

    # Choose the arrow based on the current direction
    arrow = if params[:sort] == column
              params[:direction] == "asc" ? "↓" : "↑"
            else
              "↓↑"
            end

    # Generate the dynamic path helper (e.g., admin_blogs_path)
    path_helper = "admin_#{model_path_name}_path"
    path = send(path_helper, sort: column, direction: current_direction)

    # Generate the sortable link with the arrow
    link_to "#{display_name} #{arrow}".html_safe, path, class: custom_class
  end

  def action_links(resource, edit_path, delete_path = nil)
    delete_path ||= resource
    content_tag(:div, class: "action-links") do
      [
        link_to("Edit",
                edit_path,
                class: "btn-link me-2"),
        link_to("Delete",
                delete_path,
                method: :delete,
                data: { confirm: "Are you sure?" },
                class: "btn-link",
                style: "color: red")
      ].join.html_safe
    end
  end
end
