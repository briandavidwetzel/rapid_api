class BrickService < RapidApi::Services::BaseService

  def without_errors
    return_value params[:value]
  end

  def with_errors
    add_error params[:key], params[:message]
  end

end
