-- ============================================
-- AssetMaintenance Sample Data - Simplified
-- ============================================
-- 3 Assets for GardenWorld newbie testing
-- Run as: psql -d idempiere -f GardenWorldSample.sql
--
-- GardenWorld: AD_Client_ID=11, AD_Org_ID=11
-- GardenAdmin: AD_User_ID=101
--
-- AFTER LOADING: Run "Sequence Check" process
--   Menu: System Admin > General Rules > System Rules > Sequence Check
-- ============================================

-- ============================================
-- CLEANUP (safe to re-run) - order matters for FK
-- ============================================
DELETE FROM mp_ot_resource WHERE ad_client_id = 11 AND mp_ot_resource_id >= 1100001;
DELETE FROM mp_ot_task WHERE ad_client_id = 11 AND mp_ot_task_id >= 1100001;
DELETE FROM mp_ot WHERE ad_client_id = 11 AND mp_ot_id >= 1100001;
DELETE FROM mp_ot_request WHERE ad_client_id = 11 AND mp_ot_request_id >= 1100001;
DELETE FROM mp_prognosis WHERE ad_client_id = 11 AND mp_prognosis_id >= 1100001;
DELETE FROM mp_assetmeter_log WHERE ad_client_id = 11 AND mp_assetmeter_log_id >= 1100001;
DELETE FROM mp_maintain_task WHERE ad_client_id = 11 AND mp_maintain_task_id >= 1100001;
DELETE FROM mp_maintain WHERE ad_client_id = 11 AND mp_maintain_id >= 1100001;
DELETE FROM mp_assetmeter WHERE ad_client_id = 11 AND mp_assetmeter_id >= 1100001;
DELETE FROM mp_jobstandar_task WHERE ad_client_id = 11 AND mp_jobstandar_task_id >= 1100001;
DELETE FROM mp_jobstandar WHERE ad_client_id = 11 AND mp_jobstandar_id >= 1100001;
DELETE FROM mp_meter WHERE ad_client_id = 11 AND mp_meter_id >= 1100001;
DELETE FROM a_asset WHERE ad_client_id = 11 AND a_asset_id >= 1100001;

-- ============================================
-- 1. METERS (3 types)
-- ============================================
INSERT INTO mp_meter (mp_meter_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
    isactive, name, maxday, mp_meter_uu)
VALUES
(1100001, 11, 11, NOW(), 101, NOW(), 101, 'Y', 'Kilometers', 30, uuid_generate_v4()),
(1100002, 11, 11, NOW(), 101, NOW(), 101, 'Y', 'Operating Hours', 7, uuid_generate_v4()),
(1100003, 11, 11, NOW(), 101, NOW(), 101, 'Y', 'Calendar Days', null, uuid_generate_v4());

-- ============================================
-- 2. STANDARD JOBS (3 templates)
-- ============================================
-- a_asset_group_id: 50003 = Data Processing Equipment
INSERT INTO mp_jobstandar (mp_jobstandar_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
    isactive, name, jobstandartype, maintainarea, a_asset_group_id, mp_jobstandar_uu)
VALUES
(1100001, 11, 11, NOW(), 101, NOW(), 101, 'Y', 'Vehicle Oil Change', 'AA', 'ME', 50003, uuid_generate_v4()),
(1100002, 11, 11, NOW(), 101, NOW(), 101, 'Y', 'HVAC Filter Replacement', 'AA', 'ME', 50003, uuid_generate_v4()),
(1100003, 11, 11, NOW(), 101, NOW(), 101, 'Y', 'Forklift Battery Service', 'AA', 'EL', 50003, uuid_generate_v4());

-- ============================================
-- 3. STANDARD JOB TASKS
-- ============================================
-- c_uom_id: 101 = Hour (standard iDempiere UOM)
INSERT INTO mp_jobstandar_task (mp_jobstandar_task_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
    isactive, mp_jobstandar_id, description, duration, c_uom_id, mp_jobstandar_task_uu)
VALUES
-- Oil Change Tasks
(1100001, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100001, 'Drain old oil completely', 0.5, 101, uuid_generate_v4()),
(1100002, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100001, 'Replace oil filter', 0.25, 101, uuid_generate_v4()),
(1100003, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100001, 'Add 5L synthetic oil', 0.25, 101, uuid_generate_v4()),
-- HVAC Filter Tasks
(1100004, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100002, 'Turn off HVAC system', 0.1, 101, uuid_generate_v4()),
(1100005, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100002, 'Remove old filter', 0.25, 101, uuid_generate_v4()),
(1100006, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100002, 'Install new filter', 0.25, 101, uuid_generate_v4()),
(1100007, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100002, 'Test system operation', 0.25, 101, uuid_generate_v4()),
-- Forklift Battery Tasks
(1100008, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100003, 'Safety check - power off', 0.1, 101, uuid_generate_v4()),
(1100009, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100003, 'Check water level', 0.25, 101, uuid_generate_v4()),
(1100010, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100003, 'Add distilled water', 0.25, 101, uuid_generate_v4()),
(1100011, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100003, 'Clean terminals', 0.25, 101, uuid_generate_v4()),
(1100012, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100003, 'Test voltage', 0.25, 101, uuid_generate_v4());

