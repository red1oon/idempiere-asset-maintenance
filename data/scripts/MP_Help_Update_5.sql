-- =============================================================================
-- MP Module - Description (Tooltip) Updates
-- =============================================================================
-- Short descriptions shown as tooltips for intuitive user guidance
-- =============================================================================

-- -----------------------------------------------------------------------------
-- WINDOWS
-- -----------------------------------------------------------------------------
UPDATE AD_Window SET Description = 'Schedule recurring maintenance for assets by calendar or meter' WHERE Name = 'Preventive Maintenance';
UPDATE AD_Window SET Description = 'Define meter types (km, hours, cycles) for tracking asset usage' WHERE Name = 'Meter';
UPDATE AD_Window SET Description = 'Create reusable job templates with tasks and resources' WHERE Name = 'Job Standard';
UPDATE AD_Window SET Description = 'Submit unscheduled or emergency maintenance requests' WHERE Name = 'Request OT';
UPDATE AD_Window SET Description = 'Execute and complete maintenance work orders' WHERE Name = 'Work Order';

-- -----------------------------------------------------------------------------
-- TABS - Preventive Maintenance window
-- -----------------------------------------------------------------------------
UPDATE AD_Tab SET Description = 'Define schedule. Use Gear Icon to copy from Job Standard'
WHERE Name = 'Maintenance' AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Preventive Maintenance');

UPDATE AD_Tab SET Description = 'Tasks to perform for this maintenance'
WHERE Name = 'Tasks' AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Preventive Maintenance');

UPDATE AD_Tab SET Description = 'Labor, materials, tools needed for tasks'
WHERE Name = 'Resources' AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Preventive Maintenance');

-- -----------------------------------------------------------------------------
-- TABS - Job Standard window
-- -----------------------------------------------------------------------------
UPDATE AD_Tab SET Description = 'Job template header with type and area'
WHERE Name = 'Job Standard' AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Job Standard');

UPDATE AD_Tab SET Description = 'Tasks to perform for this job'
WHERE Name = 'Task' AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Job Standard');

UPDATE AD_Tab SET Description = 'Labor, materials, tools needed for tasks'
WHERE Name = 'Resource' AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Job Standard');

-- -----------------------------------------------------------------------------
-- TABS - Meter window
-- -----------------------------------------------------------------------------
UPDATE AD_Tab SET Description = 'Meter definition with name and max days between readings'
WHERE Name = 'Meter' AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Meter');

-- -----------------------------------------------------------------------------
-- TABS - Request OT window
-- -----------------------------------------------------------------------------
UPDATE AD_Tab SET Description = 'Request details with priority and required date'
WHERE Name = 'Request' AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Request OT');

-- -----------------------------------------------------------------------------
-- TABS - Work Order window
-- -----------------------------------------------------------------------------
UPDATE AD_Tab SET Description = 'Work order header with status and dates'
WHERE Name = 'Order' AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Work Order');

UPDATE AD_Tab SET Description = 'Tasks to complete for this work order'
WHERE Name = 'Tasks' AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Work Order');

UPDATE AD_Tab SET Description = 'Resources used with actual quantities and costs'
WHERE Name = 'Resources' AND AD_Window_ID = (SELECT AD_Window_ID FROM AD_Window WHERE Name = 'Work Order');

-- -----------------------------------------------------------------------------
-- FIELDS - Maintenance tab (newbie-friendly tooltips)
-- AD_Field_IDs specific to this installation
-- -----------------------------------------------------------------------------
UPDATE AD_Field SET Description = 'Pick one! More fields will appear below' WHERE AD_Field_ID = 61774;
UPDATE AD_Field SET Description = 'Pick a template first, then click Gear Icon to copy' WHERE AD_Field_ID = 61784;
UPDATE AD_Field SET Description = 'Which meter to track? (only for Meter type)' WHERE AD_Field_ID = 61775;
UPDATE AD_Field SET Description = 'How often? Days or usage between maintenance' WHERE AD_Field_ID = 61776;
UPDATE AD_Field SET Description = 'How much buffer before overdue?' WHERE AD_Field_ID = 61777;
UPDATE AD_Field SET Description = 'When to show warning before due?' WHERE AD_Field_ID = 61779;
UPDATE AD_Field SET Description = 'At what reading is maintenance due?' WHERE AD_Field_ID = 61778;
UPDATE AD_Field SET Description = 'When was last Work Order created?' WHERE AD_Field_ID = 61783;
UPDATE AD_Field SET Description = 'Is this linked to another schedule?' WHERE AD_Field_ID = 61771;
UPDATE AD_Field SET Description = 'Which schedule is this linked to?' WHERE AD_Field_ID = 61772;

-- -----------------------------------------------------------------------------
-- VERIFICATION
-- -----------------------------------------------------------------------------
SELECT 'WINDOW' as Type, Name, Description FROM AD_Window
WHERE Name IN ('Preventive Maintenance', 'Meter', 'Job Standard', 'Request OT', 'Work Order')
ORDER BY Name;

SELECT 'FIELD' as Type, Name, Description FROM AD_Field
WHERE AD_Field_ID IN (61774, 61784, 61775, 61776, 61777, 61778, 61779, 61783, 61771, 61772)
ORDER BY Name;

-- -----------------------------------------------------------------------------
-- NOTES:
-- 1. Field IDs are specific to this installation
-- 2. After running: Reset Cache
-- -----------------------------------------------------------------------------
