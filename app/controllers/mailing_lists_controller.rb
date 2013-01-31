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
  
  def update_group
    @mlg = params[:mailing_list_group]
  end
  
  def delete_group
    @mlg = MailingListGroup.find(params[:id])
    @mlg.destroy
    render 'update_list'
  end
  
end
