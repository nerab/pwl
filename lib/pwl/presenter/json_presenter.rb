require 'jbuilder'

module Pwl
  class JsonPresenter
    def initialize(store)
        @store = store
    end

    def to_s
      Jbuilder.encode do |json|
        json.(@store, :created, :last_accesses, :last_modified)

        json.entries @store.all do |json, entry|
          json.key entry.key
          json.value entry.value
        end
      end
    end
  end
end