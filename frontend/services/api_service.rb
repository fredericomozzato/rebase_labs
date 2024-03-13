require 'faraday'
require 'faraday/multipart'

class ApiService
  def self.upload(params:)
    conn = Faraday.new('http://backend:4567') do |builder|
      builder.request :multipart
      builder.request :url_encoded
      builder.adapter :net_http
    end

    payload = { file: Faraday::UploadIO.new(params[:file][:tempfile], 'text/csv') }

    response = conn.post('/import') do |req|
      req.body = payload
    end

    p response
  end
end
