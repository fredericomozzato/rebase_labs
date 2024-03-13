require 'faraday'
require 'faraday/multipart'

class ApiService
  def self.upload(params:)
    conn = Faraday.new('http://backend:4567') do |f|
      f.request :multipart
      f.request :url_encoded
      f.adapter :net_http
    end

    payload = { file: Faraday::UploadIO.new(params[:file][:tempfile], 'text/csv') }

    conn.post('/import') { |req| req.body = payload }
  end
end
