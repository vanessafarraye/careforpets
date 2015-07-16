class DonationsController < ApplicationController
  def index
  	@user = current_user || User.new
    @client = Client.find(params[:id])
  	@donations = current_user.donations
    @amount_needed = client.amount_needed
    # @amount = 2500
  end

  def new
  	@user = current_user || User.new
    @client = Client.find(params[:client_id])
    @donation =  Donation.new
    @donation_amount = params[:donation].to_i * 100
    @existing_donations = 0
    donations = @client.donations
    donations.each do |donation|
      @existing_donations += donation.amount
    end
    @amount_needed = @client.amount_needed - @existing_donations
    @amount_needed = 0 if @amount_needed < 0
    @user = current_user || User.new
  end

  def create
    
    begin
      customer = Stripe::Customer.create(
        :email => 'example@stripe.com',
        :card  => params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => params[:donation_amount],
        :description => 'Rails Stripe customer',
        :currency    => 'usd'
      )
    
    rescue Stripe::CardError => e
      flash[:error] = e.message
    end
    current_amount = charge.amount
      current_transaction = rand(1000) #make this the charge.receipt_number
      new_donation = Donation.create(
        :user_id => current_user.id,
        :client_id => params[:client_id],
        :amount => current_amount / 100,
        :transaction_id => current_transaction 
      )

      redirect_to clients_path
  end

  def show
  	@donation = Donation.find(params[:id])
  end

  private
  def donation_params
  	white_list = [
  					:user_id, :client_id,
  					:amount, :transaction_id
  					]
    params.require(:donation).permit(*white_list)
  end

  def set_client_donation
    @donation = current_client.donations.find(params[:id])
  end

  def set_user_donation
    @donation = current_user.donations.find(params[:id])
  end
  
end
