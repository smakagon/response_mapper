# frozen_string_literal: true

# Allows to map API response to domain language of your application
#
#   ResponseMapper.map(
#     data: { order_number: 1, order_items: [1,2,3] }
#     mapping: { order_number: :id, order_items: :items }
#   )
#
# Returns nice Hash with proper naming
# which could be used to instantiate Order entity:
# { id: 1, items: [1,2,3] }
#
class ResponseMapper
  VERSION = '0.1.1'

  Error = Class.new(StandardError)

  def self.map(data:, mapping:, symbolize_keys: true)
    new(data, mapping, symbolize_keys).map
  end

  def map
    map_data(data)
  end

  private

  attr_reader :data, :mapping, :symbolize_keys

  def initialize(data, mapping, symbolize_keys)
    @data = data
    @mapping = mapping
    @symbolize_keys = symbolize_keys

    validate_mapping
  end

  def map_data(data)
    case data
    when Hash then map_hash(data)
    when Array then map_array(data)
    else
      data
    end
  end

  def map_hash(hash)
    hash.each_with_object({}) do |(k, v), result|
      k = k.to_sym if symbolize_keys

      mapped_value = [Hash, Array].include?(v.class) ? map_data(v) : v
      mapped_key = mapping.fetch(k, k)

      result[mapped_key] = mapped_value
    end
  end

  def map_array(array)
    array.each_with_object([]) do |entity, arr|
      if [Hash, Array].include?(entity.class)
        arr.push(map_data(entity))
      else
        arr.push(mapping.fetch(entity, entity))
      end
    end
  end

  def validate_mapping
    # rubocop:disable Style/GuardClause
    if !mapping.is_a?(Hash) || mapping&.empty?
      raise Error, 'Please, provide Hash with mapping, for example: { order_number: :id }' # rubocop:disable LineLength
    end
  end
end
