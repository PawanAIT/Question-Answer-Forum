CREATE TABLE [dbo].[questions]
(
    question_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    question_title NVARCHAR (1000) NOT NULL,
    question_details NVARCHAR (4000) NULL,
    question_poster_id BIGINT NOT NULL,
    question_topic_id BIGINT NOT NULL,
    question_created_datetime DATETIME DEFAULT GETUTCDATE(),
    question_updated_datetime DATETIME DEFAULT GETUTCDATE()
);