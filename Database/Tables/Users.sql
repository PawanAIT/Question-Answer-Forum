CREATE TABLE dbo.Users
(
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100),
    Bio NVARCHAR(256),
    ProfilePicture NVARCHAR (500)
)