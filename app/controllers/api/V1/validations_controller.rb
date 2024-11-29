# frozen_string_literal: true

# app/controllers/api/validations_controller.rb
module Api
  module V1
    skip_before_action :verify_authenticity_token # Allow API requests without CSRF tokens

    def validate_html
      @results = false
      html = params[:html]
      errors = []

      # Validate HTML
      begin
        if html.present?
          begin
            # Parse the HTML
            Nokogiri::HTML::Document.parse(html_string) do |config|
              config.strict # Enables strict parsing for validation
            end

            @results = true
          rescue Nokogiri::XML::SyntaxError => e
            @results = false
          end
        else
          @results = true
        end
      rescue => e
        @results = false

        errors << e.message
      end

      # Return validation result
      if errors.any?
        render json: { valid: false, errors: errors }, status: :unprocessable_entity
      else
        render json: { valid: @results }, status: :ok
      end
    end
  end
end
