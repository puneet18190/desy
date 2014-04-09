require 'spec_helper'

module Media
  module Audio
    describe Uploader do

      def media_folder
        @media_folder ||= Rails.root.join('spec/support/samples')
      end

      def media_without_extension
        @media_without_extension ||= media_folder.join('con verted').to_s
      end

      def valid_media_path
        @valid_media_path ||= media_folder.join('valid audio.m4a').to_s
      end

      def tmp_valid_media_path
        @tmp_valid_media_path ||= media_folder.join('tmp.valid audio.m4a').to_s
      end

      def media_file
        @media_file ||= File.open(tmp_valid_media_path)
      end

      def media_uploaded
        @media_uploaded ||= ActionDispatch::Http::UploadedFile.new(filename: File.basename(tmp_valid_media_path), tempfile: File.open(tmp_valid_media_path))
      end
      
      def media_hash
        @media_hash ||= { filename: 'tmp.valid audio', m4a: "#{media_without_extension}.m4a", ogg: "#{media_without_extension}.ogg" }
      end

      def media_hash_full
        @media_hash_full ||= media_hash.merge( m4a_duration: Info.new(media_hash[:m4a]).duration ,
                                               ogg_duration: Info.new(media_hash[:ogg]).duration )
      end
      
      describe 'saving the associated model' do
        before(:all) do
          FileUtils.cp valid_media_path, tmp_valid_media_path
          ['public/media_elements/audios/test', 'tmp/media/audio/editing/conversions/test'].each do |folder|
            FileUtils.rm_rf Rails.root.join(folder)
          end
        end
        
        context 'with a File', slow: true do
          def media
            media_file
          end
          def audio
            @audio ||= ::Audio.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media, user: User.admin)
          end
          
          before(:all) do
            audio.save!
            audio.reload
          end

          include_examples 'after saving an audio with a valid not converted media'
        end

        context 'with a ActionDispatch::Http::UploadedFile', slow: true do
          def media
            media_uploaded
          end
          def audio
            @audio ||= ::Audio.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media_uploaded, user: User.admin)
          end

          before(:all) do
            audio.save!
            audio.reload
          end

          include_examples 'after saving an audio with a valid not converted media'
        end

        context 'with a Hash' do
          context 'without durations and version paths' do
            def media
              media_hash
            end
            def audio
              @audio ||= ::Audio.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media_hash, user: User.admin)
            end

            before(:all) { audio.save! }

            include_examples 'after saving an audio with a valid not converted media'
          end

          context 'with durations and version paths' do
            def media
              media_hash_full
            end
            def audio
              @audio ||= ::Audio.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media_hash_full, user: User.admin)
            end

            before(:all) { audio }

            it "uses metadata durations provided by the hash" do
              expect(Media::Info).to_not receive(:new)
              audio.save!
            end

            context 'after saving' do
              def audio
                @audio ||= ::Audio.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media_hash_full, user: User.admin)
              end

              before(:all) { audio.save! }

              include_examples 'after saving an audio with a valid not converted media'
            end
          end
        end
        
        after(:all) do
          FileUtils.rm tmp_valid_media_path if File.exists? tmp_valid_media_path
        end
      end

      describe 'validations' do

        subject { ::Audio.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media, user: User.admin).valid? }

        shared_examples 'when media is a not converted audio' do
          context 'when is a valid audio' do
            let(:path) { valid_media_path }
            it { expect(subject).to be true }
          end

          context 'when filename is blank' do
            let(:path) { media_folder.join '.m4a' }
            it { expect(subject).to be false }
          end

          context 'when the extension is not valid' do
            let(:path) { media_folder.join 'valid audio.php' }
            it { expect(subject).to be false }
          end

          context 'when is an invalid audio' do
            let(:path) { media_folder.join 'invalid audio.m4a' }
            it { expect(subject).to be false }
          end

          context 'when the audio is too short' do
            let(:path) { media_folder.join 'short audio.m4a' }
            it { expect(subject).to be false }
          end

          context 'when the media elements folder size exceeds the maximum value allowed' do
            let(:path)                                    { valid_media_path }
            let(:prev_maximum_media_elements_folder_size) { Media::Uploader::MAXIMUM_MEDIA_ELEMENTS_FOLDER_SIZE }
            before do
              prev_maximum_media_elements_folder_size
              silence_warnings { Media::Uploader.const_set :MAXIMUM_MEDIA_ELEMENTS_FOLDER_SIZE, Media::Uploader.media_elements_folder_size-1 }
            end
            it { expect(subject).to be false }
            after { silence_warnings { Media::Uploader.const_set :MAXIMUM_MEDIA_ELEMENTS_FOLDER_SIZE, prev_maximum_media_elements_folder_size } }
          end
        end

        context 'when media type is a File' do
          let(:media) { File.open(path) }

          include_examples 'when media is a not converted audio'
        end

        context 'when media type is a ActionDispatch::Http::UploadedFile' do
          let(:media) { ActionDispatch::Http::UploadedFile.new(filename: File.basename(path), tempfile: File.open(path)) }

          include_examples 'when media is a not converted audio'
        end

        context 'when media type is blank' do
          let(:media) { nil }
          it { expect(subject).to be false }
        end

        context 'when media type is invalid' do
          let(:media) { %w(invalid media type) }
          it { expect(subject).to be false }
        end

        context 'when media type is a String' do

          context 'when the model is not marked for renaming' do
            context 'when media is valid and not changed' do
              subject do 
                ::Audio.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media_hash, user: User.admin) do |v|
                  v.save!
                  v.reload
                end.valid?
              end
              it { expect(subject).to be true }
            end

            context 'when is blank' do
              let(:media) { '' }
              it { expect(subject).to be false }
            end

            context 'when the processed filename is blank' do
              let(:media) { '%' }
              it { expect(subject).to be false }
            end
          end

          context 'when the model is marked for media renaming' do
            subject do 
              ::Audio.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media, user: User.admin) do |v| 
                v.rename_media = true
              end.valid?
            end

            context 'when is blank' do
              let(:media) { '' }
              it { expect(subject).to be false }
            end

            context 'when the name is valid' do
              let(:media) { 'asd' }
              it { expect(subject).to be true }
            end
          end
        end

        context 'when media is a Hash' do

          context 'when media is valid' do
            let(:media) { media_hash }
            it { expect(subject).to be true }
          end

          context 'when filename is blank' do
            let(:media) { media_hash.merge(filename: nil) }
            it { expect(subject).to be false }
          end

          context 'when m4a file extension is invalid' do
            let(:media) { media_hash.merge(m4a: media_hash[:ogg]) }
            it { expect(subject).to be false }
          end

          context 'when ogg file extension is invalid' do
            let(:media) { media_hash.merge(ogg: media_hash[:m4a]) }
            it { expect(subject).to be false }
          end

          context 'when m4a file is not a valid audio' do
            let(:media) { media_hash.merge(m4a: media_folder.join('invalid audio.m4a').to_s) }
            it { expect(subject).to be false }
          end

          context 'when ogg file is not a valid audio' do
            let(:media) { media_hash.merge(ogg: media_folder.join('invalid audio.ogg').to_s) }
            it { expect(subject).to be false }
          end

          context 'when audios are too short' do
            let(:media) { media_hash.merge(m4a: media_folder.join('short audio.m4a').to_s, ogg: media_folder.join('short audio.ogg').to_s) }
            it { expect(subject).to be false }
          end

          context 'when audios have different durations' do
            let(:media) { media_hash.merge(m4a: media_folder.join('concat 1.m4a').to_s, ogg: media_folder.join('concat 2.ogg').to_s) }
            it { expect(subject).to be false }
          end

        end
      end

    end
  end
end