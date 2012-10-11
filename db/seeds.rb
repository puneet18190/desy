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
  
  admin = User.find_by_email CONFIG['admin_email']
  
  paparesta = User.create_user 'paparesta@figc.it', 'Luca', 'Paparesta', 'School', school_level1.id, location1.id, [subject1.id, subject2.id, subject3.id]
  banti = User.create_user 'banti@figc.it', 'Giorgio', 'Banti', 'School', school_level1.id, location1.id, [subject1.id, subject2.id, subject3.id]
  valeri = User.create_user 'valeri@figc.it', 'Marco', 'Valeri', 'School', school_level1.id, location1.id, [subject1.id, subject2.id, subject3.id]
  giannoccaro = User.create_user 'giannoccaro@figc.it', 'Adolfo', 'Giannoccaro', 'School', school_level1.id, location1.id, [subject1.id, subject2.id, subject3.id]
  trefoloni = User.create_user 'trefoloni@figc.it', 'Umberto', 'Trefoloni', 'School', school_level1.id, location1.id, [subject1.id, subject2.id, subject3.id]
  de_sanctis = User.create_user 'de_sanctis@figc.it', 'Massimo', 'De Sanctis', 'School', school_level1.id, location1.id, [subject1.id, subject2.id, subject3.id]
  mazzini = User.create_user 'mazzini@figc.it', 'Luigi', 'Mazzini', 'School', school_level1.id, location1.id, [subject1.id, subject2.id, subject3.id]
  carraro = User.create_user 'carraro@figc.it', 'Franco', 'Carraro', 'School', school_level1.id, location1.id, [subject1.id, subject2.id, subject3.id]
  pairetto = User.create_user 'pairetto@figc.it', 'Fabio', 'Pairetto', 'School', school_level1.id, location1.id, [subject1.id, subject2.id, subject3.id]
  bergamo = User.create_user 'bergamo@figc.it', 'Ernesto', 'Bergamo', 'School', school_level1.id, location1.id, [subject1.id, subject2.id, subject3.id]
  celi = User.create_user 'celi@figc.it', 'Giangiorgio', 'Celi', 'School', school_level1.id, location1.id, [subject1.id, subject2.id, subject3.id]
  collina = User.create_user 'collina@figc.it', 'Pierluigi', 'Collina', 'School', school_level1.id, location1.id, [subject1.id, subject2.id, subject3.id]
  lotito = User.create_user 'lotito@figc.it', 'Claudio', 'Lotito', 'School', school_level1.id, location1.id, [subject1.id, subject2.id, subject3.id]
  della_valle = User.create_user 'della_valle@figc.it', 'Luca', 'Della Valle', 'School', school_level1.id, location1.id, [subject1.id, subject2.id, subject3.id]
  moggi = User.create_user 'moggi@figc.it', 'Luciano', 'Moggi', 'School', school_level1.id, location1.id, [subject1.id, subject2.id, subject3.id]
  galliani = User.create_user 'galliani@figc.it', 'Adriano', 'Galliani', 'School', school_level1.id, location1.id, [subject1.id, subject2.id, subject3.id]
  
  u = User.create_user 'assunzioni@pippo.it', 'Giorgio', 'Mastrota', 'School', school_level1.id, location1.id, [subject1.id, subject2.id, subject3.id]
  u.create_lesson('History of China: Shag Dynasty', 'Paolo Negro (Arzignano, 16 aprile 1972) è un allenatore di calcio ed ex calciatore italiano. Dal 2012 è alla guida dello Zagarolo.', 1)
  u.create_lesson('The birth of the great empire', 'Cresce calcisticamente nel Brescia dove viene trasformato da attaccante in fluidificante[2] e nel 1990 passa al Bologna, con cui debutta in serie A il 28 ottobre 1990 in Genoa-Bologna 0-0 ed esordisce nelle coppe europee in Zagłębie Lubin-Bologna 0-1', 2)
  u.create_lesson('Chain Reactions', "Per dieci stagioni consecutive segna almeno una rete in campionato; in particolare nell'annata 1994-1995, la prima sotto la guida del tecnico boemo Zdenek Zeman in cui la Lazio conclude il campionato con il migliore attacco, Negro segna 4 reti", 3)
  u.create_lesson('Cronologia presenze Nazionale', 'Paolo Negro (Arzignano, Italia, 16 de abril de 1972), fue un futbolista italiano, que se desempeñó como defensa y lateral en cualquier banda. Fue internacional con la selección de fútbol de Italia y disputó una Eurocopa', 1)
  u.create_lesson('Negro Gol', 'Neqro A Seriyasında 1990-cı il oktyabrın 28-də, 18 yaşı olarkən debüt edib. O, Boloniya da çıxış edirdi. Rossoblu ilə yanaşı, Paolo Breşiya da da təcrübə yığıb. Oradan isə 1993-cü ildə Romanı fəth etməyə gedib. Müdafiəçini Latsio', 2)
  u.create_lesson('Pour les articles homonymes, voir Negro.', "Paolo Negro est un ancien footballeur italien, né le 16 avril 1972 à Arzignano. Il évoluait au poste de défenseur central ou défenseur latéral droit. Il a reçu 8 sélections en équipe d'Italie et a évolué pendant douze saisons à la Lazio, où il s'est construit un respectable", 3)
  u.create_lesson('Voi siete negri.', "La parola negro definisce gli appartenenti a una razza pseudo-animale in parte simile all'uomo bianco. Le differenze da quest'ultimo sono note: i negri hanno notoriamente tre gambe.", 1)
  u.create_lesson('Pescato il calamaro più grande del mondo', "Dieci metri di lunghezza per 450 chili di peso. Sono le dimensione del calamaro gigante pescato nei giorni scorsi al largo della Nuova Zelanda. Si tratta probabilmente dell'esemplare più grande mai pescato. ", 2)
  u.create_lesson('Laberinto', "No habrá nunca una puerta. Estás adentro - y el alcázar abarca el universo - y no tiene ni anverso ni reverso - ni externo muro ni secreto centro.", 3)
  u.create_lesson('Che significa vi ho purgato ancora?', "in which he scored during the final minutes of the game and celebrated by flashing a T-shirt under his jersey, which read 'Vi ho purgato ancora' (\"I've purged you guys again\"), in reference to events at the previous derby against Lazio", 1)
  u.create_lesson('Chez Fifi', "\"Breakfast\", which was included, was supposed to start at 6:30 AM, which was fine with us because we had an early flight and did not want to spend an additional minute in this place. At 6:30 AM, Madam Fifi was sitting at the table. After we asked her \"where's breakfast?\"", 2)
  u.create_lesson('跟隨羅馬', "托迪（意大利文：Francesco Totti，1976年9月27號—）係意大利足球員，打前鋒，現時效力意大利甲組足球聯賽球隊羅馬。托迪喺羅馬出世，佢早響16歲嗰陣已經代表球會上陣意甲賽事。佢好受羅馬重用，廿歲嗰陣就贏咗意甲最佳新人獎。2001年佢跟隨羅馬贏得意甲聯賽冠軍，之前又贏埋意大利聯賽最佳年青球員。由於佢生得靚仔，只係二十歲就係意大利女人心目中嘅最佳對象，地位等同英國嘅碧咸。", 3)
  arab_title = 'لكن أسرة'
  arab_desc = 'والحزب القومي الصيني. شهد النصف الأول من القرن العشرين سقوط البلاد في فترة من التفكك والحروب الأهلية التيلشيوعيون. انتهت أعمال العنف الكبرى في عام 1949 عندما حسم الشيوعيون الحرب الأهلية وأسسوا جمهورية الصين الشعبية في بر الصين الرئيسي. نقل حزب الكومينتانغ عاصمة جم'
  u.create_lesson(arab_title, arab_desc, 1)
  u.create_lesson('È lunedì, che umiliazione', 'Juventus-Napoli alla ripresa del campionato. Vale già per lo scudetto (anche se ci sarà tempo, per chi perde, di recuperare), ma vale soprattutto per indicare chi è la squadra più forte in questo momento. Proviamo a capirlo con questo sondaggio che, giorno.', 1)
  u.create_lesson('Citroen conferma, Hyundai ritorna', 'come i principali gruppi industriali del mondo abbiano fiducia in questo sport, nonostante le difficoltà economiche». Nello stesso giorno del ritorno della casa coreana, arriva', 1)
  u.create_lesson('Ladies', 'Ladies, it’s getting cold out there. What’s the logical thing to do? Wear a Spock hoodie, of course. And they’re available now, thanks to Ashley Eckstein and her apparel company, Her Universe. The Spock hoodie comes in uniform-like sciences blue, is made of Vulcan ears.', 2)
  u.create_lesson("2013 Trek Calendars Available", "If you’re already thinking about that perfect gift for the Star Trek fan in your life… or for yourself, a classic standby awaits. Danilo’s 2013 Star Trek calendars. They’re offering two Trek calendars this year, Star Trek 2013 Calendar.", 1)
  u.create_lesson("Holographic Love", "Star Trek is a worldwide phenomenon. StarTrek.com frequently presents excerpts from the latest issue of Star Trek Magazine, which is published out of England and available internationally. the official Star Trek magazine of Italy. ", 1)
  u.create_lesson("Alimentazione", "I fattori che scatenano la prostatite sono molteplici e talvolta possono agire contemporaneamente, dando luogo a diverse forme di prostatite. Le principali cause della prostatite possono essere: batteri, che risalgono il condotto urinario e si depositano nella prostata.", 2)
  u.create_lesson("Come Si Calcola I Giorno Di Fertilità?", "ciao a tutti cerco un vostro aiuto vorrei calcolare il giorno fertile. le mestruazione sono venute 27 marzo ed ho avuto 46 giorni di ritardo ed arriva fino 40 giorni cosa ci devo mettere non ci capisco più nulla", 3)
  u.create_lesson("Educazione figli", "ho un bimbo bellisimo di 3 anni e mezzo beh, è già la seconda volta che il papà lo picchia con la cinta xkè ha disubbidito. Ebbene Nicol va col faccino mogio mogio dal suo papà e gli dice e il papà gli risponde \" prima di cena ti cinghio lo stesso e al parco non ci vai\"!!!", 1)
  u.create_lesson("Lazio, nuovo caso Fiorito dell'Idv", "La Gdf interviene dopo una segnalazione della Banca d'Italia. L'indagine riguarda i fondi del gruppo dell'Italia dei valori e l'utilizzo fattone dal responsabile, Vincenzo Salvatore Maruccio, che è anche segretario regionale del partito", 2)
  u.create_lesson("Ufologia", "Questo Database di oltre 300 immagini di Cerchi nel grano è suddiviso in diverse gallerie che riportano i vari dati sulla realizzazione. Le immagini sono state accuratamente cercate in rete e dopo averle sel ezionate", 1)
  
  admin.create_lesson('Chimica Uno', 'Chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno', 1)
  admin.create_lesson('Chimica Due', 'Chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno', 1)
  admin.create_lesson('Chimica Tre', 'Chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno', 1)
