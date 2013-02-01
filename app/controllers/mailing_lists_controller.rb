class MailingListsController < ApplicationController
  
  skip_before_filter :authenticate, only: [:create, :confirm, :request_reset_password, :reset_password]
  before_filter :initialize_layout, :only => [:edit, :subjects, :statistics, :mailing_lists]
  layout 'prelogin', only: [:create, :request_reset_password]

  def create_group
    @mlg = MailingListGroup.new
    @mlg.user = current_user
    @mlg.save
    
    render 'update_list'
  end
  
  def create_address
    mla = MailingListAddress.new
    @mlg = MailingListGroup.find(params[:mailing_list_group_id])
    mla.mailing_list_group_id = @mlg.id
    mla.heading = params[:heading]
    mla.email = params[:email]
    mla.save
    
    render 'update_addresses'
  end
  
  def update_group
    @mlg = MailingListGroup.find(params[:id])
    @mlg.update_attributes(name: params[:name])
  end
  
  def delete_group
    mlg = MailingListGroup.find(params[:id])
    mlg.destroy
    
    render 'update_list'
  end
  
  def delete_address
    mla = MailingListAddress.find(params[:id])
    @mlg = MailingListGroup.find(mla.mailing_list_group_id)
    mla.destroy
    
    render 'update_addresses'
  end
  
  def get_emails
    @email = MailingListGroup.joins(:user,:addresses).select(:email).where(user_id: current_user.id)
    render :json => @emails
  end
  
  
end
