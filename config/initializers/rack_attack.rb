class Rack::Attack
  ### Configure Cache ###
  
  # If you don't want to use Rails.cache (Rack::Attack's default), then
  # configure it here.
  #
  # Note: The store is only used for throttling (not blocklisting and
  # safelisting). It must implement .increment and .write like
  # ActiveSupport::Cache::Store
  
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  ### Throttle Spammy Clients ###

  # Throttle password reset attempts for a given email parameter to 5 requests per hour
  throttle('password_resets/email', limit: 5, period: 1.hour) do |req|
    if req.path == '/users/password' && req.post?
      # Return the email if present, nil otherwise
      req.params['user'].try(:[], 'email')&.downcase
    end
  end

  # Throttle password reset attempts by IP to 20 requests per hour
  throttle('password_resets/ip', limit: 20, period: 1.hour) do |req|
    if req.path == '/users/password' && req.post?
      req.ip
    end
  end

  ### Custom Throttle Response ###

  # By default, Rack::Attack returns an HTTP 429 for throttled responses,
  # which is just fine.
  #
  # If you want to return 503 so that the attacker might be fooled into
  # believing that they've successfully broken your app (or you just want to
  # customize the response), then uncomment these lines.
  self.throttled_responder = lambda do |env|
    now = Time.now
    match_data = env['rack.attack.match_data']

    headers = {
      'Content-Type' => 'application/json',
      'Retry-After' => (now + (match_data[:period] - now.to_i % match_data[:period])).to_s
    }

    [
      429,
      headers,
      [{
        error: 'Too many password reset attempts. Please try again later.'
      }.to_json]
    ]
  end
end 