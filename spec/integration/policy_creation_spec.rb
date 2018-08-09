require 'net/http'
require 'json'

describe 'Policy' do
  let(:uri) { URI('http://keto:4466/policies') }
  let(:http) { Net::HTTP.new(uri.host, uri.port) }

  it 'returns 0 in the policy list' do
    request = Net::HTTP::Get.new(uri.path, 'Content-Type' => 'application/json')
    expect(http.request(request).body).to eq('[]')
  end

  describe 'creation' do
    let(:id) { 'id-foo' }
    let(:subjects) { '"subject-foo"' }
    let(:body) do
      '{
        "id": "' + id + '",
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
        "subjects": [' + subjects + ']
      }'
    end

    before do
      request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
      request.body = body
      @response = http.request(request)
    end

    context 'when correct params is passed in the first time' do
      it 'returns a policy' do
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

        request = Net::HTTP::Get.new(uri.path, 'Content-Type' => 'application/json')
        expect(JSON.parse(http.request(request).body).count).to eq(1)
      end
    end

    context 'when correct params with same ID is passed in the second time' do
      it 'returns the same policy' do
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

        request = Net::HTTP::Get.new(uri.path, 'Content-Type' => 'application/json')
        expect(JSON.parse(http.request(request).body).count).to eq(1)
      end
    end

    context 'when correct params with other ID and role in subject is passed in the third time' do
      let(:id) { 'id-foo2' }
      let(:subjects) { '"subject-foo", "id-role-foo"' }

      it 'returns a policy' do
        expect(@response.body).to match(/\"id\":\"id-foo2\"/)

        request = Net::HTTP::Get.new(uri.path, 'Content-Type' => 'application/json')
        expect(JSON.parse(http.request(request).body).count).to eq(2)
      end
    end

    context 'when correct params without an ID is passed' do
      let(:id) { '' }

      it 'returns a policy with an auto generated UID' do
        expect(@response.body).to match(/\"id\":\"([a-z0-9]+\-){4}[a-z0-9]+\"/)

        request = Net::HTTP::Get.new(uri.path, 'Content-Type' => 'application/json')
        expect(JSON.parse(http.request(request).body).count).to eq(3)
      end
    end

    context 'when wrong params is passed' do
      let(:body) { '{ "foo": ["bar"] }' }

      it 'returns an error' do
        expect(@response.body).to eq(
          "{\"error\":{\"code\":500,\"message\":\"pq: new row for relation \\\"ladon_policy\\\" violates check constraint \\\"ladon_policy_effect_check\\\"\"}}\n"
        )

        request = Net::HTTP::Get.new(uri.path, 'Content-Type' => 'application/json')
        expect(JSON.parse(http.request(request).body).count).to eq(3)
      end
    end
  end
end
