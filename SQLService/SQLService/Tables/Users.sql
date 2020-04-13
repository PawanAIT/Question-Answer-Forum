CREATE TABLE [dbo].[users]
(
    user_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(50) NOT NULL,
    last_name NVARCHAR(50) NOT NULL,
    email NVARCHAR(100) NOT NULL,
    bio NVARCHAR(256),
    profile_picture NVARCHAR (500),
    profile_created_datetime DATETIME DEFAULT GETUTCDATE(),
    profile_updated_datetime DATETIME DEFAULT GETUTCDATE(),

    CONSTRAINT UC__users__email UNIQUE (email)
);