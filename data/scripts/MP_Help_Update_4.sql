-- =============================================================================
-- MP Module - Help Content Update Part 4
-- =============================================================================
-- Field-level overrides (IsCentrallyMaintained = N) and Process Help
-- ONLY touches MP module items (EntityType = 'U')
-- Does NOT touch core iDempiere elements (EntityType = 'D')
-- =============================================================================

-- -----------------------------------------------------------------------------
-- AD_FIELD: Set IsCentrallyMaintained = 'N' for MP-specific field Help
-- This prevents Synchronize Terminology from overwriting with generic text
-- -----------------------------------------------------------------------------

-- ProgrammingType field in Preventive Maintenance window
-- Controls which fields are displayed via DisplayLogic
UPDATE AD_Field SET
    IsCentrallyMaintained = 'N',
    Help = 'Maintenance scheduling type: C = Calendar-based (triggered by days interval), M = Meter-based (triggered by usage/meter readings). Calendar (C) shows: Date Last Run, Date Next Run, Interval (days). Meter (M) shows: Last MP, Next MP, Current MP, Interval (usage units).'
WHERE AD_Field_ID = 61774;

-- DateLastRun field in Preventive Maintenance window
-- DisplayLogic: @ProgrammingType@=C (only shows for Calendar-based)
UPDATE AD_Field SET
    IsCentrallyMaintained = 'N',
    Help = 'Date when this maintenance schedule was last executed. For Calendar-based maintenance, this is used with Interval to calculate Date Next Run. (Shows when Programming Type = C)'
WHERE AD_Field_ID = 61780;

-- DateNextRun field in Preventive Maintenance window
-- DisplayLogic: @ProgrammingType@=C (only shows for Calendar-based)
UPDATE AD_Field SET
    IsCentrallyMaintained = 'N',
    Help = 'Date when this maintenance is next due. For Calendar-based maintenance, calculated as Date Last Run + Interval days. (Shows when Programming Type = C)'
WHERE AD_Field_ID = 61781;

-- Next MP field in Preventive Maintenance window
-- DisplayLogic: @ProgrammingType@=M (only shows for Meter-based)
UPDATE AD_Field SET
    IsCentrallyMaintained = 'N',
    Help = 'Next meter point when maintenance is due. Calculated as Last MP + Interval. (Shows when Programming Type = M)'
WHERE AD_Field_ID = 61778;

-- Interval field in Preventive Maintenance window
UPDATE AD_Field SET
    IsCentrallyMaintained = 'N',
    Help = 'Maintenance interval. For Calendar-based (C): number of days between maintenance runs. For Meter-based (M): usage units between maintenance (e.g., 5000 km, 250 hours).'
WHERE AD_Field_ID = 61776;

-- -----------------------------------------------------------------------------
-- AD_PROCESS: Add Help and Description for MP Processes
-- All are EntityType = 'U' (MP module specific)
-- -----------------------------------------------------------------------------

-- MPCopyFromSJ - Copy From Standard Job process
UPDATE AD_Process SET
    Description = 'Copy tasks and resources from a Standard Job template to this maintenance schedule.',
    Help = 'Copies all tasks and resources defined in the selected Standard Job to the current Maintenance schedule. Use this to quickly set up maintenance based on predefined job templates instead of entering tasks manually.'
WHERE AD_Process_ID = 53257;

-- MPProcessOT - Process Work Order
UPDATE AD_Process SET
    Description = 'Process the Work Order to complete or void it.',
    Help = 'Changes the document status of the Work Order. Complete: marks all tasks as done and closes the Work Order. Void: cancels the Work Order without execution.'
WHERE AD_Process_ID = 53258;

-- ProcessRequestOT - Process Maintenance Request
UPDATE AD_Process SET
    Description = 'Approve or reject the maintenance request.',
    Help = 'Changes the status of the maintenance request. Approved requests can be converted to Work Orders for execution. Rejected requests are closed without action.'
WHERE AD_Process_ID = 53256;

-- MP Prognosis - Update existing Help to be more complete
UPDATE AD_Process SET
    Description = 'Forecast upcoming maintenance based on meter readings and calendar schedules.',
    Help = 'Analyzes all active Maintenance schedules and generates Prognosis records for upcoming work. For Meter-based: compares Current MP against Next MP. For Calendar-based: compares current date against Date Next Run. Results appear in Prognosis window for review and approval.'
WHERE AD_Process_ID = 53255;

-- -----------------------------------------------------------------------------
-- AD_FORM: Add Help and Description for MP Forms
-- All are EntityType = 'U' (MP module specific)
-- -----------------------------------------------------------------------------

-- VMPRequestOT - Request OT Form
UPDATE AD_Form SET
    Description = 'Create and manage maintenance requests for approval.',
    Help = 'Form to create maintenance requests for unscheduled or emergency work. Select asset, specify required date and priority, then submit for approval. Approved requests become Work Orders.'
WHERE AD_Form_ID = 53023;

-- VMPGenerateOT - Generate OT Form
UPDATE AD_Form SET
    Description = 'Generate Work Orders from approved Prognosis records.',
    Help = 'Form to convert approved Prognosis forecasts into Work Orders. Select Prognosis records and generate OTs for execution. Links maintenance schedules to actual work execution.'
WHERE AD_Form_ID = 53021;

-- -----------------------------------------------------------------------------
-- VERIFICATION QUERIES
-- -----------------------------------------------------------------------------

-- Verify Field updates
SELECT 'FIELD' as Type, f.Name, f.IsCentrallyMaintained as Central, LEFT(f.Help, 60) as Help
FROM AD_Field f
WHERE f.AD_Field_ID IN (61774, 61776, 61778, 61780, 61781);

-- Verify Process updates
SELECT 'PROCESS' as Type, p.Name, LEFT(p.Description, 40) as Descr, LEFT(p.Help, 50) as Help
FROM AD_Process p
WHERE p.AD_Process_ID IN (53255, 53256, 53257, 53258);

-- Verify Form updates
SELECT 'FORM' as Type, f.Name, LEFT(f.Description, 40) as Descr, LEFT(f.Help, 50) as Help
FROM AD_Form f
WHERE f.AD_Form_ID IN (53021, 53023);

-- -----------------------------------------------------------------------------
-- NOTES:
-- 1. Field IDs are specific to this installation - verify before running elsewhere
-- 2. After running: Reset Cache (no Synchronize Terminology needed for fields)
-- 3. Core Department/Cost Center windows are NOT touched (EntityType = 'D')
-- -----------------------------------------------------------------------------
