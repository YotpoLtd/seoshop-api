require 'spec_helper'
require 'ostruct'

RSpec.describe Seoshop::Client::Order do
  let(:client) { Seoshop::Client.new('app_key', 'secret', '123', 'NL', 'eu1') }
  let(:checkout_details){ { shipping_address: 'test address', billing_address: 'test address' } }
  let(:shipping_details){ { id: 'external', tax_rate: '50' } }
  let(:payment_details){ { discoutn: false } }
  let(:response){ OpenStruct.new }

  subject do
    Seoshop::Client::Order.new(client, checkout_details, payment_details, shipping_details)
  end

  before do
    allow(client).to receive(:post).with("#{client.shop_language}/checkouts.json", checkout_details) { response }
  end

  describe '.new' do
    it 'assigns on creation' do
      response.body = { 'id' => 46 }
      expect(subject.checkout_id).to equal(46)
    end
  end

  context '#valid?' do
    it 'should throw error if update! shipping or payment info fails' do
      response.body = { status: 404 }

      allow(client).to receive(:put).with("#{client.shop_language}/checkouts/#{subject.checkout_id}.json", { shipment_method: shipping_details, payment_method: payment_details }) { response }
      expect{subject.valid?}.to raise_error(Seoshop::Client::Order::CheckoutError)
    end

    it 'should return false if api validation of details fail' do
      response.body = { validated: false }
      response.status = 200
      allow(client).to receive(:put).with("#{client.shop_language}/checkouts/#{subject.checkout_id}.json", { shipment_method: shipping_details, payment_method: payment_details }) { response }
      allow(client).to receive(:get).with("#{client.shop_language}/checkouts/#{subject.checkout_id}/validate.json") { response }

      expect(subject.valid?).to equal(false)
    end

    it 'should return true if api validation of details {  true' do
      response.status = 200
      response.body = { validated: true }
      allow(client).to receive(:put).with("#{client.shop_language}/checkouts/#{subject.checkout_id}.json", { shipment_method: shipping_details, payment_method: payment_details }) { response }
      allow(client).to receive(:get).with("#{client.shop_language}/checkouts/#{subject.checkout_id}/validate.json") { response }

      expect(subject.valid?).to equal(true)
    end
  end

  context '#save!' do
    it 'should throw errors if apii call to create order does not return 200 or 201' do
      response.status = 500
      response.body = { error: { message: 'test error', code: 100 } }
      allow(subject).to receive(:checkout_attrs) { (checkout_details) }
      allow(client).to receive(:post) { response }
      expect{subject.save!}.to raise_error(Seoshop::Client::Order::CheckoutError)
    end

    it 'should upate order with id' do
      response.body = { 'order_id' => 47  }
      response.status = 200
      allow(subject).to receive(:checkout_attrs) { (checkout_details) }
      allow(client).to receive(:post) { response }
      subject.save!
      expect(subject.order_id).to eq(47)
      expect(subject.number).to eq(nil)
    end
  end

  context '#udpate' do
    it 'should not throw error if api call to update! succeeds' do
      response.body = { 'order_id' => 47, 'order' => { 'number' => 'OR0000047' } }
      response.status = 200
      expect(subject).to receive(:order_id) {  47 }
      allow(client).to receive(:put).with("#{client.shop_language}/orders/47.json", order: { paymentStatus: 'paid' }) { response }
      expect{subject.update!({ paymentStatus: 'paid' })}.not_to raise_error
      expect(subject.number).to eq('OR0000047')
    end

    it 'should throw errors if api call to update! fails' do
      response.status = 500
      expect(subject).to receive(:order_id).twice {  47 }
      allow(client).to receive(:put).with("#{client.shop_language}/orders/47.json", order: { paymentStatus: 'paid' }) { response }
      expect{subject.update!({ paymentStatus: 'paid' })}.to raise_error(Seoshop::Client::Order::CheckoutError)
    end
  end
end
