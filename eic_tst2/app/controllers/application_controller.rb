class ApplicationController < ActionController::Base
  require 'net/http'
  protect_from_forgery
  before_filter :spy

  private
    def spy
      url = URI.parse('http://127.0.0.1:3000/process')
      path = Net::HTTP::Get.new(url.path)
      path.set_form_data(controller: params[:controller], action: params[:action])
      answer = Net::HTTP.start(url.host, url.port) do |http|
        http.open_timeout = 2
        http.read_timeout = 2
        http.request(path)
      end
      if answer.class == Net::HTTPOK
        @answer = "spy server answer: '#{answer.body}'"
      else
        @answer = "spy server returned status #{answer.class}"
      end
    rescue Exception => e
      @answer = "something wrong: maybe it's spy server connection error: #{e.message}"
    end
end
