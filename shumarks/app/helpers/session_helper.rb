module SessionHelper
  
  def internal_session()
    if session[:internal_session_id] 
      Session.find_by_id(session[:internal_session_id])
    else
      internal_session = Session.new(
        :ruby_session_id => session[:session_id], 
        :referrer => request.referrer,
        :user_agent => request.env['HTTP_USER_AGENT'],
        :client_ip => request.remote_ip
      )
      internal_session.save()
      session[:internal_session_id] = internal_session.id
      internal_session
    end
  end

end