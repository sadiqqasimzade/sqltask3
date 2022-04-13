CREATE DATABASE Task2 
USE Task2

CREATE TABLE People
(
Id INT IDENTITY PRIMARY KEY,
Name NVARCHAR(50) NOT NULL,
Surname NVARCHAR(50) NOT NULL,
Age INT NOT NULL CHECK(Age>0)
)

CREATE TABLE Users
(
Id INT IDENTITY PRIMARY KEY,
PersonId INT REFERENCES People(Id) NOT NULL,
[Login] VARCHAR(50) NOT NULL,
[Password] VARCHAR(50) CHECK(len([Password]) > 8),
Mail VARCHAR(50) NOT NULL
)

CREATE TABLE Posts
(
Id INT IDENTITY PRIMARY KEY,
Content VARCHAR(100) NOT NULL,
Posttime DATE DEFAULT getdate(), 
UserId INT REFERENCES Users(Id) NOT NULL,
[Like] INT DEFAULT 0 CHECK([Like]>=0),
IsDeleted BIT DEFAULT 0
)

CREATE TABLE Comments
(
Id INT IDENTITY PRIMARY KEY,
UserId INT REFERENCES Users(Id) NOT NULL,
PostId INT REFERENCES Posts(Id) NOT NULL,
[Like] INT DEFAULT 0 CHECK([Like]>=0),
IsDeleted BIT DEFAULT 0 
)

--drop table Comments
--drop table Posts
--drop table Users
--drop table People
--
--select * from Comments
--select * from Posts
--select * from Users
--select * from People

INSERT INTO People VALUES 
('Name1','Surname1',10),('Name2','Surname2',11),('Name3','Surname3',12),('Name4','Surname4',13),('Name5','Surname5',14)

INSERT INTO Users VALUES
(1,'Login1','Password1','Mail1'),(2,'Login2','Password2','Mail2'),(3,'Login3','Password3','Mail3'),(4,'Login4','Password4','Mail4'),(5,'Login5','Password5','Mail5')

INSERT INTO Posts VALUES
('Content1',GETDATE(),1,11,DEFAULT),('Content2',GETDATE(),2,22,DEFAULT),('Content3',GETDATE(),3,33,DEFAULT),('Content4',GETDATE(),4,44,DEFAULT),('Content5',GETDATE(),5,55,DEFAULT)

INSERT INTO Comments VALUES
(1,1,11,DEFAULT),(2,2,22,DEFAULT),(3,3,33,DEFAULT),(4,4,44,DEFAULT),(5,5,55,DEFAULT)

--1) Postlara gələn comment sayların göstərin
SELECT Posts.Content, Count(Comments.Id) AS 'Comments' FROM Comments
INNER JOIN Posts ON Posts.Id = Comments.PostId
GROUP BY Posts.Content

--2) Bütün dataları göstərən relations qurun, Viewda saxlayın
CREATE VIEW ShowAllData
AS
SELECT People.Name, People.Surname, People.Age, Users.[Login], Users.Mail, Users.[Password], Posts.Content, Posts.Posttime, Posts.[Like] AS 'Post Like Count', Comments.[Like] AS 'Comment Like Count' 
FROM Users 
INNER JOIN People ON
Users.PersonId = People.Id 
INNER JOIN Posts ON
Users.Id = Posts.UserId 
INNER JOIN Comments ON
Comments.PostId = Posts.Id

SELECT * FROM ShowAllData

CREATE TRIGGER PostsTrigger
ON Posts
INSTEAD OF DELETE
AS
DECLARE @Id int
SELECT @Id = Id from deleted
UPDATE Posts SET IsDeleted = 1 WHERE Id = @Id

CREATE TRIGGER CommentsTrigger
ON Comments
INSTEAD OF DELETE
AS
DECLARE @Id int
SELECT @Id = Id from deleted
UPDATE Comments SET IsDeleted = 1 WHERE Id = @Id

delete from Posts where id=1

SELECT * FROM Posts

SELECT * FROM Posts where IsDeleted=0