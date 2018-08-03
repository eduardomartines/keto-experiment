require 'net/http'
require 'json'

describe 'Policies' do
  describe 'authorization' do
    context 'when access is granted' do
      it 'returns true'
    end

    context 'when access is denied' do
      it 'returns false'
    end
  end
end
