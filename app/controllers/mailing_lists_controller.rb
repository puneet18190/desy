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
    @mlg = MailingListGroup.find(params[:group_id])
    mla.group_id = @mlg.id
    mla.heading = params[:heading]
    mla.email = params[:email]
    if mla.save
      @saved = true
    else
      @errors = true
    end
    render 'update_addresses'
  end
  
  def update_group
    @mlg = MailingListGroup.find(params[:id])
    last_name = @mlg.name
    if @mlg.update_attributes(name: params[:name])
      @saved = true
    else
      @mlg.name = last_name
      @errors = true
    end
  end
  
  def delete_group
    mlg = MailingListGroup.find(params[:id])
    mlg.destroy
    
    render 'update_list'
  end
  
  def delete_address
    mla = MailingListAddress.find(params[:id])
    @mlg = MailingListGroup.find(mla.group_id)
    mla.destroy
    
    render 'update_addresses'
  end
  
  def get_emails
    @emails = MailingListAddress.get_emails(current_user.id, params[:term])
    render :json => @emails
  end
  
  
end
