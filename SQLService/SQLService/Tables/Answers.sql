CREATE TABLE [dbo].[answers]
(
    answer_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    answer_text NVARCHAR (MAX) NOT NULL,
    answer_poster_id BIGINT NOT NULL,
    question_id BIGINT NOT NULL,
    upvotes INT DEFAULT 0,
    answer_created_datetime DATETIME DEFAULT GETDATE(),
    answer_updated_datetime DATETIME DEFAULT GETDATE()
);