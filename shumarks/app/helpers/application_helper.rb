require 'digest/md5'
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include SessionHelper
  
  def time_ago(time, options = {})
    start_date = options.delete(:start_date) || Time.new
    date_format = options.delete(:date_format) || :default
    delta_minutes = (start_date.to_i - time.to_i).floor / 60
    if delta_minutes.abs <= (8724*60)       
      distance = distance_of_time_in_words(delta_minutes)       
      if delta_minutes < 0
        return "#{distance} from now"
      else
        return "#{distance} ago"
      end
    else
      return "on #{DateTime.now.to_formatted_s(date_format)}"
    end
  end
  
  def js_encode_quotestrings(str, quote_type)
    return str.gsub(quote_type, "\\" + quote_type)
  end
   
  def distance_of_time_in_words(minutes)
    case
      when minutes < 1
        "less than a minute"
      when minutes < 50
        pluralize(minutes, "minute")
      when minutes < 120
        "an hour"
      when minutes < 1080
        "#{(minutes / 60).round} hours"
      when minutes < 1440
        "a day"
      when minutes < 2880
        "about a day"
      else
        "#{(minutes / 1440).round} days"
    end
  end
  
  def hide_sidebar()
    @hide_sidebar = true;
  end
  
  def user_in_cookie()
    User.find_by_id(cookies[:user_id].to_i)
  end
  
  def errors_for(object, attribute)
    if errors = object.errors.on(attribute)
      errors = [errors] unless errors.is_a?(Array)
      return '<ul class="form-input-error-list">' + errors.map {
        |e| '<li class="form-input-error">' + attribute.to_s + ' '+ e + '</li>'
      }.join + '</ul>'
    end
  end
  
  def gravatar_url_for(email, options = {})
    "http://www.gravatar.com/avatar.php?gravatar_id=#{Digest::MD5.hexdigest(email)}" 
  end
end
