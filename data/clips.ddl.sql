-- Clips definition
CREATE TABLE Clips (
	idx INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	Name NVARCHAR(1024),
	Body TEXT,
	Category NVARCHAR(256), 
	Foreground BIGINT, 
	Background BIGINT);