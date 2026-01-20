-- =============================================================================
-- MP Module - Rename Spanish Acronyms to Proper English Names
-- =============================================================================
-- OT = "Orden de Trabajo" (Spanish for Work Order)
-- SJ = "Standard Job"
-- VMP = Module prefix (kept in internal classnames)
-- =============================================================================
-- All items are EntityType = 'U' (MP module specific - safe to modify)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- AD_FORM - Rename forms (Name shown in menu and form title)
-- -----------------------------------------------------------------------------
UPDATE AD_Form SET Name = 'Generate Work Order' WHERE AD_Form_ID = 53021;  -- Was: VMPGenerateOT
UPDATE AD_Form SET Name = 'Submit Maintenance Request' WHERE AD_Form_ID = 53023;  -- Was: VMPRequestOT

-- -----------------------------------------------------------------------------
-- AD_PROCESS - Rename processes (Name shown in gear menu and process dialog)
-- -----------------------------------------------------------------------------
UPDATE AD_Process SET Name = 'Copy From Standard Job' WHERE AD_Process_ID = 53257;  -- Was: MPCopyFromSJ
UPDATE AD_Process SET Name = 'Process Work Order' WHERE AD_Process_ID = 53258;  -- Was: MPProcessOT
UPDATE AD_Process SET Name = 'Process Maintenance Request' WHERE AD_Process_ID = 53256;  -- Was: ProcessRequestOT
UPDATE AD_Process SET Name = 'Maintenance Forecast' WHERE AD_Process_ID = 53255;  -- Was: MP Prognosis

-- -----------------------------------------------------------------------------
-- AD_WINDOW - Rename windows
-- -----------------------------------------------------------------------------
UPDATE AD_Window SET Name = 'Maintenance Request' WHERE AD_Window_ID = 53141;  -- Was: Request OT
-- Work Order (53145) already has proper name

-- -----------------------------------------------------------------------------
-- AD_MENU - Update menu entries to match
-- -----------------------------------------------------------------------------
UPDATE AD_Menu SET Name = 'Maintenance Request' WHERE AD_Menu_ID = 53345;  -- Was: Request OT
UPDATE AD_Menu SET Name = 'Generate Work Order' WHERE AD_Menu_ID = 53344;  -- Was: VMPGenerateOT
UPDATE AD_Menu SET Name = 'Submit Maintenance Request' WHERE AD_Menu_ID = 53346;  -- Was: VMPRequestOT
UPDATE AD_Menu SET Name = 'Maintenance Forecast' WHERE AD_Menu_ID = 53343;  -- Was: MP Prognosis

-- -----------------------------------------------------------------------------
-- VERIFICATION
-- -----------------------------------------------------------------------------
SELECT 'FORM' as Type, AD_Form_ID as ID, Name FROM AD_Form WHERE AD_Form_ID IN (53021, 53023)
UNION ALL
SELECT 'PROCESS', AD_Process_ID, Name FROM AD_Process WHERE AD_Process_ID IN (53255, 53256, 53257, 53258)
UNION ALL
SELECT 'WINDOW', AD_Window_ID, Name FROM AD_Window WHERE AD_Window_ID = 53141
UNION ALL
SELECT 'MENU', AD_Menu_ID, Name FROM AD_Menu WHERE AD_Menu_ID IN (53343, 53344, 53345, 53346)
ORDER BY 1, 3;

-- -----------------------------------------------------------------------------
-- NOTES:
-- 1. Internal class names (e.g., VMPGenerateOT.java) remain unchanged
-- 2. Only display names are updated for user-facing clarity
-- 3. After running: Reset Cache
-- -----------------------------------------------------------------------------
