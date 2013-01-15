shared_examples 'after saving an audio with a valid not converted media' do
  let(:public_relative_folder) { "/media_elements/audios/test/#{audio.id}" }
  let(:folder)                 { "#{Rails.root}/public#{public_relative_folder}" }
  let(:name)                   { 'tmp-valid-audio' }
  let(:url_without_extension)  { "#{public_relative_folder}/#{name}" }
  let(:urls)                   { { mp3: "#{url_without_extension}.mp3", ogg: "#{url_without_extension}.ogg"} }
  let(:paths)                  { { mp3: "#{folder}/#{name}.mp3", ogg: "#{folder}/#{name}.ogg" } }
  let(:info)                   { Hash[ [:mp3, :ogg].map{ |f| [f, Media::Info.new(audio.media.path(f))] } ] }
  let(:durations)              { Hash[ [:mp3, :ogg].map{ |f| [:"#{f}_duration", info[f].duration] } ] }
  let(:versions)               { [:mp3, :ogg] }

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
    audio[:media].should == name
  end

  it 'has the expected to_s' do
    audio.media.to_s.should == url_without_extension
  end

  it 'has the expected urls' do
    Hash[ versions.map{ |f| [f, audio.media.url(f)] } ].should == urls
  end

  it 'has the expected paths' do
    Hash[ versions.map{ |f| [f, audio.media.path(f)] } ].should == paths
  end

  it 'creates valid audios' do
    expect{ info }.to_not raise_error
  end

end