CREATE TABLE dbo.Comments
(
    CommentID INT IDENTITY(1,1) PRIMARY KEY,
    CommentText NVARCHAR (MAX),
    CommentDateTime DATETIME,
    CommentPosterID INT,
    AnswerID INT,
    NumberUpvotes INT
)