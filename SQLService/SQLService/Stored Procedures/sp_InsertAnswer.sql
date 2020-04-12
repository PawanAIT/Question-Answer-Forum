 CREATE PROCEDURE [dbo].[sp_InsertAnswer]      
(      
    @answer_text NVARCHAR (MAX),
    @answer_poster_id BIGINT,
    @question_id BIGINT
)      
AS
BEGIN  
    SET NOCOUNT ON; 
    BEGIN TRY
        BEGIN TRAN
            INSERT INTO [dbo].[answers] ([answer_text],[answer_poster_id],[question_id]) values (@answer_text, @answer_poster_id ,@question_id)
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        IF(@@TRANCOUNT > 0)
            ROLLBACK TRAN;
        THROW; 
    END CATCH
END