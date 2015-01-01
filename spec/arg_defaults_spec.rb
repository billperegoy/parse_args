require 'spec_helper'

describe  'Test setting of argument defaults' do
  let(:yaml_hash) do
    {
      arg1: { usage: 'Arg 1 help', type: Integer,
             multi: false, default: 5, min:1, max:10 },
      arg2: { usage: 'Arg 2 help', type: Integer,
              multi: false, default: 7, min:2, max:9 },
      arg3: { usage: 'Arg 3 help', type: String,
              multi: false, default: 'empty-string' },
      arg4: { usage: 'Arg 4 help', type: String,
              multi: true, default: [] },
      arg5: { usage: 'Arg 5 help', type: Integer,
              multi: true, default: [] },
      arg6: { usage: 'Arg 6 help', type: String,
              multi: true, default: ['help', 'me'] }
    }
  end

  it 'can access default argument values' do
    parser = Arguments.new(yaml_hash: yaml_hash)
    expect(parser.arg1).to eq(5)
    expect(parser.arg2).to eq(7)
    expect(parser.arg3).to eq('empty-string')
  end

  it 'can set argument values' do
    parser = Arguments.new(yaml_hash: yaml_hash)
    parser.arg1 = 10
    expect(parser.arg1).to eq(10)
    expect(parser.arg2).to eq(7)
  end

  it 'can parse a command line to get integer argument values' do
    parser = Arguments.new(yaml_hash: yaml_hash)
    parser.parse(%w{--arg1 2 --arg2 3})
    expect(parser.arg1).to eq(2)
    expect(parser.arg2).to eq(3)
  end

  it "can handle strings as argument values" do
    parser = Arguments.new(yaml_hash: yaml_hash)
    parser.parse(%w{--arg1 2 --arg2 3 --arg3 hello})
    expect(parser.arg3).to eq('hello')
  end

  it "can handle arguments specified multiple times" do
    parser = Arguments.new(yaml_hash: yaml_hash)
    parser.parse(%w{--arg4 hello --arg4 world})
    expect(parser.arg4).to eq(['hello', 'world'])
  end

  it "can handle integer arguments specified multiple times" do
    parser = Arguments.new(yaml_hash: yaml_hash)
    parser.parse(%w{--arg5  5 --arg5 6})
    expect(parser.arg5).to eq([5, 6])
  end

  it "can handle multi args with non-empty defaults" do
    parser = Arguments.new(yaml_hash: yaml_hash)
    parser.parse(%w{--arg6 hello --arg6 world})
    expect(parser.arg6).to eq(['help', 'me', 'hello', 'world'])
  end
end
