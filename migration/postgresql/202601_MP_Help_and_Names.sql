-- =============================================================================
-- MP Module - Help Content and Name Updates
-- =============================================================================
-- Migration script to add Help content and rename Spanish acronyms
-- Run automatically after 2Pack installation
-- All items are EntityType = 'U' (MP module specific)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- AD_ELEMENT - Core column Help text
-- -----------------------------------------------------------------------------
UPDATE AD_Element SET
    Name = 'Max Days', PrintName = 'Max Days',
    Help = 'Maximum days allowed between meter readings. Used to validate meter log entries are recorded regularly.'
WHERE ColumnName = 'MaxDay' AND AD_Client_ID = 0;

UPDATE AD_Element SET
    Name = 'Job Standard Type', PrintName = 'Job Type',
    Help = 'Type of standard job: AA = Routine/Preventive maintenance, BB = Corrective maintenance'
WHERE ColumnName = 'JobStandarType' AND AD_Client_ID = 0;

UPDATE AD_Element SET
    Name = 'Maintain Area', PrintName = 'Area',
    Help = 'Maintenance area classification: ME = Mechanical, EL = Electrical'
WHERE ColumnName = 'MaintainArea' AND AD_Client_ID = 0;

UPDATE AD_Element SET
    Name = 'Is Child', PrintName = 'Child',
    Help = 'Indicates this maintenance schedule is a child linked to a parent maintenance.'
WHERE ColumnName = 'IsChild' AND AD_Client_ID = 0;

UPDATE AD_Element SET
    Name = 'Current MP', PrintName = 'Current MP',
    Help = 'Current meter point reading for this asset. Updated from Meter Log entries.'
WHERE ColumnName = 'currentmp' AND AD_Client_ID = 0;

UPDATE AD_Element SET
    Name = 'Date Last OT', PrintName = 'Last OT Date',
    Help = 'Date when the last Work Order was generated for this maintenance schedule.'
WHERE ColumnName = 'DateLastOT' AND AD_Client_ID = 0;

UPDATE AD_Element SET
    Name = 'Date Last Run MP', PrintName = 'Last Run Date',
    Help = 'Date when meter-based maintenance was last performed.'
WHERE ColumnName = 'datelastrunmp' AND AD_Client_ID = 0;

UPDATE AD_Element SET
    Name = 'Last MP', PrintName = 'Last MP',
    Help = 'Last meter point when maintenance was performed. Used to calculate next maintenance due point.'
WHERE ColumnName = 'lastmp' AND AD_Client_ID = 0;

UPDATE AD_Element SET
    Name = 'Last Read', PrintName = 'Last Read',
    Help = 'Last meter reading value recorded from Meter Log.'
WHERE ColumnName = 'lastread' AND AD_Client_ID = 0;

UPDATE AD_Element SET
    Name = 'Next MP', PrintName = 'Next MP',
    Help = 'Next meter point when maintenance is due. Calculated as Last MP + Interval.'
WHERE ColumnName = 'nextmp' AND AD_Client_ID = 0;

UPDATE AD_Element SET
    Name = 'Programming Type', PrintName = 'Type',
    Help = 'Maintenance scheduling type: C = Calendar-based (triggered by days interval), M = Meter-based (triggered by usage/meter readings)'
WHERE ColumnName = 'ProgrammingType' AND AD_Client_ID = 0;

UPDATE AD_Element SET
    Name = 'Prom Use', PrintName = 'Warning',
    Help = 'Warning threshold. Triggers maintenance alert when current reading reaches Next MP minus this value.'
WHERE ColumnName = 'promuse' AND AD_Client_ID = 0;

UPDATE AD_Element SET
    Name = 'Parent Maintenance', PrintName = 'Parent',
    Help = 'Link to parent maintenance schedule. Child schedules can inherit settings.'
WHERE ColumnName = 'MP_MaintainParent_ID' AND AD_Client_ID = 0;

UPDATE AD_Element SET
    Name = 'Cost Amount', PrintName = 'Cost',
    Help = 'Cost amount for the resource. Used to calculate total maintenance cost.'
