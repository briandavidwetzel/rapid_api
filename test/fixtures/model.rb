class Model
  FILE_DIGEST = Digest::MD5.hexdigest(File.open(__FILE__).read)

  def self.model_name
    @_model_name ||= ActiveModel::Name.new(self)
  end

  def initialize(hash={})
    @attributes = hash
  end

  def cache_key
    "#{self.class.name.downcase}/#{self.id}-#{self.updated_at.strftime("%Y%m%d%H%M%S%9N")}"
  end

  def cache_key_with_digest
    "#{cache_key}/#{FILE_DIGEST}"
  end

  def updated_at
    @attributes[:updated_at] ||= DateTime.now.to_time
  end

  def read_attribute_for_serialization(name)
    if name == :id || name == 'id'
      id
    else
      @attributes[name]
    end
  end

  def id
    @attributes[:id] || @attributes['id'] || object_id
  end

  def method_missing(meth, *args)
    if meth.to_s =~ /^(.*)=$/
      @attributes[$1.to_sym] = args[0]
    elsif @attributes.key?(meth)
      @attributes[meth]
    else
      super
    end
  end

end
