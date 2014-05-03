require 'qtc-sdk'


describe Qtc::Client do

  let(:test_client) do
    Qtc::Client.new('https://api.qtc.io')
  end

  describe '#initialize' do
    it 'accepts single parameter (api_url)' do
      expect {
        Qtc::Client.new('https://api.qtc.io')
      }.not_to raise_exception
    end

    it 'accepts optional second parameter (headers)' do
      expect {
        client = Qtc::Client.new('https://api.qtc.io', {'Foo' => 'Bar'})
        expect(client.default_headers['Foo']).to eq('Bar')
      }.not_to raise_exception
    end
  end

  describe '#get' do
    it 'sends GET request with correct parameters' do
      params = {test: 1}
      headers = {'X-Test-Header' => 'some_value'}
      test_client.http_client.should_receive(:get).with(
          'https://api.qtc.io/v1/ping',
          params,
          hash_including(headers)
      ).and_return(double(:response, status: 200).as_null_object)
      test_client.get('/v1/ping', params, headers)
    end

    it 'raises exception when response is an error' do
      data = {name: 'Test'}
      test_client.http_client.should_receive(:get).and_return(double(:response, status: 400).as_null_object)
      expect {
        test_client.get('/v1/instances', data)
      }.to raise_error(Qtc::Errors::StandardError)
    end

    it 'returns parsed json responses' do
      data = {'name' => 'Test'}
      test_client.http_client.should_receive(:get).and_return(double(:response, status: 200, body: data.to_json).as_null_object)
      resp = test_client.get('/v1/instances', data)
      expect(resp).to eq(data)
    end
  end

  describe '#post' do
    it 'sends POST request with correct parameters' do
      data = {name: 'Test'}
      params = {test: 1}
      headers = {'Authorization' => 'Bearer token'}
      test_client.http_client.should_receive(:post).with(
          'https://api.qtc.io/v1/accounts',
          {
              header: hash_including(headers),
              body: data.to_json,
              query: params
          }
      ).and_return(double(:response, status: 201).as_null_object)
      test_client.post('/v1/accounts', data, params, headers)
    end

    it 'raises exception when response is an error' do
      data = {name: 'Test'}
      test_client.http_client.should_receive(:post).and_return(double(:response, status: 400).as_null_object)
      expect {
        test_client.post('/v1/accounts', data)
      }.to raise_error(Qtc::Errors::StandardError)
    end

    it 'returns parsed json responses' do
      data = {'name' => 'Test'}
      test_client.http_client.should_receive(:post).and_return(double(:response, status: 201, body: data.to_json).as_null_object)
      resp = test_client.post('/v1/accounts', data)
      expect(resp).to eq(data)
    end
  end

  describe '#put' do
    it 'sends PUT request with correct parameters' do
      data = {name: 'Test'}
      params = {test: 1}
      headers = {'Authorization' => 'Bearer token'}
      test_client.http_client.should_receive(:put).with(
          'https://api.qtc.io/v1/accounts',
          {
              header: hash_including(headers),
              body: data.to_json,
              query: params
          }
      ).and_return(double(:response, status: 201).as_null_object)
      test_client.put('/v1/accounts', data, params, headers)
    end

    it 'raises exception when response is an error' do
      data = {name: 'Test'}
      test_client.http_client.should_receive(:put).and_return(double(:response, status: 400).as_null_object)
      expect {
        test_client.put('/v1/accounts', data)
      }.to raise_error(Qtc::Errors::StandardError)
    end

    it 'returns parsed json responses' do
      data = {'name' => 'Test'}
      test_client.http_client.should_receive(:put).and_return(double(:response, status: 201, body: data.to_json).as_null_object)
      resp = test_client.put('/v1/accounts', data)
      expect(resp).to eq(data)
    end
  end

  describe '#delete' do
    it 'sends DELETE request with correct parameters' do
      data = {name: 'Test'}
      params = {test: 1}
      headers = {'Authorization' => 'Bearer token'}
      test_client.http_client.should_receive(:delete).with(
          'https://api.qtc.io/v1/accounts',
          {
              header: hash_including(headers),
              body: data.to_json,
              query: params
          }
      ).and_return(double(:response, status: 200).as_null_object)
      test_client.delete('/v1/accounts', data, params, headers)
    end

    it 'raises exception when response is an error' do
      data = {name: 'Test'}
      test_client.http_client.should_receive(:delete).and_return(double(:response, status: 400).as_null_object)
      expect {
        test_client.delete('/v1/accounts', data)
      }.to raise_error(Qtc::Errors::StandardError)
    end

    it 'returns parsed json responses' do
      data = {'name' => 'Test'}
      test_client.http_client.should_receive(:delete).and_return(double(:response, status: 200, body: data.to_json).as_null_object)
      resp = test_client.delete('/v1/accounts', data)
      expect(resp).to eq(data)
    end
  end
end