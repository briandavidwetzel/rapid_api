require 'active_model_serializers'

class BrickSerializer < ActiveModel::Serializer
  attributes :color,
             :weight,
             :material
end
