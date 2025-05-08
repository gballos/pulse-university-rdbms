import random 
import faker
import datetime

N_LOCATIONS = 100
N_FESTIVALS = 100
N_STAGES = 150
N_TECHNICAL_SUPPLIES = 50
N_EVENTS = 100
N_ARTISTS = 200
N_BANDS = 100
N_PERFORMANCES = 100
N_STAFF = 200
N_VISITORS = 300
N_TICKETS = 350
N_REVIEWS = 300
N_BUYERS = 200
N_RESALE_TICKETS = 50

random.seed(42)
faker.Faker.seed(42)

# LOCATIONS
def fake_locations(f):
    continents = ['Asia', 
    'Europe', 
    'North America', 
    'South America', 
    'Africa', 
    'Australia', 
    'Antarctica']

    fake = faker.Faker()

    def build_locations(location_id):
        address = fake.address()
        city = fake.city()
        country = fake.country()
        continent = random.choice(continents)
        longtitude = fake.longitude()
        latitude = fake.latitude()
        image = fake.image_url()
        return f"INSERT INTO LOCATIONS (location_id, address, city, country, continent, longtitude, latitude, image) VALUES ('{
            location_id}', '{
            address}', '{
            city}', '{
            country}', '{
            continent}', '{
            longtitude}', '{
            latitude}', '{
            image}');\n"

    locations = (build_locations(_) for _ in range(1, N_LOCATIONS+1))

    for location in locations:
        f.write(location)

  
# FESTIVALS
def fake_festivals(f):
    fake = faker.Faker()

    def build_festivals(festival_id):
        days = random.randint(1, 5)

        date_starting = fake.date()
        date_ending = date_starting + datetime.timedelta(days)
        duration = days
        location_id = random.randint(1, N_LOCATIONS)
        image = fake.image_url() 
        return f"INSERT INTO FESTIVALS (festival_id, date_starting, date_ending, duration, location_id, image) VALUES ('{
            festival_id}', '{
            date_starting}', '{
            date_ending}', '{
            duration}', '{
            location_id}', '{
            image}');\n"
    
    festivals = (build_festivals(_) for _ in range(1, N_FESTIVALS+1))

    for festival in festivals:
        f.write(festival)


# STAGES
def fake_stages(f):
    fake = faker.Faker()

    def build_stages(stage_id):
        stage_name = fake.name()
        stage_description = fake.paragraph(nb_sentences = 10)
        max_capacity = random.randint(200, 1000)
        image = fake.image_url() 
        return f"INSERT INTO STAGES (stage_id, stage_name, stage_description, max_capacity, image) VALUES ('{
            stage_id}', '{
            stage_name}', '{
            stage_description}', '{
            max_capacity}', '{
            image}');\n"


# TECHNICAL_SUPPLY
def fake_technical_supplies(f): 
    fake = faker.Faker()

    def build_technical_supplies(technical_supply_id):
        technical_supply_description = fake.paragraph(nb_sentences = 10)
        image = fake.image_url()
        return f"INSERT INTO TECHNICAL_SUPPLY (technical_supply_id, technical_supply_description, image) VALUES ('{
            technical_supply_id}', '{
            technical_supply_description}', '{
            image}');\n"

    technical_supplies = (build_technical_supplies(_) for _ in range(1, N_TECHNICAL_SUPPLIES+1)) 

    for technical_supply in technical_supplies:
        f.write(technical_supply)    
    stages = (build_stages(_) for _ in range(1, N_STAGES+1))

    for stage in stages:
        f.write(stage)


# STAGES_X_TECHNICAL_SUPPLY
def fake_stages_x_technical_supply(f):
    links = set()

    while len(links) < 100:  # adjust number of links
        stage_id = random.randint(1, N_STAGES)
        tech_id = random.randint(1, N_TECHNICAL_SUPPLIES)
        links.add((stage_id, tech_id))

    def build_link(stage_id, tech_id):
        return f"INSERT INTO STAGES_X_TECHNICAL_SUPPLY (stage_id, technical_supply_id) VALUES ('{stage_id}', '{tech_id}');\n"

    for stage_id, tech_id in links:
        f.write(build_link(stage_id, tech_id))


