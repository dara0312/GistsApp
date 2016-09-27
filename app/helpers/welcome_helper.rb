module WelcomeHelper
  
  def getPage(url)
    uri = URI.parse(url)
    uri_params = CGI.parse(uri.query)
    return uri_params["page"].first
  end

  def getPages(url)
    pattern = /<(.*)>;\s+rel="(.*)"/
    matches = {}
    url.split(',').each do |m|
      match = pattern.match m
      uri = URI.parse(match[1])
      uri_params = CGI.parse(uri.query)
      page = uri_params["page"].first.to_i
      matches[match[2].to_sym] = page
    end
    return matches.to_json
  end

  def parseUrl(url)
    puts url
    json = Jsonify::Builder.new(:format => :pretty)
    @lists = []
    @lpagination = []
    page = Nokogiri::HTML(RestClient.get(url))
    g = page.css("div.gist-snippet")
    for i in 0 .. g.length - 1 do
      lists_gists = g.css("div.gist-snippet-meta")[i]
      avatar = lists_gists.css("div.byline").css("span.creator").css("img")
      creator = lists_gists.css("div.byline").css("span.creator").css("a")
      login = avatar[0]["alt"].gsub(/@/, '')
      file = login == "anonymous" ? creator[0].css("strong") : creator[1].css("strong")
      lien_github = login != "anonymous" ? "https://gist.github.com/#{login}" : ""
      filename = file.text
      lien_filename = login == "anonymous" ? "https://gist.github.com#{creator[0]["href"]}" : "https://gist.github.com#{creator[1]["href"]}"
      hour = lists_gists.css("div.byline").css("div.extra-info").css("time-ago")
      create_at = hour[0]["datetime"]
      com = lists_gists.css("div.byline").css("span.description")
      description = com.text.gsub(/\n */, '')
      n_com = lists_gists.css("ul.gist-count-links").css("li")[2].css("a")
      n_comment = n_com.text.gsub(/\n */, '')
      @lists.push(@gists = Struct.new(:avatar, :login, :github, :filename, :lien_filename, :create_at, :description, :n_com).new(avatar[0]["src"], login, lien_github, filename, lien_filename, create_at, description, n_comment))
    end

    pagination = page.css("div.paginate-container").css("div.pagination")
    pagination_old = pagination.css("a")
    if pagination_old.length == 1
      pagination_span = pagination.css("span.disabled")
      prev_pagination = pagination_span.text
      next_pagination = pagination_old[0]["href"]
      if prev_pagination == "Older"
        tmp = prev_pagination
        prev_pagination = next_pagination
        next_pagination = tmp
      end
      prev_pagination = "" if prev_pagination == "Newer"
      next_pagination = "" if next_pagination == "Older"
    else
      prev_pagination = pagination_old[0]["href"]
      next_pagination = pagination_old[1]["href"]
    end

    prev_pagination = prev_pagination == "" ? "" : getPage(prev_pagination)
    next_pagination = next_pagination == "" ? "" : getPage(next_pagination)

    @lpagination.push(@pagination = Struct.new(:prev, :next).new(prev_pagination, next_pagination))
    json.data(@lists) do |link|
      json.avatar         link.avatar
      json.login          link.login
      json.lien_github    link.github
      json.filename       link.filename
      json.lien_filename  link.lien_filename
      json.create_at      link.create_at
      json.description    link.description
      json.n_com          link.n_com
    end

    json.pagination(@lpagination) do |pagin|
      json.prev     pagin.prev
      json.next     pagin.next
    end
    j = json.compile!
    return JSON.parse j
  end

end
