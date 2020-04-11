CREATE TABLE [dbo].[topics]
(
    topic_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    topic_name NVARCHAR (50) NOT NULL,

    CONSTRAINT UC__topics__topic_name UNIQUE (topic_name)
);