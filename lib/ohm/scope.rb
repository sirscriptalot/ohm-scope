module Ohm
  class Scope
    VERSION = '0.1.0'.freeze

    def initialize(model, dict)
      @model, @dict = model, dict
    end

    def create(**attributes)
      build(**attributes).save
    end

    def build(klass = model, **attributes)
      klass.new(scoped(attributes))
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
      model.find(scoped(attributes))
    end

    protected

    attr_reader :model, :dict

    def scoped(attributes = {})
      attributes.merge(dict)
    end
  end
end
