# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend

  # Only allow modern browsers supporting webp image_files, web push, badges, import maps, CSS nesting, and CSS :has.
  #  allow_browser versions: :modern

  before_action :setup_site
  before_action :setup_main_menu_items
  before_action :setup_footer_items
  before_action :setup_user

  private

  def setup_site
    @site_information = SiteSetup.find_by(configuration_name: 'default')

    unless @site_information.present?
      @site_information = SiteSetup.first

      unless @site_information.present?
        @site_information = SiteSetup.new(configuration_name: 'default',
                                          site_name:          'Paul Carrick',
                                          site_domain:        'paul-carrick.com',
                                          site_host:          'paul-carrick.com',
                                          site_url:           'https://paul-carrick.com',
                                          facebook_url:       'https://www.facebook.com/paul.j.carrick',
                                          twitter_url:        'https://x.com/PaulJCarrick',
                                          instagram_url:      'https://www.instagram.com/pauljcarrick/',
                                          linkedin_url:       'https://www.linkedin.com/in/pauljcarrick/',
                                          github_url:         'https://github.com/PaulCarrick',
                                          owner_name:         'Paul Carrick',
                                          copyright:          'Copyright © 2024 Paul Carrick all rights reserved')
      end
    end

    @title = @site_information.site_name
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

    if user_signed_in?
      @main_menu_items.each do |menu_item|
        next unless menu_item.link == "/users/sign_in"

        menu_item.label = "logout"
        menu_item.link  = "/users/sign_out|delete"

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
    @user = if user_signed_in?
              user = User.find_by(email: current_user.email)

              user.as_json.merge(logged_in: true) if user.present?
            else
              user = User.find_by(email: 'guest@paul-carrick.com')

              user.as_json if user.present?
            end
  end
end
