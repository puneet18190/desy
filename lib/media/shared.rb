require 'media'

module Media
  module Shared
    
    CREATION_MODES = [:uploaded, :composed]

    UPLOADED, COMPOSED = CREATION_MODES

    module InstanceMethods
      def uploaded?
        metadata.creation_mode == UPLOADED
      end

      def composed?
        metadata.creation_mode == COMPOSED
      end

      def modified?
        created_at != updated_at
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

      def overwrite!
        # tags non è un attributo, per cui non risulta tra i cambi; 
        # me lo prendo dall'associazione taggings_tags, visto che non è cambiata
        old_fields = Hash[ v.changes.map{ |col, (old)| [col, old] } << ['tags', v.taggings_tags.map(&:word).join(', ')] ]
        self.metadata.old_fields = old_fields
        self.converted = nil
        self.class.transaction do
          save!
          disable_lessons_containing_me
        end
      end

      private
      def set_creation_mode
        self.metadata.creation_mode = media.present? ? UPLOADED : COMPOSED
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

        validates_presence_of :media, if: proc{ |record| !record.composing }
        validate :media_validation

        attr_accessor :skip_conversion, :rename_media, :composing
      end
    end
  end
end