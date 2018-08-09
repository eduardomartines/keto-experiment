require 'net/http'
require 'json'

describe 'Policy' do
  let(:uri) { URI('http://keto:4466/warden/subjects/authorize') }
  let(:http) { Net::HTTP.new(uri.host, uri.port) }

  describe 'authorization' do
    before do
      request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
      request.body = '{
        "action": "action-foo",
        "context": { "conditionKeyFoo": "conditionValueFoo" },
        "resource": "resource-foo:bar",
        "subject": "' + subject + '"
      }'
      @response = http.request(request)
    end

    context 'when access is granted to a especific subject' do
      let(:subject) { 'subject-foo' }

      it 'returns allowed' do
        expect(@response.body).to eq("{\"sub\":\"subject-foo\",\"allowed\":true}")
      end
    end

    context 'when access is granted to a subject in a role' do
      let(:subject) { 'subject-bar' }

      it 'returns allowed' do
        expect(@response.body).to eq("{\"sub\":\"subject-bar\",\"allowed\":true}")
      end
    end

    context 'when access is denied' do
      let(:subject) { 'foo' }

      it 'returns not allowed' do
        expect(@response.body).to eq("{\"allowed\":false}")
      end
    end
  end
end
