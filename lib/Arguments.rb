class Arguments
  def initialize(yaml_hash: {})
    @yaml_hash = yaml_hash
    @args = {}

    @yaml_hash.each do |key, val|
      @args[key] = val[:default] 
    end
  end

  def arg1
    @args[:arg1]
  end

  def arg2
    @args[:arg2]
  end
end
