require 'spec_helper'

RSpec.describe Seoshop::Client do

  subject { described_class.new(double('token'), double('language')) }

  let(:taxes_response) do
    {
      taxes: [
        {
          id: 1,
          isDefault: true,
          rate: 0.21,
          title: 'New tax since 2014'
        },
        {
          id: 2,
          isDefault: false,
          rate: 0.19,
          title: 'classic TAX'
        }
      ]
    }
  end

  it '#get_default_tax' do
    expect(subject).to receive(:get_taxes) { taxes_response }
    expected_output = { id: 1, rate: 0.21, title: 'New tax since 2014' }
    expect(subject.get_default_tax).to eq(expected_output)
  end
end
