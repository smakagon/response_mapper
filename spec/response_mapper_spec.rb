# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResponseMapper do
  it 'has a version number' do
    expect(ResponseMapper::VERSION).not_to be_nil
  end

  context 'with valid params' do
    context 'with Array as data' do
      context 'with flat array of primitives' do
        it 'maps objects from mapping' do
          data = [:foo, 'bar', :baz]
          mapping = { foo: 'foo', 'bar' => :bar }

          mapped = ResponseMapper.map(data: data, mapping: mapping)
          expect(mapped).to eq(['foo', :bar, :baz])
        end
      end

      context 'with flat array of hashes' do
        it 'maps keys for hashes' do
          data = [{ foo: 10, baz: 20 }, { foo: 20, baz: 30 }]
          mapped = ResponseMapper.map(data: data, mapping: { foo: :bar })

          expect(mapped).to eq([{ bar: 10, baz: 20 }, { bar: 20, baz: 30 }])
        end
      end

      context 'with nested array of hashes' do
        it 'maps keys for hashes' do
          data = [[{ foo: 10 }, { foo: 20 }], [{ foo: 30 }, { foo: 40 }]]
          mapped = ResponseMapper.map(data: data, mapping: { foo: :bar })
          expect(mapped).to eq(
            [[{ bar: 10 }, { bar: 20 }], [{ bar: 30 }, { bar: 40 }]]
          )
        end
      end

      context 'with mixed types' do
        it 'maps keys for hashes and other types from mapping' do
          data = [{ foo: 10, baz: 20 }, 20, :foo]
          mapped = ResponseMapper.map(data: data, mapping: { foo: :bar })
          expect(mapped).to eq([{ bar: 10, baz: 20 }, 20, :bar])
        end
      end

      context 'with empty array' do
        it 'returns empty array' do
          mapped = ResponseMapper.map(data: [], mapping: { foo: :bar })
          expect(mapped).to eq([])
        end
      end
    end

    context 'with Hash as data' do
    end

    context 'with symbolize_keys: true (default)' do
      it 'symbolizes data keys' do
        data = { 'foo': 'bar' }
        mapping = { foo: :baz }

        mapped = ResponseMapper.map(data: data, mapping: mapping)
        expect(mapped[:baz]).to eq('bar')
      end

      it 'symbolize only Hash keys' do
        data = ['foo', 'bar', { foo: 'bar' }]
        mapping = { foo: :baz }

        mapped = ResponseMapper.map(data: data, mapping: mapping)
        expect(mapped).to eq(['foo', 'bar', { baz: 'bar' }])
      end
    end

    context 'with symbolize_keys: false' do
      it 'does not symbolize data keys' do
        data = { 'foo' => 'bar' }
        mapping = { 'foo' => 'baz' }

        mapped = ResponseMapper.map(
          data: data, mapping: mapping, symbolize_keys: false
        )
        expect(mapped['baz']).to eq('bar')
      end
    end

    context 'when data niether Hash nor Array' do
      it 'returns data as is' do
        result = ResponseMapper.map(data: 'foo', mapping: { foo: :bar })
        expect(result).to eq('foo')
      end
    end
  end

  context 'with invalid mapping params' do
    context 'without mapping hash' do
      it 'raises ResponseMapper::Error' do
        expect { ResponseMapper.map(data: [], mapping: nil) }.to(
          raise_error(ResponseMapper::Error, /provide Hash with mapping/)
        )
      end
    end

    context 'with empty mapping hash' do
      it 'raises ResponseMapper::Error' do
        expect { ResponseMapper.map(data: [], mapping: {}) }.to(
          raise_error(ResponseMapper::Error, /provide Hash with mapping/)
        )
      end
    end
  end
end
