class TestSerializerAdapter < RapidApi::SerializerAdapters::Abstract
  def serialize(member)
    return nil
  end

  def serializer_collection(collection)
    return nil
  end

  def deserialize_attributes(params, root_key)
    params.require(root_key)
  end

  def deserialize_id(params, root_key)
    params.require(:id)
  end

end
