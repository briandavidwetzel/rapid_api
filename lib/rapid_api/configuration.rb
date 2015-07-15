module RapidApi
  class Configuration
    include Singleton

    attr_accessor :model_adapter, :serializer_adapter

  end
end