admin.create_lesson('Chimica Quattro', 'Chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno', 1)
  admin.create_lesson('Chimica Cinque', 'Chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno', 1)
  admin.create_lesson('Chimica Sei', 'Chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno', 1)
  admin.create_lesson('Chimica Sette', 'Chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno', 1)
  admin.create_lesson('Chimica Otto', 'Chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno', 1)
  admin.create_lesson('Chimica Nove', 'Chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno', 1)
  admin.create_lesson('Chimica Dieci', 'Chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno', 1)
  admin.create_lesson('Chimica Undici', 'Chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno', 1)
  admin.create_lesson('Chimica Dodici', 'Chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno', 1)
  admin.create_lesson('Chimica Tredici', 'Chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno', 1)
  admin.create_lesson('Chimica Quattordici', 'Chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno, chimica parte uno', 1)
  
  types = {0 => 'Video', 1 => 'Audio', 2 => 'Image'}
  descriptions = []
  descriptions << ['Gatto', "Non dire gatto se non l'hai nel sacco"]
  descriptions << ["Pizza Berlusconi", "Pizza Berlusconi on tuotenimi Kotipizza-ketjun savuporopizzalle. Kotipizza on savuporopizzallaan voittanut maaliskuussa 2008 America's Plate International -pizzakilpailun New Yorkissa päihittäen muun muassa toiseksi kilpailussa tulleet italialaiset."]
  descriptions << ["Kotipizza är Finlands största pizzakedja", "Kedjan gjorde ett försök med en Sverigelansering under 1990-talet då tre pizzarestauranger öppnades i Umeå, grannstad med Rabbe Grönbloms hemstad Vasa. Enligt Kotipizza gick lanseringen enligt förväntan men restaurangerna lades ner efter ett par år."]
  descriptions << ['歷史', '中華人民共和國建立無耐，中國大陸因連年戰爭已經接近一個廢墟。1950年代初期，共產黨通過「鎮壓反革命」嘅運動，對私有經濟同財產進行城市工商業「社會主義改造」同農村「土改」同土地集體化，抑止戰時通貨膨脹、並喺蘇聯援助下建立一個初步完整嘅工業體系，普及國民教育同建立醫療保障體系。「一邊倒」）嘅政策，援助各社會主義國家同新興獨立國家共產主義活動。軍事上，1950年基本消滅國民黨喺大陸嘅殘餘勢力；']
  descriptions << [arab_title, arab_desc]
  descriptions << ['William Bligh', "Bligh was born in Tinten Manor in St Tudy near Bodmin, Cornwall, to Francis Bligh and his wife Jane. Francis was Jane's second husband; she was the widow of a man whose surname was Pearce and her maiden name was Balsam."]
  descriptions << ["Tokelauan self-determination referendum", "Despite the majority 60% who voted in favour of the proposal, the referendum failed to get the two-thirds majority required for the referendum to succeed."]
  descriptions << ["History of Samoa", "Robert Louis Stevenson arrived in Samoa in 1889 and built a house at Vailima. He quickly became passionately interested, and involved, in the attendant political machinations."]
  descriptions << ["Приднестровская Молдавская Республика", "С древних времён данная территория была населена тирагетами (фракийское племя)[10]. В раннем средневековье на территории современного Приднестровья жили славянские племена уличи и тиверцы, а также кочевники-тюрки — печенеги и половцы."]
  descriptions << ["Calendario 2012", "Su questo sito ogni calendario online, annuale o mensile, sta, tra l’altro, per 2012, 2013 e 2014. Questo può essere molto utile quando si cerca una data (per esempio, quando si hanno le vacanze) "]
  descriptions << ["De Rossi-Zeman, è gelo", "Scarso impegno? Il romanista è infuriato, tre mesi per trovare la pace o sarà addio."]
  descriptions << ["Balotelli imita Eto'o", "Balotelli BalotelliBalotelli Balotelli Balotelli Balotelli Balotelli Balotelli"]
  
  i = 0
  descriptions.each do |d|
    x = MediaElement.new :description => d[1], :title => d[0]
    x.user_id = admin.id
    x.sti_type = types[(i%3)]
    x.duration = (types[(i%3)] != 'Image') ? 10 : nil
    x.save
    i += 1
  end
  
  descriptions = []
  descriptions << ["Juve-Napoli, che bufera!", "Il procuratore federale Palazzi ha deferito Antonio Conte, Aurelio De Laurentiis e i due club"]
  descriptions << ["Maggio: «Cara Juve, siamo cresciuti»", "L'esterno del Napoli: «Loro hanno qualcosina in più come qualità di giocatori, noi come qualità tattica»"]
  descriptions << ["Italia, con Balotelli Osvaldo o Giovinco", "Prandelli prova prima Giovinco e poi Osvaldo come spalla di SuperMario, con Montolivo alle spalle delle punte, per chiudere con un 4-3-3 senza il milanista ma con tutte e tre le punte"]
  descriptions << ["Candreva: Una super Lazio", "Il centrocampista, tornato in Nazionale dopo tre anni:"]
  descriptions << ["Hernanes: «Vogliamo fare salto di qualit", "Il centrocampista della Lazio: «Il frutto di questo match è stato un buon risultato per affrontare la sosta con tranquillità»"]
  descriptions << ["Stipendi, Agnelli batte Lotito", "Consiglieri di amministrazione della Lazio senza paga. Nei bianconeri 1,65 milioni a Marotta e 200 mila euro a Nedved"]
  descriptions << ["Milan-Inter: c'è Valeri.", "Ecco le designazioni per le sfide della settima di Serie A: per Inter-Milan scelto Valeri. Pescara-Lazio a De Marco mentre Roma-Atalanta è stata affidata a Banti"]
  descriptions << ["mazzoleni ha alzato la coppa a pechino!", "c'è tanta gente che ruba senza pagare, almeno voi in questo siete da esempio: a fine mese saldate sempre e comunque il conto e va detto che tutto ciò vi fa onore!! Ecco lo stile juve!! Lo sport e non solo prenda esempio da voi!!"]
  descriptions << ["Due turni a Gastaldello", "Il giudice sportivo ha squalificato per due giornate Daniele Gastaldello (Sampdoria) che era stata espulso durante la partita con il Napoli. Guastaldello era stato espulso dopo essere stato ammonito per comportamento scorretto nei confronti di u"]
  descriptions << ["Risultato Juve-Roma: il tuo pronostico", "Come finirà la sfida dello Juventus Stadium? Quale sarà il punteggio finale? Chi segnerà? Ditecelo con un semplice commento!"]
  descriptions << ["Cagliari-Pescara aperta al pubblico", "Via libera ufficiale della Commissione provinciale di vigilanza per l'apertura al pubblico dello stadio Is Arenas di Quartu. Domenica gli abbonati del club sardo potranno assistere alla sfida di Serie A"]
  descriptions << ["Zeman? Niente appello ai tifosi", "L'esterno del Barcellona ricorderà a lungo martedì 9 ottobre: esattamente dopo 223 giorni ha toccato un..."]
  descriptions << ["Messi e Ronaldo, marziani al Camp Nou", "Hanno realizzato una doppietta a testa in quella che in questo momento è forse la più bella, spettacolare e avvincente partita che il mondo del calcio"]
  descriptions << ["Aguero e la perdita dell'innocenza", "L'attaccante del City attacca gli arbitri: «Hanno un occhio di riguardo per i giocatori inglesi»"]
  descriptions << ["Zamparini, è Lo Monaco l'ultimo teatro", "Il presidente del Palermo possiede tanta immaginazione, e sembra che aumenti proporzionalmente al numero di sconfitte che la sua squadra incamera"]
  descriptions << ["Ronaldo parteciperà ad un reality", "Colui che per tutti era il Fenomeno è comparso in un programma di Rede Globo, la più grande e potente emittente del Paese e ha cominciato una dieta pubblica. Periodicamente ricomparirà in video per le misurazioni del caso"]
  descriptions << ["Il momento in cui i talenti cadono", "Narciso si innamorò della sua immagine riflessa e prendendo atto dell'impossibilità del rapporto amoroso, si lasciò morire, perché mai le stesse pulsioni dovrebbero essere assenti in chi sa bene di essere, nel suo campo, il migliore?"]
  descriptions << ["Sheva ora è un traditore venduto", "L'ex attacccante del Milan ha fondato un movimento: ma i tifosi che lo adoravano ora lo accusano di amoreggiare con il partito al potere"]
  
  i = 0
  descriptions.each do |d|
    x = MediaElement.new :description => d[1], :title => d[0]
    x.user_id = u.id
    x.sti_type = types[(i%3)]
    x.duration = (types[(i%3)] != 'Image') ? 10 : nil
    x.save
    i += 1
  end
  
  slides = {1 => ['image1', 'image2'], 2 => ['text', 'video1'], 3 => ['video2', 'video2'], 4 => ['image3', 'audio1'], 5 => [], 6 => ['audio2'], 7 => ['text', 'text'], 8 => [], 9 => ['video1', 'audio1'], 10 => ['image1', 'image3'], 11 => ['text', 'image2', 'image2', 'text'], 12 => ['video2', 'audio2', 'audio1'], 13 => [], 14 => [], 15 => [], 16 => [], 17 => [], 18 => [], 19 => [], 20 => [], 21 => [], 22 => [], 23 => [], 24 => [], 25 => [], 26 => [], 27 => [], 28 => [], 29 => [], 30 => [], 31 => [], 32 => [], 33 => [], 34 => [], 35 => [], 36 => [], 37 => []}
  
  Lesson.all.each do |l|
    slides[l.id].each do |kind|
      l.add_slide kind
    end
  end
  
  notifics = []
  notifics << 'Ma De Rossi a Roma che cosa ci sta a fare quando le cose vanno male è sempre colpa sua'
  notifics << "a daniè t'avevo detto che dovevi annà al city"
  notifics << "共產黨通過「鎮壓反革命」嘅運動，對私有經濟同財產進行城市工商業"
  notifics << "Prova il brivido del Poker online Gioca su StarCasinò. Bonus 1.000€!"
  
  notifics.each do |n|
    Notification.send_to u.id, n
  end
  
  Lesson.all.each do |l|
    l.publish
  end
  
  cont = 0
  tim = Time.zone.now
  MediaElement.all.each do |l|
    l.is_public = true
    l.publication_date = tim - cont
    l.save
    cont += 1
  end
  
  Lesson.all.each do |l|
    admin.bookmark 'Lesson', l.id
    if l.subject_id == 3
      l.copy admin.id
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
  
end

puts "Created #{Subject.count} subjects, #{Location.count} locations, #{SchoolLevel.count} school_levels, #{User.count} users, #{UsersSubject.count} users_subjects, #{Lesson.count} lessons, #{MediaElement.count} media_elements, #{Slide.count} slides, #{Notification.count} notifications, #{Like.count} likes"
