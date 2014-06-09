require 'spec_helper'

feature "Creating Tickets" do 
	before do  
		project = FactoryGirl.create(:project, name: "Internet Explorer")
		user = FactoryGirl.create(:user, :email => 'sample@example.com')
		define_permission!(user, "view", project)
		define_permission!(user, "create tickets", project)
		sign_in_as!(user)
		visit '/'
		click_link project.name
		click_link "New Mticket"		
	end

	scenario "Creating a ticket" do  
		fill_in "Title", with: "Non-standars compliance"
		fill_in "Description", with: "My pages are ugly!"
		click_button "Create Mticket"		

		expect(page).to have_content("Ticket has been created.")

		within "#mticket #author" do
			expect(page).to have_content("Created by sample@example.com")
		end
	end

	scenario "Creating a ticket without valid attributes fails" do  
		click_button "Create Mticket"

		expect(page).to have_content("Ticket has not been created.")
		expect(page).to have_content("Title can't be blank")
		expect(page).to have_content("Description can't be blank")
	end
	scenario "Description must be longer than 10 characters" do
		fill_in "Title", with: "Non-standards compliance"
		fill_in "Description", with: "it sucks"
		click_button "Create Mticket"
		expect(page).to have_content("Ticket has not been created.")
		expect(page).to have_content("Description is too short")
	end
end