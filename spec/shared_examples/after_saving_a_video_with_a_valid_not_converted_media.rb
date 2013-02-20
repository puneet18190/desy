shared_examples 'after saving a video with a valid not converted media' do
  let(:public_relative_folder) { "/media_elements/videos/test/#{video.id}" }
  let(:folder)                 { "#{Rails.root}/public#{public_relative_folder}" }

  let(:name)                   { 'tmp-valid-video' }

  let(:url_without_extension)  { "#{public_relative_folder}/#{name}" }
  let(:path_without_extension) { "#{folder}/#{name}" }

  let(:urls)                   { { mp4:   [ url_without_extension, ".mp4" ], 
                                   webm:  [ url_without_extension, ".webm" ],
                                   cover: [ "#{public_relative_folder}/cover_#{name}", ".jpg" ], 
                                   thumb: [ "#{public_relative_folder}/thumb_#{name}", ".jpg" ] } }
  let(:paths)                  { { mp4:   [ path_without_extension, ".mp4" ], 
                                   webm:  [ path_without_extension, ".webm" ],
                                   cover: [ "#{folder}/cover_#{name}", ".jpg" ], 
                                   thumb: [ "#{folder}/thumb_#{name}", ".jpg" ] } }

  let(:info)                   { Hash[ MESS::VIDEO_FORMATS.map{ |f| [f, Media::Info.new(video.media.path(f))] } ] }
  let(:durations)              { Hash[ MESS::VIDEO_FORMATS.map{ |f| [:"#{f}_duration", info[f].duration] } ] }

  it 'resets model rename_media attribute' do
    video.rename_media.should_not be_true
  end

  it 'resets model skip_conversion attribute' do
    video.skip_conversion.should_not be_true
  end

  it 'sets the expected duration' do
    video.metadata.marshal_dump.should == durations
  end

  it 'sets the expected [:media] value' do
    video[:media].should match MESS::FILENAME_RE.call(name)
  end

  it 'has the expected to_s' do
    video.media.to_s.should match MESS::FILENAME_RE.call(url_without_extension)
  end

  it 'has the expected urls' do
    urls.each do |format, filename_re_arguments|
      video.media.url(format).should match MESS::FILENAME_RE.call(*filename_re_arguments)
    end
  end

  it 'has the expected paths' do
    paths.each do |format, filename_re_arguments|
      video.media.path(format).should match MESS::FILENAME_RE.call(*filename_re_arguments)
    end
  end

  it 'creates valid videos' do
    expect{ info }.to_not raise_error
  end

  it 'creates the video cover' do
    File.exists?(video.media.path(:cover)).should be_true
  end

  it 'creates the video thumb' do
    File.exists?(video.media.path(:thumb)).should be_true
  end
end