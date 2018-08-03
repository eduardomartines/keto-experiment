require 'net/http'
require 'json'

describe 'Policies' do
  describe 'creation' do
    before do
      uri = URI('http://keto:4466/policies')
      http = Net::HTTP.new(uri.host, uri.port)
      req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')

      req.body = '{
          "id": "id-foo",
          "actions": ["action-foo", "action-bar"],
          "conditions": {
            "conditionKeyFoo": {
              "options": {
                "equals": "conditionValueFoo"
              },
              "type": "StringEqualCondition"
            }
          },
          "description": "description-foo",
          "effect": "allow",
          "resources": ["resource-foo:bar"],
          "subjects": ["subject-foo"]
      }'

      @response = http.request(req)
    end

    context 'when correct params is passed' do
      it 'returns true' do
        result = "{
          \"id\": \"id-foo\",
          \"description\": \"description-foo\",
          \"subjects\": [\"subject-foo\"],
          \"effect\": \"allow\",
          \"resources\": [\"resource-foo:bar\"],
          \"actions\": [\"action-foo\", \"action-bar\"],
          \"conditions\": {
            \"conditionKeyFoo\": {
              \"type\": \"StringEqualCondition\",
              \"options\": {
                \"equals\": \"conditionValueFoo\"
              }
            }
          },
          \"meta\": null
        }"

        result.delete!("\t")
        result.delete!("\n")
        result.delete!(' ')

        expect(@response.body).to eq(result)
      end
    end

    context 'when wrong params is passed' do
      it 'returns false'
    end
  end
end
