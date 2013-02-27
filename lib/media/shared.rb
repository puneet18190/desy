require 'media'

module Media
  module Shared
    
    CREATION_MODES = [:uploading, :composing]

    UPLOADING_CREATION_MODE, COMPOSING_CREATION_MODE = CREATION_MODES

    PLACEHOLDER_URL = '/assets/media_placeholder.gif'

    # module ClassMethods  
    # end
    
    module InstanceMethods
      def uploaded?
        metadata.creation_mode == UPLOADING_CREATION_MODE
      end

      def composed?
        metadata.creation_mode == COMPOSING_CREATION_MODE
      end

      def modified?
        created_at == updated_at
      end

      def composing
        metadata.composing
      end
      
      def composing=(composing)
        metadata.composing = composing
      end

      def media
        @media || ( 
          media = read_attribute(:media)
          media ? self.class::UPLOADER.new(self, :media, media) : nil 
        )
      end

      def media=(media)
        @media = write_attribute :media, (media.present? ? self.class::UPLOADER.new(self, :media, media) : nil)
      end

      def reload
        @media = @skip_conversion = @rename_media = nil
        super
      end

      def reload_media
        @media = nil
      end

      def cannot_destroy_while_converting
        !converted.nil?
      end

      def placeholder_url
        PLACEHOLDER_URL
      end

      private
      def set_creation_mode
        self.metadata.creation_mode = composing.present? ? COMPOSING_CREATION_MODE : UPLOADING_CREATION_MODE
        true
      end

      def media_validation
        media.validation if media
      end

      def upload_or_copy
        media.upload_or_copy if media
        true
      end
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods

      receiver.instance_eval do
        before_create  :set_creation_mode
        after_save     :upload_or_copy
        before_destroy :cannot_destroy_while_converting
        after_destroy  :clean

        validates_presence_of :media, if: proc{ |record| record.composing.blank? }
        validate :media_validation

        attr_accessor :skip_conversion, :rename_media
      end
    end
  end
end