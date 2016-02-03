require 'spec_helper'
require 'ostruct'

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
    let(:connection) { mock('connection') }
    let(:do_block) { mock('do_block') }

    it 'preform get request' do
      subject.stubs(:connection).returns(connection)
      connection.stubs(:in_parallel?).returns(true)
      connection.stubs(:get).with('http://example.com', params)

      subject.expects(:preform).with('http://example.com', :get, params: params)
      subject.get('http://example.com', params)
    end
  end

  context '#connection' do
    let(:conf) { mock('conf') }
    let(:parallel_manager) { mock('parallel_manager') }

    it 'constructs oAuth digest' do
      Typhoeus::Hydra.stubs(:new).returns(parallel_manager)

      version = 'Ruby' + Seoshop::VERSION
      params = { url: 'http://localhost/seoshop-api',
                 parallel_manager: parallel_manager,
                 headers: { seoshop_api_connector: version } }
      Faraday.expects(:new).with(params).yields(conf)

      conf.expects(:adapter).with(:typhoeus)
      conf.expects(:basic_auth) # this could be improved
      conf.expects(:request).with(:oj)
      conf.expects(:response).with(:oj)
      conf.expects(:response).with(:rashify)

      conf.expects(:use).with(Seoshop::ResponseParser)
      conf.expects(:use).with(:instrumentation)

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
    let(:a_count_resource){ mock('count_entity_resource', body: { 'count' => 90 }) }
    let(:a_resource_page_1){ mock('entity_resource', body: { 'the_custom_entity' => [{'data' => 1}]}) }
    let(:a_resource_page_2){ mock('entity_resource', body: { 'the_custom_entity' => [{'data' => 2}]}) }

    it 'calls count for given entity name and fetches all data per its page with custom entity access name' do
      subject.stubs(:get).with('NL/the_entities/count.json').returns( a_count_resource )
      subject.stubs(:get).with('NL/the_entities.json?page=1').returns( a_resource_page_1)
      subject.stubs(:get).with('NL/the_entities.json?page=2').returns( a_resource_page_2 )

      result = subject.fetch_collection('the_entities', as: 'the_custom_entity')
      expect(result).to eq([{'data' => 1}, {'data' => 2}])
    end

    it 'returns empty collection if count is zero' do
      subject.stubs(:get).with('NL/the_entities/count.json').returns(mock('zero_count', body: {'count' => 0}))

      result = subject.fetch_collection('the_entities', as: 'the_custom_entity')
      expect(result).to eq([])
    end
  end

  context '#create_order_client' do
    it 'returns an order client' do
      checkout_details = { shipping_address: 'test address', billing_address: 'test address' }
      shipping_details =  { id: 'external', tax_rate: '50' }
      payment_details = { discount: false }

      Seoshop::Client::Order.stubs(:new).returns(OpenStruct.new(checkout_id: 47))
      order_client = subject.create_order_client(checkout_details, shipping_details, payment_details)
      expect(order_client.checkout_id).to equal(47)
    end

    it 'returns an ordered_porduct client' do
      ordered_product_client = subject.create_ordered_product_client('47', '123', 23, true)
      expect(ordered_product_client).to respond_to(:create)
    end
  end
end
