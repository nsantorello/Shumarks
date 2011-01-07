module BookmarkletHelper
  def shumarklet_url()
    "javascript:t=document.createElement('script');" + 
    "t.type='text/javascript';document.body.appendChild(t);" + 
    "t.src='http://#{ENV['hostname']}/javascripts/jquery-1.4.2.min.js';" +
    "t.id='shumarks-jquery-js';" + 
    "t=document.createElement('script');" + 
    "t.type='text/javascript';" +
    "document.body.appendChild(t);" +
    "t.src='http://#{ENV['hostname']}/bm/#{current_user.salt}';t.id='shumarks-js';void(0);"
  end
end