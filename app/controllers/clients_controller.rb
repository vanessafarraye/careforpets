class ClientsController < ApplicationController
  # before_action :set_user_client, only: [:edit, :update, :destroy]
  def index
  	@clients = Client.all
  	@user = current_user || User.new
    @all_donations = []
    @clients.each do |client|
      donations = client_donations(client)
      @all_donations[client.id] = donations
    end
  end

  def new
    @client = Client.new
  end

  def create
    client_params = params.require(:client).permit(:name, :age, :story, :owners_name, :photo_url, :amount_needed, :user_id, :date_expect)
    @client = Client.new(client_params)
    if @client.save
      redirect_to clients_path
    else
      redirect_to new_client_path
    end
  end


  def show
  	@client = Client.find(params[:id])
    @existing_donations = 0
    donations = @client.donations
    donations.each do |donation|
      @existing_donations += donation.amount
    end
    @amount_needed = @client.amount_needed - @existing_donations
    @amount_needed = 0 if @amount_needed < 0
  	@user = current_user || User.new
    
  end

  def edit
    @client = Client.find(params[:id])
    # if @client.user_id == current_user.id
    #   render :edit
    # else
    #   redirect_to clients_path # add a flash message
    # end
  end

  def update
    @client = Client.find(params[:id])
    if @client.update_attributes(client_params)
        redirect_to clients_path
    else
      redirect_to edit_client_path(@client)
    end    
  end

  def destroy
    @client = Client.find(params[:id])
    @client.destroy
    redirect_to clients_path

  end

  private
  def client_params 
    white_list = [
            :name, :age, :date_expect,
            :owners_name, :photo_url,
            :story, :amount_needed, :user_id
            ]
    params.require(:client).permit(*white_list)
  end
  
  def client_donations client
    donations = 0
    client.donations.each do |donation|
      donations += donation.amount
    end
    donations
  end
end
