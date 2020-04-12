CREATE PROCEDURE [dbo].[sp_UnfollowTopic]      
(      
    @unfollowed_topic_id BIGINT,
	@unfollower_user_id BIGINT
)      
AS
BEGIN  
    SET NOCOUNT ON; 
    BEGIN TRY
        BEGIN TRAN
            DELETE FROM [dbo].[follow_topic] where follower_user_id = @unfollower_user_id and followed_topic_id = @unfollowed_topic_id;
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        IF(@@TRANCOUNT > 0)
            ROLLBACK TRAN;
        THROW; 
    END CATCH
END