WHERE ColumnName = 'CostAmt' AND AD_Client_ID = 0 AND Help IS NULL;

UPDATE AD_Element SET
    Name = 'Resource Quantity', PrintName = 'Qty',
    Help = 'Quantity of the resource required for this task.'
WHERE ColumnName = 'ResourceQty' AND AD_Client_ID = 0;

UPDATE AD_Element SET
    Name = 'Resource Type', PrintName = 'Type',
    Help = 'Type of resource: Labor, Material, Tool, or External Service.'
WHERE ColumnName = 'ResourceType' AND AD_Client_ID = 0 AND Help IS NULL;

UPDATE AD_Element SET
    Name = 'Current Amount', PrintName = 'Current',
    Help = 'Current meter reading amount entered in this log entry.'
WHERE ColumnName = 'CurrentAmt' AND AD_Client_ID = 0;

UPDATE AD_Element SET
    Name = 'Cycle', PrintName = 'Cycle',
    Help = 'Maintenance cycle number. Indicates which iteration of recurring maintenance this represents.'
WHERE ColumnName = 'ciclo' AND AD_Client_ID = 0;

UPDATE AD_Element SET
    Name = 'Selected', PrintName = 'Selected',
    Help = 'Indicates this prognosis record has been selected for Work Order generation.'
WHERE ColumnName = 'selected' AND AD_Client_ID = 0;

UPDATE AD_Element SET
    Name = 'Date Required', PrintName = 'Required',
    Help = 'Date when the maintenance work is required to be completed.'
WHERE ColumnName = 'DateRequired' AND AD_Client_ID = 0 AND Help IS NULL;

UPDATE AD_Element SET
    Name = 'Request Type', PrintName = 'Request Type',
    Help = 'Type of maintenance request: Scheduled, Emergency, or User Requested.'
WHERE ColumnName = 'OT_Request_Type' AND AD_Client_ID = 0;

-- -----------------------------------------------------------------------------
-- AD_WINDOW - Help content
-- -----------------------------------------------------------------------------
UPDATE AD_Window SET
    Description = 'Schedule recurring maintenance for assets by calendar or meter',
    Help = 'Schedule and manage preventive maintenance for assets. Define maintenance intervals based on calendar dates or meter readings.'
WHERE Name = 'Preventive Maintenance';

UPDATE AD_Window SET
    Description = 'Define meter types (km, hours, cycles) for tracking asset usage',
    Help = 'Define meter types used to track asset usage. Meters measure quantities like kilometers, operating hours, or production cycles.'
WHERE Name = 'Meter';

UPDATE AD_Window SET
    Description = 'Create reusable job templates with tasks and resources',
    Help = 'Define standard job templates with tasks and resources. Standard Jobs can be copied to Maintenance schedules using the Copy From button.'
WHERE Name = 'Job Standard';

UPDATE AD_Window SET
    Description = 'Submit unscheduled or emergency maintenance requests',
    Help = 'Create maintenance requests for unscheduled or emergency work. Requests can be approved and converted to Work Orders.'
WHERE Name = 'Maintenance Request';

UPDATE AD_Window SET
    Description = 'Execute and complete maintenance work orders',
    Help = 'Work Orders are generated from approved Prognosis or Requests. Complete tasks and process to close the Work Order.'
WHERE Name = 'Work Order';

-- -----------------------------------------------------------------------------
-- AD_TAB - Help content
-- -----------------------------------------------------------------------------
UPDATE AD_Tab SET
    Description = 'Define schedule. Use Gear Icon to copy from Job Standard',
    Help = 'Define maintenance schedules for assets. Set programming type (Calendar or Meter), intervals, and link to Standard Jobs.'
WHERE Name = 'Maintenance' AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Preventive Maintenance');

UPDATE AD_Tab SET
    Description = 'Tasks to perform for this maintenance',
    Help = 'Individual tasks to be performed as part of this maintenance job. Each task has duration and can have assigned resources.'
WHERE Name = 'Tasks' AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Preventive Maintenance');

