# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Hakari::Themes::Watcher) do
  describe "#start" do
    it "should start a new thread" do
      tmp_dir = Dir.mktmpdir
      syncer = Hakari::Themes::Syncer.new
      theme_id = 1

      watcher = described_class.new(tmp_dir, syncer, theme_id)

      expect(watcher.start).to(eq(true))

      sleep(0.1)

      watcher.stop
    end
  end

  describe "#stop" do
    it "should stop the thread" do
      tmp_dir = Dir.mktmpdir
      syncer = Hakari::Themes::Syncer.new
      theme_id = 1

      watcher = described_class.new(tmp_dir, syncer, theme_id)
      watcher.start

      sleep(0.1)

      watcher.stop

      sleep(0.1)

      expect(watcher.stopped?).to(eq(true))
    end
  end

  describe "#stopped?" do
    it "should return true if the listener is stopped" do
      tmp_dir = Dir.mktmpdir
      syncer = Hakari::Themes::Syncer.new
      theme_id = 1

      watcher = described_class.new(tmp_dir, syncer, theme_id)
      watcher.start

      sleep(0.1)

      watcher.stop

      expect(watcher.stopped?).to(eq(true))
    end

    it "should return false if the listener is not stopped" do
      tmp_dir = Dir.mktmpdir
      syncer = Hakari::Themes::Syncer.new
      theme_id = 1

      watcher = described_class.new(tmp_dir, syncer, theme_id)
      watcher.start

      sleep(0.1)

      expect(watcher.stopped?).to(eq(false))

      watcher.stop
    end
  end
end
