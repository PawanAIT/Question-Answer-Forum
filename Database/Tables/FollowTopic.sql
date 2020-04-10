CREATE TABLE [dbo].[follow_topic]
(
    followed_topic_id BIGINT,
    follower_user_id BIGINT,
    PRIMARY KEY (followed_topic_id, follower_user_id),
    FOREIGN KEY (followed_topic_id) REFERENCES [dbo].[topics] (topic_id),
    FOREIGN KEY (follower_user_id) REFERENCES [dbo].[users] (user_id)
);