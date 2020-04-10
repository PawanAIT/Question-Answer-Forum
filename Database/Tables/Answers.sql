CREATE TABLE dbo.Answers
(
    AnswerID INT IDENTITY(1,1) PRIMARY KEY,
    AnswerText NVARCHAR (MAX),
    AnswerDateTime DATETIME,
    AnswerPosterID INT,
    QuestionID INT,
    NumberUpvotes INT
)