#This is common lib which will have generic lib methods.


module CommonLib
      
  module ApiHelper
    include LogFactory

    
    def initialize
      @result = {}
      @errors = []
      @api_response = {:code => 0, :result => nil}
          
      @logger = SingletonLogger.get_logger_instance
      @response_codes =
        {
        :success => 200,
        :internal_error => 10,
        :validation_error => 11,
        :insufficient_params => 12,
        :insufficient_headers => 423,
        :user_not_registered => 19,
        :auth_error => 20,
        :incorrect_auth => 21,
        :unauthorized => 22,
        :incorrect_user => 23,
        :incorrect_password => 24,
        :signup_success => 25,
        :signup_failure => 26,
        :change_password_failure => 27,
        :require_signup => 35,
        :already_invited => 41,
        :invalid_parameter => 421,
        :asp_token_not_found => 29,
        :asp_token_time_out => 40,
        :not_found => 404,
        :unauthorized_user => 401

      }
    end

    # Method to check whether the required parameters
    # for the execution of the api are present in the
    # request else it would be erroneous
    def required_params_present(params, * parameters)
      errors = []
      if params.present?
        parameters.each do |param|
          if params[param].blank?
            errors << "#{param.to_s}" if errors.any?
            errors << "parameter missing: #{param.to_s}" if errors.empty?
          end
        end
      else
        errors << "parameters missing"
      end
      [errors.blank? ? true : false, errors]
    end
    
    # Method to check whether the required headers
    # for the execution of the api are present in the
    # request else it would be erroneous
    def validate_headers(headers, * parameters)
      errors = []
      if headers.present?
        parameters.each do |param|
          if headers[param].blank?
            @api_response[:code] = @response_codes['insufficient_headers']
            errors << "#{param.to_s}" if errors.any?
            errors << "header missing: #{param.to_s}" if errors.empty?
          end
        end
      else
        errors << "headers missing"
      end
      [errors.blank? ? true : false, errors]
    end
    
    
    # Method to handle the API exceptions
    def api_exception_handler(exception)
      errors = []
      errors << exception.message
      @api_response[:code] = @response_codes['internal_error']
      # @logger.error "#{Time.now} SESSION_ID:#{session[:session_id]} EXCEPTION IS: #{errors} \n #{exception.backtrace}"
      [errors, @api_response]
    end
   
   
  end
  
end
