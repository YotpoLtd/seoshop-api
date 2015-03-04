require 'spec_helper'

module Seoshop
  RSpec.describe Client do

    subject { described_class.new('123', 'abc', 'http://localhost/seoshop-api') }

    it 'assigns on creation' do
      expect(subject).to have_attributes(access_token: '123', shop_language: 'abc')
    end

    context 'instance_methods' do
      context '#get' do
        let(:params){ {'foo' => 'bar'} }
        let(:connection){ double('connection') }
        let(:do_block){ double('do_block') }

        it 'preform get request' do
          allow(subject).to receive(:connection){ connection }
          allow(connection).to receive(:in_parallel?){ true }
          allow(connection).to receive(:get).with('http://example.com', params){ }

          expect(subject).to receive(:preform).with('http://example.com', :get, { params: params })
          subject.get('http://example.com', params)
        end
      end

      context "#connection" do
        let(:conf){ double('conf') }
        let(:parallel_manager){ double('parallel_manager') }

        it 'constructs oAuth digest' do
          allow(Typhoeus::Hydra).to receive(:new){ parallel_manager }

          params = {url: 'http://localhost/seoshop-api',
                    parallel_manager: parallel_manager,
                    headers: {seoshop_api_connector: 'Ruby' + Seoshop::VERSION}}
          expect(Faraday).to receive(:new).with(params).and_yield(conf)

          expect(conf).to receive(:adapter).with(:typhoeus)
          expect(conf).to receive(:basic_auth) # this could be improved
          expect(conf).to receive(:request).with(:oj)
          expect(conf).to receive(:response).with(:oj)
          expect(conf).to receive(:response).with(:rashify)

          expect(conf).to receive(:use).with(Seoshop::ResponseParser)
          expect(conf).to receive(:use).with(:instrumentation)

          subject.send :connection
        end
      end

      context '#convert_hash_keys' do
        it 'converts symbols to string' do
          output = subject.send :convert_hash_keys, {a: 'a'}
          expect(output).to eq({'a' => 'a'})
        end

        it 'converts an array' do
          output = subject.send :convert_hash_keys, [{a: 'a'}, {b: 'b'}]
          expect(output).to eq([{'a' => 'a'}, {'b' => 'b'}])
        end
      end
    end
  end
end
