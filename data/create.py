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
        birthday = fake.date_between(start_date='-100y', end_date='-15y')
        music_type_id = random.randint(1, 10)
        music_subtype_id = random.randint(1, 40)
        website = fake.url()
        instagram = "@" + fake.user_name()
        image = fake.image_url()
        
        return f"INSERT INTO ARTISTS (artist_id, first_name, last_name, nickname, birthday, music_type_id, music_subtype_id, website, instagram, image) VALUES ('{
            artist_id}', '{
            first_name}', '{
            last_name}', '{
            nickname}', '{
            birthday}', '{
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


# PERFORMANCE_TYPES
def fake_performance_types(f):
    performance_types = [
        "Warm Up", "Headline", "Special Guest"
    ]

    def build_performance_type(performance_type):
        return f"INSERT INTO PERFORMANCE_TYPES (performance_type) VALUES ('{performance_type}');\n"

    for performance_type in performance_types:
        f.write(build_performance_type(performance_type))


# PERFORMANCES
def fake_performances(f):
    fake = faker.Faker()

    def build_performance(performance_id):
        performance_type_id = random.randint(1, 3)
        event_id = random.randint(1, N_EVENTS)
        performance_time = fake.time()
        duration = random.randint(30, 180)
        order_in_show = random.randint(1, 10)
        is_solo = random.choice([0, 1])
        if is_solo:
            performer_id = random.randint(1, N_ARTISTS)
        else:
            performer_id = random.randint(1, N_BANDS)
        image = fake.image_url()

        return f"INSERT INTO PERFORMANCES (performance_id, performance_type_id, event_id, performance_time, duration, order_in_show, is_solo, performer_id, image) VALUES ('{
            performance_id}', '{
            performance_type_id}', '{
            event_id}', '{
            performance_time}', '{
            duration}', '{
            order_in_show}', '{
            is_solo}', '{
            performer_id}', '{
            image}');\n"

    performances = (build_performance(i) for i in range(1, N_PERFORMANCES + 1))

    for performance in performances:
        f.write(performance)


# TECHNICAL_ROLES
def fake_technical_roles(f):
    technical_descriptions = [
        "Sound Engineer",
        "Lighting Technician",
        "Stage Manager",
        "Video Technician",
        "Audio Visual Operator",
        "Backline Technician",
        "Rigging Specialist",
        "Broadcast Engineer"
    ]

    def build_technical_role(description):
        return f"INSERT INTO TECHNICAL_ROLES (technical_description) VALUES ('{description}');\n"

    for description in technical_descriptions:
        f.write(build_technical_role(description))


# STAFF_CATEGORIES
def fake_staff_categories(f):
    technical_categories = [
        ("Sound", 1),
        ("Lighting", 2),
        ("Stage", 3),
        ("Video", 4),
        ("AV Operator", 5),
        ("Backline", 6),
        ("Rigging", 7),
        ("Broadcast", 8)
    ]

    non_technical_categories = [
        ("Security", None),
        ("Assistant", None),
        ("Coordinator", None),
        ("Guide", None),
        ("Usher", None)
    ]

    def build_staff_category(category_id, desc, tech_id):
        tech_val = "NULL" if tech_id is None else f"'{tech_id}'"
        return f"INSERT INTO STAFF_CATEGORIES (staff_category_id, staff_category_desc, technical_id) VALUES ('{category_id}', '{desc}', {tech_val});\n"

    category_id = 1
    for desc, tech_id in technical_categories + non_technical_categories:
        f.write(build_staff_category(category_id, desc, tech_id))
        category_id += 1


# LEVELS_OF_EXPERTISE
def fake_levels_of_expertise(f):
    levels = [
        "Intern",
        "Beginner",
        "Intermediate",
        "Experienced",
        "Expert"
    ]

    def build_level(description):
        return f"INSERT INTO LEVELS_OF_EXPERTISE (level_description) VALUES ('{description}');\n"

    for description in levels:
        f.write(build_level(description))


# STAFF
def fake_staff(f):
    fake = faker.Faker()

    def build_staff(staff_id):
        category_id = random.randint(1, 13)
        level_id = random.randint(1, 5)
        event_id = random.randint(1, N_EVENTS)
        first_name = fake.first_name()
        last_name = fake.last_name()
        age = random.randint(18, 65)
        image = fake.image_url()

        return f"INSERT INTO STAFF (staff_id, category_id, level_id, event_id, first_name, last_name, age, image) VALUES ('{
            staff_id}', '{
            category_id}', '{
            level_id}', '{
            event_id}', '{
            first_name}', '{
            last_name}', '{
            age}', '{
            image}');\n"

    staff_members = (build_staff(i) for i in range(1, N_STAFF + 1))

    for staff in staff_members:
        f.write(staff)


# VISITORS
def fake_visitors(f):
    fake = faker.Faker()

    def build_visitor(visitor_id):
        first_name = fake.first_name()
        last_name = fake.last_name()
        phone_number = fake.phone_number()
        email = fake.email()[:20] 
        age = random.randint(16, 75)

        return f"INSERT INTO VISITORS (visitor_id, first_name, last_name, phone_number, email, age) VALUES ('{
            visitor_id}', '{
            first_name}', '{
            last_name}', '{
            phone_number}', '{
            email}', '{
            age}');\n"

    visitors = (build_visitor(i) for i in range(1, N_VISITORS + 1))

    for visitor in visitors:
        f.write(visitor)


