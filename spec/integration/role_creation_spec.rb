require 'net/http'
require 'json'

describe 'Role' do
  let(:uri) { URI('http://keto:4466/roles') }
  let(:http) { Net::HTTP.new(uri.host, uri.port) }

  it do
    request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    request.body = '{
      "id": "id-role-foo",
      "members": ["subject-foo", "subject-bar"],
      "description": "description-role-foo"
    }'
    @response = http.request(request)

    expect(@response.body).to eq("{\"id\":\"id-role-foo\",\"members\":[\"subject-foo\",\"subject-bar\"]}")
  end
end
