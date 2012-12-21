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
  toostrong = User.create_user 'toostrong@morganspa.com', 'Kassandra', 'Scarlet', 'ITC BrokenTower', secondary_school.id, shenzhen.id, [mathematics.id, natural_sciences.id]
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 3} user...\r"
  $stdout.flush
  fupete = User.create_user 'fupete@morganspa.com', 'Victor', 'Plum', 'ISS Pro', undergraduate.id, shanghai.id, [natural_sciences.id, computer_science.id, chemistry.id]
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 4} user...\r"
  $stdout.flush
  jeg = User.create_user 'jeg@morganspa.com', 'Jack', 'Mustard', 'ISA Carlocracco', secondary_school.id, wuhan.id, [literature.id, computer_science.id, geography.id]
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 5} user...\r"
  $stdout.flush
  holly = User.create_user 'holly@morganspa.com', 'Jacob', 'Green', 'ITC Pocotopocoto', primary_school.id, beijing.id, [mathematics.id, visive_arts.id, music.id]
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 6} user...\r"
  $stdout.flush
  benji = User.create_user 'benji@morganspa.com', 'Diane', 'White', 'ITC Pocotopocoto', primary_school.id, tianjin.id, [mathematics.id, visive_arts.id, music.id, literature.id]
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 7} user...\r"
  $stdout.flush
  retlaw = User.create_user 'retlaw@morganspa.com', 'Eleanor', 'Peacock', 'ISA Amor III', undergraduate.id, shenzhen.id, [mathematics.id, visive_arts.id, music.id, literature.id, natural_sciences.id, geography.id, chemistry.id]
  
  puts "Saved #{User.count} users (should be 7)\n"
  puts "Saved #{UsersSubject.count} users_subjects (should be #{22 + CONFIG['subjects'].length})\n"
  
  
  # IMAGES
  
  pub_date = Time.zone.now
  original_pub_date = pub_date
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
  image33 = Image.new
  image33.title = "Egon Schiele"
  image33.description = "Portrait."
  image33.tags = "art, portrait, painting, art"
  image33.media = File.open(Rails.root.join("db/seeds/images/936full-egon-schiele.jpg"))
  image33.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 33} image...\r"
  $stdout.flush
  image33.save!
  image33.is_public = true
  image33.publication_date = pub_date
  image33.save!
  
  pub_date -= 3
  
  image34 = Image.new
  image34.title = "Jean Michelle"
  image34.description = "Jean-Michel Basquiat (December 22, 1960 – August 12, 1988) was an American artist.[1] He began as an obscure graffiti artist in New York City in the late 1970s and evolved into an acclaimed Neo-expressionist and Primitivist painter by the 1980s."
  image34.tags = "history, logo, arte, history"
  image34.media = File.open(Rails.root.join("db/seeds/images/basquiat-2.jpg"))
  image34.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 34} image...\r"
  $stdout.flush
  image34.save!
  image34.is_public = true
  image34.publication_date = pub_date
  image34.save!
  
  pub_date -= 3
  
  image35 = Image.new
  image35.title = "Basquiat"
  image35.description = "Jean-Michel Basquiat (December 22, 1960 – August 12, 1988) was an American artist.[1] He began as an obscure graffiti artist in New York City in the late 1970s and evolved into an acclaimed Neo-expressionist and Primitivist painter by the 1980s."
  image35.tags = "art, basquiat, history, paint"
  image35.media = File.open(Rails.root.join("db/seeds/images/basquiat.jpg"))
  image35.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 35} image...\r"
  $stdout.flush
  image35.save!
  image35.is_public = true
  image35.publication_date = pub_date
  image35.save!
  
  pub_date -= 3
  
  image36 = Image.new
  image36.title = "SAMO"
  image36.description = "Jean-Michel Basquiat, born in Brooklyn, New York after the death of his brother Max, was the second of four children of Matilda Andrades (July 28, 1934 – November 17, 2008) and Gerard Basquiat (born 1930)."
  image36.tags = "art, basquiat, paint, history, color"
  image36.media = File.open(Rails.root.join("db/seeds/images/samo.jpg"))
  image36.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 36} image...\r"
  $stdout.flush
  image36.save!
  image36.is_public = true
  image36.publication_date = pub_date
  image36.save!
  
  pub_date -= 3
  
  image37 = Image.new
  image37.title = "J.M.Basquiat - 50Cent"
  image37.description = "In 1976, Basquiat and friend Al Diaz began spray-painting graffiti on buildings in Lower Manhattan, working under the pseudonym SAMO."
  image37.tags = "art, basquiat, art, history"
  image37.media = File.open(Rails.root.join("db/seeds/images/50-cent-piece.jpg"))
  image37.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 37} image...\r"
  $stdout.flush
  image37.save!
  image37.is_public = true
  image37.publication_date = pub_date
  image37.save!
  
  pub_date -= 3
  
  image38 = Image.new
  image38.title = "J.M.Basquiat - King"
  image38.description = "In 1976, Basquiat and friend Al Diaz began spray-painting graffiti on buildings in Lower Manhattan, working under the pseudonym SAMO."
  image38.tags = "art, samo, basquiat, ny, history"
  image38.media = File.open(Rails.root.join("db/seeds/images/king-alphonso.jpg"))
  image38.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 38} image...\r"
  $stdout.flush
  image38.save!
  image38.is_public = true
  image38.publication_date = pub_date
  image38.save!
  
  pub_date -= 3
  
  image39 = Image.new
  image39.title = "J.M.Basquiat - Ghost"
  image39.description = "In 1976, Basquiat and friend Al Diaz began spray-painting graffiti on buildings in Lower Manhattan, working under the pseudonym SAMO."
  image39.tags = "art, ghost, basquiat, new york, history"
  image39.media = File.open(Rails.root.join("db/seeds/images/tumblr_mapa1vnds61rhpgvfo1_500.jpg"))
  image39.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 39} image...\r"
  $stdout.flush
  image39.save!
  image39.is_public = true
  image39.publication_date = pub_date
  image39.save!
  
  pub_date -= 3
  
  image40 = Image.new
  image40.title = "J.M.Basquiat"
  image40.description = "In 1976, Basquiat and friend Al Diaz began spray-painting graffiti on buildings in Lower Manhattan, working under the pseudonym SAMO."
  image40.tags = "art, basquiat, art, samo, new york, history"
  image40.media = File.open(Rails.root.join("db/seeds/images/tumblr_ma02thv8vk1qzp5xxo1_500.jpg"))
  image40.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 40} image...\r"
  $stdout.flush
  image40.save!
  image40.is_public = true
  image40.publication_date = pub_date
  image40.save!
  
  pub_date -= 3
  
  image41 = Image.new
  image41.title = "J.M.Basquiat in New York"
  image41.description = "In 1976, Basquiat and friend Al Diaz began spray-painting graffiti on buildings in Lower Manhattan, working under the pseudonym SAMO."
  image41.tags = "art, basquiat, new york, history, art"
  image41.media = File.open(Rails.root.join("db/seeds/images/tumblr_m79phdivez1rwgohco1_r1_500.jpg"))
  image41.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 41} image...\r"
  $stdout.flush
  image41.save!
  image41.is_public = true
  image41.publication_date = pub_date
  image41.save!
  
  pub_date -= 3
  
  image42 = Image.new
  image42.title = "London taxy"
  image42.description = "The famous london taxi"
  image42.tags = "geography, london, people, english, taxi"
  image42.media = File.open(Rails.root.join("db/seeds/images/taxi_1360265b.jpg"))
  image42.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 42} image...\r"
  $stdout.flush
  image42.save!
  image42.is_public = true
  image42.publication_date = pub_date
  image42.save!
  
  pub_date -= 3
  
  image43 = Image.new
  image43.title = "London"
  image43.description = "The London Eye is a giant Ferris wheel situated on the banks of the River Thames in London, England. The entire structure is 135 metres (443 ft) tall and the wheel has a diameter of 120 metres (394 ft)."
  image43.tags = "geography, geography, taxi, car, english"
  image43.media = File.open(Rails.root.join("db/seeds/images/london2.jpg"))
  image43.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 43} image...\r"
  $stdout.flush
  image43.save!
  image43.is_public = true
  image43.publication_date = pub_date
  image43.save!
  
  pub_date -= 3
  
  image44 = Image.new
  image44.title = "The weather in London"
  image44.description = "The etymology of London is uncertain.
  It is an ancient name and can be found in sources from the 2nd century."
  image44.tags = "geography, geography, english, city"
  image44.media = File.open(Rails.root.join("db/seeds/images/london1.jpg"))
  image44.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 44} image...\r"
  $stdout.flush
  image44.save!
  image44.is_public = true
  image44.publication_date = pub_date
  image44.save!
  
  pub_date -= 3
  
  image45 = Image.new
  image45.title = "Duffy"
  image45.description = "Stephen Anthony James Duffy (born 30 May 1960, Alum Rock, Birmingham, England) is an English singer/songwriter, and multi-instrumentalist."
  image45.tags = "london, duffy, english, pop"
  image45.media = File.open(Rails.root.join("db/seeds/images/duffy.jpg"))
  image45.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 45} image...\r"
  $stdout.flush
  image45.save!
  image45.is_public = true
  image45.publication_date = pub_date
  image45.save!
  
  pub_date -= 3
  
  image46 = Image.new
  image46.title = "Egon Schiele"
  image46.description = "Two girls embracing each other"
  image46.tags = "art, art, painter, expressionism"
  image46.media = File.open(Rails.root.join("db/seeds/images/egon_schiele_022.jpg"))
  image46.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 46} image...\r"
  $stdout.flush
  image46.save!
  image46.is_public = true
  image46.publication_date = pub_date
  image46.save!
  
  pub_date -= 3
  
  image47 = Image.new
  image47.title = "calendar"
  image47.description = "The 2012 phenomenon comprises a range of"
  image47.tags = "maya, calendar, maya, cataclysmic"
  image47.media = File.open(Rails.root.join("db/seeds/images/nmai-mayan-calendar.jpg"))
  image47.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 47} image...\r"
  $stdout.flush
  image47.save!
  image47.is_public = true
  image47.publication_date = pub_date
  image47.save!
  
  pub_date -= 3
  
  image48 = Image.new
  image48.title = "maya"
  image48.description = "sdlò ds"
  image48.tags = "asjdlkdj, aisudiosd, asjdklj, zxmnc"
  image48.media = File.open(Rails.root.join("db/seeds/images/jeu_de_balle_maya.jpg"))
  image48.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 48} image...\r"
  $stdout.flush
  image48.save!
  image48.is_public = true
  image48.publication_date = pub_date
  image48.save!
  
  pub_date -= 3
  
  image49 = Image.new
  image49.title = "Arthut Roessler"
  image49.description = "Egon Schiele"
  image49.tags = "art, art, painter, expressionism"
  image49.media = File.open(Rails.root.join("db/seeds/images/arthur-roessler-egon-schiele.jpg"))
  image49.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 49} image...\r"
  $stdout.flush
  image49.save!
  image49.is_public = true
  image49.publication_date = pub_date
  image49.save!
  
  pub_date -= 3
  
  image50 = Image.new
  image50.title = "Roy Lichtenstein"
  image50.description = "His work probably defines the basic premise of pop art better than any other through parody.[7] Selecting the old-fashioned comic strip as subject matter, Lichtenstein produces a hard-edged, precise composition that documents while it parodies in a soft manner."
  image50.tags = "art, art, roy, new york"
  image50.media = File.open(Rails.root.join("db/seeds/images/royL.jpg"))
  image50.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 50} image...\r"
  $stdout.flush
  image50.save!
  image50.is_public = true
  image50.publication_date = pub_date
  image50.save!
  
  pub_date -= 3
  
  image51 = Image.new
  image51.title = "Warhol - Marilyn"
  image51.description = "Although Pop Art began in the late 1950s, Pop Art in America was given its greatest impetus during the 1960s."
  image51.tags = "art, pop, new york, color, warhol"
  image51.media = File.open(Rails.root.join("db/seeds/images/marylin.jpg"))
  image51.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 51} image...\r"
  $stdout.flush
  image51.save!
  image51.is_public = true
  image51.publication_date = pub_date
  image51.save!
  
  pub_date -= 3
  
  image52 = Image.new
  image52.title = "Pleiades"
  image52.description = "Many beautiful stars"
  image52.tags = "stars, universe, pleiades, lights"
  image52.media = File.open(Rails.root.join("db/seeds/images/90/pleiades_large.jpg"))
  image52.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 52} image...\r"
  $stdout.flush
  image52.save!
  image52.is_public = true
  image52.publication_date = pub_date
  image52.save!
  
  pub_date -= 3
  
  image53 = Image.new
  image53.title = "Egon Schiele"
  image53.description = "Portrait"
  image53.tags = "art, portrait, painting, art"
  image53.media = File.open(Rails.root.join("/media_elements/images/77/936full-egon-schiele.jpg"))
  image53.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 53} image...\r"
  $stdout.flush
  image53.save!
  image53.is_public = true
  image53.publication_date = pub_date
  image53.save!
  
  pub_date -= 3
  
  image54 = Image.new
  image54.title = "Jean Michelle"
  image54.description = "Jean-Michel Basquiat (December 22, 1960 – August 12, 1988) was an American artist.[1] He began as an obscure graffiti artist in New York City in the late 1970s and evolved into an acclaimed Neo-expressionist and Primitivist painter by the 1980s."
  image54.tags = "history, logo, arte, history"
  image54.media = File.open(Rails.root.join("/media_elements/images/65/basquiat-2.jpg"))
  image54.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 54} image...\r"
  $stdout.flush
  image54.save!
  image54.is_public = true
  image54.publication_date = pub_date
  image54.save!
  
  pub_date -= 3
  
  image55 = Image.new
  image55.title = "Basquiat"
  image55.description = "Jean-Michel Basquiat (December 22, 1960 – August 12, 1988) was an American artist.[1] He began as an obscure graffiti artist in New York City in the late 1970s and evolved into an acclaimed Neo-expressionist and Primitivist painter by the 1980s."
  image55.tags = "art, basquiat, history, paint"
  image55.media = File.open(Rails.root.join("/media_elements/images/66/basquiat.jpg"))
  image55.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 55} image...\r"
  $stdout.flush
  image55.save!
  image55.is_public = true
  image55.publication_date = pub_date
  image55.save!
  
  pub_date -= 3
  
  image56 = Image.new
  image56.title = "SAMO"
  image56.description = "Jean-Michel Basquiat, born in Brooklyn, New York after the death of his brother Max, was the second of four children of Matilda Andrades (July 28, 1934 – November 17, 2008) and Gerard Basquiat (born 1930)."
  image56.tags = "art, basquiat, paint, history, color"
  image56.media = File.open(Rails.root.join("/media_elements/images/67/1.jpg"))
  image56.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 56} image...\r"
  $stdout.flush
  image56.save!
  image56.is_public = true
  image56.publication_date = pub_date
  image56.save!
  
  pub_date -= 3
  
  image57 = Image.new
  image57.title = "J.M.Basquiat - 50Cent"
  image57.description = "In 1976, Basquiat and friend Al Diaz began spray-painting graffiti on buildings in Lower Manhattan, working under the pseudonym SAMO."
  image57.tags = "art, basquiat, art, history"
  image57.media = File.open(Rails.root.join("/media_elements/images/68/50-cent-piece.jpg"))
  image57.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 57} image...\r"
  $stdout.flush
  image57.save!
  image57.is_public = true
  image57.publication_date = pub_date
  image57.save!
  
  pub_date -= 3
  
  image58 = Image.new
  image58.title = "J.M.Basquiat - King"
  image58.description = "In 1976, Basquiat and friend Al Diaz began spray-painting graffiti on buildings in Lower Manhattan, working under the pseudonym SAMO."
  image58.tags = "art, samo, basquiat, ny, history"
  image58.media = File.open(Rails.root.join("/media_elements/images/69/king-alphonso.jpg"))
  image58.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 58} image...\r"
  $stdout.flush
  image58.save!
  image58.is_public = true
  image58.publication_date = pub_date
  image58.save!
  
  pub_date -= 3
  
  image59 = Image.new
  image59.title = "J.M.Basquiat - Ghost"
  image59.description = "In 1976, Basquiat and friend Al Diaz began spray-painting graffiti on buildings in Lower Manhattan, working under the pseudonym SAMO."
  image59.tags = "art, ghost, basquiat, new york, history"
  image59.media = File.open(Rails.root.join("/media_elements/images/70/tumblr_mapa1vnds61rhpgvfo1_500.jpg"))
  image59.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 59} image...\r"
  $stdout.flush
  image59.save!
  image59.is_public = true
  image59.publication_date = pub_date
  image59.save!
  
  pub_date -= 3
  
  image60 = Image.new
  image60.title = "J.M.Basquiat"
  image60.description = "In 1976, Basquiat and friend Al Diaz began spray-painting graffiti on buildings in Lower Manhattan, working under the pseudonym SAMO."
  image60.tags = "art, basquiat, art, samo, new york, history"
  image60.media = File.open(Rails.root.join("/media_elements/images/71/tumblr_ma02thv8vk1qzp5xxo1_500.jpg"))
  image60.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 60} image...\r"
  $stdout.flush
  image60.save!
  image60.is_public = true
  image60.publication_date = pub_date
  image60.save!
  
  pub_date -= 3
  
  image61 = Image.new
  image61.title = "J.M.Basquiat in New York"
  image61.description = "In 1976, Basquiat and friend Al Diaz began spray-painting graffiti on buildings in Lower Manhattan, working under the pseudonym SAMO."
  image61.tags = "art, basquiat, new york, history, art"
  image61.media = File.open(Rails.root.join("/media_elements/images/72/tumblr_m79phdivez1rwgohco1_r1_500.jpg"))
  image61.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 61} image...\r"
  $stdout.flush
  image61.save!
  image61.is_public = true
  image61.publication_date = pub_date
  image61.save!
  
  pub_date -= 3
  
  image62 = Image.new
  image62.title = "London taxy"
  image62.description = "The famous london taxi"
  image62.tags = "geography, london, people, english, taxi"
  image62.media = File.open(Rails.root.join("/media_elements/images/73/taxi_1360265b.jpg"))
  image62.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 62} image...\r"
  $stdout.flush
  image62.save!
  image62.is_public = true
  image62.publication_date = pub_date
  image62.save!
  
  pub_date -= 3
  
  image63 = Image.new
  image63.title = "London"
  image63.description = "The London Eye is a giant Ferris wheel situated on the banks of the River Thames in London, England. The entire structure is 135 metres (443 ft) tall and the wheel has a diameter of 120 metres (394 ft)."
  image63.tags = "geography, geography, taxi, car, english"
  image63.media = File.open(Rails.root.join("/media_elements/images/74/london.jpg"))
  image63.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 63} image...\r"
  $stdout.flush
  image63.save!
  image63.is_public = true
  image63.publication_date = pub_date
  image63.save!
  
  pub_date -= 3
  
  image64 = Image.new
  image64.title = "The weather in London"
  image64.description = "The etymology of London is uncertain.
  It is an ancient name and can be found in sources from the 2nd century."
  image64.tags = "geography, geography, english, city"
  image64.media = File.open(Rails.root.join("/media_elements/images/75/london1.jpg"))
  image64.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 64} image...\r"
  $stdout.flush
  image64.save!
  image64.is_public = true
  image64.publication_date = pub_date
  image64.save!
  
  pub_date -= 3
  
  image65 = Image.new
  image65.title = "Duffy"
  image65.description = "Stephen Anthony James Duffy (born 30 May 1960, Alum Rock, Birmingham, England) is an English singer/songwriter, and multi-instrumentalist."
  image65.tags = "london, duffy, english, pop"
  image65.media = File.open(Rails.root.join("/media_elements/images/76/duffy.jpg"))
  image65.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 65} image...\r"
  $stdout.flush
  image65.save!
  image65.is_public = true
  image65.publication_date = pub_date
  image65.save!
  
  pub_date -= 3
  
  image66 = Image.new
  image66.title = "Egon Schiele"
  image66.description = "Two girls embracing each other"
  image66.tags = "art, art, painter, expressionism"
  image66.media = File.open(Rails.root.join("/media_elements/images/84/egon_schiele_022.jpg"))
  image66.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 66} image...\r"
  $stdout.flush
  image66.save!
  image66.is_public = true
  image66.publication_date = pub_date
  image66.save!
  
  pub_date -= 3
  
  image67 = Image.new
  image67.title = "calendar"
  image67.description = "The 2012 phenomenon comprises a range of"
  image67.tags = "maya, calendar, maya, cataclysmic"
  image67.media = File.open(Rails.root.join("/media_elements/images/82/nmai-mayan-calendar.jpg"))
  image67.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 67} image...\r"
  $stdout.flush
  image67.save!
  image67.is_public = true
  image67.publication_date = pub_date
  image67.save!
  
  pub_date -= 3
  
  image68 = Image.new
  image68.title = "maya"
  image68.description = "sdlò ds"
  image68.tags = "asjdlkdj, aisudiosd, asjdklj, zxmnc"
  image68.media = File.open(Rails.root.join("/media_elements/images/105/jeu_de_balle_maya.jpg"))
  image68.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 68} image...\r"
  $stdout.flush
  image68.save!
  image68.is_public = true
  image68.publication_date = pub_date
  image68.save!
  
  pub_date -= 3
  
  image69 = Image.new
  image69.title = "Arthut Roessler"
  image69.description = "Egon Schiele"
  image69.tags = "art, art, painter, expressionism"
  image69.media = File.open(Rails.root.join("/media_elements/images/80/arthur-roessler-egon-schiele.jpg"))
  image69.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 69} image...\r"
  $stdout.flush
  image69.save!
  image69.is_public = true
  image69.publication_date = pub_date
  image69.save!
  
  pub_date -= 3
  
  image70 = Image.new
  image70.title = " Roy Lichtenstein"
  image70.description = "His work probably defines the basic premise of pop art better than any other through parody.[7] Selecting the old-fashioned comic strip as subject matter, Lichtenstein produces a hard-edged, precise composition that documents while it parodies in a soft manner."
  image70.tags = "art, art, roy, new york"
  image70.media = File.open(Rails.root.join("/media_elements/images/87/02.jpg"))
  image70.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 70} image...\r"
  $stdout.flush
  image70.save!
  image70.is_public = true
  image70.publication_date = pub_date
  image70.save!
  
  pub_date -= 3
  
  image71 = Image.new
  image71.title = "Warhol - Merilyn"
  image71.description = "Although Pop Art began in the late 1950s, Pop Art in America was given its greatest impetus during the 1960s."
  image71.tags = "art, pop, new york, color, warhol"
  image71.media = File.open(Rails.root.join("/media_elements/images/85/01.jpg"))
  image71.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 71} image...\r"
  $stdout.flush
  image71.save!
  image71.is_public = true
  image71.publication_date = pub_date
  image71.save!
  
  pub_date -= 3
  
  image72 = Image.new
  image72.title = "pleiadi"
  image72.description = "adsadasd"
  image72.tags = "lòkasd, aslk, cmnvbn, shdjfh"
  image72.media = File.open(Rails.root.join("/media_elements/images/90/pleiades_large.jpg"))
  image72.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 72} image...\r"
  $stdout.flush
  image72.save!
  image72.is_public = true
  image72.publication_date = pub_date
  image72.save!
  
  pub_date -= 3
  
  image73 = Image.new
  image73.title = "Egon Schiele"
  image73.description = "Portrait"
  image73.tags = "art, portrait, painting, art"
  image73.media = File.open(Rails.root.join("/media_elements/images/77/936full-egon-schiele.jpg"))
  image73.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 73} image...\r"
  $stdout.flush
  image73.save!
  image73.is_public = true
  image73.publication_date = pub_date
  image73.save!
  
  pub_date -= 3
  
  image74 = Image.new
  image74.title = "London taxy"
  image74.description = "The famous london taxi"
  image74.tags = "geography, london, people, english, taxi"
  image74.media = File.open(Rails.root.join("/media_elements/images/73/taxi_1360265b.jpg"))
  image74.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 74} image...\r"
  $stdout.flush
  image74.save!
  image74.is_public = true
  image74.publication_date = pub_date
  image74.save!
  
  pub_date -= 3
  
  image75 = Image.new
  image75.title = "London"
  image75.description = "The London Eye is a giant Ferris wheel situated on the banks of the River Thames in London, England. The entire structure is 135 metres (443 ft) tall and the wheel has a diameter of 120 metres (394 ft)."
  image75.tags = "geography, geography, taxi, car, english"
  image75.media = File.open(Rails.root.join("/media_elements/images/74/london.jpg"))
  image75.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 75} image...\r"
  $stdout.flush
  image75.save!
  image75.is_public = true
  image75.publication_date = pub_date
  image75.save!
  
  pub_date -= 3
  
  image76 = Image.new
  image76.title = "The weather in London"
  image76.description = "The etymology of London is uncertain.
  It is an ancient name and can be found in sources from the 2nd century."
  image76.tags = "geography, geography, english, city"
  image76.media = File.open(Rails.root.join("/media_elements/images/75/london1.jpg"))
  image76.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 76} image...\r"
  $stdout.flush
  image76.save!
  image76.is_public = true
  image76.publication_date = pub_date
  image76.save!
  
  pub_date -= 3
  
  image77 = Image.new
  image77.title = "Duffy"
  image77.description = "Stephen Anthony James Duffy (born 30 May 1960, Alum Rock, Birmingham, England) is an English singer/songwriter, and multi-instrumentalist."
  image77.tags = "london, duffy, english, pop"
  image77.media = File.open(Rails.root.join("/media_elements/images/76/duffy.jpg"))
  image77.user_id = benji.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 77} image...\r"
  $stdout.flush
  image77.save!
  image77.is_public = true
  image77.publication_date = pub_date
  image77.save!
  
  pub_date -= 3
  
  image78 = Image.new
  image78.title = "Egon Schiele"
  image78.description = "Two girls embracing each other"
  image78.tags = "art, art, painter, expressionism"
  image78.media = File.open(Rails.root.join("/media_elements/images/84/egon_schiele_022.jpg"))
  image78.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 78} image...\r"
  $stdout.flush
  image78.save!
  image78.is_public = true
  image78.publication_date = pub_date
  image78.save!
  
  pub_date -= 3
  
  image79 = Image.new
  image79.title = "calendar"
  image79.description = "The 2012 phenomenon comprises a range of"
  image79.tags = "maya, calendar, maya, cataclysmic"
  image79.media = File.open(Rails.root.join("/media_elements/images/82/nmai-mayan-calendar.jpg"))
  image79.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 79} image...\r"
  $stdout.flush
  image79.save!
  image79.is_public = true
  image79.publication_date = pub_date
  image79.save!
  
  pub_date -= 3
  
  image80 = Image.new
  image80.title = "maya"
  image80.description = "sdlò ds"
  image80.tags = "asjdlkdj, aisudiosd, asjdklj, zxmnc"
  image80.media = File.open(Rails.root.join("/media_elements/images/105/jeu_de_balle_maya.jpg"))
  image80.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 80} image...\r"
  $stdout.flush
  image80.save!
  image80.is_public = true
  image80.publication_date = pub_date
  image80.save!
  
  pub_date -= 3
  
  image81 = Image.new
  image81.title = "Arthut Roessler"
  image81.description = "Egon Schiele"
  image81.tags = "art, art, painter, expressionism"
  image81.media = File.open(Rails.root.join("/media_elements/images/80/arthur-roessler-egon-schiele.jpg"))
  image81.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 81} image...\r"
  $stdout.flush
  image81.save!
  image81.is_public = true
  image81.publication_date = pub_date
  image81.save!
  
  pub_date -= 3
  
  image82 = Image.new
  image82.title = " Roy Lichtenstein"
  image82.description = "His work probably defines the basic premise of pop art better than any other through parody.[7] Selecting the old-fashioned comic strip as subject matter, Lichtenstein produces a hard-edged, precise composition that documents while it parodies in a soft manner."
  image82.tags = "art, art, roy, new york"
  image82.media = File.open(Rails.root.join("/media_elements/images/87/02.jpg"))
  image82.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 82} image...\r"
  $stdout.flush
  image82.save!
  image82.is_public = true
  image82.publication_date = pub_date
  image82.save!
  
  pub_date -= 3
  
  image83 = Image.new
  image83.title = "Warhol - Merilyn"
  image83.description = "Although Pop Art began in the late 1950s, Pop Art in America was given its greatest impetus during the 1960s."
  image83.tags = "art, pop, new york, color, warhol"
  image83.media = File.open(Rails.root.join("/media_elements/images/85/01.jpg"))
  image83.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 83} image...\r"
  $stdout.flush
  image83.save!
  image83.is_public = true
  image83.publication_date = pub_date
  image83.save!
  
  pub_date -= 3
  
  image84 = Image.new
  image84.title = "pleiadi"
  image84.description = "adsadasd"
  image84.tags = "lòkasd, aslk, cmnvbn, shdjfh"
  image84.media = File.open(Rails.root.join("/media_elements/images/90/pleiades_large.jpg"))
  image84.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 84} image...\r"
  $stdout.flush
  image84.save!
  image84.is_public = true
  image84.publication_date = pub_date
  image84.save!
  
  pub_date -= 3
  
  image85 = Image.new
  image85.title = "Velvet Underground"
  image85.description = "Velvet Underground album cover by Andy Warhol"
  image85.tags = "art, warhol, pop, new york"
  image85.media = File.open(Rails.root.join("/media_elements/images/92/08.jpg"))
  image85.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 85} image...\r"
  $stdout.flush
  image85.save!
  image85.is_public = true
  image85.publication_date = pub_date
  image85.save!
  
  pub_date -= 3
  
  image86 = Image.new
  image86.title = "Andy Warhol - Portrait"
  image86.description = "Andy Warhol (August 6, 1928 – February 22, 1987)"
  image86.tags = "art, warhol, pop, art"
  image86.media = File.open(Rails.root.join("/media_elements/images/89/04.jpg"))
  image86.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 86} image...\r"
  $stdout.flush
  image86.save!
  image86.is_public = true
  image86.publication_date = pub_date
  image86.save!
  
  pub_date -= 3
  
  image87 = Image.new
  image87.title = "Mimmo Rotella"
  image87.description = "Domenico "Mimmo" Rotella
  (7 October 1918 – 8 January 2006), was an Italian artist and poet best known for his works of décollage and psychogeographics, made from torn advertising posters. Rotella was born in Catanzaro, Calabria."
  image87.tags = "art, rotella, pop, art, italy, artist"
  image87.media = File.open(Rails.root.join("/media_elements/images/97/14.jpg"))
  image87.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 87} image...\r"
  $stdout.flush
  image87.save!
  image87.is_public = true
  image87.publication_date = pub_date
  image87.save!
  
  pub_date -= 3
  
  image88 = Image.new
  image88.title = "Warhol"
  image88.description = "Andy Warhol (August 6, 1928 – February 22, 1987)"
  image88.tags = "art, art, pop, new york, color"
  image88.media = File.open(Rails.root.join("/media_elements/images/91/05.jpg"))
  image88.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 88} image...\r"
  $stdout.flush
  image88.save!
  image88.is_public = true
  image88.publication_date = pub_date
  image88.save!
  
  pub_date -= 3
  
  image89 = Image.new
  image89.title = "Keith Haring"
  image89.description = "Keith Haring (May 4, 1958 – February 16, 1990)"
  image89.tags = "art, art, haring, color, ny"
  image89.media = File.open(Rails.root.join("/media_elements/images/93/10.jpg"))
  image89.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 89} image...\r"
  $stdout.flush
  image89.save!
  image89.is_public = true
  image89.publication_date = pub_date
  image89.save!
  
  pub_date -= 3
  
  image90 = Image.new
  image90.title = "Keith Haring - Yes"
  image90.description = "Keith Haring (May 4, 1958 – February 16, 1990)"
  image90.tags = "art, hering, ny, art, color"
  image90.media = File.open(Rails.root.join("/media_elements/images/96/11.png"))
  image90.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 90} image...\r"
  $stdout.flush
  image90.save!
  image90.is_public = true
  image90.publication_date = pub_date
  image90.save!
  
  pub_date -= 3
  
  image91 = Image.new
  image91.title = "Mario Schifano - Coca Cola"
  image91.description = "Mario Schifano ( 20 September 1934, Khoms, Libya - 26 January 1998, Rome, Italy ) was an Italian painter and collagist of the Postmodern tradition. He also achieved some renown as a film-maker and rock musician."
  image91.tags = "art, art, italy, artist, coca cola"
  image91.media = File.open(Rails.root.join("/media_elements/images/101/16.jpg"))
  image91.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 91} image...\r"
  $stdout.flush
  image91.save!
  image91.is_public = true
  image91.publication_date = pub_date
  image91.save!
  
  pub_date -= 3
  
  image92 = Image.new
  image92.title = "Mario Schifano - Bicicletta"
  image92.description = "Mario Schifano ( 20 September 1934, Khoms, Libya - 26 January 1998, Rome, Italy ) was an Italian painter and collagist of the Postmodern tradition. He also achieved some renown as a film-maker and rock musician."
  image92.tags = "art, art, italy, artist, color"
  image92.media = File.open(Rails.root.join("/media_elements/images/98/17.jpg"))
  image92.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 92} image...\r"
  $stdout.flush
  image92.save!
  image92.is_public = true
  image92.publication_date = pub_date
  image92.save!
  
  pub_date -= 3
  
  image93 = Image.new
  image93.title = "maya"
  image93.description = "sdlò ds"
  image93.tags = "asjdlkdj, aisudiosd, asjdklj, zxmnc"
  image93.media = File.open(Rails.root.join("/media_elements/images/105/jeu_de_balle_maya.jpg"))
  image93.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 93} image...\r"
  $stdout.flush
  image93.save!
  image93.is_public = true
  image93.publication_date = pub_date
  image93.save!
  
  pub_date -= 3
  
  image94 = Image.new
  image94.title = "Mimmo Rotella"
  image94.description = "Domenico "Mimmo" Rotella
  (7 October 1918 – 8 January 2006), was an Italian artist and poet best known for his works of décollage and psychogeographics, made from torn advertising posters. Rotella was born in Catanzaro, Calabria."
  image94.tags = "art, rotella, pop, art, italy, artist"
  image94.media = File.open(Rails.root.join("/media_elements/images/97/14.jpg"))
  image94.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 94} image...\r"
  $stdout.flush
  image94.save!
  image94.is_public = true
  image94.publication_date = pub_date
  image94.save!
  
  pub_date -= 3
  
  image95 = Image.new
  image95.title = "Keith Haring"
  image95.description = "Keith Haring (May 4, 1958 – February 16, 1990)"
  image95.tags = "art, art, haring, color, ny"
  image95.media = File.open(Rails.root.join("/media_elements/images/93/10.jpg"))
  image95.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 95} image...\r"
  $stdout.flush
  image95.save!
  image95.is_public = true
  image95.publication_date = pub_date
  image95.save!
  
  pub_date -= 3
  
  image96 = Image.new
  image96.title = "Keith Haring - Yes"
  image96.description = "Keith Haring (May 4, 1958 – February 16, 1990)"
  image96.tags = "art, hering, ny, art, color"
  image96.media = File.open(Rails.root.join("/media_elements/images/96/11.png"))
  image96.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 96} image...\r"
  $stdout.flush
  image96.save!
  image96.is_public = true
  image96.publication_date = pub_date
  image96.save!
  
  pub_date -= 3
  
  image97 = Image.new
  image97.title = "Mario Schifano - Coca Cola"
  image97.description = "Mario Schifano ( 20 September 1934, Khoms, Libya - 26 January 1998, Rome, Italy ) was an Italian painter and collagist of the Postmodern tradition. He also achieved some renown as a film-maker and rock musician."
  image97.tags = "art, art, italy, artist, coca cola"
  image97.media = File.open(Rails.root.join("/media_elements/images/101/16.jpg"))
  image97.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 97} image...\r"
  $stdout.flush
  image97.save!
  image97.is_public = true
  image97.publication_date = pub_date
  image97.save!
  
  pub_date -= 3
  
  image98 = Image.new
  image98.title = "Mario Schifano - Bicicletta"
  image98.description = "Mario Schifano ( 20 September 1934, Khoms, Libya - 26 January 1998, Rome, Italy ) was an Italian painter and collagist of the Postmodern tradition. He also achieved some renown as a film-maker and rock musician."
  image98.tags = "art, art, italy, artist, color"
  image98.media = File.open(Rails.root.join("/media_elements/images/98/17.jpg"))
  image98.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 98} image...\r"
  $stdout.flush
  image98.save!
  image98.is_public = true
  image98.publication_date = pub_date
  image98.save!
  
  pub_date -= 3
  
  image99 = Image.new
  image99.title = "Mario Schifano"
  image99.description = "Mario Schifano ( 20 September 1934, Khoms, Libya - 26 January 1998, Rome, Italy )"
  image99.tags = "art, pop, art, italy"
  image99.media = File.open(Rails.root.join("/media_elements/images/102/schifano.jpg"))
  image99.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 99} image...\r"
  $stdout.flush
  image99.save!
  image99.is_public = true
  image99.publication_date = pub_date
  image99.save!
  
  pub_date -= 3
  
  image100 = Image.new
  image100.title = "Angry Maya Statue"
  image100.description = "Many similar busts were used as architectural embellishments on Structure 22 at Copán. "
  image100.tags = "museum, maya, angry, museum"
  image100.media = File.open(Rails.root.join("/media_elements/images/95/angry_maya_statue.JPG"))
  image100.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 100} image...\r"
  $stdout.flush
  image100.save!
  image100.is_public = true
  image100.publication_date = pub_date
  image100.save!
  
  pub_date -= 3
  
  image101 = Image.new
  image101.title = "Temple"
  image101.description = "temple"
  image101.tags = "temple, chiapas, jungle, mexican"
  image101.media = File.open(Rails.root.join("/media_elements/images/104/maya_profezia.jpg"))
  image101.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 101} image...\r"
  $stdout.flush
  image101.save!
  image101.is_public = true
  image101.publication_date = pub_date
  image101.save!
  
  pub_date -= 3
  
  image102 = Image.new
  image102.title = "Academy of Fine Arts Vienna"
  image102.description = "The Academy of Fine Arts Vienna (German: Akademie der bildenden Künste Wien) is a public art school of higher education in Vienna, Austria."
  image102.tags = "wien, academy of fine arts, schiele, austria"
  image102.media = File.open(Rails.root.join("/media_elements/images/99/450px-akadbildkwien.jpg"))
  image102.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 102} image...\r"
  $stdout.flush
  image102.save!
  image102.is_public = true
  image102.publication_date = pub_date
  image102.save!
  
  pub_date -= 3
  
  image103 = Image.new
  image103.title = "Gustav Klimt"
  image103.description = "The kiss (1907-08)"
  image103.tags = "art, expressionism, painter, art"
  image103.media = File.open(Rails.root.join("/media_elements/images/100/gustav_klimt_016.jpg"))
  image103.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 103} image...\r"
  $stdout.flush
  image103.save!
  image103.is_public = true
  image103.publication_date = pub_date
  image103.save!
  
  pub_date -= 3
  
  image104 = Image.new
  image104.title = "Maize"
  image104.description = "Tonsured Maize God as a patron of the scribal arts, Classic period"
  image104.tags = "god, male, god, calendrical"
  image104.media = File.open(Rails.root.join("/media_elements/images/106/maize_god_l.jpg"))
  image104.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 104} image...\r"
  $stdout.flush
  image104.save!
  image104.is_public = true
  image104.publication_date = pub_date
  image104.save!
  
  pub_date -= 3
  
  image105 = Image.new
  image105.title = "Elephant"
  image105.description = "description (max 280 characters)"
  image105.tags = "maya, maya, opdif, xmc, vnv"
  image105.media = File.open(Rails.root.join("/media_elements/images/107/elephant-edit-20121221-094503.jpg"))
  image105.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 105} image...\r"
  $stdout.flush
  image105.save!
  image105.is_public = true
  image105.publication_date = pub_date
  image105.save!
  
  pub_date -= 3
  
  image106 = Image.new
  image106.title = "Keith Haring  -  Paint"
  image106.description = "Keith Haring (Reading, 4 maggio 1958 – New York, 16 febbraio 1990)"
  image106.tags = "art, art, new york, haring, paint"
  image106.media = File.open(Rails.root.join("/media_elements/images/110/tseng-kwong-chi-bill-t-jones-and-keith-haring.jpg"))
  image106.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 106} image...\r"
  $stdout.flush
  image106.save!
  image106.is_public = true
  image106.publication_date = pub_date
  image106.save!
  
  pub_date -= 3
  
  image107 = Image.new
  image107.title = "Mimmo Rotella"
  image107.description = "Domenico "Mimmo" Rotella, (7 October 1918 – 8 January 2006)"
  image107.tags = "art, art, italy, color, artist"
  image107.media = File.open(Rails.root.join("/media_elements/images/116/rotella.jpg"))
  image107.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 107} image...\r"
  $stdout.flush
  image107.save!
  image107.is_public = true
  image107.publication_date = pub_date
  image107.save!
  
  pub_date -= 3
  
  image108 = Image.new
  image108.title = "Golconda"
  image108.description = "painting"
  image108.tags = "pop, painting, surrealism, pop"
  image108.media = File.open(Rails.root.join("/media_elements/images/118/golconda-magritte.jpg"))
  image108.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 108} image...\r"
  $stdout.flush
  image108.save!
  image108.is_public = true
  image108.publication_date = pub_date
  image108.save!
  
  pub_date -= 3
  
  image109 = Image.new
  image109.title = "Egon Schiele"
  image109.description = "Self"
  image109.tags = "art, expressionism, art, painter"
  image109.media = File.open(Rails.root.join("/media_elements/images/112/schieleselfshirt.jpg"))
  image109.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 109} image...\r"
  $stdout.flush
  image109.save!
  image109.is_public = true
  image109.publication_date = pub_date
  image109.save!
  
  pub_date -= 3
  
  image110 = Image.new
  image110.title = "Egon Schiele"
  image110.description = "Self-portrait"
  image110.tags = "art, expressionism, art, painter"
  image110.media = File.open(Rails.root.join("/media_elements/images/115/schiele_05.jpg"))
  image110.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 110} image...\r"
  $stdout.flush
  image110.save!
  image110.is_public = true
  image110.publication_date = pub_date
  image110.save!
  
  pub_date -= 3
  
  image111 = Image.new
  image111.title = "Egon Schiele"
  image111.description = "Die kleine Stadt II, 1912–1913."
  image111.tags = "art, expressionism, art, painter"
  image111.media = File.open(Rails.root.join("/media_elements/images/113/763px-egon_schiele_015.jpg"))
  image111.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 111} image...\r"
  $stdout.flush
  image111.save!
  image111.is_public = true
  image111.publication_date = pub_date
  image111.save!
  
  pub_date -= 3
  
  image112 = Image.new
  image112.title = "Egon Schiele, Friendship, 1913"
  image112.description = "Egon Schiele, Friendship, 1913"
  image112.tags = "art, art, painter, expressionism"
  image112.media = File.open(Rails.root.join("/media_elements/images/109/schiele_-_freundschaft_-_1913.jpg"))
  image112.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 112} image...\r"
  $stdout.flush
  image112.save!
  image112.is_public = true
  image112.publication_date = pub_date
  image112.save!
  
  pub_date -= 3
  
  image113 = Image.new
  image113.title = "Mimmo Rotella"
  image113.description = "Domenico "Mimmo" Rotella, (7 October 1918 – 8 January 2006)"
  image113.tags = "art, art, italy, color, artist"
  image113.media = File.open(Rails.root.join("/media_elements/images/116/rotella.jpg"))
  image113.user_id = retlaw.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 113} image...\r"
  $stdout.flush
  image113.save!
  image113.is_public = true
  image113.publication_date = pub_date
  image113.save!
  
  pub_date -= 3
  
  image114 = Image.new
  image114.title = "Golconda"
  image114.description = "painting"
  image114.tags = "pop, painting, surrealism, pop"
  image114.media = File.open(Rails.root.join("/media_elements/images/118/golconda-magritte.jpg"))
  image114.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 114} image...\r"
  $stdout.flush
  image114.save!
  image114.is_public = true
  image114.publication_date = pub_date
  image114.save!
  
  pub_date -= 3
  
  image115 = Image.new
  image115.title = "Egon Schiele"
  image115.description = "Self-portrait"
  image115.tags = "art, expressionism, art, painter"
  image115.media = File.open(Rails.root.join("/media_elements/images/115/schiele_05.jpg"))
  image115.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 115} image...\r"
  $stdout.flush
  image115.save!
  image115.is_public = true
  image115.publication_date = pub_date
  image115.save!
  
  pub_date -= 3
  
  image116 = Image.new
  image116.title = "Egon Schiele"
  image116.description = "Die kleine Stadt II, 1912–1913."
  image116.tags = "art, expressionism, art, painter"
  image116.media = File.open(Rails.root.join("/media_elements/images/113/763px-egon_schiele_015.jpg"))
  image116.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 116} image...\r"
  $stdout.flush
  image116.save!
  image116.is_public = true
  image116.publication_date = pub_date
  image116.save!
  
  pub_date -= 3
  
  image117 = Image.new
  image117.title = "Egon Schiele"
  image117.description = "House with Shingles, 1915"
  image117.tags = "art, expressionism, art, painter"
  image117.media = File.open(Rails.root.join("/media_elements/images/114/house_with_shingles_egon_schiele_1915.jpeg"))
  image117.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 117} image...\r"
  $stdout.flush
  image117.save!
  image117.is_public = true
  image117.publication_date = pub_date
  image117.save!
  
  pub_date -= 3
  
  image118 = Image.new
  image118.title = "The son of man"
  image118.description = "Beautiful, original hand-painted artwork in your home. "
  image118.tags = "oil, painted, magritte, oil"
  image118.media = File.open(Rails.root.join("/media_elements/images/119/the-son-of-man-by-ren_-magritte-636544.jpg"))
  image118.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 118} image...\r"
  $stdout.flush
  image118.save!
  image118.is_public = true
  image118.publication_date = pub_date
  image118.save!
  
  pub_date -= 3
  
  image119 = Image.new
  image119.title = "The listening room"
  image119.description = "Rene Magritte"
  image119.tags = "art, painting, surrealism, magritte"
  image119.media = File.open(Rails.root.join("/media_elements/images/121/tumblr_md1f37odrk1qiv63po1_1280.jpg"))
  image119.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 119} image...\r"
  $stdout.flush
  image119.save!
  image119.is_public = true
  image119.publication_date = pub_date
  image119.save!
  
  pub_date -= 3
  
  image120 = Image.new
  image120.title = "Rene Magritte"
  image120.description = "Photo Magritte"
  image120.tags = "art, surrealism, art, painting"
  image120.media = File.open(Rails.root.join("/media_elements/images/126/rene_magritte.jpg"))
  image120.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 120} image...\r"
  $stdout.flush
  image120.save!
  image120.is_public = true
  image120.publication_date = pub_date
  image120.save!
  
  pub_date -= 3
  
  image121 = Image.new
  image121.title = "Les amants"
  image121.description = "people with cloth obscuring their faces"
  image121.tags = "art, oil, pop, surrealism"
  image121.media = File.open(Rails.root.join("/media_elements/images/136/04-rene-magritte-the-lovers-1928.jpg"))
  image121.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 121} image...\r"
  $stdout.flush
  image121.save!
  image121.is_public = true
  image121.publication_date = pub_date
  image121.save!
  
  pub_date -= 3
  
  image122 = Image.new
  image122.title = "Salgado"
  image122.description = "Terra"
  image122.tags = "photography, photography, journalism, reportage"
  image122.media = File.open(Rails.root.join("/media_elements/images/143/salgado__sebasti_o-_terra_-_p-_58.jpg"))
  image122.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 122} image...\r"
  $stdout.flush
  image122.save!
  image122.is_public = true
  image122.publication_date = pub_date
  image122.save!
  
  pub_date -= 3
  
  image123 = Image.new
  image123.title = "Salgado"
  image123.description = "Sebastiao Salgado"
  image123.tags = "reportage, photographer, photojournalism, reportage"
  image123.media = File.open(Rails.root.join("/media_elements/images/144/dsc06605.jpg"))
  image123.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 123} image...\r"
  $stdout.flush
  image123.save!
  image123.is_public = true
  image123.publication_date = pub_date
  image123.save!
  
  pub_date -= 3
  
  image124 = Image.new
  image124.title = "Salgado"
  image124.description = "Alaska"
  image124.tags = "photography, photojournalism, reportage, photography"
  image124.media = File.open(Rails.root.join("/media_elements/images/145/screen-shot-2011-02-26-at-8-13-42-pm.png"))
  image124.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 124} image...\r"
  $stdout.flush
  image124.save!
  image124.is_public = true
  image124.publication_date = pub_date
  image124.save!
  
  pub_date -= 3
  
  image125 = Image.new
  image125.title = "Salgado"
  image125.description = "Alaska"
  image125.tags = "photography, photography, photojournalism, reportage"
  image125.media = File.open(Rails.root.join("/media_elements/images/146/sebastiao-salgado-2.jpg"))
  image125.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 125} image...\r"
  $stdout.flush
  image125.save!
  image125.is_public = true
  image125.publication_date = pub_date
  image125.save!
  
  pub_date -= 3
  
  image126 = Image.new
  image126.title = "Koudelka"
  image126.description = "Romania"
  image126.tags = "reportage, photographer, reportage, journalism"
  image126.media = File.open(Rails.root.join("/media_elements/images/148/1-_josef_koudelka__romania__1968.jpg"))
  image126.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 126} image...\r"
  $stdout.flush
  image126.save!
  image126.is_public = true
  image126.publication_date = pub_date
  image126.save!
  
  pub_date -= 3
  
  image127 = Image.new
  image127.title = "Koudelka"
  image127.description = "Untitled"
  image127.tags = "art, reportage, photography, art"
  image127.media = File.open(Rails.root.join("/media_elements/images/157/tumblr_mccbdmm8nh1r69p0no1_1280.jpg"))
  image127.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 127} image...\r"
  $stdout.flush
  image127.save!
  image127.is_public = true
  image127.publication_date = pub_date
  image127.save!
  
  pub_date -= 3
  
  image128 = Image.new
  image128.title = "Koudelka"
  image128.description = "Boemia"
  image128.tags = "art, reportage, photography, art"
  image128.media = File.open(Rails.root.join("/media_elements/images/159/josef_koudelka-298.jpg"))
  image128.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 128} image...\r"
  $stdout.flush
  image128.save!
  image128.is_public = true
  image128.publication_date = pub_date
  image128.save!
  
  pub_date -= 3
  
  image129 = Image.new
  image129.title = "Koudelka"
  image129.description = "Birds"
  image129.tags = "art, reportage, photography, art"
  image129.media = File.open(Rails.root.join("/media_elements/images/160/1rcl.png"))
  image129.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 129} image...\r"
  $stdout.flush
  image129.save!
  image129.is_public = true
  image129.publication_date = pub_date
  image129.save!
  
  pub_date -= 3
  
  image130 = Image.new
  image130.title = "Koudelka"
  image130.description = "Praga 1968"
  image130.tags = "photography, photography, praga, 1968"
  image130.media = File.open(Rails.root.join("/media_elements/images/171/4926885965_412f79a56f_z.jpg"))
  image130.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 130} image...\r"
  $stdout.flush
  image130.save!
  image130.is_public = true
  image130.publication_date = pub_date
  image130.save!
  
  pub_date -= 3
  
  image131 = Image.new
  image131.title = "Koudelka"
  image131.description = "Untitled"
  image131.tags = "reportage, photographer, reportage, journalism"
  image131.media = File.open(Rails.root.join("/media_elements/images/153/koudelka_intersection.jpg"))
  image131.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 131} image...\r"
  $stdout.flush
  image131.save!
  image131.is_public = true
  image131.publication_date = pub_date
  image131.save!
  
  pub_date -= 3
  
  image132 = Image.new
  image132.title = "Koudelka"
  image132.description = "Gypsies"
  image132.tags = "art, reportage, photography, art"
  image132.media = File.open(Rails.root.join("/media_elements/images/154/gypsies_5.jpg"))
  image132.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 132} image...\r"
  $stdout.flush
  image132.save!
  image132.is_public = true
  image132.publication_date = pub_date
  image132.save!
  
  pub_date -= 3
  
  image133 = Image.new
  image133.title = "Les amants"
  image133.description = "people with cloth obscuring their faces"
  image133.tags = "art, oil, pop, surrealism"
  image133.media = File.open(Rails.root.join("/media_elements/images/136/04-rene-magritte-the-lovers-1928.jpg"))
  image133.user_id = toostrong.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 133} image...\r"
  $stdout.flush
  image133.save!
  image133.is_public = true
  image133.publication_date = pub_date
  image133.save!
  
  pub_date -= 3
  
  image134 = Image.new
  image134.title = "Salgado"
  image134.description = "Terra"
  image134.tags = "photography, photography, journalism, reportage"
  image134.media = File.open(Rails.root.join("/media_elements/images/143/salgado__sebasti_o-_terra_-_p-_58.jpg"))
  image134.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 134} image...\r"
  $stdout.flush
  image134.save!
  image134.is_public = true
  image134.publication_date = pub_date
  image134.save!
  
  pub_date -= 3
  
  image135 = Image.new
  image135.title = "Salgado"
  image135.description = "Sebastiao Salgado"
  image135.tags = "reportage, photographer, photojournalism, reportage"
  image135.media = File.open(Rails.root.join("/media_elements/images/144/dsc06605.jpg"))
  image135.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 135} image...\r"
  $stdout.flush
  image135.save!
  image135.is_public = true
  image135.publication_date = pub_date
  image135.save!
  
  pub_date -= 3
  
  image136 = Image.new
  image136.title = "Salgado"
  image136.description = "Alaska"
  image136.tags = "photography, photojournalism, reportage, photography"
  image136.media = File.open(Rails.root.join("/media_elements/images/145/screen-shot-2011-02-26-at-8-13-42-pm.png"))
  image136.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 136} image...\r"
  $stdout.flush
  image136.save!
  image136.is_public = true
  image136.publication_date = pub_date
  image136.save!
  
  pub_date -= 3
  
  image137 = Image.new
  image137.title = "Salgado"
  image137.description = "Alaska"
  image137.tags = "photography, photography, photojournalism, reportage"
  image137.media = File.open(Rails.root.join("/media_elements/images/146/sebastiao-salgado-2.jpg"))
  image137.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 137} image...\r"
  $stdout.flush
  image137.save!
  image137.is_public = true
  image137.publication_date = pub_date
  image137.save!
  
  pub_date -= 3
  
  image138 = Image.new
  image138.title = "Koudelka"
  image138.description = "Romania"
  image138.tags = "reportage, photographer, reportage, journalism"
  image138.media = File.open(Rails.root.join("/media_elements/images/148/1-_josef_koudelka__romania__1968.jpg"))
  image138.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 138} image...\r"
  $stdout.flush
  image138.save!
  image138.is_public = true
  image138.publication_date = pub_date
  image138.save!
  
  pub_date -= 3
  
  image139 = Image.new
  image139.title = "Koudelka"
  image139.description = "Untitled"
  image139.tags = "art, reportage, photography, art"
  image139.media = File.open(Rails.root.join("/media_elements/images/157/tumblr_mccbdmm8nh1r69p0no1_1280.jpg"))
  image139.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 139} image...\r"
  $stdout.flush
  image139.save!
  image139.is_public = true
  image139.publication_date = pub_date
  image139.save!
  
  pub_date -= 3
  
  image140 = Image.new
  image140.title = "Koudelka"
  image140.description = "Boemia"
  image140.tags = "art, reportage, photography, art"
  image140.media = File.open(Rails.root.join("/media_elements/images/159/josef_koudelka-298.jpg"))
  image140.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 140} image...\r"
  $stdout.flush
  image140.save!
  image140.is_public = true
  image140.publication_date = pub_date
  image140.save!
  
  pub_date -= 3
  
  image141 = Image.new
  image141.title = "Koudelka"
  image141.description = "Birds"
  image141.tags = "art, reportage, photography, art"
  image141.media = File.open(Rails.root.join("/media_elements/images/160/1rcl.png"))
  image141.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 141} image...\r"
  $stdout.flush
  image141.save!
  image141.is_public = true
  image141.publication_date = pub_date
  image141.save!
  
  pub_date -= 3
  
  image142 = Image.new
  image142.title = "Koudelka"
  image142.description = "Praga 1968"
  image142.tags = "photography, photography, praga, 1968"
  image142.media = File.open(Rails.root.join("/media_elements/images/171/4926885965_412f79a56f_z.jpg"))
  image142.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 142} image...\r"
  $stdout.flush
  image142.save!
  image142.is_public = true
  image142.publication_date = pub_date
  image142.save!
  
  pub_date -= 3
  
  image143 = Image.new
  image143.title = "Koudelka"
  image143.description = "Untitled"
  image143.tags = "reportage, photographer, reportage, journalism"
  image143.media = File.open(Rails.root.join("/media_elements/images/153/koudelka_intersection.jpg"))
  image143.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 143} image...\r"
  $stdout.flush
  image143.save!
  image143.is_public = true
  image143.publication_date = pub_date
  image143.save!
  
  pub_date -= 3
  
  image144 = Image.new
  image144.title = "Koudelka"
  image144.description = "Gypsies"
  image144.tags = "art, reportage, photography, art"
  image144.media = File.open(Rails.root.join("/media_elements/images/154/gypsies_5.jpg"))
  image144.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 144} image...\r"
  $stdout.flush
  image144.save!
  image144.is_public = true
  image144.publication_date = pub_date
  image144.save!
  
  pub_date -= 3
  
  image145 = Image.new
  image145.title = "Koudelka"
  image145.description = "Koudelka"
  image145.tags = "art, reportage, photography, art"
  image145.media = File.open(Rails.root.join("/media_elements/images/161/c0004293_1224759.jpg"))
  image145.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 145} image...\r"
  $stdout.flush
  image145.save!
  image145.is_public = true
  image145.publication_date = pub_date
  image145.save!
  
  pub_date -= 3
  
  image146 = Image.new
  image146.title = "Koudelka"
  image146.description = "Praga"
  image146.tags = "photography, photography, praga, 1968"
  image146.media = File.open(Rails.root.join("/media_elements/images/173/praga.jpg"))
  image146.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 146} image...\r"
  $stdout.flush
  image146.save!
  image146.is_public = true
  image146.publication_date = pub_date
  image146.save!
  
  pub_date -= 3
  
  image147 = Image.new
  image147.title = "Sebastiao Salgado"
  image147.description = "Portrait"
  image147.tags = "photography, photography, reportage, photojournalism"
  image147.media = File.open(Rails.root.join("/media_elements/images/140/portrait_292.jpg"))
  image147.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 147} image...\r"
  $stdout.flush
  image147.save!
  image147.is_public = true
  image147.publication_date = pub_date
  image147.save!
  
  pub_date -= 3
  
  image148 = Image.new
  image148.title = "Salgado"
  image148.description = "Untitled"
  image148.tags = "photography, photography, journalism, reportage"
  image148.media = File.open(Rails.root.join("/media_elements/images/139/image2.jpg"))
  image148.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 148} image...\r"
  $stdout.flush
  image148.save!
  image148.is_public = true
  image148.publication_date = pub_date
  image148.save!
  
  pub_date -= 3
  
  image149 = Image.new
  image149.title = "Salgado"
  image149.description = "Nature"
  image149.tags = "photography, photojournalism, reportage, photography"
  image149.media = File.open(Rails.root.join("/media_elements/images/142/salgado-alaska.jpg"))
  image149.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 149} image...\r"
  $stdout.flush
  image149.save!
  image149.is_public = true
  image149.publication_date = pub_date
  image149.save!
  
  pub_date -= 3
  
  image150 = Image.new
  image150.title = "Salgado"
  image150.description = "India"
  image150.tags = "photography, photography, photojournalism, reportage"
  image150.media = File.open(Rails.root.join("/media_elements/images/141/salgado_india.jpg"))
  image150.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 150} image...\r"
  $stdout.flush
  image150.save!
  image150.is_public = true
  image150.publication_date = pub_date
  image150.save!
  
  pub_date -= 3
  
  image151 = Image.new
  image151.title = "Salgado"
  image151.description = "Africa"
  image151.tags = "photography, salgado, photojournalism, photography"
  image151.media = File.open(Rails.root.join("/media_elements/images/147/salgado_2.jpg"))
  image151.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 151} image...\r"
  $stdout.flush
  image151.save!
  image151.is_public = true
  image151.publication_date = pub_date
  image151.save!
  
  pub_date -= 3
  
  image152 = Image.new
  image152.title = "Salgado"
  image152.description = "Untitled"
  image152.tags = "photography, photography, journalism, reportage"
  image152.media = File.open(Rails.root.join("/media_elements/images/138/tumblr_mcxxdyxvsk1qgwmzso1_1280.jpg"))
  image152.user_id = fupete.id
  $stdout.print "Saving #{ActiveSupport::Inflector.ordinalize 152} image...\r"
  $stdout.flush
  image152.save!
  image152.is_public = true
  image152.publication_date = pub_date
  image152.save!
  
  pub_date -= 3


  
  puts "Saved #{Image.count} images (should be 32)\n"
  
  
  # AUDIOS
  
  pub_date = original_pub_date + 1
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
  puts "Saved #{Audio.count} audios (should be 6)\n"
  
  
  # VIDEOS
  
  pub_date = original_pub_date + 2
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
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
  
  pub_date -= 3
  
  puts "Saved #{Video.count} videos (should be 24)\n"
  
  
  # RESUME
  
  puts "Saved #{Tag.count} tags (should be 130)\n"
  puts "Saved #{Tagging.count} taggings (should be 355)\n"
  puts 'FINE'
  
end

plant_development_seeds
