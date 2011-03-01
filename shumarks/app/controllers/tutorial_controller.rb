# This controller handles the tutorial that you go through after registering.
class TutorialController < ApplicationController
  before_filter :login_required
  before_filter :hide_sidebar
  
  def example_for(username)
    return TutorialExample.find(:first, :conditions => { :username => username})
  end
  
  def start
  end
  
  def step1
  end
  
  def step2
  end
  
  def completed
  end
  
  def example
    examp = example_for(current_user.login)
    completed = examp != nil
    
    render :json => completed
    
    examp.destroy() if completed
  end
  
end
