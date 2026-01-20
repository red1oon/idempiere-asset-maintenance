-- ============================================
-- SET 3: MANUFACTURING EQUIPMENT
-- ============================================
-- Business Model: Factory, production line, industrial equipment
-- Use Case: Manufacturing plants, assembly lines, food processing
-- GardenWorld: AD_Client_ID=11, AD_Org_ID=11
-- ID Range: 1000201-1000299
-- ============================================

-- CLEANUP Set 3
DELETE FROM mp_assetmeter_log WHERE mp_assetmeter_log_id BETWEEN 1000201 AND 1000299;
DELETE FROM mp_maintain WHERE mp_maintain_id BETWEEN 1000201 AND 1000299;
DELETE FROM mp_assetmeter WHERE mp_assetmeter_id BETWEEN 1000201 AND 1000299;
DELETE FROM mp_jobstandar_task WHERE mp_jobstandar_task_id BETWEEN 1000201 AND 1000299;
DELETE FROM mp_jobstandar WHERE mp_jobstandar_id BETWEEN 1000201 AND 1000299;
DELETE FROM a_asset WHERE a_asset_id BETWEEN 1000201 AND 1000299;
DELETE FROM mp_meter WHERE mp_meter_id BETWEEN 1000201 AND 1000299;

-- ============================================
-- 1. METERS (Production-specific)
-- ============================================
INSERT INTO mp_meter (mp_meter_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive, name, maxday, mp_meter_uu)
VALUES
(1000201, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Machine Hours', 7, uuid_generate_v4()),
(1000202, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Production Cycles', 1, uuid_generate_v4()),
(1000203, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Spindle Hours (CNC)', 7, uuid_generate_v4());

-- ============================================
-- 2. ASSETS (Production Equipment)
-- ============================================
INSERT INTO a_asset (a_asset_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive,
                     value, name, description, a_asset_group_id, m_product_id, assetservicedate, isowned, isdepreciated, isfullydepreciated, a_asset_uu)
VALUES
-- CNC Machines
(1000201, 11, 11, NOW(), 100, NOW(), 100, 'Y',
 'CNC-001', 'CNC Lathe #1', 'Haas ST-10 CNC Turning Center', 50007, 200002, '2021-03-15', 'Y', 'N', 'N', uuid_generate_v4()),
(1000202, 11, 11, NOW(), 100, NOW(), 100, 'Y',
 'CNC-002', 'CNC Mill #1', 'Haas VF-2 Vertical Mill', 50007, 200002, '2021-03-15', 'Y', 'N', 'N', uuid_generate_v4()),
-- Assembly Line
(1000203, 11, 11, NOW(), 100, NOW(), 100, 'Y',
 'ASM-001', 'Assembly Line A', 'Main product assembly line', 50007, 200002, '2019-06-01', 'Y', 'N', 'N', uuid_generate_v4()),
-- Packaging Equipment
(1000204, 11, 11, NOW(), 100, NOW(), 100, 'Y',
 'PKG-001', 'Packaging Machine #1', 'Automated box sealer and labeler', 50007, 200002, '2020-01-15', 'Y', 'N', 'N', uuid_generate_v4()),
-- Compressor (utilities)
(1000205, 11, 11, NOW(), 100, NOW(), 100, 'Y',
 'CMP-001', 'Air Compressor', 'Atlas Copco GA-30 Rotary Screw', 50007, 200002, '2018-09-01', 'Y', 'N', 'N', uuid_generate_v4()),
-- Hydraulic Press
(1000206, 11, 11, NOW(), 100, NOW(), 100, 'Y',
 'PRS-001', 'Hydraulic Press', '100-ton forming press', 50007, 200002, '2017-05-20', 'Y', 'N', 'N', uuid_generate_v4());

-- ============================================
-- 3. STANDARD JOBS (Manufacturing Maintenance)
-- ============================================
INSERT INTO mp_jobstandar (mp_jobstandar_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                           isactive, name, jobstandartype, maintainarea, a_asset_group_id, mp_jobstandar_uu)
VALUES
-- CNC Jobs
(1000201, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'CNC Spindle Lubrication', 'AA', 'ME', 50007, uuid_generate_v4()),
(1000202, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'CNC Way Wiper Replacement', 'AA', 'ME', 50007, uuid_generate_v4()),
(1000203, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'CNC Coolant System Service', 'AA', 'ME', 50007, uuid_generate_v4()),
-- Assembly Line Jobs
(1000204, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Conveyor Belt Inspection', 'AA', 'ME', 50007, uuid_generate_v4()),
(1000205, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Sensor Calibration', 'AA', 'EL', 50007, uuid_generate_v4()),
-- Compressor Jobs
(1000206, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Compressor Oil Change', 'AA', 'ME', 50007, uuid_generate_v4()),
(1000207, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Air Filter Replacement', 'AA', 'ME', 50007, uuid_generate_v4()),
-- Hydraulic Press Jobs
(1000208, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Hydraulic Fluid Change', 'AA', 'ME', 50007, uuid_generate_v4());

-- ============================================
-- 4. STANDARD JOB TASKS
-- ============================================
INSERT INTO mp_jobstandar_task (mp_jobstandar_task_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                                 isactive, mp_jobstandar_id, description, duration, c_uom_id, mp_jobstandar_task_uu)
VALUES
-- CNC Spindle Lubrication (1000201)
(1000201, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000201, 'Check spindle oil level', 0.25, 101, uuid_generate_v4()),
(1000202, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000201, 'Top up spindle oil', 0.25, 101, uuid_generate_v4()),
(1000203, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000201, 'Check for leaks', 0.25, 101, uuid_generate_v4()),
-- CNC Way Wiper Replacement (1000202)
(1000204, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000202, 'Remove old way wipers', 0.5, 101, uuid_generate_v4()),
(1000205, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000202, 'Clean way surfaces', 0.5, 101, uuid_generate_v4()),
(1000206, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000202, 'Install new wipers', 0.5, 101, uuid_generate_v4()),
(1000207, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000202, 'Test axis movement', 0.25, 101, uuid_generate_v4()),
-- CNC Coolant System Service (1000203)
(1000208, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000203, 'Drain old coolant', 0.5, 101, uuid_generate_v4()),
(1000209, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000203, 'Clean sump and tank', 1.0, 101, uuid_generate_v4()),
(1000210, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000203, 'Replace coolant filter', 0.25, 101, uuid_generate_v4()),
(1000211, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000203, 'Fill with fresh coolant', 0.5, 101, uuid_generate_v4()),
-- Conveyor Belt Inspection (1000204)
(1000212, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000204, 'Check belt tension', 0.5, 101, uuid_generate_v4()),
(1000213, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000204, 'Inspect for wear/damage', 0.5, 101, uuid_generate_v4()),
(1000214, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000204, 'Lubricate bearings', 0.5, 101, uuid_generate_v4()),
-- Sensor Calibration (1000205)
(1000215, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000205, 'Test proximity sensors', 0.5, 101, uuid_generate_v4()),
(1000216, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000205, 'Calibrate photoelectric sensors', 0.5, 101, uuid_generate_v4()),
(1000217, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000205, 'Verify safety interlocks', 0.5, 101, uuid_generate_v4()),
-- Compressor Oil Change (1000206)
(1000218, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000206, 'Drain old oil', 0.5, 101, uuid_generate_v4()),
(1000219, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000206, 'Replace oil filter', 0.25, 101, uuid_generate_v4()),
(1000220, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000206, 'Fill with new synthetic oil', 0.5, 101, uuid_generate_v4()),
(1000221, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000206, 'Check oil separator', 0.25, 101, uuid_generate_v4()),
-- Air Filter Replacement (1000207)
(1000222, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000207, 'Remove old filter element', 0.25, 101, uuid_generate_v4()),
(1000223, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000207, 'Clean filter housing', 0.25, 101, uuid_generate_v4()),
(1000224, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000207, 'Install new filter', 0.25, 101, uuid_generate_v4()),
-- Hydraulic Fluid Change (1000208)
(1000225, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000208, 'Drain hydraulic reservoir', 1.0, 101, uuid_generate_v4()),
(1000226, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000208, 'Replace hydraulic filter', 0.5, 101, uuid_generate_v4()),
(1000227, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000208, 'Fill with ISO 46 hydraulic oil', 1.0, 101, uuid_generate_v4()),
(1000228, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000208, 'Bleed air from system', 0.5, 101, uuid_generate_v4());

-- ============================================
-- 5. ASSET METERS
-- ============================================
INSERT INTO mp_assetmeter (mp_assetmeter_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                           isactive, a_asset_id, mp_meter_id, value, name, amt, datetrx, mp_assetmeter_uu)
VALUES
-- CNC Lathe - Spindle Hours
(1000201, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000201, 1000203, 'CNC001-SPD', 'Lathe Spindle Hours', 4500, NOW(), uuid_generate_v4()),
-- CNC Mill - Spindle Hours
(1000202, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000202, 1000203, 'CNC002-SPD', 'Mill Spindle Hours', 3800, NOW(), uuid_generate_v4()),
-- Assembly Line - Production Cycles
(1000203, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000203, 1000202, 'ASM001-CYC', 'Assembly Cycles', 125000, NOW(), uuid_generate_v4()),
-- Packaging Machine - Cycles
(1000204, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000204, 1000202, 'PKG001-CYC', 'Packaging Cycles', 89000, NOW(), uuid_generate_v4()),
-- Air Compressor - Machine Hours
(1000205, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000205, 1000201, 'CMP001-HRS', 'Compressor Hours', 18500, NOW(), uuid_generate_v4()),
-- Hydraulic Press - Cycles
(1000206, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000206, 1000202, 'PRS001-CYC', 'Press Cycles', 45000, NOW(), uuid_generate_v4());

-- ============================================
-- 6. MAINTENANCE SCHEDULES
-- ============================================
INSERT INTO mp_maintain (mp_maintain_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                         isactive, documentno, ischild, a_asset_id, mp_jobstandar_id, mp_meter_id,
                         programmingtype, interval, lastmp, nextmp, lastread, currentmp, promuse, range,
                         datelastrun, datenextrun, docstatus, priorityrule, mp_maintain_uu)
VALUES
-- CNC Lathe: Spindle Lubrication every 500 spindle hours
(1000201, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-M001', 'N', 1000201, 1000201, 1000203,
 'M', 500, 4000, 4500, 4500, 4500, 50, 100,
 '2025-11-15', NULL, 'AT', '3', uuid_generate_v4()),
-- CNC Lathe: Way Wipers every 2000 spindle hours
(1000202, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-M002', 'N', 1000201, 1000202, 1000203,
 'M', 2000, 4000, 6000, 4500, 4500, 200, 500,
 '2025-09-01', NULL, 'AT', '5', uuid_generate_v4()),
-- CNC Mill: Coolant Service every 1000 spindle hours
(1000203, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-M003', 'N', 1000202, 1000203, 1000203,
 'M', 1000, 3000, 4000, 3800, 3800, 100, 200,
 '2025-10-01', NULL, 'AT', '5', uuid_generate_v4()),
-- Assembly Line: Conveyor Inspection every 7 days
(1000204, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-M004', 'N', 1000203, 1000204, NULL,
 'C', 7, NULL, NULL, NULL, NULL, NULL, NULL,
 '2026-01-13', '2026-01-20', 'AT', '5', uuid_generate_v4()),
-- Assembly Line: Sensor Calibration every 30 days
(1000205, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-M005', 'N', 1000203, 1000205, NULL,
 'C', 30, NULL, NULL, NULL, NULL, NULL, NULL,
 '2025-12-20', '2026-01-19', 'AT', '3', uuid_generate_v4()),
-- Air Compressor: Oil Change every 4000 hours
(1000206, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-M006', 'N', 1000205, 1000206, 1000201,
 'M', 4000, 16000, 20000, 18500, 18500, 500, 1000,
 '2025-08-01', NULL, 'AT', '5', uuid_generate_v4()),
-- Air Compressor: Air Filter every 2000 hours
(1000207, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-M007', 'N', 1000205, 1000207, 1000201,
 'M', 2000, 18000, 20000, 18500, 18500, 200, 500,
 '2025-11-01', NULL, 'AT', '5', uuid_generate_v4()),
-- Hydraulic Press: Fluid Change every 10000 cycles
(1000208, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-M008', 'N', 1000206, 1000208, 1000202,
 'M', 10000, 40000, 50000, 45000, 45000, 1000, 2000,
 '2025-07-15', NULL, 'AT', '5', uuid_generate_v4());

-- ============================================
-- 7. METER LOGS (Sample Readings)
-- ============================================
INSERT INTO mp_assetmeter_log (mp_assetmeter_log_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                               isactive, mp_assetmeter_id, datetrx, amt, currentamt, description, mp_assetmeter_log_uu)
VALUES
-- CNC Lathe Spindle Hours
(1000201, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000201, '2025-10-01', 150, 4050, 'Monthly reading', uuid_generate_v4()),
(1000202, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000201, '2025-11-01', 200, 4250, 'Monthly reading', uuid_generate_v4()),
(1000203, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000201, '2025-12-01', 180, 4430, 'Monthly reading', uuid_generate_v4()),
(1000204, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000201, '2026-01-01', 70, 4500, 'Monthly reading', uuid_generate_v4()),
-- CNC Mill Spindle Hours
(1000205, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000202, '2025-10-01', 120, 3440, 'Monthly reading', uuid_generate_v4()),
(1000206, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000202, '2025-11-01', 180, 3620, 'Monthly reading', uuid_generate_v4()),
(1000207, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000202, '2025-12-01', 130, 3750, 'Monthly reading', uuid_generate_v4()),
(1000208, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000202, '2026-01-01', 50, 3800, 'Monthly reading', uuid_generate_v4()),
-- Assembly Line Cycles (high volume)
(1000209, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000203, '2025-10-01', 8000, 109000, 'Monthly count', uuid_generate_v4()),
(1000210, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000203, '2025-11-01', 9000, 118000, 'Monthly count', uuid_generate_v4()),
(1000211, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000203, '2025-12-01', 7000, 125000, 'Monthly count', uuid_generate_v4()),
-- Packaging Machine Cycles
(1000212, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000204, '2025-10-01', 6000, 77000, 'Monthly count', uuid_generate_v4()),
(1000213, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000204, '2025-11-01', 7000, 84000, 'Monthly count', uuid_generate_v4()),
(1000214, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000204, '2025-12-01', 5000, 89000, 'Monthly count', uuid_generate_v4()),
-- Compressor Hours
(1000215, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000205, '2025-10-01', 350, 17800, 'Monthly reading', uuid_generate_v4()),
(1000216, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000205, '2025-11-01', 400, 18200, 'Monthly reading', uuid_generate_v4()),
(1000217, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000205, '2025-12-01', 300, 18500, 'Monthly reading', uuid_generate_v4()),
-- Hydraulic Press Cycles
(1000218, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000206, '2025-10-01', 1500, 42000, 'Monthly count', uuid_generate_v4()),
(1000219, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000206, '2025-11-01', 1800, 43800, 'Monthly count', uuid_generate_v4()),
(1000220, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000206, '2025-12-01', 1200, 45000, 'Monthly count', uuid_generate_v4());

-- ============================================
-- SUMMARY: Set 3 - Manufacturing
-- ============================================
-- Scenario: Small Manufacturing Plant
-- Assets: 2 CNC Machines, Assembly Line, Packaging, Compressor, Press
-- Meters: Machine Hours, Production Cycles, Spindle Hours
-- Jobs: Lubrication, Way Wipers, Coolant, Belt Inspection, Oil Change
-- Key Features:
--   - Heavy use of Meter-based maintenance (wear/usage driven)
--   - CNC-specific maintenance (spindle hours)
--   - High-cycle production equipment
--   - Critical utilities (compressor)
