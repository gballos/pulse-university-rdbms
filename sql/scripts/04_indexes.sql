-- indexes for the most common joins / foreign keys

-- festival_events
CREATE INDEX idx_events_festivals ON FESTIVAL_EVENTS(festival_id);
CREATE INDEX idx_events_performances_events ON PERFORMANCES(event_id);
CREATE INDEX idx_events_tickets ON TICKETS(event_id);
CREATE INDEX idx_events_staff ON STAFF(event_id);

-- artist / band relationships
CREATE INDEX idx_ab_artist ON ARTISTS_X_BANDS(artist_id);
CREATE INDEX idx_ab_band ON ARTISTS_X_BANDS(band_id);