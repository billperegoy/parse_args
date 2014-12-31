class Arguments
  def initialize(yaml_hash: {})
    @yaml_hash = yaml_hash
    init_args_from_yaml
  end

  def parse(cmd_line_args)
    opt_parser = OptionParser.new do |opts|
      opts.on('--arg1 VAL', 'Arg 1 help') do |val|
        @args[:arg1] = val.to_i
      end

      opts.on('--arg2 VAL', 'Arg 2 help') do |val|
        @args[:arg2] = val.to_i
      end
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
end
