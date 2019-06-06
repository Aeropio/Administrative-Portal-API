# app/controllers/users_controller.rb
class UsersController < ApplicationController
  # POST /signup
  # return authenticated token upon signup
  	include CommonLib::ApiHelper

   skip_before_action :authorize_request, only: [:create, :disable_user_from_login]

# Provide the ability to create a new user.
  def create
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    response = { message: Message.account_created, auth_token: auth_token }
    @api_response[:code] = @response_codes[:success]
      @api_response[:result] = response

    rescue Exception => e
      @errors, @api_response = api_exception_handler(e)
    ensure
      send_response(@api_response, @errors)
    #json_response(response, :created)
  end

  #Provide the ability to delete a user.
  def delete_user
    user = User.where(email: user_params[:email]).first
    response = user.destroy
    @api_response[:code] = @response_codes[:success]
    @api_response[:result] = response

    rescue Exception => e
      @errors, @api_response = api_exception_handler(e)
    ensure
      send_response(@api_response, @errors)
  end

  # Provide the ability to access all the users.
  def all_users
    all_users = User.all
    @api_response[:code] = @response_codes[:success]
    @api_response[:result] = all_users
  rescue Exception => e
      @errors, @api_response = api_exception_handler(e)
  ensure
    #send the response back to the user
    send_response(@api_response, @errors)
  end

  #• Provide the ability to edit the user information (Email address should not be allowed to be
# editable). # name should be editable 
  def update
    user = User.where(email: user_params[:email]).first
    if user.present?
      user.update_attributes(user_params)
      @api_response[:code] = @response_codes[:success]
      @api_response[:result] = "User Updated"
    else
      @api_response[:code] = @response_codes[:success]
      @api_response[:result] = "User Does not exist"
    end
    rescue Exception => e
      @errors, @api_response = api_exception_handler(e)
    ensure
    #send the response back to the user
    send_response(@api_response, @errors)
  end

  # Provide the ability to disable a user.
  # TODO

  #• Allow for sorting on fields.
  def sort_on_a_field
      @users = User.order(sort_column + " " + sort_direction)
      @api_response[:code] = @response_codes[:success]
      @api_response[:result] = @users
    rescue Exception => e
        @errors, @api_response = api_exception_handler(e)
    ensure
      #send the response back to the user
      send_response(@api_response, @errors)
  end

  #• Allow for filtering on fields.
  def filter_on_fields
    @users = User.where(nil)
    filtering_params(params).each do |key, value|
      @users = @users.public_send(key, value) if value.present?
    end
    @api_response[:code] = @response_codes[:success]
    @api_response[:result] = @users
    rescue Exception => e
        @errors, @api_response = api_exception_handler(e)
    ensure
      #send the response back to the user
    send_response(@api_response, @errors)

  end

  #• Allow tags to be added and removed on each user. A user can have multiple tags.
  def user_tags
   @user = User.where(id: user_params[:id]).first
   response = "User not found with this id"
   if user_params[:add_tag] == "true"# add_tag is present in params and is true
    # add a new tag to the user 
     tag = Tag.create(name: user_params[:tag_name], User_id: user_params[:id])
     response = "tag added to user"
    
   else #:add_tag is not present , so delete the tag (for the passed in tag name)
      # remove a tag 
      tag = Tag.where(name: user_params[:tag_name], User_id: user_params[:id])
      # remove tag for that user
      if tag.present?
        @user.tags.delete(tag)
        response = "tag deleted for this user"
      else
        response = "No tag found"
      end
      
   end
    @api_response[:code] = @response_codes[:success]
    @api_response[:result] = response
    rescue Exception => e
        @errors, @api_response = api_exception_handler(e)
    ensure
      #send the response back to the user
    send_response(@api_response, @errors)

  end

  #• Provide the ability to disable a user.
  def disable_user_from_login
    user = User.where(id: user_params[:id]).first
    response = ""
    if user.present?
      response = user.update(disable: true);
    else
      response = "No User Found"
    end
    @api_response[:code] = @response_codes[:success]
    @api_response[:result] = response
    rescue Exception => e
        @errors, @api_response = api_exception_handler(e)
    ensure
      #send the response back to the user
    send_response(@api_response, @errors)
  end

  private

  def user_params
    params.permit(
      :name,
      :id,
      :email,
      :password,
      :password_confirmation,
      :direction,
      :add_tag,
      :tag_id,
      :tag_name
    )
  end

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def filtering_params(params)
    params.slice(:name, :email)
  end

end
