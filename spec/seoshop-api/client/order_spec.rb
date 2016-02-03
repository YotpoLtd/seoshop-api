require 'spec_helper'
require 'ostruct'

RSpec.describe Seoshop::Client::Order do
  let(:client) { Seoshop::Client.new('123', 'NL', 'http://localhost/seoshop-api') }
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

  context '#new' do
    it 'assigns on creation' do
      response.id = 46
      response.body = { 'checkout_id' => 46 }
      expect(subject.checkout_id).to equal(46)
      expect(subject.checkout_body['checkout_id']).to equal(46)
    end
  end

  context '#valid?' do
    it 'should throw error if update! shipping or payment info fails' do
      response.body = { status: 404 }

      allow(client).to receive(:put).with("#{client.shop_language}/checkouts/#{subject.checkout_id}.json", { shipping_method: shipping_details, payment_method: payment_details }) { response }
      expect{subject.valid?}.to raise_error(Seoshop::Client::Order::CheckoutError)
    end

    it 'should return false if api validation of details fail' do
      response.body = { validated: false }
      response.status = 200
      allow(client).to receive(:put).with("#{client.shop_language}/checkouts/#{subject.checkout_id}.json", { shipping_method: shipping_details, payment_method: payment_details }) { response }
      allow(client).to receive(:get).with("#{client.shop_language}/checkouts/#{subject.checkout_id}/validate.json") { response }

      expect(subject.valid?).to equal(false)
    end

    it 'should return true if api validation of details {  true' do
      response.status = 200
      response.body = { validated: true }
      allow(client).to receive(:put).with("#{client.shop_language}/checkouts/#{subject.checkout_id}.json", { shipping_method: shipping_details, payment_method: payment_details }) { response }
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

    it 'should upate order with id if api call to create order {  200 or 201' do
      response.body = { order_id:  47 }
      response.status = 200
      allow(subject).to receive(:checkout_attrs) { (checkout_details) }
      allow(client).to receive(:post) { response }
      subject.save!
      expect(subject.id).to equal(47)
    end
  end

  context '#udpate' do
    it 'should not throw error if api call to update! succeeds' do
      response.body = { order_id: 47 }
      response.status = 200
      allow(subject).to receive(:id) { 47 }
      allow(client).to receive(:put).with("#{client.shop_language}/orders/#{subject.id}.json", order: { paymentStatus: 'paid' }) { response }
      expect{subject.update!({ paymentStatus: 'paid' })}.not_to raise_error
    end

    it 'should throw errors if api call to update! fails' do
      response.status = 500
      allow(subject).to receive(:id) {  47 }
      allow(client).to receive(:put).with("#{client.shop_language}/orders/#{subject.id }.json", order: { paymentStatus: 'paid' }) { response }
      expect{subject.update!({ paymentStatus: 'paid' })}.to raise_error(Seoshop::Client::Order::CheckoutError)
    end
  end
end
