require 'rails_helper'

RSpec.describe Admin::DashboardController, type: :controller do
  let(:admin_user) { create(:user, admin: true) }
  let(:non_admin_user) { create(:user, admin: false) }

  describe "GET #index" do
    context "when the user is logged in as an admin" do
      before do
        sign_in admin_user, scope: :user
      end

      it "allows access and renders the index template" do
        # TO DO Find a fix for devise.
      end
    end

    context "when the user is logged in but not an admin" do
      before do
        sign_in non_admin_user, scope: :user
      end

      it "redirects to the root path with an alert" do
        # TO DO Find a fix for devise.
      end
    end

    context "when the user is not logged in" do
      it "redirects to the login page" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
