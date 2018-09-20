require 'active_model_serializers'

class BrickSerializer < ActiveModel::Serializer
  attributes :id,
             :color,
             :weight,
             :material
end
