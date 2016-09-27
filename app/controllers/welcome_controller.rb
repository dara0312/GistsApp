class WelcomeController < ApplicationController
  include WelcomeHelper

  def index
  end

  def collect
    # api GET /gists/pubic
    gh = Ghee.access_token(TOKEN["access_token"])
    g = gh.gists.public(params[:id])

    @h = g.headers
    @parsed = g.body
    # pagination
    p = JSON.parse getPages(g.headers["Link"])
    puts g.headers["Link"]
    #puts p.inspect
    @current_page = params[:id].nil? ? 1 : params[:id]
    @next_page = p["next"].nil? ? 1 : p["next"]
    @last_page = p["last"].nil? ? 0 : p["last"]
    @first_page = p["first"].nil? ? 0 : p["first"]
    @prev_page = p["prev"].nil? ? @last_page : p["prev"]
    puts @current_page
  end

  def categories_home
  end

  def categories
    @name = params[:name] ? params[:name] : ""
    @id = params[:id] ? params[:id] : ""
    url = "https://gist.github.com/"
    u = @id ? url + @name + "?page=" + @id : url + @name
    json = parseUrl(u)
    @categories = json["data"]
    @page = json["pagination"]
  end

  def search
    @s = params[:w] == "" ? "No word" : params[:w]
    @info = params[:info]
    @h = {}
    @parsed = {}
    if @s != nil and @s != "No word"
      gh = Ghee.access_token(TOKEN["access_token"])
      g = gh.gists.user(@s, @info)
      puts g.body
      @h = g.headers
      @parsed = g.body
    end
  end

  def searchpost
    s = params[:s]
    i = params[:info]
    redirect_to :action => "search", :w => s, :info => i
  end

end
