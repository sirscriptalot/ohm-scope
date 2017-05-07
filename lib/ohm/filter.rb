module Ohm
  class Filter
    VERSION = '0.1.0'.freeze

    def initialize(model, scope)
      @model, @scope = model, scope
    end

    def create(**attributes)
      build(**attributes).save
    end

    def build(klass = model, **attributes)
      klass.new(filtered(attributes))
    end

    def [](id)
      all[id]
    end

    def fetch(ids)
      all.fetch(ids.select { |id| exists?(id) })
    end

    def with(key, val)
      instance = model.with(key, val)

      if instance && exists?(instance.id)
        instance
      else
        nil
      end
    end

    def exists?(id)
      !!all[id]
    end

    def all
      find({})
    end

    def find(attributes)
      model.find(filtered(attributes))
    end

    protected

    attr_reader :model, :scope

    def filtered(attributes = {})
      attributes.merge(scope)
    end
  end
end
