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

  describe '.logger' do
    after do
      described_class.logger = nil
    end

    it 'has no default logger' do
      expect(described_class).to respond_to(:logger)
      expect(described_class.logger).to be_nil
    end

    it 'allows setting a logger' do
      logger = double('Logger')

      expect(described_class).to respond_to(:logger=)

      described_class.logger = logger
      expect(described_class.logger).to eq(logger)
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
      expect(subject.headers[:user_agent]).to match('TaxjarRubyGem')
      expect(subject.headers[:authorization]).to eq('Bearer AK')
    end

    it 'should return custom headers' do
      client = Taxjar::Client.new(api_key: 'AK', api_url: Taxjar::API::Request::SANDBOX_API_URL, headers: {
        'X-TJ-Expected-Response' => 422
      })
      subject = Taxjar::API::Request.new(client, :get, '/api_path', 'object')
      expect(subject).to respond_to(:headers)
      expect(subject.headers).to be_instance_of(Hash)
      expect(subject.headers[:user_agent]).to match('TaxjarRubyGem')
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
                            'Host'=>'api.taxjar.com',
                            'User-Agent'=>"TaxjarRubyGem/#{Taxjar::Version.to_s}"}).
          to_return(:status => 200, :body => '{"object": {"id": "3"}}',
                    :headers => {content_type: 'application/json; charset=UTF-8'})

        expect(subject.perform).to eq({id: '3'})
        expect(subject.send(:build_http_client).default_options.proxy).to eq({proxy_address: "127.0.0.1", proxy_port: 8080})
      end
    end

    context 'with get' do
      it 'should return a body if no errors' do
        stub_request(:get, "https://api.taxjar.com/api_path").
          with(:headers => {'Authorization'=>'Bearer AK', 'Connection'=>'close',
                            'Host'=>'api.taxjar.com',
                            'User-Agent'=>"TaxjarRubyGem/#{Taxjar::Version.to_s}"}).
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
                                      'Host'=>'api.taxjar.com',
                                      'User-Agent'=>"TaxjarRubyGem/#{Taxjar::Version.to_s}"}).
          to_return(:status => 200, :body => '{"object": {"id": "3"}}',
                    :headers => {content_type: 'application/json; charset=UTF-8'})

        expect(subject.perform).to eq({id: '3'})
      end
    end

    context 'with a logger' do
      let(:logger) { double('Logger 2') }

      before do
        stub_request(:get, "https://api.taxjar.com/api_path").
          with(:headers => {'Authorization'=>'Bearer AK', 'Connection'=>'close',
                            'Host'=>'api.taxjar.com',
                            'User-Agent'=>"TaxjarRubyGem/#{Taxjar::Version.to_s}"}).
          to_return(:status => 200, :body => '{"object": {"id": "3"}}',
                    :headers => {content_type: 'application/json; charset=UTF-8'})

        allow(logger).to receive(:info)
        allow(logger).to receive(:debug)

        described_class.logger = logger
      end

      after do
        described_class.logger = nil
      end

      if HTTP::Options.available_features.key?(:logging)
        context 'when HTTP logging supported' do
          it 'logs both request and response' do
            allow(described_class).to receive(:http_logger_supported?).and_return(true)
            subject.perform
            expect(logger).to have_received(:info)
            expect(logger).to have_received(:debug)

            expect(logger).to have_received(:info)
            expect(logger).to have_received(:debug)
          end
        end
      end

      context 'when HTTP logging is unsupported' do
        it "doesn't use the provided logger" do
          allow(described_class).to receive(:http_logger_supported?).and_return(false)
          subject.perform
          expect(logger).not_to have_received(:info)
          expect(logger).not_to have_received(:debug)
        end
      end
    end
    it 'handles unexpected Content-Type responses' do
      stub_request(:get, "https://api.taxjar.com/api_path").
        with(:headers => {'Authorization'=>'Bearer AK', 'Connection'=>'close',
                          'Host'=>'api.taxjar.com',
                          'User-Agent'=>"TaxjarRubyGem/#{Taxjar::Version.to_s}"}).
        to_return(:status => 200, :body => 'Something unexpected',
                  :headers => {content_type: 'text/html; charset=UTF-8'})

      expect{subject.perform}.to raise_error(Taxjar::Error::ServerError)
    end

    Taxjar::Error::ERRORS.each do |status, exception|
      context "when HTTP status is #{status}" do
        it "raises #{exception}" do
          stub_request(:get, "https://api.taxjar.com/api_path").
            with(:headers => {'Authorization'=>'Bearer AK', 'Connection'=>'close',
                              'Host'=>'api.taxjar.com',
                              'User-Agent'=>"TaxjarRubyGem/#{Taxjar::Version.to_s}"}).
            to_return(:status => status,
                      :body => '{"error": "Not Acceptable",
                                 "detail": "error explanation",
                                 "status": "'+ status.to_s + '"}',
                      :headers => {content_type: 'application/json; charset=UTF-8'})

          expect{subject.perform}.to raise_error(exception, 'error explanation')
        end
      end
    end
  end
end
