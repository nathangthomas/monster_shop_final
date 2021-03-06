require 'rails_helper'

RSpec.describe 'User Registration' do
  describe 'As a Visitor' do
    it 'I see a link to register as a user' do
      visit root_path

      click_link 'Register'

      expect(current_path).to eq(registration_path)
    end

    it 'I can register as a user' do
      visit registration_path
      fill_in 'Name', with: 'Megan'
      fill_in 'Street address', with: '123 Main St'
      fill_in 'City', with: 'Denver'
      fill_in 'State', with: 'CO'
      fill_in 'Zip', with: '80218'
      fill_in 'Email', with: 'megan@example.com'
      fill_in 'Password', with: 'securepassword'
      fill_in 'Password confirmation', with: 'securepassword'
      click_button 'Register'

      #expect(user.address.address_type).to eq(0)
      expect(current_path).to eq(profile_path)
      expect(page).to have_content('Welcome, Megan!')
    end

    describe 'I can not register as a user if' do
      it 'I do not complete the registration form' do
        visit registration_path

        fill_in 'Name', with: 'Megan'
        click_button 'Register'

        expect(page).to have_button('Register')

        # expect(page).to have_content("street address: [\"can't be blank\"]")
        # expect(page).to have_content("city: [\"can't be blank\"]")
        # expect(page).to have_content("state: [\"can't be blank\"]")
        # expect(page).to have_content("zip: [\"can't be blank\"]")
        expect(page).to have_content("email: [\"can't be blank\"]")
        expect(page).to have_content("password: [\"can't be blank\"]")
      end

      it 'I use a non-unique email' do
        user = User.create!(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
        user_address = user.addresses.create!(street_address: '123 user lives here', city: 'Denver', state: 'CO', zip: 80301)

        visit registration_path
        fill_in 'Name', with: user.name
        fill_in 'Street address', with: user_address.street_address
        fill_in 'City', with: user_address.city
        fill_in 'State', with: user_address.state
        fill_in 'Zip', with: user_address.zip
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        fill_in 'Password confirmation', with: user.password
        click_button 'Register'

        expect(page).to have_button('Register')
        expect(page).to have_content("email: [\"has already been taken\"]")
      end
    end
  end
end
