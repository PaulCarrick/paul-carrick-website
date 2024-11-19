# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :setup_main_menu_items

  private

  def setup_main_menu_items
    @main_menu_items ||= MenuItem.where(parent_id: nil)
                                 .order(:menu_order)
                                 .includes(:sub_items)
                                 .references(:sub_items)
                                 .order("menu_items.menu_order", "sub_items_menu_items.menu_order")
  end
end
