-- =============================================================================
-- MP Module - Help Content and Display Name Updates
-- =============================================================================
-- Run as System (AD_Client_ID = 0)
-- Test first, then include in 2Pack if OK
-- =============================================================================

-- -----------------------------------------------------------------------------
-- MP_Meter columns
-- -----------------------------------------------------------------------------
UPDATE AD_Element SET
    Name = 'Max Days',
    PrintName = 'Max Days',
    Help = 'Maximum days allowed between meter readings. Used to validate meter log entries are recorded regularly.'
WHERE ColumnName = 'MaxDay' AND AD_Client_ID = 0;

UPDATE AD_Column SET Help = (SELECT Help FROM AD_Element WHERE ColumnName = 'MaxDay' AND AD_Client_ID = 0)
WHERE ColumnName = 'MaxDay' AND Help IS NULL;

-- -----------------------------------------------------------------------------
-- MP_JobStandar columns
-- -----------------------------------------------------------------------------
UPDATE AD_Element SET
    Name = 'Job Standard Type',
    PrintName = 'Job Type',
    Help = 'Type of standard job: AA = Routine/Preventive maintenance, BB = Corrective maintenance'
WHERE ColumnName = 'JobStandarType' AND AD_Client_ID = 0;

UPDATE AD_Column SET Help = (SELECT Help FROM AD_Element WHERE ColumnName = 'JobStandarType' AND AD_Client_ID = 0)
WHERE ColumnName = 'JobStandarType' AND Help IS NULL;

UPDATE AD_Element SET
    Name = 'Maintain Area',
    PrintName = 'Area',
    Help = 'Maintenance area classification: ME = Mechanical, EL = Electrical'
WHERE ColumnName = 'MaintainArea' AND AD_Client_ID = 0;

UPDATE AD_Column SET Help = (SELECT Help FROM AD_Element WHERE ColumnName = 'MaintainArea' AND AD_Client_ID = 0)
WHERE ColumnName = 'MaintainArea' AND Help IS NULL;

-- -----------------------------------------------------------------------------
-- MP_Maintain columns
-- -----------------------------------------------------------------------------
UPDATE AD_Element SET
    Name = 'Is Child',
    PrintName = 'Child',
    Help = 'Indicates this maintenance schedule is a child linked to a parent maintenance. Child schedules inherit settings from parent.'
WHERE ColumnName = 'IsChild' AND AD_Client_ID = 0;

UPDATE AD_Column SET Help = (SELECT Help FROM AD_Element WHERE ColumnName = 'IsChild' AND AD_Client_ID = 0)
WHERE ColumnName = 'IsChild' AND Help IS NULL;

UPDATE AD_Element SET
    Name = 'Current MP',
    PrintName = 'Current MP',
    Help = 'Current meter point reading for this asset. Updated from Meter Log entries.'
WHERE ColumnName = 'currentmp' AND AD_Client_ID = 0;

UPDATE AD_Column SET Help = (SELECT Help FROM AD_Element WHERE ColumnName = 'currentmp' AND AD_Client_ID = 0)
WHERE ColumnName = 'currentmp' AND Help IS NULL;

UPDATE AD_Element SET
    Name = 'Date Last OT',
    PrintName = 'Last OT Date',
    Help = 'Date when the last Work Order (OT) was generated for this maintenance schedule.'
WHERE ColumnName = 'DateLastOT' AND AD_Client_ID = 0;

UPDATE AD_Column SET Help = (SELECT Help FROM AD_Element WHERE ColumnName = 'DateLastOT' AND AD_Client_ID = 0)
WHERE ColumnName = 'DateLastOT' AND Help IS NULL;

UPDATE AD_Element SET
    Name = 'Date Last Run MP',
    PrintName = 'Last Run Date',
    Help = 'Date when meter-based maintenance was last performed.'
WHERE ColumnName = 'datelastrunmp' AND AD_Client_ID = 0;

UPDATE AD_Column SET Help = (SELECT Help FROM AD_Element WHERE ColumnName = 'datelastrunmp' AND AD_Client_ID = 0)
WHERE ColumnName = 'datelastrunmp' AND Help IS NULL;

UPDATE AD_Element SET
    Name = 'Last MP',
    PrintName = 'Last MP',
    Help = 'Last meter point when maintenance was performed. Used to calculate next maintenance due point.'
WHERE ColumnName = 'lastmp' AND AD_Client_ID = 0;

