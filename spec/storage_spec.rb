# frozen_string_literal: true

require "spec_helper"
require "tempfile"

RSpec.describe(Hakari::Storage) do
  describe "#store" do
    context "when the store is empty" do
      it "should store the key and value" do
        temp_file = Tempfile.new
        storage = Hakari::Storage.new(temp_file.path)

        storage.store("key", "value")

        content = temp_file.read
        json = JSON.parse(content)

        expect(json.to_s).to(eq("{\"key\"=>\"value\"}"))
      end
    end

    context "when the store is not empty" do
      it "should store the key 'key2' with value 'value2'" do
        store = {
          "key" => "value",
        }

        temp_file = Tempfile.new
        temp_file.write(store.to_json)
        temp_file.rewind

        storage = Hakari::Storage.new(temp_file.path)

        storage.store("key2", "value2")

        content = temp_file.read
        json = JSON.parse(content)

        expect(json.to_s).to(eq("{\"key\"=>\"value\", \"key2\"=>\"value2\"}"))
      end
    end
  end

  describe "#retrieve" do
    context "when the store is empty" do
      it "should return nil" do
        temp_file = Tempfile.new
        storage = Hakari::Storage.new(temp_file.path)

        expect(storage.retrieve("key")).to(be_nil)
      end
    end

    context "when the store is not empty" do
      it "should return the value for the key" do
        store = {
          "key" => "value",
        }

        temp_file = Tempfile.new
        temp_file.write(store.to_json)
        temp_file.rewind

        storage = Hakari::Storage.new(temp_file.path)

        expect(storage.retrieve("key")).to(eq("value"))
      end
    end
  end

  describe "#clear" do
    it "should clear the store" do
      store = {
        "key" => "value",
      }

      temp_file = Tempfile.new
      temp_file.write(store.to_json)
      temp_file.rewind

      storage = Hakari::Storage.new(temp_file.path)

      storage.clear

      content = temp_file.read
      json = JSON.parse(content)

      expect(json).to(be_empty)
    end
  end
end
