CREATE PROCEDURE [dbo].[sp_InsertUserTopicMapping]      
(      
    @followed_topic_id BIGINT,
	@follower_user_id BIGINT
)      
AS
BEGIN  
    SET NOCOUNT ON; 
    BEGIN TRY
        BEGIN TRAN
            INSERT INTO [dbo].[follow_topic] (follower_user_id, followed_topic_id) values (@followed_topic_id,@follower_user_id);
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        IF(@@TRANCOUNT > 0)
            ROLLBACK TRAN;
        THROW; 
    END CATCH
END