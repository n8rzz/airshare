module OmniauthHelpers
  def mock_google_auth_hash
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '123456789',
      info: {
        email: 'test@example.com',
        name: 'Test User',
        image: 'https://example.com/photo.jpg'
      },
      credentials: {
        token: 'mock_token',
        expires_at: Time.now + 1.week,
        expires: true
      }
    })
  end

  def mock_invalid_google_auth
    OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
  end

  def mock_google_auth_hash_with_revoked_access
    OmniAuth.config.mock_auth[:google_oauth2] = :access_denied
  end

  def mock_google_auth_hash_with_different_email
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '123456789',
      info: {
        email: 'different@example.com',
        name: 'Different User',
        image: 'https://example.com/different.jpg'
      },
      credentials: {
        token: 'mock_token',
        expires_at: Time.now + 1.week,
        expires: true
      }
    })
  end

  def mock_google_auth_hash_without_email
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '123456789',
      info: {
        name: 'No Email User',
        image: 'https://example.com/photo.jpg'
      },
      credentials: {
        token: 'mock_token',
        expires_at: Time.now + 1.week,
        expires: true
      }
    })
  end
end 