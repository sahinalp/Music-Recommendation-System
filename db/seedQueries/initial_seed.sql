CREATE TABLE Database (
    Id SERIAL PRIMARY KEY,
    SongId VARCHAR(50),
    SongName TEXT,
    SongCluster VARCHAR(4),
    Popularity SMALLINT,
    AvaibleMarkets TEXT,
    Country VARCHAR(10),
    Uri VARCHAR(50),
    Lyrics TEXT
)