require 'spec_helper'

describe  'Test setting of argument defaults' do
  let(:yaml_hash) do
    {
      arg1: { type: Integer, default: 5, min:1, max:10 },
      arg2: { type: Integer, default: 7, min:2, max:9 }
    }
  end

  it 'can access default argument values' do
    parser = Arguments.new(yaml_hash: yaml_hash)
    expect(parser.arg1).to eq(5)
    expect(parser.arg2).to eq(7)
  end

  it 'can set argument values' do
    parser = Arguments.new(yaml_hash: yaml_hash)
    parser.arg1 = 10
    expect(parser.arg1).to eq(10)
    expect(parser.arg2).to eq(7)
  end

  it 'can parse a command line to get argument values' do
    parser = Arguments.new(yaml_hash: yaml_hash)
    parser.parse(%w{--arg1 2 --arg2 3})
    expect(parser.arg1).to eq(2)
    expect(parser.arg2).to eq(3)
  end
end
