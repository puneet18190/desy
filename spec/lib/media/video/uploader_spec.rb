require 'spec_helper'

module Media
  module Video
    describe Uploader do
      let(:media_folder)            { Rails.root.join('spec/support/samples') }
      let(:media_without_extension) { media_folder.join('con verted').to_s }
      let(:valid_video_path)        { media_folder.join('valid video.flv').to_s }
      let(:tmp_valid_video_path)    { media_folder.join('tmp.valid video.flv').to_s }
      let(:media_file)              { File.open(tmp_valid_video_path) }
      let(:media_uploaded)          do 
        ActionDispatch::Http::UploadedFile.new(filename: File.basename(tmp_valid_video_path), tempfile: File.open(tmp_valid_video_path))
      end
      let(:media_hash)              { { filename: 'tmp.valid video', mp4: "#{media_without_extension}.mp4", webm: "#{media_without_extension}.webm" } }
      
      describe 'saving the associated model' do
        before(:all) do
          FileUtils.cp valid_video_path, tmp_valid_video_path
          ['public/media_elements/videos/test', 'tmp/media/video/editing/conversions/test'].each do |folder|
            FileUtils.rm_rf Rails.root.join(folder)
          end
        end
        
        context 'with a File', slow: true do
          let(:video) { ::Video.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media_file) { |v| v.user = User.admin } }
          
          before(:all) do
            video.save!
            video.reload
          end

          include_examples 'after saving a video with a valid not converted media'
        end

        context 'with a ActionDispatch::Http::UploadedFile', slow: true do
          let(:video) { ::Video.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media_uploaded) { |v| v.user = User.admin } }

          before(:all) do
            video.save!
            video.reload
          end

          include_examples 'after saving a video with a valid not converted media'
        end

        context 'with a Hash' do
          let(:video) { ::Video.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media_hash) { |v| v.user = User.admin } }

          before(:all) { video.save! }

          include_examples 'after saving a video with a valid not converted media'
        end
        
        after(:all) do
          FileUtils.rm tmp_valid_video_path if File.exists? tmp_valid_video_path
        end
      end

      describe 'validations' do

        subject { ::Video.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media){ |v| v.user = User.admin }.valid? }

        shared_examples 'when media is a not converted video' do
          context 'when is a valid video' do
            let(:path) { valid_video_path }
            it { should be_true }
          end

          context 'when filename is blank' do
            let(:path) { media_folder.join '.flv' }
            it { should be_false }
          end

          context 'when the extension is not valid' do
            let(:path) { media_folder.join 'valid video.php' }
            it { should be_false }
          end

          context 'when is an invalid video' do
            let(:path) { media_folder.join 'invalid video.flv' }
            it { should be_false }
          end

          context 'when the video is too short' do
            let(:path) { media_folder.join 'short video.mp4' }
            it { should be_false }
          end

          context 'when the media elements folder size exceeds the maximum value allowed' do
            let(:path)                                    { valid_video_path }
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

          include_examples 'when media is a not converted video'
        end

        context 'when media type is a ActionDispatch::Http::UploadedFile' do
          let(:media) { ActionDispatch::Http::UploadedFile.new(filename: File.basename(path), tempfile: File.open(path)) }

          include_examples 'when media is a not converted video'
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
                ::Video.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media_hash) do |v| 
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
              ::Video.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media) do |v| 
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

          context 'when mp4 file extension is invalid' do
            let(:media) { media_hash.merge(mp4: media_hash[:webm]) }
            it { should be_false }
          end

          context 'when webm file extension is invalid' do
            let(:media) { media_hash.merge(webm: media_hash[:mp4]) }
            it { should be_false }
          end

          context 'when mp4 file is not a valid video' do
            let(:media) { media_hash.merge(mp4: media_folder.join('invalid video.mp4').to_s) }
            it { should be_false }
          end

          context 'when webm file is not a valid video' do
            let(:media) { media_hash.merge(webm: media_folder.join('invalid video.webm').to_s) }
            it { should be_false }
          end

          context 'when videos are too short' do
            let(:media) { media_hash.merge(mp4: media_folder.join('short video.mp4').to_s, webm: media_folder.join('short video.webm').to_s) }
            it { should be_false }
          end

          context 'when videos have different durations' do
            let(:media) { media_hash.merge(mp4: media_folder.join('concat 1.mp4').to_s, webm: media_folder.join('concat 2.webm').to_s) }
            it { should be_false }
          end

        end
      end

    end
  end
end