
-- Movie Database Project

-- Drop existing tables if they exist (for re-runs)
DROP TABLE IF EXISTS Ratings;
DROP TABLE IF EXISTS Movie_Actors;
DROP TABLE IF EXISTS Movies;
DROP TABLE IF EXISTS Actors;
DROP TABLE IF EXISTS Genres;

-- Create Genres table
CREATE TABLE Genres (
    genre_id INT PRIMARY KEY,
    genre_name VARCHAR(50)
);

-- Create Movies table
CREATE TABLE Movies (
    movie_id INT PRIMARY KEY,
    title VARCHAR(100),
    release_year INT,
    genre_id INT,
    FOREIGN KEY (genre_id) REFERENCES Genres(genre_id)
);

-- Create Actors table
CREATE TABLE Actors (
    actor_id INT PRIMARY KEY,
    name VARCHAR(100)
);

-- Create Movie_Actors table
CREATE TABLE Movie_Actors (
    movie_id INT,
    actor_id INT,
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
    FOREIGN KEY (actor_id) REFERENCES Actors(actor_id),
    PRIMARY KEY (movie_id, actor_id)
);

-- Create Ratings table
CREATE TABLE Ratings (
    rating_id INT PRIMARY KEY,
    movie_id INT,
    rating DECIMAL(2,1),
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id)
);

-- Insert sample data
INSERT INTO Genres VALUES
(1, 'Action'), (2, 'Drama'), (3, 'Comedy');

INSERT INTO Movies VALUES
(1, 'Inception', 2010, 1),
(2, 'Titanic', 1997, 2),
(3, 'The Hangover', 2009, 3),
(4, 'The Dark Knight', 2008, 1);

INSERT INTO Actors VALUES
(1, 'Leonardo DiCaprio'), (2, 'Bradley Cooper'), (3, 'Christian Bale');

INSERT INTO Movie_Actors VALUES
(1, 1), (2, 1), (3, 2), (4, 3);

INSERT INTO Ratings VALUES
(1, 1, 8.8), (2, 2, 7.8), (3, 3, 7.7), (4, 4, 9.0);

-- Query 1: Movies by rating, year, genre
-- List movies with their rating, release year, and genre
SELECT 
    m.title,
    m.release_year,
    g.genre_name,
    r.rating
FROM Movies m
JOIN Genres g ON m.genre_id = g.genre_id
JOIN Ratings r ON m.movie_id = r.movie_id
ORDER BY r.rating DESC;

-- Query 2: Top-rated actor per genre
SELECT 
    g.genre_name,
    a.name AS top_actor,
    MAX(r.rating) AS max_rating
FROM Genres g
JOIN Movies m ON g.genre_id = m.genre_id
JOIN Movie_Actors ma ON m.movie_id = ma.movie_id
JOIN Actors a ON ma.actor_id = a.actor_id
JOIN Ratings r ON m.movie_id = r.movie_id
GROUP BY g.genre_name;

-- Query 3: Most common movie genre per year
SELECT 
    release_year,
    genre_name,
    COUNT(*) AS genre_count
FROM Movies m
JOIN Genres g ON m.genre_id = g.genre_id
GROUP BY release_year, genre_name
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM Movies m2
    WHERE m2.release_year = m.release_year
    GROUP BY m2.genre_id
)
ORDER BY release_year;