UPDATE AD_Tab SET
    Description = 'Labor, materials, tools needed for tasks',
    Help = 'Resources assigned to this task: labor, materials, tools, or external services with quantities and costs.'
WHERE Name = 'Resources' AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Preventive Maintenance');

UPDATE AD_Tab SET
    Description = 'Job template header with type and area',
    Help = 'Define standard job header with job type (Routine/Corrective) and maintenance area (Mechanical/Electrical).'
WHERE Name = 'Job Standard' AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Job Standard');

UPDATE AD_Tab SET
    Description = 'Tasks to perform for this job',
    Help = 'Tasks to be performed as part of this standard job. Each task has description and estimated duration.'
WHERE Name = 'Task' AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Job Standard');

UPDATE AD_Tab SET
    Description = 'Labor, materials, tools needed for tasks',
    Help = 'Resources required for each task: labor, materials, tools with quantities and costs.'
WHERE Name = 'Resource' AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Job Standard');

UPDATE AD_Tab SET
    Description = 'Meter definition with name and max days between readings',
    Help = 'Configure meter settings including name and maximum days between readings.'
WHERE Name = 'Meter' AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Meter');

UPDATE AD_Tab SET
    Description = 'Request details with priority and required date',
    Help = 'Maintenance request details. Specify required date, priority, and link to Standard Job template.'
WHERE Name = 'Request' AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Maintenance Request');

UPDATE AD_Tab SET
    Description = 'Work order header with status and dates',
    Help = 'Work Order header with document status, dates, and linked maintenance schedule.'
WHERE Name = 'Order' AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Work Order');

UPDATE AD_Tab SET
    Description = 'Tasks to complete for this work order',
    Help = 'Tasks to complete for this Work Order. Mark each task complete before processing the Work Order.'
WHERE Name = 'Tasks' AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Work Order');

UPDATE AD_Tab SET
    Description = 'Resources used with actual quantities and costs',
    Help = 'Resources used for each task with actual quantities and costs.'
WHERE Name = 'Resources' AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Work Order');

-- -----------------------------------------------------------------------------
-- AD_FIELD - Override Help with IsCentrallyMaintained = 'N'
-- -----------------------------------------------------------------------------
UPDATE AD_Field SET
    IsCentrallyMaintained = 'N',
    Description = 'Pick one! More fields will appear below',
    Help = 'Maintenance scheduling type: C = Calendar-based (triggered by days interval), M = Meter-based (triggered by usage/meter readings). Calendar (C) shows: Date Last Run, Date Next Run, Interval (days). Meter (M) shows: Last MP, Next MP, Current MP, Interval (usage units).'
WHERE AD_Field_ID = 61774;

UPDATE AD_Field SET
    IsCentrallyMaintained = 'N',
    Help = 'Date when this maintenance schedule was last executed. For Calendar-based maintenance, this is used with Interval to calculate Date Next Run. (Shows when Programming Type = C)'
WHERE AD_Field_ID = 61780;

UPDATE AD_Field SET
    IsCentrallyMaintained = 'N',
    Help = 'Date when this maintenance is next due. For Calendar-based maintenance, calculated as Date Last Run + Interval days. (Shows when Programming Type = C)'
WHERE AD_Field_ID = 61781;

UPDATE AD_Field SET
    IsCentrallyMaintained = 'N',
    Description = 'At what reading is maintenance due?',
    Help = 'Next meter point when maintenance is due. Calculated as Last MP + Interval. (Shows when Programming Type = M)'
WHERE AD_Field_ID = 61778;

UPDATE AD_Field SET
    IsCentrallyMaintained = 'N',
    Description = 'How often? Days or usage between maintenance',
    Help = 'Maintenance interval. For Calendar-based (C): number of days between maintenance runs. For Meter-based (M): usage units between maintenance (e.g., 5000 km, 250 hours).'
WHERE AD_Field_ID = 61776;

