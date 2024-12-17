# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend

  # Only allow modern browsers supporting webp image_files, web push, badges, import maps, CSS nesting, and CSS :has.
  #  allow_browser versions: :modern

  before_action :setup_site
  before_action :setup_main_menu_items
  before_action :setup_footer_items

  def get_site_information
    setup_site unless @site_information.present?

    @site_information
  end

  def set_title(title)
    @title = title
  end

  def get_title
    @title
  end

  def set_current_user(user)
    @application_user = user if Rails.env == 'test' # Only for testing.
  end

  def get_current_user
    @application_user
  end

  def current_user_is_admin?
    signed_in? && @application_user.admin?
  end

  private

  def setup_site
    @site_information = SiteSetup.find_by(configuration_name: 'default')

    unless @site_information.present?
      @site_information = SiteSetup.first

      unless @site_information.present?
        @site_information = SiteSetup.new(configuration_name:    'default',
                                          site_name:             'Example Site',
                                          site_domain:           'example.com',
                                          site_host:             'example.com',
                                          site_url:              'https://example.com',
                                          header_background:     '#0d6efd',
                                          header_text_color:     '#f8f9fa',
                                          footer_background:     '#0d6efd',
                                          footer_text_color:     '#f8f9fa',
                                          container_background:  '#f8f9fa',
                                          container_text_color:  '#000000',
                                          page_background_image: "none",
                                          facebook_url:          nil,
                                          twitter_url:           nil,
                                          instagram_url:         nil,
                                          linkedin_url:          nil,
                                          github_url:            nil,
                                          owner_name:            'Anyone',
                                          copyright:             'Copyright © 2024')
      end
    end

    @title            = @site_information.site_name unless @title.present?
  end

  # TO DO Remove this when we can figure out what's wrong with the devise setup
  # This only seems to affect the test environment
  def signed_in?
    @signed_in = false

    if Rails.env != "test"
      @signed_in = user_signed_in?

      if @signed_in
        @application_user ||= User.find(current_user.id)
      end
    else
      begin
        @signed_in        = user_signed_in?
        @application_user = current_user
      rescue ArgumentError => e
        if e.message == "wrong number of arguments (given 1, expected 2)"
          warden_user       = session["warden.user.user.key"]
          @signed_in        = warden_user[:approved] if warden_user.present?
          @application_user ||= User.find(warden_user[:id])
        else
          raise e
        end
      end
    end

    @application_user ||= User.find_by(email: 'guest@paul-carrick.com')

    @signed_in
  end

  def setup_main_menu_items
    @main_menu_items  ||= MenuItem.where(menu_type: "Main", parent_id: nil)
                                  .order(:menu_order)
                                  .includes(:sub_items)
                                  .references(:sub_items)
                                  .order("menu_items.menu_order", "sub_items_menu_items.menu_order")
    @admin_menu_items ||= MenuItem.where(menu_type: "Admin", parent_id: nil)
                                  .order(:menu_order)
                                  .includes(:sub_items)
                                  .references(:sub_items)
                                  .order("menu_items.menu_order", "sub_items_menu_items.menu_order")
    @footer_items     ||= FooterItem.where(parent_id: nil)
                                    .order(:footer_order)
                                    .includes(:sub_items)
                                    .references(:sub_items)
                                    .order("footer_items.footer_order", "footer_items.footer_order")

    if signed_in?
      @main_menu_items.each do |menu_item|
        next unless menu_item.link&.strip == "/users/sign_in"

        menu_item.label = "logout"
        menu_item.icon  = "/images/no-keys.svg"
        menu_item.link  = "/users/sign_out"
        break
      end

      @footer_items.each do |footer_item|
        footer_item.sub_items.each do |sub_item|
          next unless sub_item.link&.strip == "/users/sign_in"

          sub_item.label = "logout"
          sub_item.icon  = "/images/no-keys.svg"
          sub_item.link  = "/users/sign_out"

          break
        end

        next unless footer_item.link&.strip == "/users/sign_in"

        footer_item.label = "logout"
        footer_item.icon  = "/images/no-keys.svg"
        footer_item.link  = "/users/sign_out"

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
end
