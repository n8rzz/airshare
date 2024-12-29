RSpec.shared_examples 'oauth form validation' do |provider_name|
  let(:button_text) { "Sign in with #{provider_name}" }
  
  before { visit new_user_session_path }

  it 'uses POST method for OAuth requests' do
    oauth_form = find_button(button_text).ancestor('form')
    expect(oauth_form['method']).to eq('post')
  end

  it 'includes CSRF token in the form' do
    oauth_form = find_button(button_text).ancestor('form')
    expect(oauth_form).to have_selector("input[name='authenticity_token']", visible: :hidden)
  end

  it 'has the correct OAuth path' do
    oauth_form = find_button(button_text).ancestor('form')
    expect(oauth_form['action']).to end_with("/users/auth/#{provider_name.downcase.gsub(' ', '_')}")
  end

  it 'disables turbo on the form' do
    oauth_button = find_button(button_text)
    expect(oauth_button['data-turbo']).to eq('false')
  end

  it 'is implemented as a button, not a link' do
    expect(page).not_to have_link(button_text)
    expect(page).to have_button(button_text)
  end
end 