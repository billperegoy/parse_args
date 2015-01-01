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
        if @yaml_hash[key][:multi]
          if @args[key].empty?
            @args[key] = [val.to_i]
          else
            @args[key] << val.to_i
          end
        else
          @args[key] = val.to_i
        end
      else
        if @yaml_hash[key][:multi]
          if @args[key].empty?
            @args[key] = [val]
          else
            @args[key] << val
          end
        else
          @args[key] = val
        end
      end
    end
  end
end
