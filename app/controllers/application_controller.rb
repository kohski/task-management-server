class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  def response_success(class_instance = "")
    render(
      status: 200,
      json:{
        status: 200,
        message: "Success #{class_instance == "" ? "" : class_instance.class}",
        data: class_instance
      }
    )
  end

  def response_created(class_instance)
    render(
      status: 201,
      json:{
        status: 201,
        message: "Created #{class_instance.class.to_s}",
        data: class_instance
      }
    )
  end

  def response_bad_request(class_instance)
    render(
      status: 400,
      json: {
        status: 400,
        message: "Bad Request",
        data: class_instance.nil? ? class_instance : class_instance.errors.full_messages
      }
    ) 
  end

  def response_bad_request_with_notes(class_instance, notes)
    render(
      status: 400,
      json: {
        status: 400,
        message: "Bad Request",
        data: class_instance.nil? ? class_instance : class_instance.errors.full_messages,
        notes: notes
      }
    ) 
  end

  def response_not_found(class_instance)  
    render(
      status: 404,
      json: { 
        status: 404,
        message: "#{class_instance.class} Not Found",
        data: class_instance.nil?  || class_instance.empty? ? class_instance : class_instance.errors.full_messages
      }      
    )
  end

  def response_not_found_with_notes(class_instance,notes)  
    render(
      status: 404,
      json: { 
        status: 404,
        message: "#{class_instance.class} Not Found",
        data: nil,
        notes: notes
      }      
    )
  end

end
