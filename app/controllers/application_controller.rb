# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend

  protect_from_forgery with: :exception, unless: -> { request.base_url == "http://paul-carrick.com" }

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :setup_main_menu_items
  before_action :setup_footer_items
  before_action :setup_user

  def after_sign_in_path_for(resource)
    root_path
  end

  private

  def setup_main_menu_items
    @main_menu_items ||= MenuItem.where(parent_id: nil)
                                 .order(:menu_order)
                                 .includes(:sub_items)
                                 .references(:sub_items)
                                 .order("menu_items.menu_order", "sub_items_menu_items.menu_order")

    if user_signed_in?
      @main_menu_items.each do |menu_item|
        next unless menu_item.link == "/users/sign_in"

        menu_item.label = "logout"
        menu_item.link = "/users/sign_out|delete"

        break
      end
    end
  end

  def setup_footer_items
    @footer_items ||= FooterItem.where(parent_id: nil)
                                .order(:footer_order)
                                .includes(:sub_items)
                                .references(:sub_items)
                                .order("footer_items.footer_order", "sub_items_footer_items.footer_order")
  end

  def setup_user
    if @user.present?
      @user = User.find_by(email: 'guest@paul-carrick.com') unless user_signed_in?
    else
      @user = User.find_by(email: 'guest@paul-carrick.com')
    end
  end
end
