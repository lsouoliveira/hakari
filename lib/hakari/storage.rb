# frozen_string_literal: true

module Hakari
  class Storage
    def initialize(store_path = File.expand_path("~/.hakari.json"))
      @store_path = store_path
    end

    def store(key, value)
      store = read_store
      store[key] = value
      persist(store)
    end

    def retrieve(key)
      store = read_store
      store[key]
    end

    def clear
      persist({})
    end

    private

    def read_store
      content = File.read(@store_path)
      JSON.parse(content)
    rescue Errno::ENOENT, JSON::ParserError
      {}
    end

    def persist(store)
      File.write(@store_path, JSON.pretty_generate(store))
    end
  end
end
