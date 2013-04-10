require 'spec_helper'

module Media
  module Audio
    describe Uploader do

      let(:media_folder)            { Rails.root.join('spec/support/samples') }
      let(:media_without_extension) { media_folder.join('con verted').to_s }
      let(:valid_audio_path)        { media_folder.join('valid audio.m4a').to_s }
      let(:tmp_valid_audio_path)    { media_folder.join('tmp.valid audio.m4a').to_s }
      let(:media_file)              { File.open(tmp_valid_audio_path) }
      let(:media_uploaded)          do 
        ActionDispatch::Http::UploadedFile.new(filename: File.basename(tmp_valid_audio_path), tempfile: File.open(tmp_valid_audio_path))
      end
      let(:media_hash)              { { filename: 'tmp.valid audio', m4a: "#{media_without_extension}.m4a", ogg: "#{media_without_extension}.ogg" } }
      
      describe 'saving the associated model' do
        before(:all) do
          FileUtils.cp valid_audio_path, tmp_valid_audio_path
          ['public/media_elements/audios/test', 'tmp/media/audio/editing/conversions/test'].each do |folder|
            FileUtils.rm_rf Rails.root.join(folder)
          end
        end
        
        context 'with a File', slow: true do
          let(:audio) { ::Audio.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media_file) { |v| v.user = User.admin } }
          
          before(:all) do
            audio.save!
            audio.reload    
          end

          include_examples 'after saving an audio with a valid not converted media'
        end

        context 'with a ActionDispatch::Http::UploadedFile', slow: true do
          let(:audio) { ::Audio.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media_uploaded) { |v| v.user = User.admin } }

          before(:all) do
            audio.save!
            audio.reload
          end

          include_examples 'after saving an audio with a valid not converted media'
        end

        context 'with a Hash' do
          let(:audio) { ::Audio.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media_hash) { |v| v.user = User.admin } }

          before(:all) { audio.save! }

          include_examples 'after saving an audio with a valid not converted media'
        end
        
        after(:all) do
          FileUtils.rm tmp_valid_audio_path if File.exists? tmp_valid_audio_path
        end
      end

      describe 'validations' do

        subject { ::Audio.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media){ |v| v.user = User.admin }.valid? }

        shared_examples 'when media is a not converted audio' do
          context 'when is a valid audio' do
            let(:path) { valid_audio_path }
            it { should be_true }
          end

          context 'when filename is blank' do
            let(:path) { media_folder.join '.m4a' }
            it { should be_false }
          end

          context 'when the extension is not valid' do
            let(:path) { media_folder.join 'valid audio.php' }
            it { should be_false }
          end

          context 'when is an invalid audio' do
            let(:path) { media_folder.join 'invalid audio.m4a' }
            it { should be_false }
          end

          context 'when the audio is too short' do
            let(:path) { media_folder.join 'short audio.m4a' }
            it { should be_false }
          end

          context 'when the media elements folder size exceeds the maximum value allowed' do
            let(:path)                                    { valid_audio_path }
            let(:prev_maximum_media_elements_folder_size) { Media::Uploader::MAXIMUM_MEDIA_ELEMENTS_FOLDER_SIZE }
            before do
              prev_maximum_media_elements_folder_size
              Media::Uploader.const_set :MAXIMUM_MEDIA_ELEMENTS_FOLDER_SIZE, Media::Uploader.media_elements_folder_size-1
            end
            it { should be_false }
            after { Media::Uploader.const_set :MAXIMUM_MEDIA_ELEMENTS_FOLDER_SIZE, prev_maximum_media_elements_folder_size }
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
          it { should be_false }
        end

        context 'when media type is invalid' do
          let(:media) { %w(invalid media type) }
          it { should be_false }
        end

        context 'when media type is a String' do

          context 'when the model is not marked for renaming' do
            context 'when media is valid and not changed' do
              subject do 
                ::Audio.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media_hash) do |v| 
                  v.user = User.admin
                  v.save!
                  v.reload
                end
              end
              it { should be_true }
            end

            context 'when is blank' do
              let(:media) { '' }
              it { should be_false }
            end

            context 'when the processed filename is blank' do
              let(:media) { '%' }
              it { should be_false }
            end
          end

          context 'when the model is marked for media renaming' do
            subject do 
              ::Audio.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media) do |v| 
                v.user = User.admin
                v.rename_media = true
              end.valid?
            end

            context 'when is blank' do
              let(:media) { '' }
              it { should be_false }
            end

            context 'when the name is valid' do
              let(:media) { 'asd' }
              it { should be_true }
            end
          end
        end

        context 'when media is a Hash' do

          context 'when media is valid' do
            let(:media) { media_hash }
            it { should be_true }
          end

          context 'when filename is blank' do
            let(:media) { media_hash.merge(filename: nil) }
            it { should be_false }
          end

          context 'when m4a file extension is invalid' do
            let(:media) { media_hash.merge(m4a: media_hash[:ogg]) }
            it { should be_false }
          end

          context 'when ogg file extension is invalid' do
            let(:media) { media_hash.merge(ogg: media_hash[:m4a]) }
            it { should be_false }
          end

          context 'when m4a file is not a valid audio' do
            let(:media) { media_hash.merge(m4a: media_folder.join('invalid audio.m4a').to_s) }
            it { should be_false }
          end

          context 'when ogg file is not a valid audio' do
            let(:media) { media_hash.merge(ogg: media_folder.join('invalid audio.ogg').to_s) }
            it { should be_false }
          end

          context 'when audios are too short' do
            let(:media) { media_hash.merge(m4a: media_folder.join('short audio.m4a').to_s, ogg: media_folder.join('short audio.ogg').to_s) }
            it { should be_false }
          end

          context 'when audios have different durations' do
            let(:media) { media_hash.merge(m4a: media_folder.join('concat 1.m4a').to_s, ogg: media_folder.join('concat 2.ogg').to_s) }
            it { should be_false }
          end

        end
      end

    end
  end
end