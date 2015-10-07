require 'spec_helper'

RSpec.describe Seoshop::Client do

  subject { described_class.new('123', 'NL', 'http://localhost/seoshop-api') }

  context '.new' do
    it 'assigns on creation' do
      params = { access_token: '123', shop_language: 'NL' }
      expect(subject).to have_attributes(params)
    end
  end

  context '#get' do
    let(:params) { { 'foo' => 'bar' } }
    let(:connection) { double('connection') }
    let(:do_block) { double('do_block') }

    it 'preform get request' do
      allow(subject).to receive(:connection) { connection }
      allow(connection).to receive(:in_parallel?) { true }
      allow(connection).to receive(:get).with('http://example.com', params)

      expect(subject).to receive(:preform).with('http://example.com',
                                                :get, params: params)
      subject.get('http://example.com', params)
    end
  end

  context '#connection' do
    let(:conf) { double('conf') }
    let(:parallel_manager) { double('parallel_manager') }

    it 'constructs oAuth digest' do
      allow(Typhoeus::Hydra).to receive(:new) { parallel_manager }

      version = 'Ruby' + Seoshop::VERSION
      params = { url: 'http://localhost/seoshop-api',
                 parallel_manager: parallel_manager,
                 headers: { seoshop_api_connector: version } }
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
      output = subject.send :convert_hash_keys, a: 'a'
      expect(output).to eq('a' => 'a')
    end

    it 'converts an array' do
      output = subject.send :convert_hash_keys, [{ a: 'a' }, { b: 'b' }]
      expect(output).to eq([{ 'a' => 'a' }, { 'b' => 'b' }])
    end
  end

  context '#fetch_collection' do
    let(:a_count_resource){ double('count_entity_resource', body: { 'count' => 90 }) }
    let(:a_resource_page_1){ double('entity_resource', body: { 'the_custom_entity' => [{'data' => 1}]}) }
    let(:a_resource_page_2){ double('entity_resource', body: { 'the_custom_entity' => [{'data' => 2}]}) }
    it 'calls count for given entity name and fetches all data per its page with custom entity access name' do
      expect(subject).to receive(:get).with('NL/the_entities/count.json'){ a_count_resource }
      expect(subject).to receive(:get).with('NL/the_entities.json?page=1'){ a_resource_page_1 }
      expect(subject).to receive(:get).with('NL/the_entities.json?page=2'){ a_resource_page_2 }

      result = subject.fetch_collection('the_entities', as: 'the_custom_entity')
      expect(result).to eq([{'data' => 1}, {'data' => 2}])
    end

    it 'returns empty collection if count is zero' do
      expect(subject).to receive(:get).with('NL/the_entities/count.json'){ double('zero_count', body: {'count' => 0}) }

      result = subject.fetch_collection('the_entities', as: 'the_custom_entity')
      expect(result).to eq([])
    end
  end
end