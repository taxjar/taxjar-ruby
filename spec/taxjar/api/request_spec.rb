require 'helper'

describe Taxjar::API::Request do
  describe "#DEFAULT_API_URL" do
    it 'should have taxjar api url' do
      expect(Taxjar::API::Request::DEFAULT_API_URL).to eq('https://api.taxjar.com')
    end
  end

  describe "#SANDBOX_API_URL" do
    it 'should have sandbox taxjar api url' do
      expect(Taxjar::API::Request::SANDBOX_API_URL).to eq('https://api.sandbox.taxjar.com')
    end
  end

  describe "attr_accessors" do
    let(:client){ Taxjar::Client.new(api_key: 'AK')}
    let(:subject) do
      Taxjar::API::Request.new(client, :get, '/api_path', 'object')
    end

    it 'should return the client' do
      expect(subject).to respond_to(:client)
      expect(subject.client).to be(client)
    end

    it 'should return a uri' do
      expect(subject).to respond_to(:uri)
      expect(subject.uri).to be_instance_of(Addressable::URI)
      expect(subject.uri.to_s).to eq('https://api.taxjar.com/api_path')
    end

    it 'should return a sandbox uri' do
      client = Taxjar::Client.new(api_key: 'AK', api_url: Taxjar::API::Request::SANDBOX_API_URL)
      subject = Taxjar::API::Request.new(client, :get, '/api_path', 'object')
      expect(subject).to respond_to(:uri)
      expect(subject.uri).to be_instance_of(Addressable::URI)
      expect(subject.uri.to_s).to eq('https://api.sandbox.taxjar.com/api_path')
    end

    it 'should return headers' do
      expect(subject).to respond_to(:headers)
      expect(subject.headers).to be_instance_of(Hash)
      expect(subject.headers[:user_agent]).to match(/^TaxJar\/Ruby \(.+\) taxjar-ruby\/\d+\.\d+\.\d+$/)
      expect(subject.headers[:authorization]).to eq('Bearer AK')
    end

    it 'should return custom headers' do
      client = Taxjar::Client.new(api_key: 'AK', api_url: Taxjar::API::Request::SANDBOX_API_URL, headers: {
        'X-TJ-Expected-Response' => 422
      })
      subject = Taxjar::API::Request.new(client, :get, '/api_path', 'object')
      expect(subject).to respond_to(:headers)
      expect(subject.headers).to be_instance_of(Hash)
      expect(subject.headers[:user_agent]).to match(/^TaxJar\/Ruby \(.+\) taxjar-ruby\/\d+\.\d+\.\d+$/)
      expect(subject.headers[:authorization]).to eq('Bearer AK')
      expect(subject.headers['X-TJ-Expected-Response']).to eq(422)
    end

    it 'should return request method' do
      expect(subject).to respond_to(:request_method)
      expect(subject.request_method).to be_instance_of(Symbol)
      expect(subject.request_method).to eq(:get)
    end

    it 'should return path' do
      expect(subject).to respond_to(:path)
      expect(subject.path).to be_instance_of(String)
      expect(subject.path).to eq('/api_path')
    end

    it 'should return object_key' do
      expect(subject).to respond_to(:object_key)
      expect(subject.object_key).to be_instance_of(String)
      expect(subject.object_key).to eq('object')
    end

    describe 'options' do
      it 'should return options' do
        expect(subject).to respond_to(:options)
        expect(subject.options).to be_instance_of(Hash)
      end

      it 'should have an empty hash if no options passed to constructor' do
        expect(subject.options).to eq({})
      end

      it 'should have options if passed to constructor' do
        options = {city: "New York City", state: "NY"}
        client =  Taxjar::Client.new(api_key: 'AK')
        subject = Taxjar::API::Request.new(client, :get, '/api_path', 'object', options)
        expect(subject.options).to eq(options)
      end

      context 'timeout' do
        it 'should initialize nil timeout if not set' do
          client = Taxjar::Client.new(api_key: 'AK')
          subject = Taxjar::API::Request.new(client, :get, '/api_path', 'object', {})

          expect(subject.instance_variable_get(:@http_timeout)).to eq({write: nil, read: nil, connect: nil})
        end

        it 'should take a timeout option and set timeout for request' do
          options = {timeout: 1}
          client = Taxjar::Client.new(api_key: 'AK')
          subject = Taxjar::API::Request.new(client, :get, '/api_path', 'object', options)

          expect(subject.instance_variable_get(:@http_timeout)).to eq({write: 1, read: 1, connect: 1})
        end
      end
    end

  end

  describe "#perform" do

    let(:client){ Taxjar::Client.new(api_key: 'AK')}
    let(:subject) do
      Taxjar::API::Request.new(client, :get, '/api_path', 'object')
    end

    context 'with a proxy' do
      let(:client){ Taxjar::Client.new(api_key: 'AK', http_proxy: ["127.0.0.1", 8080])}
      it "runs through the proxy" do
        stub_request(:get, "https://api.taxjar.com/api_path").
          with(:headers => {'Authorization'=>'Bearer AK', 'Connection'=>'close',
                            'Host'=>'api.taxjar.com'}).
          to_return(:status => 200, :body => '{"object": {"id": "3"}}',
                    :headers => {content_type: 'application/json; charset=UTF-8'})

        expect(subject.perform).to eq({id: '3'})
        expect(subject.send(:build_http_client).default_options.proxy).to eq({proxy_address: "127.0.0.1", proxy_port: 8080})
      end
    end

    context 'with logger' do
      let(:client) { Taxjar::Client.new(api_key: 'AK', logger: logger) }
      let(:logger) { double }

      before do
        stub_request(:get, "https://api.taxjar.com/api_path").
          with(:headers => {'Authorization'=>'Bearer AK', 'Connection'=>'close',
                            'Host'=>'api.taxjar.com'}).
          to_return(:status => 200, :body => '{"object": {"id": "3"}}',
                    :headers => {content_type: 'application/json; charset=UTF-8'})
      end

      it "calls the logger" do
        expect(logger).to receive(:info).at_least(:once)
        expect(logger).to receive(:debug).at_least(:once)
        subject.perform
      end
    end

    context 'with get' do
      it 'should return a body if no errors' do
        stub_request(:get, "https://api.taxjar.com/api_path").
          with(:headers => {'Authorization'=>'Bearer AK', 'Connection'=>'close',
                            'Host'=>'api.taxjar.com'}).
          to_return(:status => 200, :body => '{"object": {"id": "3"}}',
                    :headers => {content_type: 'application/json; charset=UTF-8'})

        expect(subject.perform).to eq({id: '3'})
      end
    end

    context 'with POST' do

      let(:client){ Taxjar::Client.new(api_key: 'AK')}
      let(:subject) do
        Taxjar::API::Request.new(client, :post, '/api_path', 'object', {:city => "New York"})
      end

      it 'should return a body if no errors' do
         stub_request(:post, "https://api.taxjar.com/api_path").
                    with(:body => "{\"city\":\"New York\"}",
                         :headers => {'Authorization'=>'Bearer AK', 'Connection'=>'close',
                                      'Content-Type'=>'application/json; charset=UTF-8',
                                      'Host'=>'api.taxjar.com'}).
          to_return(:status => 200, :body => '{"object": {"id": "3"}}',
                    :headers => {content_type: 'application/json; charset=UTF-8'})

        expect(subject.perform).to eq({id: '3'})
      end
    end

    it 'handles unexpected Content-Type responses' do
      stub_request(:get, "https://api.taxjar.com/api_path").
        with(:headers => {'Authorization'=>'Bearer AK', 'Connection'=>'close',
                          'Host'=>'api.taxjar.com'}).
        to_return(:status => 200, :body => 'Something unexpected',
                  :headers => {content_type: 'text/html; charset=UTF-8'})

      expect{subject.perform}.to raise_error(Taxjar::Error::ServerError)
    end

    [
      HTTP::Error,
      HTTP::ConnectionError,
      HTTP::RequestError,
      HTTP::ResponseError,
      HTTP::StateError,
      HTTP::TimeoutError,
      HTTP::HeaderError
    ].each do |http_error_class|
      context "#{http_error_class}" do
        it "is classified as a Taxjar::Error" do
          stub_request(:get, "https://api.taxjar.com/api_path").to_raise(http_error_class)

          expect{subject.perform}.to raise_error(Taxjar::Error)
        end
      end
    end

    Taxjar::Error::ERRORS.each do |status, exception|
      context "when HTTP status is #{status}" do
        it "raises #{exception}" do
          stub_request(:get, "https://api.taxjar.com/api_path").
            with(:headers => {'Authorization'=>'Bearer AK', 'Connection'=>'close',
                              'Host'=>'api.taxjar.com'}).
            to_return(:status => status,
                      :body => '{"error": "Not Acceptable",
                                 "detail": "error explanation",
                                 "status": "'+ status.to_s + '"}',
                      :headers => {content_type: 'application/json; charset=UTF-8'})

          expect{subject.perform}.to raise_error(exception, 'error explanation')
        end
      end
    end

    context "when HTTP status is 502" do
      it "raises Taxjar::Error" do
        stub_request(:get, "https://api.taxjar.com/api_path").
          with(:headers => {'Authorization'=>'Bearer AK', 'Connection'=>'close',
                            'Host'=>'api.taxjar.com'}).
          to_return(:status => 502,
                    :body => '{}',
                    :headers => {content_type: 'application/json; charset=UTF-8'})

        expect{subject.perform}.to raise_error(
          an_instance_of(Taxjar::Error).and having_attributes({
            "message" => "Bad Gateway",
            "code" => 502
          })
        )
      end
    end

    context "when HTTP status is 5xx" do
      it "raises Taxjar::Error" do
        stub_request(:get, "https://api.taxjar.com/api_path").
          with(:headers => {'Authorization'=>'Bearer AK', 'Connection'=>'close',
                            'Host'=>'api.taxjar.com'}).
          to_return(:status => 509,
                    :body => '{}',
                    :headers => {content_type: 'application/json; charset=UTF-8'})

        expect{subject.perform}.to raise_error(
          an_instance_of(Taxjar::Error).and having_attributes({
            "message" => "Unknown Error",
            "code" => 509
          })
        )
      end
    end
  end
end
