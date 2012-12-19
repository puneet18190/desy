# encoding: UTF-8

def plant_development_seeds
  
  # INITIALIZE
  
  videos_folder = media =:Video::Uploader::ABSOLUTE_FOLDER
  audios_folder = media =:Audio::Uploader::ABSOLUTE_FOLDER
  unless Rails.env.production?
    [videos_folder, audios_folder].each { |d| FileUtils.rm_rf d if Dir.exists? d }
  end
  
  
  # LOCATIONS
  
  shanghai = Location.find_by_name 'Shanghai'
  guangzhou = Location.find_by_name 'Guangzhou'
  wuhan = Location.find_by_name 'Wuhan'
  beijing = Location.find_by_name 'Beijing'
  tianjin = Location.find_by_name 'Tianjin'
  shenzhen = Location.find_by_name 'Shenzhen'
  nanjing = Location.find_by_name 'Nanjing'
  
  
  # SUBJECTS
  
  mathematics = Subject.find_by_name 'Mathematics'
  natural_sciences = Subject.find_by_name 'Natural Sciences'
  geography = Subject.find_by_name 'Geography'
  history = Subject.find_by_name 'History'
  visive_arts = Subject.find_by_name 'Visive Arts'
  music = Subject.find_by_name 'Music'
  physical_education = Subject.find_by_name 'Phisycal Education'
  computer_science = Subject.find_by_name 'Computer Science'
  languages = Subject.find_by_name 'Languages'
  literature = Subject.find_by_name 'Literature'
  chemistry = Subject.find_by_name 'Chemistry'
  
  
  # SCHOOL LEVELS
  
  primary_school = SchoolLevel.find_by_name 'Primary School'
  secondary_school = SchoolLevel.find_by_name 'Secondary School'
  undergraduate = SchoolLevel.find_by_name 'Undergraduate'
  
  
  # USERS
  
  admin = User.find_by_email CONFIG['admin_email']
  toostrong = User.create_user 'toostrong@morganspa.com', 'Oscar', 'Pettinari', 'ITC BrokenTower', secondary_school.id, shenzhen.id, [mathematics.id, natural_sciences.id]
  fupete = User.create_user 'fupete@morganspa.com', 'Massimo', 'Decimomeridio', 'ISS Pro', undergraduate.id, shanghai.id, [natural_sciences.id, computer_science.id, chemistry.id]
  jeg = User.create_user 'jeg@morganspa.com', 'Hiroshi', 'Sheba', 'ISA Carlocracco', secondary_school.id, wuhan.id, [literature.id, computer_science.id, geography.id]
  holly = User.create_user 'holly@morganspa.com', 'Oliver', 'Hutton', 'ITC Pocotopocoto', primary_school.id, beijing.id, [mathematics.id, visive_arts.id, music.id]
  benji = User.create_user 'benji@morganspa.com', 'Benji', 'Price', 'ITC Pocotopocoto', primary_school.id, tianjin.id, [mathematics.id, visive_arts.id, music.id, literature.id]
  retlaw = User.create_user 'retlaw@morganspa.com', 'Retlaw', 'Ofracs', 'ISA Amor III', undergraduate.id, shenzhen.id, [mathematics.id, visive_arts.id, music.id, literature.id, natural_sciences.id, geography.id, chemistry.id]
  
  
  # IMAGES
  
  image1 = Image.new
  image1.title = 'A couple of donkeys'
  image1.description = 'A nice picture. Two donkeys smiling!'
  image1.tags = 'animals, smile, teeth, nature, science'
  image1.media = File.open(Rails.root.join('db/seeds/images/asino.jpg'))
  image1.user_id = holly.id
  image1.save!
  image1.is_public = true
  image1.save!
  
  image2 = Image.new
  image2.title = 'Futuristic architecture'
  image2.description = 'Between the end of the twentieth century and early twenty-first century, in the city of Valencia (Spain), several architectural and urban projects took place. The most impressive is the City of Arts and Sciences, a new neighborhood in the southwest of the center designed by the Valencian architect Santiago Calatrava.'
  image2.tags = 'future, architecture, art, design, spain, valencia, geography'
  image2.media =  File.open(Rails.root.join('db/seeds/images/architettura.jpg'))
  image2.user_id = toostrong.id
  image2.save!
  image2.is_public = true
  image2.save!
  
  image3 = Image.new
  image3.title = 'Birds'
  image3.description = 'Sea gulls are birds of medium size: a small sea gull measures around 30 centimeters (for a weight of 120 grams), while a big one can reah 75 centimeters (for 200 grams kilos). The beak is long and strong, and the feet are webbed and fit to swim. The wings are usually white, gray or black, but sometimes they can be also brown. Depending on the species, the birds take two to four years before reaching the adult age.'
  image3.tags = 'animals, birds, fly, sea, sky, new york, geography'
  image3.media = File.open(Rails.root.join('db/seeds/images/uccelli.jpg'))
  image3.user_id = benj.id
  image3.save!
  image3.is_public = true
  image3.save!
  
  image4 = Image.new
  image4.title = 'Traffic'
  image4.description = 'A picture from New York City. The metropolitan area of ​​New York is located at the intersection of three states (New York, New Jersey and Connecticut). The entire urban agglomeration has 18.223.567 inhabitants, while the metropolitan population is 23.019.036, which make it the third most populous urban area in the world and the first in the American continent (in competition with Mexico City and Sao Paulo, Brazil).'
  image4.tags = 'city, traffic, urban, new york, geography'
  image4.media = File.open(Rails.root.join('db/seeds/images/city.jpg'))
  image4.user_id = benj.id
  image4.save!
  image4.is_public = true
  image4.save!
  
  image5 = Image.new
  image5.title = 'Iguana'
  image5.description = 'A beautiful picture of an iguana. Iguanas are very similar to lizards, but bigger and slower. In the adult age they grow a characteristic crest on their back, much more evident in males than in females. In the male the head has a triangular shape, sharper than in the female.'
  image5.tags = 'science, animals, nature, reptile, geography, iguana'
  image5.media = File.open(Rails.root.join('db/seeds/images/rettile.jpg'))
  image5.user_id = fupete.id
  image5.save!
  image5.is_public = true
  image5.save!
  
  image6 = Image.new
  image6.title = 'Wind'
  image6.description = 'Wind power is the energy obtained from the wind or the product of the conversion of kinetic energy, obtained from drafts, other forms of energy (electrical or mechanical). Today it is mostly converted into electricity by a wind farm, while in the past, wind energy was immediately used on site as motive power for industrial and pre-industrial.
  image6.tags = science, energy, wind, sky, geography, nature
  image6.media = File.open(Rails.root.join('db/seeds/images/energia_del_vento.jpg'))
  image6.user_id = toostrong.id
  image6.save!
  image6.is_public = true
  image6.save!
  
  image7 = Image.new
  image7.title = Love for art
  image7.description = Chuck Close (Snohomish County, July 5, 1940) is an American painter and photographer. He achieved world fame as a painter through his hyper-realistic paintings of large dimensions. Despite the collapse of the vertebral artery in 1988 has left severely paralyzed, he continued to paint and produce works sought after by museums and collectors.
  image7.tags = art, museum, love, new york, creative, idea, mom, close
  image7.media = File.open(Rails.root.join('db/seeds/images/coppia.jpg'))
  image7.user_id = benj.id
  image7.save!
  image7.is_public = true
  image7.save!
  
  image8 = Image.new
  image8.title = Compact disk
  image8.description = The compact disc is composed of a disk of transparent polycarbonate, generally 12 centimeters in diameter, coupled at the top to a thin sheet of metal material on which, in the lower part stores information as a succession of "holes" and "lands" (in English "pits" and "lands") subsequently read by means of a laser (for this reason are also called optical discs).
  image8.tags = science, tech, optical, disc, compact disc, music, light, laser
  image8.media = File.open(Rails.root.join('db/seeds/images/cd.jpg'))
  image8.user_id = toostrong.id
  image8.save!
  image8.is_public = true
  image8.save!
  
  image9 = Image.new
  image9.title = Flowers
  image9.description = The flower comes from the differentiation of the apex of a branch whose leaves have almost always lost photosynthetic capacity. This differentiation that flower induction or induction antogena, occurs when the apex is still microscopic in size within the gem, under the stimulus of hormonal and environmental factors. The flower induction precedes the real flowering, depending on the species, from a few weeks to about one year.
  image9.tags = science, nature, color, flower, air, smell
  image9.media = File.open(Rails.root.join('db/seeds/images/fiori.jpg'))
  image9.user_id = fupete.id
  image9.save!
  image9.is_public = true
  image9.save!
  
  image10 = Image.new
  image10.title = Battery
  image10.description = The stack itself is not rechargeable and in this connection is also called a primary battery, to distinguish it from the rechargeable battery that takes the name instead of secondary battery or accumulator of electric charge. A set of more batteries arranged in series instead takes the name of the battery pack.
  image10.tags = energy, science, battery, electric
  image10.media = File.open(Rails.root.join('db/seeds/images/batterie.jpg'))
  image10.user_id = jeg.id
  image10.save!
  image10.is_public = true
  image10.save!
  
  image11 = Image.new
  image11.title = Pantheon
  image11.description = Tthe Pantheon ("Temple of all the gods") is a building of ancient Rome, built as a temple dedicated to the gods of Olympus. The inhabitants of Rome call it a friendly Rotonna or Ritonna, from which the name of the square. Was made to reconstruct the Emperor Hadrian between 118 and 128 AD, after the fire, 80 and 110 AD had damaged the previous construction of the Augustan age.
  image11.tags = rome, history, sky, roman, temple, god, ancient, art
  image11.media = File.open(Rails.root.join('db/seeds/images/cielo_roma.jpg'))
  image11.user_id = benj.id
  image11.save!
  image11.is_public = true
  image11.save!
  
  image12 = Image.new
  image12.title = Lawn
  image12.description = The ear is a simple inflorescence composed of numerous flowers sessile (no stalk) placed on a central spine.
  image12.tags = lawn, nature, sky, ear
  image12.media = File.open(Rails.root.join('db/seeds/images/natura.jpg'))
  image12.user_id = retlaw.id
  image12.save!
  image12.is_public = true
  image12.save!
  
  image13 = Image.new
  image13.title = The history of the wood
  image13.description = The wood of the trees is an energy source (direct combustion and charcoal) and construction material (whole house, beams, ships, furniture, everyday objects and art). Always from the trees, often grown for the purpose, is derived cellulose for the production of paper.
  image13.tags = wood, nature, paper, art, science, geography
  image13.media = File.open(Rails.root.join('db/seeds/images/ossigeno.jpg'))
  image13.user_id = fupete.id
  image13.save!
  image13.is_public = true
  image13.save!
  
  image14 = Image.new
  image14.title = Rome
  image14.description = A beautiful photo of one of the most beautiful cities in the world. In the picture you can see the dome of St Peter, the cradle of Christian civilization.
  image14.tags = rome, river, bridge, geography, sky, water, history, art
  image14.media = File.open(Rails.root.join('db/seeds/images/roma.jpg'))
  image14.user_id = jeg.id
  image14.save!
  image14.is_public = true
  image14.save!
  
  image15 = Image.new
  image15.title = The life of bees
  image15.description = The bee is an insect since ancient times symbolic myths, legends and religions, certainly already known from prehistoric times to its usefulness.
  image15.tags = nature, bee, flower, color, nature, animal, honey
  image15.media = File.open(Rails.root.join('db/seeds/images/ape.jpg'))
  image15.user_id = holly.id
  image15.save!
  image15.is_public = true
  image15.save!
  
  image16 = Image.new
  image16.title = A perfect machine
  image16.description = Living beings who most successfully are able to master the ability to fly are insects, birds and bats.
  image16.tags = nature, fly, sky, nature, animal, air, science
  image16.media = File.open(Rails.root.join('db/seeds/images/uccello.jpg'))
  image16.user_id = holly.id
  image16.save!
  image16.is_public = true
  image16.save!
  
  image17 = Image.new
  image17.title = natural gas
  image17.description = Natural gas is a gas produced by the anaerobic decomposition of organic material. In nature it is commonly found in the fossil state, along with the oil, coal or natural gas deposits only. It is, however, also produced by the decomposition processes current in the swamps in landfills, during digestion in animals and other natural processes.
  image17.tags = nature, gas, fire, nature, energie, air, science
  image17.media = File.open(Rails.root.join('db/seeds/images/fiamma.jpg'))
  image17.user_id = toostrong.id
  image17.save!
  image17.is_public = true
  image17.save!
  
  image18 = Image.new
  image18.title = Family
  image18.description = A mother helps her child to study using the internet.
  image18.tags = school, computer, history, science, maths, student, mother
  image18.media = File.open(Rails.root.join('db/seeds/images/mamma_e_figlia.jpg'))
  image18.user_id = toostrong.id
  image18.save!
  image18.is_public = true
  image18.save!
  
  image19 = Image.new
  image19.title = Harlem
  image19.description = Harlem is a neighborhood of Manhattan in New York City, known to be a major commercial and cultural center of African-Americans. Although the name is generally attributed to the whole region uptown Manhattan, Harlem has traditionally been limited by Road 155 (155th Street) to the north, and the Harlem River to the east.
  image19.tags = geography, new york,woman, city, colored, walk
  image19.media = File.open(Rails.root.join('db/seeds/images/colored.jpg'))
  image19.user_id = retlaw.id
  image19.save!
  image19.is_public = true
  image19.save!
  
  image20 = Image.new
  image20.title = Modern architecture
  image20.description = "The Hemisfèric is one of the buildings that are part of the Ciutat de les Arts i les Ciències of Valencia.
  The building was designed by Santiago Calatrava and was the first of the Ciutat de les Arts i les Ciències to be open to the public April 16, 1998. It was designed in the shape of the eye and inside there is a large room with a concave screen of 900 square meters and 24 meters in diameter, which are de l'Hemisfèric the IMAX theater largest in Spain."
  image20.tags = geography, valencia, modern, water, creative
  image20.media = File.open(Rails.root.join('db/seeds/images/architettura_acqua.jpg'))
  image20.user_id = benj.id
  image20.save!
  image20.is_public = true
  image20.save!
  
  image21 = Image.new
  image21.title = Peacock
  image21.description = The plumage of these birds is one of the most representative cases of sexual dimorphism: see the head and neck covered with feathers of the male electric blue metallic reflections. The area around the eye is naked, with white leather interrupted by a black stripe.
  image21.tags = animal, peacock, color, science, bird
  image21.media = File.open(Rails.root.join('db/seeds/images/pavone.jpg'))
  image21.user_id = toostrong.id
  image21.save!
  image21.is_public = true
  image21.save!
  
  image22 = Image.new
  image22.title = People
  image22.description = A group of interested visitors walking in the halls of a museum of modern art.
  image22.tags = art, people, museum, new york, culture
  image22.media = File.open(Rails.root.join('db/seeds/images/museo.jpg'))
  image22.user_id = benj.id
  image22.save!
  image22.is_public = true
  image22.save!
  
  image23 = Image.new
  image23.title = Money
  image23.description = The U.S. dollar is the official currency of the United States of America. It is also widely used as a reserve currency outside the United States. The commonly used symbol for the U.S. dollar is '$'. The ISO 4217 currency code is USD.
  image23.tags = USA, money, geography, new york, culture
  image23.media = File.open(Rails.root.join('db/seeds/images/dollari.jpg'))
  image23.user_id = benj.id
  image23.save!
  image23.is_public = true
  image23.save!
  
  image24 = Image.new
  image24.title = Airport
  image24.description = The London Heathrow Airport is the main airport in London. It is the busiest airport in the EU by passenger numbers (and third in the world after the Atlanta and Beijing) and the third, in the EU, by number of flight movements preceded by Paris-Charles de Gaulle and Frankfurt.
  image24.tags = airport, london, city, departure, fly, geography
  image24.media = File.open(Rails.root.join('db/seeds/images/london.jpg'))
  image24.user_id = jeg.id
  image24.save!
  image24.is_public = true
  image24.save!
  
  image25 = Image.new
  image25.title = Underground
  image25.description = The London Underground (London Underground in English) is the oldest subway system in the world, the largest in Europe and the second largest boasting Some 460 km of line independent of which 45% are underground tunnels, exceeded only by 467.5 km of the recent Shanghai plant.
  image25.tags = underground, london, city, train, people, geography
  image25.media = File.open(Rails.root.join('db/seeds/images/underground.jpg'))
  image25.user_id = benj.id
  image25.save!
  image25.is_public = true
  image25.save!
  
  image26 = Image.new
  image26.title = Plane
  image26.description = The Boeing 737 is the most widely used airliner for routes medium-short: with 7,634 aircraft delivered and 2,134 other passenger aircraft to be delivered is the most produced in the history of aviation. The project is Boeing that produces since 1967. It is so widespread that in 2006 it was estimated there were about 1,250 aircraft of this type in flight simultaneously around the world, while, on average, it took off or landed one every five seconds.
  image26.tags = plane, london, city, fly, people, geography
  image26.media = File.open(Rails.root.join('db/seeds/images/plane.jpg'))
  image26.user_id = fupete.id
  image26.save!
  image26.is_public = true
  image26.save!
  
  image27 = Image.new
  image27.title = Lady Liberty
  image27.description = Liberty Enlightening the World (lit. Liberty enlightening the world; fr. Éclairant La liberté le monde), known more commonly as the Statue of Liberty is a monument symbol of New York and the entire United States of America.
  image27.tags = art, new york, city, people, geography
  image27.media = File.open(Rails.root.join('db/seeds/images/liberty.jpg'))
  image27.user_id = benj.id
  image27.save!
  image27.is_public = true
  image27.save!
  
  image28 = Image.new
  image28.title = A young woman
  image28.description = Portrait of a Muslim woman
  image28.tags = woman, new york, city, people, geography
  image28.media = File.open(Rails.root.join('db/seeds/images/donna.jpg'))
  image28.user_id = benj.id
  image28.save!
  image28.is_public = true
  image28.save!
  
  image29 = Image.new
  image29.title = The Sphinx
  image29.description = The sphinx is a mythological figure as belonging to Greek mythology as the Egyptian mythology. Is portrayed as a monster with the body of a lion (or dog) and the human head (androsfinge), hawk (ieracosfinge) or goat (criosfinge), looking magnificent and imposing.
  image29.tags = history, egypt, city, art, geography
  image29.media = File.open(Rails.root.join('db/seeds/images/statua.jpg'))
  image29.user_id = fupete.id
  image29.save!
  image29.is_public = true
  image29.save!
  
  image30 = Image.new
  image30.title = A long bridge
  image30.description = A bridge is a structure used to overcome a natural or artificial barriers, which puts the continuity of a line of communication.
  image30.tags = geography, city, new york, art, geography
  image30.media = File.open(Rails.root.join('db/seeds/images/ponte.jpg'))
  image30.user_id = benj.id
  image30.save!
  image30.is_public = true
  image30.save!
  
  image31 = Image.new
  image31.title = DNA
  image31.description = From the chemical point of view, DNA is an organic polymer made ​​up of monomers called nucleotides (deoxyribonucleotides). All nucleotides consist of three basic components: a phosphate group, the deoxyribose (pentose sugar) and a nitrogenous base which binds to the deoxyribose with N-glycosidic bond.
  image31.tags = dan, science, chemical, organic, polymer, basic
  image31.media = File.open(Rails.root.join('db/seeds/images/dna.jpg'))
  image31.user_id = fupete.id
  image31.save!
  image31.is_public = true
  image31.save!
  
  image32 = Image.new
  image32.title = Solar system
  image32.description = The solar system is the planetary system consists of a variety of celestial bodies kept in orbit by the gravitational force of the Sun, also belongs to the Earth. It consists of eight planets, in their natural satellites, five dwarf planets and billions of small bodies.
  image32.tags = space, science, chemical, planet, sky, history
  image32.media = File.open(Rails.root.join('db/seeds/images/space.jpg'))
  image32.user_id = jeg.id
  image32.save!
  image32.is_public = true
  image32.save!


































  slides = {1 => ['image1', 'image2', 'image3', 'image4', 'audio', 'video1', 'video2', 'text', 'title'], 2 => ['text', 'video1'], 3 => ['video2', 'video2'], 4 => ['image3', 'audio'], 5 => [], 6 => ['audio'], 7 => ['text', 'text'], 8 => [], 9 => ['video1', 'title'], 10 => ['image1', 'image3'], 11 => ['text', 'image2', 'image2', 'text'], 12 => ['video2', 'audio', 'title'], 13 => [], 14 => [], 15 => [], 16 => [], 17 => [], 18 => [], 19 => [], 20 => [], 21 => [], 22 => [], 23 => [], 24 => [], 25 => [], 26 => [], 27 => [], 28 => [], 29 => [], 30 => [], 31 => [], 32 => [], 33 => ['image1', 'image2', 'image3', 'image4', 'audio', 'video1', 'video2', 'text', 'title', 'image1', 'image2', 'image3', 'image4', 'audio', 'video1', 'video2', 'text', 'title', 'image1', 'image2', 'image3', 'image4', 'audio', 'video1', 'video2', 'text', 'title', 'image1', 'image2', 'image3', 'image4', 'audio', 'video1', 'video2', 'text', 'title', 'image1', 'image2', 'image3', 'image4', 'audio', 'video1', 'video2', 'text', 'title'], 34 => [], 35 => [], 36 => [], 37 => []}
  
  Lesson.all.each do |l|
    slides[l.id].each do |kind|
      l.add_slide kind, 2
    end
  end
  
  notifics = []
  notifics << "Que tipo de homosexual sufre mucho? Un cristiano con tendencias homosexuales o un homosexual no cristiano?"
  notifics << "I laziali staranno già avendo la loro prima erezione mattutina, ma possono stare tranquilli. Il loro incubo resta a Roma. Pronto a purgarli ancora!!"
  notifics << "speriamo sia giunta l'ora di levarcelo di torno, ha un pò stancato....che vada a fare il turista a Mosca adesso. "
  notifics << "Corriere dello sport, la tifoseria romanista ha capito qual è l'andazzo (il fatto che il direttore sia ex-Tuttosport vale più di mille parole) e non abbocca più a questi casi creati ad hoc dopo che la Roma vince una partita. Restate da soli con le vostre \"notizie\""
  notifics << "La roma dovrebbe stare sul fondo della classifica ed invece grazie alle partite truccate e alle vittorie a tavolino eccola li nel gruppo di testa. Il calcio in Italia sta diventando una cosa ridicola!"
  notifics << "Che tristezza...Preziosi ingrato! De Canio allenatore capace e molto preparato (ma poco sponsorizzato....) "
  notifics << "E ci vogliamo meravigliare ancora? Si sa che Preziosi é della pasta di Zamparini... Per cui alla fine 1+1 ha sempre fatto due. Per la serie \"Il gatto e la volpe\""
  notifics << "Voi parlate dei bagni... C'e' un video su youtube che dimostra che quelli non sono i bagni del settore ospiti. Che squallido tentativo di spostare l'attenzione sullo schifo che fanno gli juventini e il loro giornalista in primis... Dopo Roma, Torino. Ho scoperto sabato di avere un vicino juventino, e ' aperta la caccia..."
  notifics << "Io Puzzo ... di lava, di tufo, di ortobotanico, di golfo e di isole, di mare e pure di cozze, di ragu' e di dolci fatti in casa, di pizza, di almeno tre castelli, di solfatara, di canzoni cantate a squarcia gola nel traffico,"
  notifics << "non siamo una nazione perchè non è nata su un concetto di unità ma su un concetto di dualità...ed ancora oggi così viene gestita"
  notifics << "Caro Mazzarri questo non succedera' mai perchè altrimenti non avremmo perso la partita di Pechino.Ci sara' sempre qualcuno che fara' l'occhiolino alla Juve.Saluti"
  notifics << "Questo giornalista merita il premio 'ciuccio juventino dell'anno'. facciamogli i complimenti, ha vinto una bella concorrenza, ma se lo merita proprio!"
  notifics << "vogliamo 1 turno di squalifica per i tifosi.. A PORTE CHIUSE!!!!"
  notifics << "ormai il razzismo è così radicato in voi che non ci fate manco più caso ...ma chi se ne frega del risultato della partita"
  notifics << "vergognati di vivere razzista"
  notifics << "Alla fine, ciò che conta questo è di essere felici e sbocciato, no? In un mondo o i riferimenti che siano familiari, sociali, etici﻿ esplodono, come non volete essere perturbato?"
  notifics << "Luca﻿ è ancora gay...probabilmente represso..."
  notifics << "dovrebbero cambiare il image.title in: Luca è bisex -.-'''' Inoltre Freud sosteneva che l'uomo nascesse bisessuale!!!! a Povia studia un po' prima di scrivere﻿ minchiate!!!!"
  notifics << "guarda ke non parla di se stesso ma parla di un ragazzo che si kiama davvero luca e ke ha avuto davvero questi problemi﻿"
  notifics << "vabbe' e' una storia, Povia parla evidentemente﻿ della sua esperienza , non e' contro l'omossesualita'.."
  notifics << "I do not understand italian language, but I know the history of this his song. You are a brave man for writing it, dude! Keep going with that! Congratulations!!!﻿"
  notifics << "Comunque oltre al testo che fa schifo, anche il video è terribile e poco professionale. Questa canzone è una delle solite figuraccie italiane nei confronti del mondo intero."
  notifics << "Un po' come quando la Mussolini dice \"meglio fascista che frocio\" in tv e Berlusconi dice che \"è meglio essere appassionati delle belle ragazze che gay\""
  notifics << "é terribile questo video ed offensivo nei confronti di tutte le persone﻿ omosessuali"
  notifics << 'Ma De Rossi a Roma che cosa ci sta a fare quando le cose vanno male è sempre colpa sua'
  notifics << "a daniè t'avevo detto che dovevi annà al city"
  notifics << "共產黨通過「鎮壓反革命」嘅運動，對私有經濟同財產進行城市工商業"
  notifics << "Prova il brivido del Poker online Gioca su StarCasinò. Bonus 1.000€!"
  notifics << "Io i napoletani li conosco benissimo senza la violenza sono gente morta"
  notifics << "CMQ SE DOVESSERO ESSERE STANCHI CI PENSA IL DR.FAJARDO A TIRARLI SU."
  notifics << "La unica cosa certa che c'e' e' che gli juventini e i napoletani sono riusciti a fare odiare la nazionale"
  notifics << "la lazio e' l'unica squadra forte che abbiamo in italia... juventus e napoli si credono real madrid e barcellona "
  notifics << "stai dicendo fregnacce.....taci e meglio,e non condannare prima del tempo."
  notifics << "Uhm e chi sarebbero i giocatori della juve che non han giocato???"
  notifics << "se la pensi cosi è meglio che cambi sport!!!!"
  notifics << "Un número apreciable de hombres y mujeres presentan tendencias homosexuales instintivas"
  notifics << "La squadra piu ladra del pianeta rubera' l'ennesimo scudetto ,,,cavolo che soddisfazione !!! "
  notifics << "scommettiamo che la prossima degli azzurri non gioca neanche Pirlo?"
  notifics << "Il fatto che per eliminare l'italia quella partita dovesse finire non solo in un pareggio, ma anche esattamente 2-2, le è sfuggito per caso, mica perchè avrebbe screditato le sue teorie, giusto?"
  notifics << "Irlanda travolta 6-1. Trap: «Non mi dimetto»"
  notifics << "Mou: «Balotelli? Potrei scriverci un romanzo»"
  notifics << "Roma e lazio nel punto di vista simbolico storico la roma rappresenta il popolo romano e la Lazio I LEGIONALI!! grazie ai LEGIONALI Roma è diventata VASTA E POTENTE e i LEGIONALU ERANO ANCHE ESSI ROMANI!!!! Dunque il derby romano stesso rappresenta simbolicamente la potenza DI ROMA sia dal popplo romano e i LEGIONALI!!! Sabatini non è romano e non conosce storia e leggenda del derby ovvero E IGNORANTE!!!!"
  notifics << "Felix, 36 km di volo e muro del suono rotto, ma mai spettacolare come il volo di Pessotto"
  
  notifics.each do |n|
    Notification.send_to admin.id, n
  end
  
  Notification.limit(32).each do |n|
    n.has_been_seen
  end
  
  Lesson.all.each do |l|
    raise Exception if !l.publish
  end
  
  cont = 0
  tim = Time.zone.now
  MediaElement.all.each do |l|
    if ![2, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40].include?(l.id)
      l.is_public = true
      l.publication_date = tim - cont
      l.save
      cont += 1
    end
  end
  
  Lesson.all.each do |l|
    if [2, 3].include? l.subject_id
      raise Exception if !admin.bookmark('Lesson', l.id)
    end
    if l.subject_id == 3
      raise Exception if !l.copy(admin.id)
    end
  end
  
  MediaElement.all.each do |me|
    if me.id % 3 == 1
      admin.bookmark 'MediaElement', me.id
    end
  end
  
  paparesta.like(1)
  paparesta.like(10)
  paparesta.like(14)
  paparesta.like(16)
  paparesta.like(34)
  paparesta.like(25)
  paparesta.like(28)
  paparesta.like(19)
  paparesta.like(21)
  paparesta.like(3)
  paparesta.like(4)
  paparesta.like(5)
  paparesta.like(9)
  banti.like(20)
  banti.like(22)
  banti.like(23)
  banti.like(24)
  banti.like(25)
  banti.like(26)
  valeri.like(30)
  valeri.like(31)
  valeri.like(32)
  valeri.like(33)
  valeri.like(34)
  valeri.like(35)
  giannoccaro.like(4)
  giannoccaro.like(6)
  giannoccaro.like(17)
  giannoccaro.like(29)
  giannoccaro.like(36)
  giannoccaro.like(34)
  giannoccaro.like(33)
  giannoccaro.like(29)
  giannoccaro.like(18)
  giannoccaro.like(16)
  giannoccaro.like(11)
  trefoloni.like(10)
  trefoloni.like(25)
  trefoloni.like(15)
  trefoloni.like(5)
  trefoloni.like(3)
  trefoloni.like(2)
  trefoloni.like(1)
  trefoloni.like(34)
  trefoloni.like(37)
  de_sanctis.like(6)
  de_sanctis.like(16)
  de_sanctis.like(26)
  de_sanctis.like(36)
  de_sanctis.like(33)
  de_sanctis.like(11)
  de_sanctis.like(22)
  mazzini.like(14)
  mazzini.like(13)
  mazzini.like(12)
  mazzini.like(11)
  mazzini.like(7)
  mazzini.like(17)
  carraro.like(18)
  carraro.like(28)
  carraro.like(8)
  carraro.like(37)
  carraro.like(21)
  carraro.like(22)
  carraro.like(23)
  carraro.like(24)
  pairetto.like(1)
  pairetto.like(2)
  pairetto.like(3)
  pairetto.like(6)
  pairetto.like(7)
  pairetto.like(8)
  pairetto.like(9)
  pairetto.like(12)
  bergamo.like(16)
  bergamo.like(21)
  bergamo.like(22)
  bergamo.like(23)
  bergamo.like(25)
  celi.like(5)
  celi.like(6)
  celi.like(7)
  celi.like(11)
  celi.like(14)
  celi.like(15)
  celi.like(17)
  collina.like(4)
  collina.like(21)
  collina.like(20)
  collina.like(19)
  collina.like(18)
  collina.like(17)
  collina.like(36)
  lotito.like(31)
  lotito.like(32)
  lotito.like(33)
  lotito.like(13)
  lotito.like(16)
  lotito.like(17)
  lotito.like(18)
  della_valle.like(2)
  della_valle.like(4)
  della_valle.like(5)
  della_valle.like(8)
  della_valle.like(10)
  della_valle.like(20)
  della_valle.like(22)
  della_valle.like(24)
  moggi.like(1)
  moggi.like(11)
  moggi.like(21)
  moggi.like(31)
  galliani.like(10)
  galliani.like(18)
  galliani.like(19)
  galliani.like(20)
  galliani.like(21)
  galliani.like(22)
  galliani.like(23)
  galliani.like(24)
  galliani.like(34)
  galliani.like(35)
  
  Lesson.last.modify
  raise Exception if !Lesson.last.copy(admin.id)
  Lesson.last.modify
  
  admin.like(Bookmark.where(:user_id => admin.id, :bookmarkable_type => 'Lesson').first.id)
  
  Lesson.record_timestamps = false
  prima_data = '2012-10-10 12:00:00'.to_time
  cont = 0
  Lesson.all.each do |l|
    l.created_at = prima_data + cont
    l.save
    cont += 1
  end
  Lesson.record_timestamps = true
  
  MediaElement.record_timestamps = false
  prima_data = '2012-10-10 12:00:00'.to_time
  cont = 0
  MediaElement.all.each do |l|
    l.created_at = prima_data + cont
    l.save
    cont += 1
  end
  MediaElement.record_timestamps = true
  
end
