CREATE PROCEDURE [dbo].[sp_UnfollowQuestion]      
(      
	@unfollower_user_id BIGINT,
    @unfollowed_question_id BIGINT
)      
AS
BEGIN  
    SET NOCOUNT ON; 
    BEGIN TRY
        BEGIN TRAN
            DELETE FROM [dbo].[follow_question] where follower_user_id = @unfollower_user_id and followed_question_id = @unfollowed_question_id;
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        IF(@@TRANCOUNT > 0)
            ROLLBACK TRAN;
        THROW; 
    END CATCH
END