CREATE TABLE [dbo].[answers]
(
    answer_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    answer_text NVARCHAR (MAX) NOT NULL,
    answer_poster_id BIGINT NOT NULL,
    question_id BIGINT NOT NULL,
    kudos INT DEFAULT 0,
    downvotes INT DEFAULT 0,
    answer_created_datetime DATETIME DEFAULT GETUTCDATE(),
    answer_updated_datetime DATETIME DEFAULT GETUTCDATE()
);