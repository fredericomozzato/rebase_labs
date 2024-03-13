require 'faraday'
require 'faraday/multipart'

class ApiService
  BACKEND_URL = 'http://backend:4567'

  def self.upload(params:)
    conn = Faraday.new(BACKEND_URL) do |f|
      f.request :multipart
      f.request :url_encoded
      f.adapter :net_http
    end

    payload = { file: Faraday::UploadIO.new(params[:file][:tempfile], 'text/csv') }

    conn.post('/import') { |req| req.body = payload }
  end

  def self.search(token:)
    conn = Faraday.new(
      url: BACKEND_URL,
    )

    res = conn.get("/tests/#{token}")

    JSON.parse(res.body, symbolize_names: true) if res.status == 200
  end
end
