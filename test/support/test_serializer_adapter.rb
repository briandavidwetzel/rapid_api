class TestSerializerAdapter < RapidApi::SerializerAdapters::Abstract
  def serialize(member)
    return nil
  end

  def serializer_collection(collection)
    return nil
  end
  
end
