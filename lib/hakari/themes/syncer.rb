# frozen_string_literal: true

module Hakari
  module Themes
    class Syncer
      LAST_SYNC_THRESHOLD = 1

      attr_reader :queue

      def initialize
        @queue = Queue.new
        @last_sync = Time.now
      end

      def enqueue_theme_upload(theme_id, source_path)
        return unless can_enqueue?

        @queue << { theme_id: theme_id, source_path: source_path }
        @last_sync = Time.now
      end

      def start
        @thread = Thread.new do
          loop do
            task_info = @queue.pop

            upload_theme(task_info[:theme_id], task_info[:source_path])
          end
        end
      end

      def stop
        @thread.kill if @thread.alive?
      end

      def upload_theme(theme_id, source_path)
        log("Syncing theme ##{"#{theme_id}".colorize(:green)}...")

        packer = Hakari::Themes::Packer.new(source_path)
        package = packer.pack

        payload = {
          id: theme_id,
          file: package,
        }

        theme = Hakari.api_client.themes.patch(**payload)
        log("Theme synced")

        theme
      rescue StandardError => e
        log("Error syncing theme: #{e.message}", :error)
      end

      def can_enqueue?
        Time.now - @last_sync > LAST_SYNC_THRESHOLD
      end
    end
  end
end
