require 'spec_helper'

describe  'Test setting of argument defaults' do
  let(:yaml_hash) do
    {
      arg1: { type: Integer, default: 5, min:1, max:10 },
      arg2: { type: Integer, default: 7, min:2, max:9 }
    }
  end

  it 'Can set a single default argument' do
    parser = Arguments.new(yaml_hash: yaml_hash)
    expect(parser.arg1).to eq(5)
    expect(parser.arg2).to eq(7)
  end
end
