CREATE PROCEDURE [dbo].[sp_Follow_Question]      
(      
	@follower_user_id BIGINT,
    @followed_question_id BIGINT
)      
AS
BEGIN  
    SET NOCOUNT ON; 
    BEGIN TRY
        BEGIN TRAN
            INSERT INTO [dbo].[follow_question] (follower_user_id, followed_question_id) values (@follower_user_id,@followed_question_id);
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        IF(@@TRANCOUNT > 0)
            ROLLBACK TRAN;
        THROW; 
    END CATCH
END