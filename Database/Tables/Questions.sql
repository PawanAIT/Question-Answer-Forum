CREATE TABLE dbo.Questions
(
    QuestionID INT IDENTITY(1,1) PRIMARY KEY,
    QuestionTitle NVARCHAR (1000),
    QuestionDetails NVARCHAR (4000),
    QuestionDateTime DATETIME,
    QuestionPosterID INT,
    QuestionTopicID INT
)