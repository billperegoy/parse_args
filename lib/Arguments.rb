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
      @args[key] = arg_default(val)
      create_accessor(key)
      create_setter(key)
    end
  end

  def arg_default(arg)
    if is_boolean_arg?(arg)
      no_default_provided?(arg)  ? false : arg[:default]
    else
      if arg[:multi] && no_default_provided?(arg)
        []
      else
        arg[:default]
      end
    end
  end

  def no_default_provided?(arg)
    arg[:default] == nil
  end

  def is_boolean_arg?(arg)
    arg[:type] == 'boolean'
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
    if @yaml_hash[key][:type] == 'boolean'
      add_boolean_option_to_parser(opts, key, val)
    else
      add_non_boolean_option_to_parser(opts, key, val)
    end
  end

  def add_non_boolean_option_to_parser(opts, key, val)
    opts.on("--#{key.to_sym} VAL", val[:usage]) do |val|
      if @yaml_hash[key][:type] == 'integer'
        casted_val = val.to_i
      elsif @yaml_hash[key][:type] == 'string'
        casted_val = val.to_s
      else
        raise "Unknown argumet type: #{@yaml_hash[key][:type]}"
      end
      update_arg(key: key, val: casted_val, multi: @yaml_hash[key][:multi])
    end
  end

  def add_boolean_option_to_parser(opts, key, val)
    opts.on("--#{key.to_sym}", val[:usage]) do
      @args[key] = true
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
