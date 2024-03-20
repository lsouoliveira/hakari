# frozen_string_literal: true

module Hakari
  module Themes
    class Watcher
      def initialize(source_path, syncer, theme_id)
        @source_path = source_path
        @syncer = syncer
        @theme_id = theme_id
      end

      def start
        @listener = Listen.to(@source_path) do
          @syncer.enqueue_theme_upload(@theme_id, @source_path)
        end

        @listener.start
      end

      def stop
        @listener.stop
      end

      def stopped?
        @listener.stopped?
      end
    end
  end
end
