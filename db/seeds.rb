# encoding: UTF-8

location1 = Location.create :description => 'Nanjing' # qui va sostituito dalle città vere, prese da qualche file esterno
location2 = Location.create :description => 'Shanghai' # qui va sostituito dalle città vere, prese da qualche file esterno
location3 = Location.create :description => 'Beijing' # qui va sostituito dalle città vere, prese da qualche file esterno

school_level1 = SchoolLevel.create :description => 'Elementare' # idem
school_level2 = SchoolLevel.create :description => 'Medie' # idem
school_level3 = SchoolLevel.create :description => 'Liceo' # idem


subject1 = Subject.create :description => 'Curiosità' # idem
subject2 = Subject.create :description => 'Animali' # idem
subject3 = Subject.create :description => 'Scienze' # idem


User.create_user CONFIG['admin_email'], 'DESY', 'Admin User', 'School', school_level1.id, location1.id, [subject1.id, subject2.id, subject3.id]

if Rails.env.development?
  
  u = User.find_by_email(CONFIG['admin_email'])
  u.create_lesson('History of China: Shang Dynasty', 'Paolo Negro (Arzignano, 16 aprile 1972) è un allenatore di calcio ed ex calciatore italiano. Dal 2012 è alla guida dello Zagarolo.', 1)
  u.create_lesson('The birth of the great empire', 'Cresce calcisticamente nel Brescia dove viene trasformato da attaccante in fluidificante[2] e nel 1990 passa al Bologna, con cui debutta in serie A il 28 ottobre 1990 in Genoa-Bologna 0-0 ed esordisce nelle coppe europee in Zagłębie Lubin-Bologna 0-1', 2)
  u.create_lesson('Chain Reactions', "Per dieci stagioni consecutive segna almeno una rete in campionato; in particolare nell'annata 1994-1995, la prima sotto la guida del tecnico boemo Zdenek Zeman in cui la Lazio conclude il campionato con il migliore attacco a quota 69,[4] Negro segna 4 reti", 3)
  u.create_lesson('Cronologia presenze e reti in Nazionale', 'Paolo Negro (Arzignano, Italia, 16 de abril de 1972), fue un futbolista italiano, que se desempeñó como defensa y lateral en cualquier banda. Fue internacional con la selección de fútbol de Italia y disputó una Eurocopa', 1)
  u.create_lesson('Negro Gol', 'Neqro A Seriyasında 1990-cı il oktyabrın 28-də, 18 yaşı olarkən debüt edib. O, Boloniya da çıxış edirdi. Rossoblu ilə yanaşı, Paolo Breşiya da da təcrübə yığıb. Oradan isə 1993-cü ildə Romanı fəth etməyə gedib. Müdafiəçini Latsio', 2)
  u.create_lesson('Pour les articles homonymes, voir Negro.', "Paolo Negro est un ancien footballeur italien, né le 16 avril 1972 à Arzignano. Il évoluait au poste de défenseur central ou défenseur latéral droit. Il a reçu 8 sélections en équipe d'Italie et a évolué pendant douze saisons à la Lazio, où il s'est construit un respectable palmarès", 3)
  u.create_lesson('Io non sono razzista, siete voi che siete negri.', "La parola negro definisce gli appartenenti a una razza pseudo-animale in parte simile all'uomo bianco. Le differenze da quest'ultimo sono note: i negri hanno notoriamente tre gambe. Così spiega la legge dello sport che vuole che tutti i più grandi velocisti appartengano a suddetta razza", 1)
  u.create_lesson('Pescato il calamaro più grande del mondo', "Dieci metri di lunghezza per 450 chili di peso. Sono le dimensione del calamaro gigante pescato nei giorni scorsi al largo della Nuova Zelanda. Si tratta probabilmente dell'esemplare più grande mai pescato. ", 2)
  u.create_lesson('Laberinto', "No habrá nunca una puerta. Estás adentro - y el alcázar abarca el universo - y no tiene ni anverso ni reverso - ni externo muro ni secreto centro.", 3)
  u.create_lesson('Che significa vi ho purgato ancora? - Yahoo! Answers', "in which he scored during the final minutes of the game and celebrated by flashing a T-shirt under his jersey, which read 'Vi ho purgato ancora' (\"I've purged you guys again\"), in reference to events at the previous derby against Lazio", 1)
  u.create_lesson('Chez Fifi', "\"Breakfast\", which was included, was supposed to start at 6:30 AM, which was fine with us because we had an early flight and did not want to spend an additional minute in this place. At 6:30 AM, Madam Fifi was sitting at the table--but no breakfast. After we asked her \"where's breakfast?\"", 2)
  u.create_lesson('跟隨羅馬', "托迪（意大利文：Francesco Totti，1976年9月27號—）係意大利足球員，打前鋒，現時效力意大利甲組足球聯賽球隊羅馬。托迪喺羅馬出世，佢早響16歲嗰陣已經代表球會上陣意甲賽事。佢好受羅馬重用，廿歲嗰陣就贏咗意甲最佳新人獎。2001年佢跟隨羅馬贏得意甲聯賽冠軍，之前又贏埋意大利聯賽最佳年青球員。由於佢生得靚仔，只係二十歲就係意大利女人心目中嘅最佳對象，地位等同英國嘅碧咸。", 3)
  
end

puts "Created #{Subject.count} subjects, #{Location.count} locations, #{SchoolLevel.count} school_levels, #{User.count} users, #{UsersSubject.count} users_subjects, #{Lesson.count} lessons"