UPDATE AD_Field SET Description = 'Pick a template first, then click Gear Icon to copy' WHERE AD_Field_ID = 61784;
UPDATE AD_Field SET Description = 'Which meter to track? (only for Meter type)' WHERE AD_Field_ID = 61775;
UPDATE AD_Field SET Description = 'How much buffer before overdue?' WHERE AD_Field_ID = 61777;
UPDATE AD_Field SET Description = 'When to show warning before due?' WHERE AD_Field_ID = 61779;
UPDATE AD_Field SET Description = 'When was last Work Order created?' WHERE AD_Field_ID = 61783;
UPDATE AD_Field SET Description = 'Is this linked to another schedule?' WHERE AD_Field_ID = 61771;
UPDATE AD_Field SET Description = 'Which schedule is this linked to?' WHERE AD_Field_ID = 61772;

-- -----------------------------------------------------------------------------
-- AD_PROCESS - Help content and rename Spanish names
-- -----------------------------------------------------------------------------
UPDATE AD_Process SET
    Name = 'Copy From Standard Job',
    Description = 'Copy tasks and resources from a Standard Job template to this maintenance schedule.',
    Help = 'Copies all tasks and resources defined in the selected Standard Job to the current Maintenance schedule. Use this to quickly set up maintenance based on predefined job templates instead of entering tasks manually.'
WHERE AD_Process_ID = 53257;

UPDATE AD_Process SET
    Name = 'Process Work Order',
    Description = 'Process the Work Order to complete or void it.',
    Help = 'Changes the document status of the Work Order. Complete: marks all tasks as done and closes the Work Order. Void: cancels the Work Order without execution.'
WHERE AD_Process_ID = 53258;

UPDATE AD_Process SET
    Name = 'Process Maintenance Request',
    Description = 'Approve or reject the maintenance request.',
    Help = 'Changes the status of the maintenance request. Approved requests can be converted to Work Orders for execution. Rejected requests are closed without action.'
WHERE AD_Process_ID = 53256;

UPDATE AD_Process SET
    Name = 'Maintenance Forecast',
    Description = 'Forecast upcoming maintenance based on meter readings and calendar schedules.',
    Help = 'Analyzes all active Maintenance schedules and generates Prognosis records for upcoming work. For Meter-based: compares Current MP against Next MP. For Calendar-based: compares current date against Date Next Run. Results appear in Prognosis window for review and approval.'
WHERE AD_Process_ID = 53255;

-- -----------------------------------------------------------------------------
-- AD_FORM - Help content and rename Spanish names
-- -----------------------------------------------------------------------------
UPDATE AD_Form SET
    Name = 'Generate Work Order',
    Description = 'Generate Work Orders from approved Prognosis records.',
    Help = 'Form to convert approved Prognosis forecasts into Work Orders. Select Prognosis records and generate OTs for execution. Links maintenance schedules to actual work execution.'
WHERE AD_Form_ID = 53021;

UPDATE AD_Form SET
    Name = 'Submit Maintenance Request',
    Description = 'Create and manage maintenance requests for approval.',
    Help = 'Form to create maintenance requests for unscheduled or emergency work. Select asset, specify required date and priority, then submit for approval. Approved requests become Work Orders.'
WHERE AD_Form_ID = 53023;

-- -----------------------------------------------------------------------------
-- AD_WINDOW - Rename Spanish names
-- -----------------------------------------------------------------------------
UPDATE AD_Window SET Name = 'Maintenance Request' WHERE AD_Window_ID = 53141;

-- -----------------------------------------------------------------------------
-- AD_MENU - Update menu entries to match
-- -----------------------------------------------------------------------------
UPDATE AD_Menu SET Name = 'Maintenance Request' WHERE AD_Menu_ID = 53345;
UPDATE AD_Menu SET Name = 'Generate Work Order' WHERE AD_Menu_ID = 53344;
UPDATE AD_Menu SET Name = 'Submit Maintenance Request' WHERE AD_Menu_ID = 53346;
UPDATE AD_Menu SET Name = 'Maintenance Forecast' WHERE AD_Menu_ID = 53343;

-- =============================================================================
-- END OF MIGRATION SCRIPT
-- =============================================================================