-- ============================================
-- 4. ASSETS (3 assets)
-- ============================================
-- a_asset_group_id: 50003 = Data Processing Equipment
-- m_product_id: 200001 = Asset Vehicle, 200002 = Computers
INSERT INTO a_asset (a_asset_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
    isactive, value, name, description, a_asset_group_id, m_product_id,
    assetservicedate, isowned, isdepreciated, isfullydepreciated, a_asset_uu)
VALUES
(1100001, 11, 11, NOW(), 101, NOW(), 101, 'Y',
    'VH-001', 'Delivery Truck #1', 'Ford F-150 for local deliveries', 50003, 200001,
    '2024-01-15', 'Y', 'N', 'N', uuid_generate_v4()),
(1100002, 11, 11, NOW(), 101, NOW(), 101, 'Y',
    'HVAC-001', 'Office HVAC Unit #1', 'Main office air conditioning', 50003, 200002,
    '2023-06-01', 'Y', 'N', 'N', uuid_generate_v4()),
(1100003, 11, 11, NOW(), 101, NOW(), 101, 'Y',
    'FL-001', 'Forklift #1', 'Toyota electric forklift 2-ton', 50003, 200001,
    '2023-03-01', 'Y', 'N', 'N', uuid_generate_v4());

-- ============================================
-- 5. ASSET METERS (link meters to assets)
-- ============================================
-- name is varchar(20), value is varchar(60)
INSERT INTO mp_assetmeter (mp_assetmeter_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
    isactive, a_asset_id, mp_meter_id, value, name, amt, datetrx, mp_assetmeter_uu)
VALUES
(1100001, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100001, 1100001, 'VH001-KM', 'Truck Odometer', 45000, NOW(), uuid_generate_v4()),
(1100002, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100002, 1100003, 'HVAC001-DAYS', 'HVAC Tracker', 0, NOW(), uuid_generate_v4()),
(1100003, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100003, 1100002, 'FL001-HRS', 'Forklift Hours', 1200, NOW(), uuid_generate_v4());

-- ============================================
-- 6. MAINTENANCE SCHEDULES
-- ============================================
INSERT INTO mp_maintain (mp_maintain_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
    isactive, documentno, a_asset_id, mp_jobstandar_id, mp_meter_id,
    programmingtype, interval, lastmp, nextmp, currentmp, promuse, range,
    datelastrun, datenextrun, docstatus, ischild, mp_maintain_uu)
VALUES
-- Truck: Oil change every 5000 km - DUE NOW
(1100001, 11, 11, NOW(), 101, NOW(), 101, 'Y',
    'MP-001', 1100001, 1100001, 1100001,
    'M', 5000, 40000, 45000, 45000, 500, 1000,
    '2024-11-01', null, 'AT', 'N', uuid_generate_v4()),
-- HVAC: Filter every 90 days - due in 5 days
(1100002, 11, 11, NOW(), 101, NOW(), 101, 'Y',
    'MP-002', 1100002, 1100002, null,
    'C', 90, null, null, null, null, null,
    NOW() - INTERVAL '85 days', NOW() + INTERVAL '5 days', 'AT', 'N', uuid_generate_v4()),
-- Forklift: Battery every 250 hrs - due soon
(1100003, 11, 11, NOW(), 101, NOW(), 101, 'Y',
    'MP-003', 1100003, 1100003, 1100002,
    'M', 250, 1000, 1250, 1200, 25, 50,
    '2024-10-15', null, 'AT', 'N', uuid_generate_v4());

-- ============================================
-- 7. MAINTENANCE TASKS
-- ============================================
INSERT INTO mp_maintain_task (mp_maintain_task_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
    isactive, mp_maintain_id, description, duration, c_uom_id, mp_maintain_task_uu)
