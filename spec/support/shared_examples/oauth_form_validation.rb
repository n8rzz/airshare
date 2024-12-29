RSpec.shared_examples 'oauth form validation' do |provider_name|
  let(:button_text) { "Sign in with #{provider_name}" }
  let(:provider_path) { provider_name.downcase == 'google' ? 'google_oauth2' : provider_name.downcase.gsub(' ', '_') }
  
  before { visit new_user_session_path }

  it 'uses POST method for OAuth requests' do
    oauth_form = find_button(button_text).ancestor('form')
    expect(oauth_form['method']).to eq('post')
  end

  it 'includes CSRF protection' do
    form = find_button(button_text).ancestor('form')
    expect(form).to have_field('authenticity_token', type: 'hidden')
  end

  it 'has the correct OAuth path' do
    oauth_form = find_button(button_text).ancestor('form')
    expect(oauth_form['action']).to end_with("/users/auth/#{provider_path}")
  end

  it 'disables turbo on the form' do
    form = find_button(button_text).ancestor('form')
    expect(form['data-turbo']).to eq('false')
  end

  it 'is implemented as a button, not a link' do
    expect(page).not_to have_link(button_text)
    expect(page).to have_button(button_text)
  end
end 