UPDATE AD_Column SET Help = (SELECT Help FROM AD_Element WHERE ColumnName = 'lastmp' AND AD_Client_ID = 0)
WHERE ColumnName = 'lastmp' AND Help IS NULL;

UPDATE AD_Element SET
    Name = 'Last Read',
    PrintName = 'Last Read',
    Help = 'Last meter reading value recorded from Meter Log.'
WHERE ColumnName = 'lastread' AND AD_Client_ID = 0;

UPDATE AD_Column SET Help = (SELECT Help FROM AD_Element WHERE ColumnName = 'lastread' AND AD_Client_ID = 0)
WHERE ColumnName = 'lastread' AND Help IS NULL;

UPDATE AD_Element SET
    Name = 'Next MP',
    PrintName = 'Next MP',
    Help = 'Next meter point when maintenance is due. Calculated as Last MP + Interval.'
WHERE ColumnName = 'nextmp' AND AD_Client_ID = 0;

UPDATE AD_Column SET Help = (SELECT Help FROM AD_Element WHERE ColumnName = 'nextmp' AND AD_Client_ID = 0)
WHERE ColumnName = 'nextmp' AND Help IS NULL;

UPDATE AD_Element SET
    Name = 'Programming Type',
    PrintName = 'Type',
    Help = 'Maintenance scheduling type: C = Calendar-based (triggered by days interval), M = Meter-based (triggered by usage/meter readings)'
WHERE ColumnName = 'ProgrammingType' AND AD_Client_ID = 0;

UPDATE AD_Column SET Help = (SELECT Help FROM AD_Element WHERE ColumnName = 'ProgrammingType' AND AD_Client_ID = 0)
WHERE ColumnName = 'ProgrammingType' AND Help IS NULL;

UPDATE AD_Element SET
    Name = 'Prom Use',
    PrintName = 'Warning',
    Help = 'Warning threshold (Prognosis Use). Triggers maintenance alert when current reading reaches Next MP minus this value.'
WHERE ColumnName = 'promuse' AND AD_Client_ID = 0;

UPDATE AD_Column SET Help = (SELECT Help FROM AD_Element WHERE ColumnName = 'promuse' AND AD_Client_ID = 0)
WHERE ColumnName = 'promuse' AND Help IS NULL;

UPDATE AD_Element SET
    Name = 'Range',
    PrintName = 'Range',
    Help = 'Tolerance range for maintenance due point. Maintenance is considered due when reading is within Next MP +/- Range.'
WHERE ColumnName = 'Range' AND AD_Client_ID = 0
AND EXISTS (SELECT 1 FROM AD_Column c JOIN AD_Table t ON c.AD_Table_ID = t.AD_Table_ID
            WHERE c.ColumnName = 'Range' AND t.TableName LIKE 'MP_%');

UPDATE AD_Column SET Help = 'Tolerance range for maintenance due point. Maintenance is considered due when reading is within Next MP +/- Range.'
WHERE ColumnName = 'Range' AND Help IS NULL
AND AD_Table_ID IN (SELECT AD_Table_ID FROM AD_Table WHERE TableName LIKE 'MP_%');

-- -----------------------------------------------------------------------------
-- MP_Maintain Parent link
-- -----------------------------------------------------------------------------
UPDATE AD_Element SET
    Name = 'Parent Maintenance',
    PrintName = 'Parent',
    Help = 'Link to parent maintenance schedule. Child maintenance schedules can inherit settings and be triggered together with parent.'
WHERE ColumnName = 'MP_MaintainParent_ID' AND AD_Client_ID = 0;

UPDATE AD_Column SET Help = (SELECT Help FROM AD_Element WHERE ColumnName = 'MP_MaintainParent_ID' AND AD_Client_ID = 0)
WHERE ColumnName = 'MP_MaintainParent_ID' AND Help IS NULL;

-- -----------------------------------------------------------------------------
-- AFTER RUNNING THIS SCRIPT:
-- 1. Run "Synchronize Terminology" from System Admin → General Rules → System Rules
-- 2. Reset Cache
-- -----------------------------------------------------------------------------

-- Verify changes
SELECT e.ColumnName, e.Name, e.PrintName, e.Help
FROM AD_Element e
WHERE e.ColumnName IN ('MaxDay', 'JobStandarType', 'MaintainArea', 'IsChild',
    'currentmp', 'DateLastOT', 'datelastrunmp', 'lastmp', 'lastread',
    'nextmp', 'ProgrammingType', 'promuse', 'Range', 'MP_MaintainParent_ID')
AND e.AD_Client_ID = 0
ORDER BY e.ColumnName;
