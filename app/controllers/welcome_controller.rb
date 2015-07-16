class WelcomeController < ApplicationController

	def index
		@donations = Donation.all
  	@clients = Client.all
  	@user = current_user || User.new
    @all_donations = []
    @clients.each do |client|
      donations = client_donations(client)
     	@all_donations[client.id] = donations
    end
  end

  private
  def client_donations client
    donations = 0
    client.donations.each do |donation|
      donations += donation.amount
    end
    donations
  end
end
