CREATE PROCEDURE [dbo].[sp_Add_Downvotes_To_Answer]      
(      
	@answer_id BIGINT,
    @downvotes_to_add INT
)      
AS
BEGIN  
    SET NOCOUNT ON; 
    BEGIN TRY
        BEGIN TRAN
            UPDATE [dbo].[answers] set downvotes = downvotes + @downvotes_to_add where answer_id = @answer_id;
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        IF(@@TRANCOUNT > 0)
            ROLLBACK TRAN;
        THROW; 
    END CATCH
END