# FESTIVAL_EVENTS
def fake_festival_events(f):
    fake = faker.Faker()

    def build_festivaL_events(event_id):
        festival_id = random.randint(1, N_FESTIVALS)
        stage_id = random.randint(1, N_STAGES) 
        event_date = fake.date()
        duration = random.randint(60, 180)
        image = fake.image_url()
        return f"INSERT INTO FESTIVAL_EVENTS (event_id, festival_id, stage_id, event_date, duration, image) VALUES ('{
            event_id}', '{
            festival_id}', '{
            stage_id}', '{
            event_date}', '{
            duration}', '{
            image}');\n"

    festival_events = (build_festivaL_events(_) for _ in range(1, N_EVENTS+1)) 

    for festival_event in festival_events:
        f.write(festival_event)


# MUSIC_TYPES
def fake_music_types(f):
    music_types = [
        "Rock", "Pop", "Hip Hop", "Jazz", "Classical",
        "Electronic", "Country", "Reggae", "Blues", "Metal"
    ]

    def build_music_type(music_type_id, music_type):
        return f"INSERT INTO MUSIC_TYPES (music_type_id, music_type) VALUES ('{music_type_id}', '{music_type}');\n"

    music_type_statements = (
        build_music_type(i, music_type)
        for i, music_type in enumerate(music_types, start=1)
    )

    for music_type_stmt in music_type_statements:
        f.write(music_type_stmt)


# MUSIC_SUBTYPES
def fake_music_subtypes(f):
    music_subtypes = [
        "Alternative Rock", "Hard Rock", "Punk Rock", "Indie Rock",
        "Synth Pop", "Dance Pop", "Electropop", "Teen Pop",
        "Trap", "Boom Bap", "Gangsta Rap", "Conscious Hip Hop",
        "Bebop", "Smooth Jazz", "Swing", "Free Jazz",
        "Baroque", "Romantic", "Modern Classical", "Minimalism",
        "House", "Techno", "Trance", "Drum and Bass",
        "Bluegrass", "Country Pop", "Outlaw Country", "Americana",
        "Roots Reggae", "Dub", "Dancehall", "Lovers Rock",
        "Delta Blues", "Chicago Blues", "Electric Blues", "Piedmont Blues",
        "Death Metal", "Black Metal", "Power Metal", "Thrash Metal"
    ]

    def build_music_subtype(subtype):
        return f"INSERT INTO MUSIC_SUBTYPES (music_subtype) VALUES ('{subtype}');\n"

    for subtype in music_subtypes:
        f.write(build_music_subtype(subtype))


# ARTISTS
def fake_artists(f):
    fake = faker.Faker()

    def build_artist(artist_id):
        first_name = fake.first_name()
        last_name = fake.last_name()
        nickname = fake.user_name()
        music_type_id = random.randint(1, 10)
        music_subtype_id = random.randint(1, 40)
        website = fake.url()
        instagram = "@" + fake.user_name()
        image = fake.image_url()
        
        return f"INSERT INTO ARTISTS (artist_id, first_name, last_name, nickname, music_type_id, music_subtype_id, website, instagram, image) VALUES ('{
            artist_id}', '{
            first_name}', '{
            last_name}', '{
            nickname}', '{
            music_type_id}', '{
            music_subtype_id}', '{
            website}', '{
            instagram}', '{
            image}');\n"

    artists = (build_artist(i) for i in range(1, N_ARTISTS + 1))

    for artist in artists:
        f.write(artist)


# BANDS
def fake_bands(f):
    fake = faker.Faker()

    def build_band(band_id):
        name = fake.company()[:25]
        date_of_creation = fake.date_between(start_date='-50y', end_date='today')
        music_type_id = random.randint(1, 10)
        music_subtype_id = random.randint(1, 40)
        website = fake.url()
        instagram = "@" + fake.user_name()
        image = fake.image_url()
        return f"INSERT INTO BANDS (band_id, name, date_of_creation, music_type_id, music_subtype_id, website, instagram, image) VALUES ('{
            band_id}', '{
            name}', '{
            date_of_creation}', '{
            music_type_id}', '{
            music_subtype_id}', '{
            website}', '{
            instagram}', '{
            image}');\n"

    bands = (build_band(i) for i in range(1, N_BANDS + 1))

    for band in bands:
        f.write(band)

# ARTISTS_X_BANDS
def fake_artists_x_bands(f):
    pairs = set()

    while len(pairs) < 150:  # or however many links you want
        artist_id = random.randint(1, N_ARTISTS)
        band_id = random.randint(1, N_BANDS)
        pairs.add((artist_id, band_id))

    def build_artist_band_link(artist_id, band_id):
        return f"INSERT INTO ARTISTS_X_BANDS (artist_id, band_id) VALUES ('{artist_id}', '{band_id}');\n"

    for artist_id, band_id in pairs:
        f.write(build_artist_band_link(artist_id, band_id))
