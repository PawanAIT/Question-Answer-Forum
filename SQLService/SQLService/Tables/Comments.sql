CREATE TABLE [dbo].[comments]
(
    comment_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    comment_text NVARCHAR (MAX),
    comment_datetime DATETIME,
    comment_poster_id BIGINT,
    answer_id BIGINT,
    upvotes INT,
    comment_created_datetime DATETIME DEFAULT GETUTCDATE(),
    comment_updated_datetime DATETIME DEFAULT GETUTCDATE()
);