VALUES
-- Truck Oil Change
(1100001, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100001, 'Drain old oil completely', 0.5, 101, uuid_generate_v4()),
(1100002, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100001, 'Replace oil filter', 0.25, 101, uuid_generate_v4()),
(1100003, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100001, 'Add 5L synthetic oil', 0.25, 101, uuid_generate_v4()),
-- HVAC Filter
(1100004, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100002, 'Turn off HVAC system', 0.1, 101, uuid_generate_v4()),
(1100005, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100002, 'Remove old filter', 0.25, 101, uuid_generate_v4()),
(1100006, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100002, 'Install new filter', 0.25, 101, uuid_generate_v4()),
(1100007, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100002, 'Test system operation', 0.25, 101, uuid_generate_v4()),
-- Forklift Battery
(1100008, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100003, 'Safety check - power off', 0.1, 101, uuid_generate_v4()),
(1100009, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100003, 'Check water level', 0.25, 101, uuid_generate_v4()),
(1100010, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100003, 'Add distilled water', 0.25, 101, uuid_generate_v4()),
(1100011, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100003, 'Clean terminals', 0.25, 101, uuid_generate_v4()),
(1100012, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100003, 'Test voltage', 0.25, 101, uuid_generate_v4());

-- ============================================
-- 8. METER LOG ENTRIES
-- ============================================
INSERT INTO mp_assetmeter_log (mp_assetmeter_log_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
    isactive, mp_assetmeter_id, amt, datetrx, description, mp_assetmeter_log_uu)
VALUES
-- Truck readings
(1100001, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100001, 44200, NOW() - INTERVAL '21 days', 'Weekly reading', uuid_generate_v4()),
(1100002, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100001, 44500, NOW() - INTERVAL '14 days', 'Weekly reading', uuid_generate_v4()),
(1100003, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100001, 44800, NOW() - INTERVAL '7 days', 'Weekly reading', uuid_generate_v4()),
(1100004, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100001, 45000, NOW(), 'Maintenance due!', uuid_generate_v4()),
-- Forklift readings
(1100005, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100003, 1150, NOW() - INTERVAL '10 days', 'Daily reading', uuid_generate_v4()),
(1100006, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100003, 1175, NOW() - INTERVAL '5 days', 'Daily reading', uuid_generate_v4()),
(1100007, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100003, 1200, NOW(), 'Approaching maintenance', uuid_generate_v4());

-- ============================================
-- 9. WORK ORDER REQUESTS
-- ============================================
INSERT INTO mp_ot_request (mp_ot_request_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
    isactive, documentno, a_asset_id, mp_jobstandar_id, ad_user_id,
    datedoc, daterequired, description, priorityrule, ot_request_type,
    docstatus, processed, mp_ot_request_uu)
VALUES
-- Pending - waiting approval
(1100001, 11, 11, NOW(), 101, NOW(), 101, 'Y',
    'REQ-001', 1100001, 1100001, 101,
    NOW() - INTERVAL '2 days', NOW() + INTERVAL '5 days',
    'Truck oil warning light on', '5', 'RP', 'WC', 'Y', uuid_generate_v4()),
-- Approved - ready for WO
(1100002, 11, 11, NOW(), 101, NOW(), 101, 'Y',
    'REQ-002', 1100003, 1100003, 101,
    NOW() - INTERVAL '5 days', NOW() + INTERVAL '2 days',
    'Forklift battery not holding charge', '7', 'RV', 'AP', 'Y', uuid_generate_v4()),