# TICKET_TYPES
def fake_ticket_types(f):
    ticket_types = [
        "General Admission",
        "VIP",
        "Backstage",
    ]

    def build_ticket_type(ticket_type):
        return f"INSERT INTO TICKET_TYPES (ticket_type) VALUES ('{ticket_type}');\n"

    for ticket_type in ticket_types:
        f.write(build_ticket_type(ticket_type))


# PAYMENT_METHODS
def fake_payment_methods(f):
    payment_methods = [
        "Credit Card",
        "Debit Card",
        "Bank Transfer",
        "Mobile Wallet",
        "Online Banking",
        "Prepaid Card",
        "Cash"
    ]

    def build_payment_method(method):
        return f"INSERT INTO PAYMENT_METHODS (payment_method) VALUES ('{method}');\n"

    for method in payment_methods:
        f.write(build_payment_method(method))


# TICKETS
def fake_tickets(f):
    fake = faker.Faker()

    def build_ticket(ticket_id):
        event_id = random.randint(1, N_EVENTS)
        visitor_id = random.randint(1, N_VISITORS)
        ticket_type_id = random.randint(1, 3)
        payment_method_id = random.randint(1, 7)
        ean_code = ''.join(str(random.randint(0, 9)) for _ in range(13))
        is_scanned = random.choice([0, 1])
        date_bought = fake.date_between(start_date='-1y', end_date='today')
        cost = random.randint(20, 200)

        return f"INSERT INTO TICKETS (ticket_id, event_id, visitor_id, ticket_type_id, payment_method_id, ean_code, is_scanned, date_bought, cost) VALUES ('{
            ticket_id}', '{
            event_id}', '{
            visitor_id}', '{
            ticket_type_id}', '{
            payment_method_id}', '{
            ean_code}', '{
            is_scanned}', '{
            date_bought}', '{
            cost}');\n"

    tickets = (build_ticket(i) for i in range(1, N_TICKETS + 1))

    for ticket in tickets:
        f.write(ticket)


# LIKERT_RATINGS
def fake_likert_ratings(f):
    likert_scale = [
        (1, "Very Bad"),
        (2, "Bad"),
        (3, "Neutral"),
        (4, "Good"),
        (5, "Excellent")
    ]

    def build_rating(rating_number, description):
        return f"INSERT INTO LIKERT_RATINGS (rating_number, rating_description) VALUES ('{rating_number}', '{description}');\n"

    for rating_number, description in likert_scale:
        f.write(build_rating(rating_number, description))


# REVIEWS
def fake_reviews(f):
    def build_review(review_id):
        visitor_id = random.randint(1, N_VISITORS)
        performance_id = random.randint(1, N_PERFORMANCES)
        interpretation_rating = random.randint(1, 5)
        sound_lighting_rating = random.randint(1, 5)
        stage_presence_rating = random.randint(1, 5)
        organization_rating = random.randint(1, 5)
        overall_impression_rating = random.randint(1, 5)

        return f"INSERT INTO REVIEWS (review_id, visitor_id, performance_id, interpretation_rating, sound_lighting_rating, stage_presence_rating, organization_rating, overall_impression_rating) VALUES ('{
                review_id}', '{
                visitor_id}', '{
                performance_id}', '{
                interpretation_rating}', '{
                sound_lighting_rating}', '{
                stage_presence_rating}', '{
                organization_rating}', '{
                overall_impression_rating}');\n"

    reviews = (build_review(i) for i in range(1, N_REVIEWS + 1))

    for review in reviews:
        f.write(review)


# BUYERS
def fake_buyers(f):
    def build_buyer(buyer_id):
        ticket_id = random.randint(1, N_TICKETS)
        event_id = random.randint(1, N_EVENTS)
        ticket_type_id = random.randint(1, 3)

        return f"INSERT INTO BUYERS (buyer_id, event_id, ticket_type_id, ticket_id) VALUES ('{
            buyer_id}', '{
            event_id}', '{
            ticket_type_id}', '{
            ticket_id}');\n"

    buyers = (build_buyer(i) for i in range(1, N_BUYERS + 1))

    for buyer in buyers:
        f.write(buyer)


# TICKETS_FOR_RESALE
def fake_tickets_for_resale(f):
    def build_resale_ticket(resale_id):
        ticket_id = random.randint(1, N_TICKETS)
        event_id = random.randint(1, N_EVENTS)
        ticket_type_id = random.randint(1, 3)

        return f"INSERT INTO TICKETS_FOR_RESALE (ticket_for_resale_id, ticket_id, event_id, ticket_type_id) VALUES ('{
            resale_id}', '{
            ticket_id}', '{
            event_id}', '{
            ticket_type_id}');\n"

    resale_tickets = (build_resale_ticket(i) for i in range(1, N_RESALE_TICKETS + 1))

    for resale_ticket in resale_tickets:
        f.write(resale_ticket)


with open("load.sql", "w") as f:
    fake_locations(f)
    fake_festivals(f)
    fake_stages(f)
    fake_technical_supplies(f)
    fake_music_types(f)
    fake_music_subtypes(f)
    fake_artists(f)
    fake_bands(f)
    fake_artists_x_bands(f)
    fake_performance_types(f)
    fake_festival_events(f)
    fake_performances(f)
    fake_technical_roles(f)
    fake_staff_categories(f)
    fake_levels_of_expertise(f)
    fake_staff(f)
    fake_visitors(f)
    fake_ticket_types(f)
    fake_payment_methods(f)
    fake_tickets(f)
    fake_likert_ratings(f)
    fake_reviews(f)
    fake_buyers(f)
    fake_tickets_for_resale(f)
    fake_stages_x_technical_supply(f)
