shared_examples 'after saving an audio with a valid not converted media' do
  let(:public_relative_folder) { "/media_elements/audios/test/#{audio.id}" }
  let(:folder)                 { "#{Rails.root}/public#{public_relative_folder}" }

  let(:name)                   { 'tmp-valid-audio' }

  let(:url_without_extension)  { "#{public_relative_folder}/#{name}" }
  let(:path_without_extension) { "#{folder}/#{name}" }

  let(:urls)                   { { mp3:   [ url_without_extension, ".mp3" ], 
                                   ogg:   [ url_without_extension, ".ogg" ] } }
  let(:paths)                  { { mp3:   [ path_without_extension, ".mp3" ], 
                                   ogg:   [ path_without_extension, ".ogg" ] } }

  let(:info)                   { Hash[ MESS::AUDIO_FORMATS.map{ |f| [f, Media::Info.new(audio.media.path(f))] } ] }
  let(:durations)              { Hash[ MESS::AUDIO_FORMATS.map{ |f| [:"#{f}_duration", info[f].duration] } ] }

  it 'resets model rename_media attribute' do
    audio.rename_media.should_not be_true
  end

  it 'resets model skip_conversion attribute' do
    audio.skip_conversion.should_not be_true
  end

  it 'sets the expected duration' do
    audio.metadata.marshal_dump.should == durations
  end

  it 'sets the expected [:media] value' do
    audio[:media].should match MESS::FILENAME_RE.call(name)
  end

  it 'has the expected to_s' do
    audio.media.to_s.should match MESS::FILENAME_RE.call(url_without_extension)
  end

  it 'has the expected urls' do
    urls.each do |format, filename_re_arguments|
      audio.media.url(format).should match MESS::FILENAME_RE.call(*filename_re_arguments)
    end
  end

  it 'has the expected paths' do
    paths.each do |format, filename_re_arguments|
      audio.media.path(format).should match MESS::FILENAME_RE.call(*filename_re_arguments)
    end
  end

  it 'creates valid audios' do
    expect{ info }.to_not raise_error
  end
end