require 'spec_helper'

describe  'Test setting of argument defaults' do
  let(:yaml_hash) do
    {
      arg1: { usage: 'Arg 1 help', type: 'integer',
             multi: false, default: 5, min:1, max:10 },
      arg2: { usage: 'Arg 2 help', type: 'integer',
              multi: false, default: 7, min:2, max:9 },
      arg3: { usage: 'Arg 3 help', type: 'string',
              multi: false, default: 'empty-string' },
      arg4: { usage: 'Arg 4 help', type: 'string',
              multi: true, default: [] },
      arg5: { usage: 'Arg 5 help', type: 'integer',
              multi: true, default: [] },
      arg6: { usage: 'Arg 6 help', type: 'string',
              multi: true, default: ['help', 'me'] },
      arg7: { usage: 'Arg 7 help', type: 'boolean',
              multi: false, default: false },
      arg8: { usage: 'Arg 8 help', type: 'string',
              multi: false },
      arg9: { usage: 'Arg 9 help', type: 'boolean',
              multi: false },
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

  it "gets proper defaults for  boolean arguments" do
    parser = Arguments.new(yaml_hash: yaml_hash)
    expect(parser.arg7).to eq(false)
  end

  it "can accept boolean arguments" do
    parser = Arguments.new(yaml_hash: yaml_hash)
    parser.parse(%w{--arg7})
    expect(parser.arg7).to eq(true)
  end

  it "defaults to false for boolean args" do
    parser = Arguments.new(yaml_hash: yaml_hash)
    expect(parser.arg9).to eq(false)
  end

  it "uses nil as default when none is specified" do
    parser = Arguments.new(yaml_hash: yaml_hash)
    expect(parser.arg8).to eq(nil)
  end

  it "can use environment variables for default values"
  it "rejects arguments that are not contained in valid list"
  it "allows use of alternate option name"
  it "rejects argiments that don't match a regex"
end
