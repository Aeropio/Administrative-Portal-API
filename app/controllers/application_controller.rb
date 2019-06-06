# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
    include ActionController::MimeResponds

  include CommonLib::LogFactory

  include Response
  include ExceptionHandler

  # called before every action on controllers
  before_action :authorize_request
  attr_reader :current_user

  private

  # Check for valid request token and return user
  def authorize_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end
   # Method to create a response to api requests
  def send_response(api_response, errors)
    api_response = create_response(api_response, errors)

    respond_to do |format|
      @logger.info "#{Time.now} INFO   ###  #{request.path}  ###"
      if errors.length > 0
        @logger.info "#{Time.now} EXCEPTION is: #{errors}"
      end
      if request.host == 'localhost'
        @logger.info "#{Time.now} response:#{api_response}"
      end
     #TODO: Disable it later, enabled for now only
      if Rails.env == "production"
        @logger.info "#{Time.now} INFO  ###  #{api_response}  ###"
      end
      format.html {
        
      }
      format.json {        
        render :json => api_response.to_json, :callback => params[:callback], :content_type => "text/html"
      }
      format.js {
       
      }
      format.xml { 
        @logger.info "#{Time.now} #{api_response}"
        render :xml => api_response
      }
    end
  end
  
  # Method that creates api_response
  def create_response(api_response, errors)
    Rails.logger.error "#{Time.now} ERRORS: #{errors}"
    api_response[:code] = 99 if errors.length >= 1
    unless errors.empty?
      long_error = ""
      errors.each do |error|
        long_error += "#{error} "
      end
      api_response[:result] = long_error
    end
    return api_response
  end
  
  def action_missing(m)
    Rails.logger.error(m)
    render "#{Rails.root}/public/404"
    # or render/redirect_to somewhere else
  end

  def encode(id)
    Digest::SHA2.hexdigest(id.to_s)
  end

  def decode(id)
    Digest::SHA2.hexdigest(id)
  end

  def display_error_page
    render :file => "public/404.html"
  end
end