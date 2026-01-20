-- =============================================================================
-- MP Module - Help Content Update Part 3
-- =============================================================================
-- Missing Windows and Tabs
-- =============================================================================

-- -----------------------------------------------------------------------------
-- WINDOWS
-- -----------------------------------------------------------------------------
UPDATE AD_Window SET
    Help = 'Define standard job templates with tasks and resources. Standard Jobs can be copied to Maintenance schedules using the Copy From button.'
WHERE Name = 'Job Standard'
AND (Help IS NULL OR Help = '');

UPDATE AD_Window SET
    Help = 'Work Orders (OT) are generated from approved Prognosis or Requests. Complete tasks and process to close the Work Order.'
WHERE Name = 'Work Order'
AND (Help IS NULL OR Help = '');

-- -----------------------------------------------------------------------------
-- TABS for Job Standard
-- -----------------------------------------------------------------------------
UPDATE AD_Tab SET
    Help = 'Define standard job header with job type (Routine/Corrective) and maintenance area (Mechanical/Electrical).'
WHERE Name = 'Job Standard'
AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Job Standard')
AND (Help IS NULL OR Help = '');

UPDATE AD_Tab SET
    Help = 'Tasks to be performed as part of this standard job. Each task has description and estimated duration.'
WHERE Name = 'Task'
AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Job Standard')
AND (Help IS NULL OR Help = '');

UPDATE AD_Tab SET
    Help = 'Resources required for each task: labor, materials, tools with quantities and costs.'
WHERE Name = 'Resource'
AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Job Standard')
AND (Help IS NULL OR Help = '');

-- -----------------------------------------------------------------------------
-- TABS for Work Order (tab names: Order, Tasks, Resources)
-- -----------------------------------------------------------------------------
UPDATE AD_Tab SET
    Help = 'Work Order header with document status, dates, and linked maintenance schedule.'
WHERE Name = 'Order'
AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Work Order')
AND (Help IS NULL OR Help = '');

UPDATE AD_Tab SET
    Help = 'Tasks to complete for this Work Order. Mark each task complete before processing the Work Order.'
WHERE Name = 'Tasks'
AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Work Order')
AND (Help IS NULL OR Help = '');

UPDATE AD_Tab SET
    Help = 'Resources used for each task with actual quantities and costs.'
WHERE Name = 'Resources'
AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Work Order')
AND (Help IS NULL OR Help = '');

-- -----------------------------------------------------------------------------
-- TABS for Asset (Asset Meter sub-tab)
-- -----------------------------------------------------------------------------
UPDATE AD_Tab SET
    Help = 'Link meters to this asset. Each asset can have multiple meters (e.g., kilometers, operating hours).'
WHERE Name = 'Asset Meter'
AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Asset')
AND (Help IS NULL OR Help = '');

-- -----------------------------------------------------------------------------
-- AFTER RUNNING THIS SCRIPT:
-- 1. Run "Synchronize Terminology" from System Admin → General Rules → System Rules
-- 2. Reset Cache
-- -----------------------------------------------------------------------------

-- Verify changes
SELECT 'WINDOW' as Type, Name, LEFT(Help, 60) as Help
FROM AD_Window
WHERE Name IN ('Job Standard', 'Work Order')
UNION ALL
SELECT 'TAB', t.Name, LEFT(t.Help, 60)
FROM AD_Tab t
JOIN AD_Window w ON t.AD_Window_ID = w.AD_Window_ID
WHERE w.Name IN ('Job Standard', 'Work Order')
AND t.Name IN ('Job Standard', 'Work Order', 'Task', 'Resource')
ORDER BY 1, 2;
