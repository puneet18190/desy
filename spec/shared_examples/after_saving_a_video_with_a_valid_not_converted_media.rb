shared_examples 'after saving a video with a valid not converted media' do
  let(:public_relative_folder) { "/media_elements/videos/test/#{video.id}" }
  let(:absolute_folder)        { "#{Rails.root}/public#{public_relative_folder}" }
  let(:name)                   { 'tmp-valid-video' }
  let(:path_without_extension) { "#{public_relative_folder}/#{name}" }
  let(:paths)                  { { mp4: "#{path_without_extension}.mp4", webm: "#{path_without_extension}.webm",
                                   cover: "#{public_relative_folder}/cover_#{name}.jpg", thumb: "#{public_relative_folder}/thumb_#{name}.jpg" } }
  let(:absolute_paths)         { { mp4: "#{absolute_folder}/#{name}.mp4", webm: "#{absolute_folder}/#{name}.webm",
                                   cover: "#{absolute_folder}/cover_#{name}.jpg", thumb: "#{absolute_folder}/thumb_#{name}.jpg" } }
  let(:info)                   { Hash[ [:mp4, :webm].map{ |f| [f, Media::Info.new(video.media.absolute_path(f))] } ] }
  let(:durations)              { Hash[ [:mp4, :webm].map{ |f| [:"#{f}_duration", info[f].duration] } ] }
  let(:versions)               { [:mp4, :webm, :cover, :thumb] }

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
    video[:media].should == name
  end

  it 'has the expected to_s' do
    video.media.to_s.should == path_without_extension
  end

  it 'has the expected paths' do
    Hash[ versions.map{ |f| [f, video.media.path(f)] } ].should == paths
  end

  it 'has the expected absolute_paths' do
    Hash[ versions.map{ |f| [f, video.media.absolute_path(f)] } ].should == absolute_paths
  end

  it 'creates valid videos' do
    expect{ info }.to_not raise_error
  end

  it 'creates the video cover' do
    File.exists?(video.media.absolute_path(:cover)).should be_true
  end

  it 'creates the video thumb' do
    File.exists?(video.media.absolute_path(:thumb)).should be_true
  end
end