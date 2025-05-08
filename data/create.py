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

    
    stages = (build_stages(_) for _ in range(1, N_STAGES+1))

    for stage in stages:
        f.write(stage)
