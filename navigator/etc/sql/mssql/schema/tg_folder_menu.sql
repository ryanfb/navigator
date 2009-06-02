CREATE TRIGGER trig_folder_menu ON FOLDER_MENU FOR DELETE
AS
DECLARE @MenuID INT
SELECT @MenuID = (SELECT MENU_ID FROM Deleted)
DELETE FROM FOLDER_MENU WHERE PARENT_ID = @MenuID
;