require 'net/http'
class StaticController < ApplicationController
  def index
    redirect_to "http://localhost:3000"
	#render :layout => false
    #@users = User.all(:order => "created_at DESC", :limit => 16)
  end
  def tweet
	if logged_in?
		# shorten url
		bitly = "http://api.bit.ly/v3/shorten?login=nsantorello&apiKey=R_1a8ae61512f06a04c8794075437890ed&longUrl="+params[:r]+"&format=json"
		bitly_response = Net::HTTP.get(URI.parse(bitly))
		short = JSON.parse(bitly_response)
		#if short['status_code'] == "200"
		
		
			# tweet
			user = User.find_by_login(current_user.login)
			
			user.twitter.get('/account/verify_credentials')
			thought = params[:t]
			wordcount = 100
			shortname = (thought.length > wordcount) ? (thought[0..wordcount] + "...") : thought

			user.twitter.post('/statuses/update.json', 'status' => ("#{shortname} - #{short['data']['url']} #shumarks"))
		#end
	end
	redirect_to "http://localhost:3000/remote-result?lid=#{params[:lid]}&uid=#{params[:uid]}&st=true"
  end
  def status
	render :layout => false
  end
  def account
	if logged_in?
		@srv_res = [logged_in?, current_user.profile_image_url, current_user.login]
	else
		@srv_res = [logged_in?]
	end
	@srv_res2 = @srv_res.to_json#render :json => 'parseResponse({"name" : "hello world"});'
	render :layout => false
  end
  def pic
    @users = User.all(:order => "created_at DESC", :limit => 16)

	render :layout => false
  end
  def twitid
	@users = User.all(:order => "created_at DESC", :limit => 16)

	render :layout => false
  end
end