-- Completed (AP = Approved, since Reference 53393 doesn't have CO)
(1100003, 11, 11, NOW(), 101, NOW(), 101, 'Y',
    'REQ-003', 1100002, 1100002, 101,
    NOW() - INTERVAL '10 days', NOW() - INTERVAL '3 days',
    'Quarterly HVAC filter change', '3', 'RP', 'AP', 'Y', uuid_generate_v4());

-- ============================================
-- 10. WORK ORDERS
-- ============================================
-- Note: c_doctype_id needed - get from system
INSERT INTO mp_ot (mp_ot_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
    isactive, documentno, a_asset_id, mp_maintain_id, mp_jobstandar_id,
    datetrx, description, docstatus, docaction, processed, mp_ot_uu)
VALUES
-- Draft
(1100001, 11, 11, NOW(), 101, NOW(), 101, 'Y',
    'WO-001', 1100001, 1100001, 1100001,
    NOW(), 'Oil change for Truck #1', 'DR', 'CO', 'N', uuid_generate_v4()),
-- In Progress
(1100002, 11, 11, NOW(), 101, NOW(), 101, 'Y',
    'WO-002', 1100003, 1100003, 1100003,
    NOW() - INTERVAL '1 day', 'Battery service Forklift #1', 'IP', 'CO', 'N', uuid_generate_v4()),
-- Completed
(1100003, 11, 11, NOW(), 101, NOW(), 101, 'Y',
    'WO-003', 1100002, 1100002, 1100002,
    NOW() - INTERVAL '5 days', 'HVAC filter completed', 'CO', '--', 'Y', uuid_generate_v4());

-- ============================================
-- 11. WORK ORDER TASKS
-- ============================================
INSERT INTO mp_ot_task (mp_ot_task_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
    isactive, mp_ot_id, description, duration, c_uom_id, status, processed, mp_ot_task_uu)
VALUES
-- WO-001 (Draft)
(1100001, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100001, 'Drain old oil', 0.5, 101, 'NS', 'N', uuid_generate_v4()),
(1100002, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100001, 'Replace filter', 0.25, 101, 'NS', 'N', uuid_generate_v4()),
(1100003, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100001, 'Add new oil', 0.25, 101, 'NS', 'N', uuid_generate_v4()),
-- WO-002 (In Progress)
(1100004, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100002, 'Safety check', 0.1, 101, 'CO', 'N', uuid_generate_v4()),
(1100005, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100002, 'Check water level', 0.25, 101, 'CO', 'N', uuid_generate_v4()),
(1100006, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100002, 'Add water', 0.25, 101, 'IP', 'N', uuid_generate_v4()),
(1100007, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100002, 'Clean terminals', 0.25, 101, 'NS', 'N', uuid_generate_v4()),
(1100008, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100002, 'Test voltage', 0.25, 101, 'NS', 'N', uuid_generate_v4()),
-- WO-003 (Completed)
(1100009, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100003, 'Turn off unit', 0.1, 101, 'CO', 'Y', uuid_generate_v4()),
(1100010, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100003, 'Remove filter', 0.25, 101, 'CO', 'Y', uuid_generate_v4()),
(1100011, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100003, 'Install filter', 0.25, 101, 'CO', 'Y', uuid_generate_v4()),
(1100012, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100003, 'Test system', 0.25, 101, 'CO', 'Y', uuid_generate_v4());

-- ============================================
-- 12. WORK ORDER RESOURCES
-- ============================================
-- resourcetype: RR=Part, TT=Tool, HH=Human Resource, BP=BOM Parts, BT=BOM Tools
INSERT INTO mp_ot_resource (mp_ot_resource_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
    isactive, mp_ot_task_id, resourcetype, resourceqty, costamt, processed, mp_ot_resource_uu)
VALUES
(1100001, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100002, 'RR', 1, 15.00, 'N', uuid_generate_v4()),
(1100002, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100003, 'RR', 5, 45.00, 'N', uuid_generate_v4()),
(1100003, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100006, 'RR', 2, 8.00, 'N', uuid_generate_v4()),
(1100004, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100007, 'TT', 1, 12.00, 'N', uuid_generate_v4()),
(1100005, 11, 11, NOW(), 101, NOW(), 101, 'Y', 1100011, 'RR', 1, 35.00, 'Y', uuid_generate_v4());

-- ============================================
-- VERIFICATION
-- ============================================
SELECT 'Meters' as item, count(*) as cnt FROM mp_meter WHERE ad_client_id=11 AND mp_meter_id >= 1100001
UNION ALL SELECT 'Assets', count(*) FROM a_asset WHERE ad_client_id=11 AND a_asset_id >= 1100001
UNION ALL SELECT 'Std Jobs', count(*) FROM mp_jobstandar WHERE ad_client_id=11 AND mp_jobstandar_id >= 1100001
UNION ALL SELECT 'Job Tasks', count(*) FROM mp_jobstandar_task WHERE ad_client_id=11 AND mp_jobstandar_task_id >= 1100001
UNION ALL SELECT 'Asset Meters', count(*) FROM mp_assetmeter WHERE ad_client_id=11 AND mp_assetmeter_id >= 1100001
UNION ALL SELECT 'Maintenance', count(*) FROM mp_maintain WHERE ad_client_id=11 AND mp_maintain_id >= 1100001
UNION ALL SELECT 'Maint Tasks', count(*) FROM mp_maintain_task WHERE ad_client_id=11 AND mp_maintain_task_id >= 1100001
UNION ALL SELECT 'Meter Logs', count(*) FROM mp_assetmeter_log WHERE ad_client_id=11 AND mp_assetmeter_log_id >= 1100001
UNION ALL SELECT 'Requests', count(*) FROM mp_ot_request WHERE ad_client_id=11 AND mp_ot_request_id >= 1100001
UNION ALL SELECT 'Work Orders', count(*) FROM mp_ot WHERE ad_client_id=11 AND mp_ot_id >= 1100001
UNION ALL SELECT 'WO Tasks', count(*) FROM mp_ot_task WHERE ad_client_id=11 AND mp_ot_task_id >= 1100001
UNION ALL SELECT 'WO Resources', count(*) FROM mp_ot_resource WHERE ad_client_id=11 AND mp_ot_resource_id >= 1100001;

-- ============================================
-- NOTE: Prognosis records are generated by the
-- "Maintenance Forecast" process, not inserted directly.
-- Run the forecast from Office menu to generate them.
-- ============================================

-- ============================================
-- AFTER LOADING: Run Sequence Check!
-- Menu: System Admin > General Rules > System Rules > Sequence Check
-- ============================================
