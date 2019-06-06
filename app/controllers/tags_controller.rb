class TagsController < ApplicationController

  include CommonLib::ApiHelper

  def new
  end
  #• Provide the ability to create a new tag
  def create
    tag = Tag.create!(tag_params)
    
    @api_response[:code] = @response_codes[:success]
    @api_response[:result] = tag

    rescue Exception => e
      @errors, @api_response = api_exception_handler(e)
    ensure
      send_response(@api_response, @errors)
  end

  def update
  end

  #• Provide the ability to edit a tag.
  def edit
    tag = Tag.where(User_id: tag_params[:User_id]).first
    if tag.present?
      tag.update_attributes(tag_params)
      @api_response[:code] = @response_codes[:success]
      @api_response[:result] = "tag Updated"
    else
      @api_response[:code] = @response_codes[:success]
      @api_response[:result] = "tag Does not exist"
    end
    rescue Exception => e
      @errors, @api_response = api_exception_handler(e)
    ensure
    #send the response back to the user
    send_response(@api_response, @errors)
  end

  #• Provide the ability to delete a tag.
  def destroy
    tag = Tag.where(User_id: tag_params[:User_id]).first

    if tag.present?
      response = tag.destroy
    else
      response = "Tag not found"
    end
    @api_response[:code] = @response_codes[:success]
    @api_response[:result] = response
    rescue Exception => e
      @errors, @api_response = api_exception_handler(e)
    ensure
    #send the response back to the user
    send_response(@api_response, @errors)

  end

#• Provide the ability to access all tags.
  def index
    all_tags = Tag.all
    @api_response[:code] = @response_codes[:success]
    @api_response[:result] = all_tags
  rescue Exception => e
      @errors, @api_response = api_exception_handler(e)
  ensure
    #send the response back to the user
    send_response(@api_response, @errors)
  end

  #• Allow for sorting on fields.
  def sort_on_a_field
      @tags = Tag.order(sort_column + " " + sort_direction)
      @api_response[:code] = @response_codes[:success]
      @api_response[:result] = @tags
    rescue Exception => e
        @errors, @api_response = api_exception_handler(e)
    ensure
      #send the response back to the user
      send_response(@api_response, @errors)
  end

  def show
  end

  private 

  def tag_params
    params.permit(
      :name,
      :User_id
    )
  end

  def sort_column
    Tag.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end


end
