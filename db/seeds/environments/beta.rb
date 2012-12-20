# encoding: UTF-8

def plant_development_seeds
  
  # INITIALIZE
  
  videos_folder = Media::Video::Uploader::ABSOLUTE_FOLDER
  audios_folder = Media::Audio::Uploader::ABSOLUTE_FOLDER
  [videos_folder, audios_folder].each { |d| FileUtils.rm_rf d if Dir.exists? d }
  
  
  # LOCATIONS
  
  shanghai = Location.find_by_description 'Shanghai'
  guangzhou = Location.find_by_description 'Guangzhou'
  wuhan = Location.find_by_description 'Wuhan'
  beijing = Location.find_by_description 'Beijing'
  tianjin = Location.find_by_description 'Tianjin'
  shenzhen = Location.find_by_description 'Shenzhen'
  nanjing = Location.find_by_description 'Nanjing'
  
  puts "Saved #{Location.count} locations (should be #{CONFIG['locations'].length})\n"
  
  
  # SUBJECTS
  
  mathematics = Subject.find_by_description 'Mathematics'
  natural_sciences = Subject.find_by_description 'Natural Sciences'
  geography = Subject.find_by_description 'Geography'
  history = Subject.find_by_description 'History'
  visive_arts = Subject.find_by_description 'Visive Arts'
  music = Subject.find_by_description 'Music'
  physical_education = Subject.find_by_description 'Phisycal Education'
  computer_science = Subject.find_by_description 'Computer Science'
  languages = Subject.find_by_description 'Languages'
  literature = Subject.find_by_description 'Literature'
  chemistry = Subject.find_by_description 'Chemistry'
  
  puts "Saved #{Subject.count} subjects (should be #{CONFIG['subjects'].length})\n"
  
  
  # SCHOOL LEVELS
  
  primary_school = SchoolLevel.find_by_description 'Primary School'
  secondary_school = SchoolLevel.find_by_description 'Secondary School'
  undergraduate = SchoolLevel.find_by_description 'Undergraduate'
  
  puts "Saved #{SchoolLevel.count} school_levels (should be #{CONFIG['school_levels'].length})\n"
  
  
  # USERS
  
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 1} user...\r"
  $stdout.flush
  admin = User.find_by_email CONFIG['admin_email']
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 2} user...\r"
  $stdout.flush
  toostrong = User.create_user 'toostrong@morganspa.com', 'Oscar', 'Pettinari', 'ITC BrokenTower', secondary_school.id, shenzhen.id, [mathematics.id, natural_sciences.id]
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 3} user...\r"
  $stdout.flush
  fupete = User.create_user 'fupete@morganspa.com', 'Massimo', 'Decimomeridio', 'ISS Pro', undergraduate.id, shanghai.id, [natural_sciences.id, computer_science.id, chemistry.id]
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 4} user...\r"
  $stdout.flush
  jeg = User.create_user 'jeg@morganspa.com', 'Hiroshi', 'Sheba', 'ISA Carlocracco', secondary_school.id, wuhan.id, [literature.id, computer_science.id, geography.id]
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 5} user...\r"
  $stdout.flush
  holly = User.create_user 'holly@morganspa.com', 'Oliver', 'Hutton', 'ITC Pocotopocoto', primary_school.id, beijing.id, [mathematics.id, visive_arts.id, music.id]
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 6} user...\r"
  $stdout.flush
  benji = User.create_user 'benji@morganspa.com', 'Benji', 'Price', 'ITC Pocotopocoto', primary_school.id, tianjin.id, [mathematics.id, visive_arts.id, music.id, literature.id]
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 7} user...\r"
  $stdout.flush
  retlaw = User.create_user 'retlaw@morganspa.com', 'Retlaw', 'Ofracs', 'ISA Amor III', undergraduate.id, shenzhen.id, [mathematics.id, visive_arts.id, music.id, literature.id, natural_sciences.id, geography.id, chemistry.id]
  
  puts "Saved #{User.count} users (should be 7)\n"
  puts "Saved #{UsersSubject.count} users_subjects (should be #{22 + CONFIG['subjects'].length})\n"
  
  
  # IMAGES
  
  pub_date = Time.zone.now
  
  image1 = Image.new
  image1.title = 'A couple of donkeys'
  image1.description = 'A nice picture. Two donkeys smiling!'
  image1.tags = 'animal, smile, teeth, nature, science'
  image1.media = File.open(Rails.root.join('db/seeds/images/asino.jpg'))
  image1.user_id = holly.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 1} image...\r"
  $stdout.flush
  image1.save!
  image1.is_public = true
  image1.publication_date = pub_date
  image1.save!
  
  pub_date += 1
  
  image2 = Image.new
  image2.title = 'Futuristic architecture'
  image2.description = 'Between the end of the twentieth century and early twenty-first century, in the city of Valencia (Spain), several architectural and urban projects took place.'
  image2.tags = 'future, architecture, art, design, spain, valencia, geography'
  image2.media =  File.open(Rails.root.join('db/seeds/images/architettura.jpg'))
  image2.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 2} image...\r"
  $stdout.flush
  image2.save!
  image2.is_public = true
  image2.publication_date = pub_date
  image2.save!
  
  pub_date += 1
  
  image3 = Image.new
  image3.title = 'Birds'
  image3.description = 'Sea gulls are birds of medium size: a small sea gull measures around 30 centimeters (for a weight of 120 grams), while a big one can reah 75 centimeters (for 200 grams kilos).'
  image3.tags = 'animal, birds, fly, sea, sky, new york, geography'
  image3.media = File.open(Rails.root.join('db/seeds/images/uccelli.jpg'))
  image3.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 3} image...\r"
  $stdout.flush
  image3.save!
  image3.is_public = true
  image3.publication_date = pub_date
  image3.save!
  
  pub_date += 1
  
  image4 = Image.new
  image4.title = 'Traffic'
  image4.description = 'A picture from New York City. The metropolitan area of ​​New York is located at the intersection of three states (New York, New Jersey and Connecticut).'
  image4.tags = 'city, traffic, urban, new york, geography'
  image4.media = File.open(Rails.root.join('db/seeds/images/city.jpg'))
  image4.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 4} image...\r"
  $stdout.flush
  image4.save!
  image4.is_public = true
  image4.publication_date = pub_date
  image4.save!
  
  pub_date += 1
  
  image5 = Image.new
  image5.title = 'Iguana'
  image5.description = 'A beautiful picture of an iguana. Iguanas are very similar to lizards, but bigger and slower.'
  image5.tags = 'science, animal, nature, reptile, geography, iguana'
  image5.media = File.open(Rails.root.join('db/seeds/images/rettile.jpg'))
  image5.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 5} image...\r"
  $stdout.flush
  image5.save!
  image5.is_public = true
  image5.publication_date = pub_date
  image5.save!
  
  pub_date += 1
  
  image6 = Image.new
  image6.title = 'Wind'
  image6.description = 'Wind power is the energy obtained from the wind. Today it is mostly converted into electricity by a wind farm, while in the past wind energy was directly used by a local factory.'
  image6.tags = 'science, energy, wind, sky, geography, nature'
  image6.media = File.open(Rails.root.join('db/seeds/images/energia_del_vento.jpg'))
  image6.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 6} image...\r"
  $stdout.flush
  image6.save!
  image6.is_public = true
  image6.publication_date = pub_date
  image6.save!
  
  pub_date += 1
  
  image7 = Image.new
  image7.title = 'Love for art'
  image7.description = 'Chuck Close (Snohomish County, July 5, 1940) is an American painter and photographer.'
  image7.tags = 'art, museum, love, new york, creative, idea, mom, close'
  image7.media = File.open(Rails.root.join('db/seeds/images/coppia.jpg'))
  image7.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 7} image...\r"
  $stdout.flush
  image7.save!
  image7.is_public = true
  image7.publication_date = pub_date
  image7.save!
  
  pub_date += 1
  
  image8 = Image.new
  image8.title = 'Compact disk'
  image8.description = 'The compact disc is composed of a disk of transparent polycarbonate, generally 12 centimeters in diameter, covered at the top by a thin sheet of metal material.'
  image8.tags = 'science, optical, disc, compact disc, music, light, laser'
  image8.media = File.open(Rails.root.join('db/seeds/images/cd.jpg'))
  image8.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 8} image...\r"
  $stdout.flush
  image8.save!
  image8.is_public = true
  image8.publication_date = pub_date
  image8.save!
  
  pub_date += 1
  
  image9 = Image.new
  image9.title = 'Flowers'
  image9.description = 'A picture of nice colored flowers, to be used in any natural science lesson.'
  image9.tags = 'science, nature, color, flower, air, smell'
  image9.media = File.open(Rails.root.join('db/seeds/images/fiori.jpg'))
  image9.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 9} image...\r"
  $stdout.flush
  image9.save!
  image9.is_public = true
  image9.publication_date = pub_date
  image9.save!
  
  pub_date += 1
  
  image10 = Image.new
  image10.title = 'Battery'
  image10.description = 'A battery is a device consisting of one or more electrochemical cells that convert stored chemical energy into electrical energy.'
  image10.tags = 'energy, science, battery, electric'
  image10.media = File.open(Rails.root.join('db/seeds/images/batterie.jpg'))
  image10.user_id = jeg.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 10} image...\r"
  $stdout.flush
  image10.save!
  image10.is_public = true
  image10.publication_date = pub_date
  image10.save!
  
  pub_date += 1
  
  image11 = Image.new
  image11.title = 'Pantheon'
  image11.description = "The Pantheon (\"Temple of all gods\") is an ancient building in the center of Rome."
  image11.tags = 'rome, history, sky, roman, temple, god, ancient, art'
  image11.media = File.open(Rails.root.join('db/seeds/images/cielo_roma.jpg'))
  image11.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 11} image...\r"
  $stdout.flush
  image11.save!
  image11.is_public = true
  image11.publication_date = pub_date
  image11.save!
  
  pub_date += 1
  
  image12 = Image.new
  image12.title = 'Lawn'
  image12.description = 'A picture of a winded lawn during spring.'
  image12.tags = 'lawn, nature, sky, ear'
  image12.media = File.open(Rails.root.join('db/seeds/images/natura.jpg'))
  image12.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 12} image...\r"
  $stdout.flush
  image12.save!
  image12.is_public = true
  image12.publication_date = pub_date
  image12.save!
  
  pub_date += 1
  
  image13 = Image.new
  image13.title = 'History of the wood'
  image13.description = 'The wood is a source of energy and cellulose.'
  image13.tags = 'wood, nature, paper, art, science, geography'
  image13.media = File.open(Rails.root.join('db/seeds/images/ossigeno.jpg'))
  image13.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 13} image...\r"
  $stdout.flush
  image13.save!
  image13.is_public = true
  image13.publication_date = pub_date
  image13.save!
  
  pub_date += 1
  
  image14 = Image.new
  image14.title = 'Rome'
  image14.description = 'A beautiful picture of one of the most beautiful cities in the world. You can see the dome of St Peter, the cradle of Christian civilization.'
  image14.tags = 'rome, river, bridge, geography, sky, water, history, art'
  image14.media = File.open(Rails.root.join('db/seeds/images/roma.jpg'))
  image14.user_id = jeg.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 14} image...\r"
  $stdout.flush
  image14.save!
  image14.is_public = true
  image14.publication_date = pub_date
  image14.save!
  
  pub_date += 1
  
  image15 = Image.new
  image15.title = 'Bees'
  image15.description = 'Since prehistoric times, the bee has been useful to mankind.'
  image15.tags = 'nature, bee, flower, color, nature, animal, honey'
  image15.media = File.open(Rails.root.join('db/seeds/images/ape.jpg'))
  image15.user_id = holly.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 15} image...\r"
  $stdout.flush
  image15.save!
  image15.is_public = true
  image15.publication_date = pub_date
  image15.save!
  
  pub_date += 1
  
  image16 = Image.new
  image16.title = 'A flying machine'
  image16.description = 'Nature has provided birds with a perfect structure allowing them to fly.'
  image16.tags = 'nature, fly, sky, nature, animal, air, science'
  image16.media = File.open(Rails.root.join('db/seeds/images/uccello.jpg'))
  image16.user_id = holly.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 16} image...\r"
  $stdout.flush
  image16.save!
  image16.is_public = true
  image16.publication_date = pub_date
  image16.save!
  
  pub_date += 1
  
  image17 = Image.new
  image17.title = 'Natural gas'
  image17.description = 'In nature, the gas is produced by the anaerobic decomposition of organic material.'
  image17.tags = 'nature, gas, fire, nature, energie, air, science'
  image17.media = File.open(Rails.root.join('db/seeds/images/fiamma.jpg'))
  image17.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 17} image...\r"
  $stdout.flush
  image17.save!
  image17.is_public = true
  image17.publication_date = pub_date
  image17.save!
  
  pub_date += 1
  
  image18 = Image.new
  image18.title = 'Family'
  image18.description = 'A mother uses the internet to help her child studying.'
  image18.tags = 'school, computer, history, science, maths, student, mother'
  image18.media = File.open(Rails.root.join('db/seeds/images/mamma_e_figlia.jpg'))
  image18.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 18} image...\r"
  $stdout.flush
  image18.save!
  image18.is_public = true
  image18.publication_date = pub_date
  image18.save!
  
  pub_date += 1
  
  image19 = Image.new
  image19.title = 'Harlem'
  image19.description = 'Harlem is a neighborhood of Manhattan in New York City, known as a major commercial and cultural center of Afro-Americans.'
  image19.tags = 'geography, new york,woman, city, colored, walk'
  image19.media = File.open(Rails.root.join('db/seeds/images/colored.jpg'))
  image19.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 19} image...\r"
  $stdout.flush
  image19.save!
  image19.is_public = true
  image19.publication_date = pub_date
  image19.save!
  
  pub_date += 1
  
  image20 = Image.new
  image20.title = 'Modern architecture'
  image20.description = "The \"Hemisfèric\" is one of the buildings of \"Ciutat de les Arts i les Ciències\" in Valencia."
  image20.tags = 'geography, valencia, modern, water, creative'
  image20.media = File.open(Rails.root.join('db/seeds/images/architettura_acqua.jpg'))
  image20.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 20} image...\r"
  $stdout.flush
  image20.save!
  image20.is_public = true
  image20.publication_date = pub_date
  image20.save!
  
  pub_date += 1
  
  image21 = Image.new
  image21.title = 'Peacock'
  image21.description = 'The plumage of these birds is one of the most colorful in the animal world.'
  image21.tags = 'animal, peacock, color, science, bird'
  image21.media = File.open(Rails.root.join('db/seeds/images/pavone.jpg'))
  image21.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 21} image...\r"
  $stdout.flush
  image21.save!
  image21.is_public = true
  image21.publication_date = pub_date
  image21.save!
  
  pub_date += 1
  
  image22 = Image.new
  image22.title = 'People'
  image22.description = 'A group of interested visitors walking in the halls of a museum of modern art.'
  image22.tags = 'art, people, museum, new york, culture'
  image22.media = File.open(Rails.root.join('db/seeds/images/museo.jpg'))
  image22.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 22} image...\r"
  $stdout.flush
  image22.save!
  image22.is_public = true
  image22.publication_date = pub_date
  image22.save!
  
  pub_date += 1
  
  image23 = Image.new
  image23.title = 'Money'
  image23.description = "As in a famous song of the Beatles, \"That's all I want\"."
  image23.tags = 'money, geography, new york, culture'
  image23.media = File.open(Rails.root.join('db/seeds/images/dollari.jpg'))
  image23.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 23} image...\r"
  $stdout.flush
  image23.save!
  image23.is_public = true
  image23.publication_date = pub_date
  image23.save!
  
  pub_date += 1
  
  image24 = Image.new
  image24.title = 'Airport'
  image24.description = 'Heathrow Airport is the main airport in London.'
  image24.tags = 'airport, london, city, departure, fly, geography'
  image24.media = File.open(Rails.root.join('db/seeds/images/london.jpg'))
  image24.user_id = jeg.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 24} image...\r"
  $stdout.flush
  image24.save!
  image24.is_public = true
  image24.publication_date = pub_date
  image24.save!
  
  pub_date += 1
  
  image25 = Image.new
  image25.title = 'Underground'
  image25.description = 'The London Underground is the largest subway system in Europe.'
  image25.tags = 'underground, london, city, train, people, geography'
  image25.media = File.open(Rails.root.join('db/seeds/images/underground.jpg'))
  image25.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 25} image...\r"
  $stdout.flush
  image25.save!
  image25.is_public = true
  image25.publication_date = pub_date
  image25.save!
  
  pub_date += 1
  
  image26 = Image.new
  image26.title = 'Plane'
  image26.description = 'The Boeing 737 is the most widely used airliner for medium-short routes.'
  image26.tags = 'plane, london, city, fly, people, geography'
  image26.media = File.open(Rails.root.join('db/seeds/images/plane.jpg'))
  image26.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 26} image...\r"
  $stdout.flush
  image26.save!
  image26.is_public = true
  image26.publication_date = pub_date
  image26.save!
  
  pub_date += 1
  
  image27 = Image.new
  image27.title = 'Statue of Liberty'
  image27.description = 'Liberty Enlightening the World (lit. Liberty enlightening the world; fr. Éclairant La liberté le monde), more commonly known as the Statue of Liberty, is the symbol of New York.'
  image27.tags = 'art, new york, city, people, geography'
  image27.media = File.open(Rails.root.join('db/seeds/images/liberty.jpg'))
  image27.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 27} image...\r"
  $stdout.flush
  image27.save!
  image27.is_public = true
  image27.publication_date = pub_date
  image27.save!
  
  pub_date += 1
  
  image28 = Image.new
  image28.title = 'A young woman'
  image28.description = 'Portrait of a Muslim woman.'
  image28.tags = 'woman, new york, city, people, geography'
  image28.media = File.open(Rails.root.join('db/seeds/images/donna.jpg'))
  image28.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 28} image...\r"
  $stdout.flush
  image28.save!
  image28.is_public = true
  image28.publication_date = pub_date
  image28.save!
  
  pub_date += 1
  
  image29 = Image.new
  image29.title = 'The Sphinx'
  image29.description = 'The sphinx is a mythological figure belonging to Egyptian mythology.'
  image29.tags = 'history, egypt, city, art, geography'
  image29.media = File.open(Rails.root.join('db/seeds/images/statua.jpg'))
  image29.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 29} image...\r"
  $stdout.flush
  image29.save!
  image29.is_public = true
  image29.publication_date = pub_date
  image29.save!
  
  pub_date += 1
  
  image30 = Image.new
  image30.title = 'A long bridge'
  image30.description = 'A picture of a bridge.'
  image30.tags = 'city, new york, art, geography'
  image30.media = File.open(Rails.root.join('db/seeds/images/ponte.jpg'))
  image30.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 30} image...\r"
  $stdout.flush
  image30.save!
  image30.is_public = true
  image30.publication_date = pub_date
  image30.save!
  
  pub_date += 1
  
  image31 = Image.new
  image31.title = 'DNA'
  image31.description = 'DNA is an organic polymer made ​​up of monomers called nucleotides (deoxyribonucleotides).'
  image31.tags = 'dna, science, chemical, organic, polymer, basic'
  image31.media = File.open(Rails.root.join('db/seeds/images/dna.jpg'))
  image31.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 31} image...\r"
  $stdout.flush
  image31.save!
  image31.is_public = true
  image31.publication_date = pub_date
  image31.save!
  
  pub_date += 1
  
  image32 = Image.new
  image32.title = 'Solar system'
  image32.description = 'The solar system consists of a variety of celestial bodies kept in orbit by the gravitational force of the Sun.'
  image32.tags = 'space, science, chemical, planet, sky, history'
  image32.media = File.open(Rails.root.join('db/seeds/images/space.jpg'))
  image32.user_id = jeg.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 32} image...\r"
  $stdout.flush
  image32.save!
  image32.is_public = true
  image32.publication_date = pub_date
  image32.save!
  
  pub_date += 1
  
  puts "Saved #{Image.count} images (should be 32)\n"
  
  
  # AUDIOS
  
  audio1 = Audio.new
  audio1.title = 'What is energy?'
  audio1.description = 'The interview with an expert talking about energy (in italian language).'
  audio1.tags = 'interview, science, energy, power'
  audio1.media = {:mp3 => Rails.root.join('db/seeds/audios/energia_cosa.mp3').to_s, :ogg => Rails.root.join('db/seeds/audios/energia_cosa.ogg').to_s, :filename => 'energia_cosa'}
  audio1.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 1} audio...\r"
  $stdout.flush
  audio1.save!
  audio1.is_public = true
  audio1.publication_date = pub_date
  audio1.save!
  
  pub_date += 1
  
  audio2 = Audio.new
  audio2.title = 'Energy statistics in Italy'
  audio2.description = 'An interview with experts about italian use and production of energy (in italian language).'
  audio2.tags = 'interview, science, energy, power, numbers'
  audio2.media = {:mp3 => Rails.root.join('db/seeds/audios/energia_dati.mp3').to_s, :ogg => Rails.root.join('db/seeds/audios/energia_dati.ogg').to_s, :filename => 'energia_dati'}
  audio2.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 2} audio...\r"
  $stdout.flush
  audio2.save!
  audio2.is_public = true
  audio2.publication_date = pub_date
  audio2.save!
  
  pub_date += 1
  
  audio3 = Audio.new
  audio3.title = 'Principles of modern energy'
  audio3.description = 'The principles of modern energy explained by experts (in italian language).'
  audio3.tags = 'interview, science, energy, power, principles'
  audio3.media = {:mp3 => Rails.root.join('db/seeds/audios/energia_principi.mp3').to_s, :ogg => Rails.root.join('db/seeds/audios/energia_principi.ogg').to_s, :filename => 'energia_principi'}
  audio3.user_id = jeg.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 3} audio...\r"
  $stdout.flush
  audio3.save!
  audio3.is_public = true
  audio3.publication_date = pub_date
  audio3.save!
  
  pub_date += 1
  
  audio4 = Audio.new
  audio4.title = 'Once upon a time the energy'
  audio4.description = 'The history of energy development in the twentieth century (in italian language).'
  audio4.tags = 'interview, science, energy, power, history'
  audio4.media = {:mp3 => Rails.root.join('db/seeds/audios/energia_storia.mp3').to_s, :ogg => Rails.root.join('db/seeds/audios/energia_storia.ogg').to_s, :filename => 'energia_storia'}
  audio4.user_id = holly.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 4} audio...\r"
  $stdout.flush
  audio4.save!
  audio4.is_public = true
  audio4.publication_date = pub_date
  audio4.save!
  
  pub_date += 1
  
  audio5 = Audio.new
  audio5.title = 'Digital sound'
  audio5.description = 'A good base of digital music to be used in your video.'
  audio5.tags = 'music, digital, sound, audio, song'
  audio5.media = {:mp3 => Rails.root.join('db/seeds/audios/archangel.mp3').to_s, :ogg => Rails.root.join('db/seeds/audios/archangel.ogg').to_s, :filename => 'archangel'}
  audio5.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 5} audio...\r"
  $stdout.flush
  audio5.save!
  audio5.is_public = true
  audio5.publication_date = pub_date
  audio5.save!
  
  pub_date += 1
  
  audio6 = Audio.new
  audio6.title = 'Modern digital sound'
  audio6.description = 'A good base of digital music to be used in your video.'
  audio6.tags = 'music, digital, sound, audio, song'
  audio6.media = {:mp3 => Rails.root.join('db/seeds/audios/homeless.mp3').to_s, :ogg => Rails.root.join('db/seeds/audios/homeless.ogg').to_s, :filename => 'homeless'}
  audio6.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 6} audio...\r"
  $stdout.flush
  audio6.save!
  audio6.is_public = true
  audio6.publication_date = pub_date
  audio6.save!
  
  pub_date += 1
  
  puts "Saved #{Audio.count} audios (should be 6)\n"
  
  
  # VIDEOS
  
  video1 = Video.new
  video1.title = 'Water'
  video1.description = 'A video explaining scientific facts about water.'
  video1.tags = 'water, science, chemical, nature'
  video1.media = {:mp4 => Rails.root.join('db/seeds/videos/acqua.mp4').to_s, :webm => Rails.root.join('db/seeds/videos/acqua.webm').to_s, :filename => 'acqua'}
  video1.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 1} video...\r"
  $stdout.flush
  video1.save!
  video1.is_public = true
  video1.publication_date = pub_date
  video1.save!
  
  pub_date += 1
  
  video2 = Video.new
  video2.title = 'The life of bees'
  video2.description = 'A very nice and interesting movie about bees.'
  video2.tags = 'bee, science, flower, nature, color'
  video2.media = {:mp4 => Rails.root.join('db/seeds/videos/ape_su_fiori.mp4').to_s, :webm => Rails.root.join('db/seeds/videos/ape_su_fiori.webm').to_s, :filename => 'ape_su_fiori'}
  video2.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 2} video...\r"
  $stdout.flush
  video2.save!
  video2.is_public = true
  video2.publication_date = pub_date
  video2.save!
  
  pub_date += 1
  
  video3 = Video.new
  video3.title = 'The structure of the atoms'
  video3.description = 'Atoms are made by protons, neutrons and electrons.'
  video3.tags = 'atom, science, neutrons, molecules, electrons'
  video3.media = {:mp4 => Rails.root.join('db/seeds/videos/atomo.mp4').to_s, :webm => Rails.root.join('db/seeds/videos/atomo.webm').to_s, :filename => 'atomo'}
  video3.user_id = jeg.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 3} video...\r"
  $stdout.flush
  video3.save!
  video3.is_public = true
  video3.publication_date = pub_date
  video3.save!
  
  pub_date += 1
  
  video4 = Video.new
  video4.title = 'Bacteria seen under a microscope'
  video4.description = 'Bacteria include unicellular microorganisms and prokaryotes.'
  video4.tags = 'bacteria, science, chemical, microscope, electrons, experiment, laboratory'
  video4.media = {:mp4 => Rails.root.join('db/seeds/videos/batteri.mp4').to_s, :webm => Rails.root.join('db/seeds/videos/batteri.webm').to_s, :filename => 'batteri'}
  video4.user_id = holly.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 4} video...\r"
  $stdout.flush
  video4.save!
  video4.is_public = true
  video4.publication_date = pub_date
  video4.save!
  
  pub_date += 1
  
  video5 = Video.new
  video5.title = 'Structure of the cell'
  video5.description = 'The cell is the smallest structure that might bt classified as living.'
  video5.tags = 'cellular, science, chemical, microscope, organism, experiment, laboratory'
  video5.media = {:mp4 => Rails.root.join('db/seeds/videos/catena_cellulare.mp4').to_s, :webm => Rails.root.join('db/seeds/videos/catena_cellulare.webm').to_s, :filename => 'catena_cellulare'}
  video5.user_id = holly.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 5} video...\r"
  $stdout.flush
  video5.save!
  video5.is_public = true
  video5.publication_date = pub_date
  video5.save!
  
  pub_date += 1
  
  video6 = Video.new
  video6.title = "Let's look inside us"
  video6.description = 'A video about cells.'
  video6.tags = 'cellular, science, chemical, microscope, organism, experiment, laboratory'
  video6.media = {:mp4 => Rails.root.join('db/seeds/videos/cellule.mp4').to_s, :webm => Rails.root.join('db/seeds/videos/cellule.webm').to_s, :filename => 'cellule'}
  video6.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 6} video...\r"
  $stdout.flush
  video6.save!
  video6.is_public = true
  video6.publication_date = pub_date
  video6.save!
  
  pub_date += 1
  
  video7 = Video.new
  video7.title = 'A chemical experiment'
  video7.description = 'Chemistry is the science, which studies the composition of matter.'
  video7.tags = 'liquid, science, chemical, microscope, organism, experiment, laboratory'
  video7.media = {:mp4 => Rails.root.join('db/seeds/videos/chimica.mp4').to_s, :webm => Rails.root.join('db/seeds/videos/chimica.webm').to_s, :filename => 'chimica'}
  video7.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 7} video...\r"
  $stdout.flush
  video7.save!
  video7.is_public = true
  video7.publication_date = pub_date
  video7.save!
  
  pub_date += 1
  
  video8 = Video.new
  video8.title = 'Interesting chemical experiment'
  video8.description = 'A video about an interesting chemical experiment.'
  video8.tags = 'liquid, science, chemical, microscope, organism, experiment, laboratory'
  video8.media = {:mp4 => Rails.root.join('db/seeds/videos/chimica2.mp4').to_s, :webm => Rails.root.join('db/seeds/videos/chimica2.webm').to_s, :filename => 'chimica2'}
  video8.user_id = jeg.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 8} video...\r"
  $stdout.flush
  video8.save!
  video8.is_public = true
  video8.publication_date = pub_date
  video8.save!
  
  pub_date += 1
  
  video9 = Video.new
  video9.title = 'The future comes from the sun'
  video9.description = 'Solar energy is the energy which makes life possible on the earth.'
  video9.tags = 'sun, science, chemical, energy, sky, experiment'
  video9.media = {:mp4 => Rails.root.join('db/seeds/videos/energia_solare.mp4').to_s, :webm => Rails.root.join('db/seeds/videos/energia_solare.webm').to_s, :filename => 'energia_solare'}
  video9.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 9} video...\r"
  $stdout.flush
  video9.save!
  video9.is_public = true
  video9.publication_date = pub_date
  video9.save!
  
  pub_date += 1
  
  video10 = Video.new
  video10.title = 'The biggest star'
  video10.description = 'The Sun is the parent star of the solar system.'
  video10.tags = 'sun, science, chemical, energy, sky, experiment, space'
  video10.media = {:mp4 => Rails.root.join('db/seeds/videos/energia.mp4').to_s, :webm => Rails.root.join('db/seeds/videos/energia.webm').to_s, :filename => 'energia'}
  video10.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 10} video...\r"
  $stdout.flush
  video10.save!
  video10.is_public = true
  video10.publication_date = pub_date
  video10.save!
  
  pub_date += 1
  
  video11 = Video.new
  video11.title = 'A chemical experiment about liquids'
  video11.description = 'The liquid is one of the states of matter.'
  video11.tags = 'liquid, science, chemical, experiment, chemistry'
  video11.media = {:mp4 => Rails.root.join('db/seeds/videos/esperimento_acqua.mp4').to_s, :webm => Rails.root.join('db/seeds/videos/esperimento_acqua.webm').to_s, :filename => 'esperimento_acqua'}
  video11.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 11} video...\r"
  $stdout.flush
  video11.save!
  video11.is_public = true
  video11.publication_date = pub_date
  video11.save!
  
  pub_date += 1
  
  video12 = Video.new
  video12.title = 'Discover the liquids'
  video12.description = 'Ionic liquids are chemical compounds consisting exclusively of ions.'
  video12.tags = 'ionic, liquid, science, chemical, experiment, chemistry'
  video12.media = {:mp4 => Rails.root.join('db/seeds/videos/esperimento.mp4').to_s, :webm => Rails.root.join('db/seeds/videos/esperimento.webm').to_s, :filename => 'esperimento'}
  video12.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 12} video...\r"
  $stdout.flush
  video12.save!
  video12.is_public = true
  video12.publication_date = pub_date
  video12.save!
  
  pub_date += 1
  
  video13 = Video.new
  video13.title = 'Inside mathematics'
  video13.description = 'Mathematics has a long tradition.'
  video13.tags = 'mathematics, science, calculation, equation'
  video13.media = {:mp4 => Rails.root.join('db/seeds/videos/formule.mp4').to_s, :webm => Rails.root.join('db/seeds/videos/formule.webm').to_s, :filename => 'formule'}
  video13.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 13} video...\r"
  $stdout.flush
  video13.save!
  video13.is_public = true
  video13.publication_date = pub_date
  video13.save!
  
  pub_date += 1
  
  video14 = Video.new
  video14.title = 'Descriptive geometry'
  video14.description = 'A video about descriptive geometry.'
  video14.tags = 'mathematics, geometry, solid, science, constructions, floors, objects'
  video14.media = {:mp4 => Rails.root.join('db/seeds/videos/geometria.mp4').to_s, :webm => Rails.root.join('db/seeds/videos/geometria.webm').to_s, :filename => 'geometria'}
  video14.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 14} video...\r"
  $stdout.flush
  video14.save!
  video14.is_public = true
  video14.publication_date = pub_date
  video14.save!
  
  pub_date += 1
  
  video15 = Video.new
  video15.title = 'The triangle'
  video15.description = 'In geometry, the triangle is a polygon formed by three corners or vertices and three sides.'
  video15.tags = 'renato zero, maths, geometry, solid, science, constructions, floors, objects, triangle'
  video15.media = {:mp4 => Rails.root.join('db/seeds/videos/geometria2.mp4').to_s, :webm => Rails.root.join('db/seeds/videos/geometria2.webm').to_s, :filename => 'geometria2'}
  video15.user_id = jeg.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 15} video...\r"
  $stdout.flush
  video15.save!
  video15.is_public = true
  video15.publication_date = pub_date
  video15.save!
  
  pub_date += 1
  
  video16 = Video.new
  video16.title = 'Chemical lab'
  video16.description = 'Two researchers working in a chemical lab.'
  video16.tags = 'chemistry, liquid, experiment, science, lab'
  video16.media = {:mp4 => Rails.root.join('db/seeds/videos/laboratorio.mp4').to_s, :webm => Rails.root.join('db/seeds/videos/laboratorio.webm').to_s, :filename => 'laboratorio'}
  video16.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 16} video...\r"
  $stdout.flush
  video16.save!
  video16.is_public = true
  video16.publication_date = pub_date
  video16.save!
  
  pub_date += 1
  
  video17 = Video.new
  video17.title = 'Behavior of liquids'
  video17.description = 'A video about the behavior of liquids.'
  video17.tags = 'chemistry, liquid, experiment, science, lab'
  video17.media = {:mp4 => Rails.root.join('db/seeds/videos/liquidi.mp4').to_s, :webm => Rails.root.join('db/seeds/videos/liquidi.webm').to_s, :filename => 'liquidi'}
  video17.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 17} video...\r"
  $stdout.flush
  video17.save!
  video17.is_public = true
  video17.publication_date = pub_date
  video17.save!
  
  pub_date += 1
  
  video18 = Video.new
  video18.title = 'Snail'
  video18.description = 'The snail is not always gray.'
  video18.tags = 'animal, snail, science, nature, invertebrate'
  video18.media = {:mp4 => Rails.root.join('db/seeds/videos/lumaca.mp4').to_s, :webm => Rails.root.join('db/seeds/videos/lumaca.webm').to_s, :filename => 'lumaca'}
  video18.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 18} video...\r"
  $stdout.flush
  video18.save!
  video18.is_public = true
  video18.publication_date = pub_date
  video18.save!
  
  pub_date += 1
  
  video19 = Video.new
  video19.title = 'On the footsteps of Titanic'
  video19.description = 'The Titanic sank in the beginning of twentieth century in the Atlantic Ocean.'
  video19.tags = 'ice, sea, titanic, iceberg, tragedy'
  video19.media = {:mp4 => Rails.root.join('db/seeds/videos/mare.mp4').to_s, :webm => Rails.root.join('db/seeds/videos/mare.webm').to_s, :filename => 'mare'}
  video19.user_id = holly.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 19} video...\r"
  $stdout.flush
  video19.save!
  video19.is_public = true
  video19.publication_date = pub_date
  video19.save!
  
  pub_date += 1
  
  video20 = Video.new
  video20.title = 'Wind Energy'
  video20.description = 'Wind energy is the energy obtained from the wind.'
  video20.tags = 'energy, science, wind, sky, power'
  video20.media = {:mp4 => Rails.root.join('db/seeds/videos/paleeoliche.mp4').to_s, :webm => Rails.root.join('db/seeds/videos/paleeoliche.webm').to_s, :filename => 'paleeoliche'}
  video20.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 20} video...\r"
  $stdout.flush
  video20.save!
  video20.is_public = true
  video20.publication_date = pub_date
  video20.save!
  
  pub_date += 1
  
  video21 = Video.new
  video21.title = 'How does a real chemistry lab work?'
  video21.description = 'We enter into a research center.'
  video21.tags = 'energy, science, lab, chemistry, experiment'
  video21.media = {:mp4 => Rails.root.join('db/seeds/videos/ricercatori.mp4').to_s, :webm => Rails.root.join('db/seeds/videos/ricercatori.webm').to_s, :filename => 'ricercatori'}
  video21.user_id = jeg.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 21} video...\r"
  $stdout.flush
  video21.save!
  video21.is_public = true
  video21.publication_date = pub_date
  video21.save!
  
  pub_date += 1
  
  video22 = Video.new
  video22.title = 'The birth of a star'
  video22.description = 'A star is a celestial body that shines with its own light.'
  video22.tags = 'energy, science, space, sky, fire, star, power, history'
  video22.media = {:mp4 => Rails.root.join('db/seeds/videos/sole.mp4').to_s, :webm => Rails.root.join('db/seeds/videos/sole.webm').to_s, :filename => 'sole'}
  video22.user_id = jeg.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 22} video...\r"
  $stdout.flush
  video22.save!
  video22.is_public = true
  video22.publication_date = pub_date
  video22.save!
  
  pub_date += 1
  
  video23 = Video.new
  video23.title = 'Little scientists'
  video23.description = 'A high school class try simple chemistry experiments.'
  video23.tags = 'student, science, school, experiment, lab'
  video23.media = {:mp4 => Rails.root.join('db/seeds/videos/studenti.mp4').to_s, :webm => Rails.root.join('db/seeds/videos/studenti.webm').to_s, :filename => 'studenti'}
  video23.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 23} video...\r"
  $stdout.flush
  video23.save!
  video23.is_public = true
  video23.publication_date = pub_date
  video23.save!
  
  pub_date += 1
  
  video24 = Video.new
  video24.title = 'Look at the virus closely'
  video24.description = 'Viruses are biological entities.'
  video24.tags = 'virus, experiment, lab, biology'
  video24.media = {:mp4 => Rails.root.join('db/seeds/videos/virus.mp4').to_s, :webm => Rails.root.join('db/seeds/videos/virus.webm').to_s, :filename => 'virus'}
  video24.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 24} video...\r"
  $stdout.flush
  video24.save!
  video24.is_public = true
  video24.publication_date = pub_date
  video24.save!
  
  pub_date += 1
  
  puts "Saved #{Video.count} videos (should be 24)\n"
  
  
  # RESUME
  
  puts "Saved #{Tag.count} tags (should be 130)\n"
  puts "Saved #{Tagging.count} taggings (should be 355)\n"
  puts 'FINE'
  
end

plant_development_seeds
