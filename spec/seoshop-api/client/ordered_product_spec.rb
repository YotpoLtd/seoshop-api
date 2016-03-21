require 'spec_helper'
require 'ostruct'

RSpec.describe Seoshop::Client::OrderedProduct do
  let(:client) { Seoshop::Client.new('123', 'NL', 'http://localhost/seoshop-api') }
  let(:details){ { shipping_address: 'test address', billing_address: 'test address' } }
  let(:response){ OpenStruct.new(status: 201) }

  subject do
    Seoshop::Client::OrderedProduct.new(client, 47, details)
  end

  before do
    expect(client).to receive(:post).with("#{client.shop_language}/checkouts/#{47}/products.json", details) { response }
  end

  context '#create!' do
    it 'should throw error when ordered product api response is not 201' do
      response.status = 500
      expect{subject.create!}.to raise_error(StandardError)
    end

    it 'should not throw error when ordered product api response is 201' do
      expect{subject.create!}.not_to raise_error
    end
  end
end
