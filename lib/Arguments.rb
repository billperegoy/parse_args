class Arguments
  def initialize(yaml_hash: {})
    @yaml_hash = yaml_hash
    init_args_from_yaml
  end

  def parse(cmd_line_args)
    opt_parser = OptionParser.new do |opts|
      @yaml_hash.each { |key, val| add_option_to_parser(opts, key, val) }
    end
    opt_parser.parse!(cmd_line_args)
  end

  private
  def init_args_from_yaml
    @args = {}
    @yaml_hash.each do |key, val|
      @args[key] = val[:default]
      create_accessor(key)
      create_setter(key)
    end
  end

  def create_accessor(method)
    self.class.send(:define_method, method) do
      @args[method]
    end
  end

  def create_setter(method)
    name = method.to_s + '='
    self.class.send(:define_method, name.to_sym) do |val|
      @args[method] = val
    end
  end

  def add_option_to_parser(opts, key, val)
    opts.on("--#{key.to_sym} VAL", val[:usage]) do |val|
      if @yaml_hash[key][:type] == Integer
        casted_val = val.to_i
      elsif @yaml_hash[key][:type] == String
        casted_val = val.to_s
      else
        raise "Unknown argumet type: #{@yaml_hash[key][:type]}"
      end
      update_arg(key: key, val: casted_val, multi: @yaml_hash[key][:multi])
    end
  end

  def update_arg(key:, val:, multi: false)
    if multi
      update_multi_arg(key: key, val: val)
    else
      update_single_arg(key: key, val: val)
    end
  end

  def update_multi_arg(key:, val:)
    if @args[key].empty?
      @args[key] = [val]
    else
      @args[key] << val
    end
  end

  def update_single_arg(key:, val:)
    @args[key] = val
  end
end
