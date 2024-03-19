# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Hakari::Themes::Syncer) do
  describe "#enqueue_theme_upload" do
    context "when the last sync was less than the threshold" do
      it "should enqueue a theme for upload" do
        syncer = described_class.new

        allow(syncer).to(receive(:can_enqueue?).and_return(true))
        syncer.enqueue_theme_upload(1, "path/to/theme")

        expect(syncer.queue.size).to(eq(1))
      end
    end

    context "when the last sync was more than the threshold" do
      it "should not enqueue a theme for upload" do
        syncer = described_class.new

        allow(syncer).to(receive(:can_enqueue?).and_return(false))
        syncer.enqueue_theme_upload(1, "path/to/theme")

        expect(syncer.queue.size).to(eq(0))
      end
    end
  end

  describe "#start" do
    it "should start a new thread" do
      syncer = described_class.new
      thread = syncer.start

      expect(syncer.instance_variable_get(:@thread)).to(be_a(Thread))

      syncer.stop
      thread.join
    end

    it "should upload themes from the queue" do
      syncer = described_class.new
      thread = syncer.start

      allow(syncer).to(receive(:upload_theme))

      syncer.instance_variable_set(:@last_sync, Time.now - Hakari::Themes::Syncer::LAST_SYNC_THRESHOLD - 0.1)
      syncer.enqueue_theme_upload(1, "path/to/theme")

      expect(syncer).to(have_received(:upload_theme).with(1, "path/to/theme"))

      syncer.stop
      thread.join
    end
  end

  describe "#stop" do
    it "should stop the thread" do
      syncer = described_class.new
      thread = syncer.start
      syncer.stop
      thread.join

      expect(thread.alive?).to(be(false))
    end
  end

  describe "#can_enqueue?" do
    context "when the last sync was less than the threshold" do
      it "should return false" do
        syncer = described_class.new
        syncer.instance_variable_set(:@last_sync, Time.now - Hakari::Themes::Syncer::LAST_SYNC_THRESHOLD + 0.1)

        expect(syncer.can_enqueue?).to(be(false))
      end
    end

    context "when the last sync was more than the threshold" do
      it "should return true" do
        syncer = described_class.new
        syncer.instance_variable_set(:@last_sync, Time.now - Hakari::Themes::Syncer::LAST_SYNC_THRESHOLD - 0.1)

        expect(syncer.can_enqueue?).to(be(true))
      end
    end
  end

  describe "#upload_theme" do
    it "should pack and upload the theme" do
      syncer = described_class.new
      theme = Hakari::Api::Theme.new(id: 1, name: "Test Theme")

      allow_any_instance_of(Hakari::Api::Themes).to(receive(:patch))
        .and_return(theme)
      result = syncer.upload_theme(1, File.join("spec", "fixtures", "theme"))

      expect(result).to(eq(theme))
    end

    context "when the theme fails to upload" do
      it "should return nil" do
        syncer = described_class.new

        allow_any_instance_of(Hakari::Api::Themes).to(receive(:patch))
          .and_raise(Hakari::Error.new("Error syncing theme"))

        result = syncer.upload_theme(1, File.join("spec", "fixtures", "theme"))

        expect(result).to(be_nil)
      end
    end
  end
end
