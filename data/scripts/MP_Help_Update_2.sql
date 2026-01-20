-- =============================================================================
-- MP Module - Help Content Update Part 2
-- =============================================================================
-- Columns, Windows, and Tabs
-- =============================================================================

-- -----------------------------------------------------------------------------
-- RESOURCE COLUMNS (shared across tables)
-- -----------------------------------------------------------------------------
UPDATE AD_Element SET
    Name = 'Cost Amount',
    PrintName = 'Cost',
    Help = 'Cost amount for the resource. Used to calculate total maintenance cost.'
WHERE ColumnName = 'CostAmt' AND AD_Client_ID = 0
AND Help IS NULL;

UPDATE AD_Element SET
    Name = 'Resource Quantity',
    PrintName = 'Qty',
    Help = 'Quantity of the resource required for this task.'
WHERE ColumnName = 'ResourceQty' AND AD_Client_ID = 0;

UPDATE AD_Element SET
    Name = 'Resource Type',
    PrintName = 'Type',
    Help = 'Type of resource: Labor, Material, Tool, or External Service.'
WHERE ColumnName = 'ResourceType' AND AD_Client_ID = 0
AND Help IS NULL;

-- -----------------------------------------------------------------------------
-- METER LOG COLUMNS
-- -----------------------------------------------------------------------------
UPDATE AD_Element SET
    Name = 'Current Amount',
    PrintName = 'Current',
    Help = 'Current meter reading amount entered in this log entry.'
WHERE ColumnName = 'CurrentAmt' AND AD_Client_ID = 0;

-- -----------------------------------------------------------------------------
-- PROGNOSIS COLUMNS
-- -----------------------------------------------------------------------------
UPDATE AD_Element SET
    Name = 'Cycle',
    PrintName = 'Cycle',
    Help = 'Maintenance cycle number. Indicates which iteration of recurring maintenance this represents.'
WHERE ColumnName = 'ciclo' AND AD_Client_ID = 0;

UPDATE AD_Element SET
    Name = 'Selected',
    PrintName = 'Selected',
    Help = 'Indicates this prognosis record has been selected for Work Order generation.'
WHERE ColumnName = 'selected' AND AD_Client_ID = 0;

-- -----------------------------------------------------------------------------
-- OT REQUEST COLUMNS
-- -----------------------------------------------------------------------------
UPDATE AD_Element SET
    Name = 'Date Required',
    PrintName = 'Required',
    Help = 'Date when the maintenance work is required to be completed.'
WHERE ColumnName = 'DateRequired' AND AD_Client_ID = 0
AND Help IS NULL;

UPDATE AD_Element SET
    Name = 'Request Type',
    PrintName = 'Request Type',
    Help = 'Type of maintenance request: Scheduled, Emergency, or User Requested.'
WHERE ColumnName = 'OT_Request_Type' AND AD_Client_ID = 0;

-- -----------------------------------------------------------------------------
-- INTERVAL (MP_Maintain specific)
-- -----------------------------------------------------------------------------
UPDATE AD_Column SET
    Help = 'Interval between maintenance: For Calendar type = days between runs. For Meter type = usage units between maintenance.'
WHERE ColumnName = 'Interval'
AND AD_Table_ID = (SELECT AD_Table_ID FROM AD_Table WHERE TableName = 'MP_Maintain')
AND (Help IS NULL OR Help = '');

-- -----------------------------------------------------------------------------
-- WINDOWS
-- -----------------------------------------------------------------------------
UPDATE AD_Window SET
    Help = 'Define meter types used to track asset usage. Meters measure quantities like kilometers, operating hours, or production cycles.'
WHERE Name = 'Meter'
AND (Help IS NULL OR Help = '');

UPDATE AD_Window SET
    Help = 'Schedule and manage preventive maintenance for assets. Define maintenance intervals based on calendar dates or meter readings.'
WHERE Name = 'Preventive Maintenance'
AND (Help IS NULL OR Help = '');

UPDATE AD_Window SET
    Help = 'Create maintenance requests for unscheduled or emergency work. Requests can be approved and converted to Work Orders.'
WHERE Name = 'Request OT'
AND (Help IS NULL OR Help = '');

-- -----------------------------------------------------------------------------
-- TABS
-- -----------------------------------------------------------------------------
UPDATE AD_Tab SET
    Help = 'Define maintenance schedules for assets. Set programming type (Calendar or Meter), intervals, and link to Standard Jobs.'
WHERE Name = 'Maintenance'
AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Preventive Maintenance')
AND (Help IS NULL OR Help = '');

UPDATE AD_Tab SET
    Help = 'Configure meter settings including name and maximum days between readings.'
WHERE Name = 'Meter'
AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Meter')
AND (Help IS NULL OR Help = '');

UPDATE AD_Tab SET
    Help = 'Maintenance request details. Specify required date, priority, and link to Standard Job template.'
WHERE Name = 'Request'
AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Request OT')
AND (Help IS NULL OR Help = '');

UPDATE AD_Tab SET
    Help = 'Resources assigned to this task: labor, materials, tools, or external services with quantities and costs.'
WHERE Name = 'Resources'
AND AD_Window_ID IN (SELECT AD_Window_ID FROM AD_Window WHERE Name IN ('Preventive Maintenance', 'Standard Job', 'Work Order (OT)'))
AND (Help IS NULL OR Help = '');

UPDATE AD_Tab SET
    Help = 'Individual tasks to be performed as part of this maintenance job. Each task has duration and can have assigned resources.'
WHERE Name = 'Tasks'
AND AD_Window_ID IN (SELECT AD_Window_ID FROM AD_Window WHERE Name IN ('Preventive Maintenance', 'Standard Job', 'Work Order (OT)'))
AND (Help IS NULL OR Help = '');

-- -----------------------------------------------------------------------------
-- AFTER RUNNING THIS SCRIPT:
-- 1. Run "Synchronize Terminology" from System Admin → General Rules → System Rules
-- 2. Reset Cache
-- -----------------------------------------------------------------------------

-- Verify changes
SELECT 'ELEMENT' as Type, ColumnName as Name, Help
FROM AD_Element
WHERE ColumnName IN ('CostAmt', 'ResourceQty', 'ResourceType', 'CurrentAmt', 'ciclo', 'selected', 'DateRequired', 'OT_Request_Type')
AND AD_Client_ID = 0
UNION ALL
SELECT 'WINDOW', Name, Help FROM AD_Window WHERE Name IN ('Meter', 'Preventive Maintenance', 'Request OT')
UNION ALL
SELECT 'TAB', Name, Help FROM AD_Tab WHERE Name IN ('Maintenance', 'Meter', 'Request', 'Resources', 'Tasks')
AND AD_Window_ID IN (SELECT AD_Window_ID FROM AD_Window WHERE Name IN ('Preventive Maintenance', 'Meter', 'Request OT', 'Standard Job', 'Work Order (OT)'))
ORDER BY 1, 2;
