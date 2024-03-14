require 'faraday'
require 'faraday/multipart'

class ApiService
  BACKEND_URL = 'http://backend:4567'

  def self.select_all(page:, limit:)
    res = Faraday.new(BACKEND_URL)
                 .get("/tests?page=#{page}&limit=#{limit}")

    res.body if res.status == 200
  end

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
    res = Faraday.new(BACKEND_URL)
                 .get("/tests/#{token}")

    res.body if res.status == 200
  end
end
