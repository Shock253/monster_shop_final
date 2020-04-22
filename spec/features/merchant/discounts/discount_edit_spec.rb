require "rails_helper"

RSpec.describe "Bulk discount index page" do
  describe "As a Merchant user" do
    before :each do
      @merchant_1 = Merchant.create!(
        name: 'Megans Marmalades',
        address: '123 Main St',
        city: 'Denver',
        state: 'CO',
        zip: 80218)
      @merchant_user = @merchant_1.users.create(
        name: 'Megan',
        address: '123 Main St',
        city: 'Denver',
        state: 'CO',
        zip: 80218,
        email: 'megan@example.com',
        password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
    end

    context "when I visit a discount edit page" do
      it "I see all the existing info, change it, and submit it and see those changes reflected" do
        discount1 = @merchant_1.discounts.create!(name: "Family size discount", threshold: 10, percent: 10)

        visit "/merchant/discounts/#{discount1.id}/edit"


        expect(find_field("Name").value).to eq("Family size discount")
        expect(find_field("Threshold").value).to eq("10")
        expect(find_field("Percent").value).to eq("10")

        fill_in 'Name', with: "Party size discount"

        click_button "Update Discount"

        expect(current_path).to eq("/merchant/discounts")

        within "#discount-#{discount1.id}" do
          expect(page).to have_content("Party size discount")
        end
      end

      it "if I put in invalid information into the form, I get a flash message telling me what went wrong" do
        visit "/merchant/discounts/new"

        fill_in 'Percent', with: "300"
        fill_in 'Threshold', with: "yeet"
        click_button 'Create Discount'
        expect(current_path).to eq("/merchant/discounts")


        expect(page).to have_content("percent: [\"must be less than 100\"]")
        expect(page).to have_content("threshold: [\"is not a number\"]")
      end
    end
  end
end

# **User Story 4: Bulk Discount Editing**
# - As a Merchant User
# - When I visit my Bulk Discount index page
# - I see a link to edit a discount next to that discount's name
# - When I click that link
# - I am directed to a Bulk Discount edit page, where I see a form with the current information for the Bulk Discount
# - When I fill out the form with new information and click the submit button
# - I am redirected to the Bulk Discount index page and I see those changes reflected
