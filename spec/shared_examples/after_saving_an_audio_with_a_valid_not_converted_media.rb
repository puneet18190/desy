shared_examples 'after saving an audio with a valid not converted media' do
  let(:public_relative_folder) { "/media_elements/audios/test/#{audio.id}" }
  let(:folder)                 { "#{Rails.root}/public#{public_relative_folder}" }

  let(:name)                   { 'tmp-valid-audio' }

  let(:url_without_extension)  { "#{public_relative_folder}/#{name}" }
  let(:path_without_extension) { "#{folder}/#{name}" }

  let(:urls)                   { { m4a:   [ url_without_extension, ".m4a" ], 
                                   ogg:   [ url_without_extension, ".ogg" ] } }
  let(:paths)                  { { m4a:   [ path_without_extension, ".m4a" ], 
                                   ogg:   [ path_without_extension, ".ogg" ] } }

  let(:info)                   { Hash[ MESS::AUDIO_FORMATS.map{ |f| [f, Media::Info.new(audio.media.path(f))] } ] }
  let(:metadata)               { Hash[ MESS::AUDIO_FORMATS.map{ |f| [:"#{f}_duration", info[f].duration] } ].merge(creation_mode: :uploaded) }

  it 'resets model rename_media attribute' do
    audio.rename_media.should_not be_true
  end

  it 'resets model skip_conversion attribute' do
    audio.skip_conversion.should_not be_true
  end

  it 'sets the expected metadata' do
    audio.metadata.marshal_dump.should == metadata
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