-- ============================================
-- SET 1: FLEET EQUIPMENT MAINTENANCE
-- ============================================
-- Business Model: Delivery vehicles, warehouse equipment
-- Use Case: Logistics, distribution, warehousing companies
-- GardenWorld: AD_Client_ID=11, AD_Org_ID=11
-- ID Range: 1000001-1000099
-- ============================================

-- CLEANUP Set 1
DELETE FROM mp_assetmeter_log WHERE mp_assetmeter_log_id BETWEEN 1000001 AND 1000099;
DELETE FROM mp_maintain WHERE mp_maintain_id BETWEEN 1000001 AND 1000099;
DELETE FROM mp_assetmeter WHERE mp_assetmeter_id BETWEEN 1000001 AND 1000099;
DELETE FROM mp_jobstandar_task WHERE mp_jobstandar_task_id BETWEEN 1000001 AND 1000099;
DELETE FROM mp_jobstandar WHERE mp_jobstandar_id BETWEEN 1000001 AND 1000099;
DELETE FROM a_asset WHERE a_asset_id BETWEEN 1000001 AND 1000099;
DELETE FROM mp_meter WHERE mp_meter_id BETWEEN 1000001 AND 1000099;

-- ============================================
-- 1. METERS
-- ============================================
INSERT INTO mp_meter (mp_meter_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive, name, maxday, mp_meter_uu)
VALUES
(1000001, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Kilometers', 30, uuid_generate_v4()),
(1000002, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Operating Hours', 7, uuid_generate_v4());

-- ============================================
-- 2. ASSETS (Vehicles and Equipment)
-- ============================================
INSERT INTO a_asset (a_asset_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive,
                     value, name, description, a_asset_group_id, m_product_id, assetservicedate, isowned, isdepreciated, isfullydepreciated, a_asset_uu)
VALUES
-- Delivery Vehicles
(1000001, 11, 11, NOW(), 100, NOW(), 100, 'Y',
 'VH-001', 'Delivery Truck #1', 'Ford F-150 for local deliveries', 50006, 200001, '2023-01-15', 'Y', 'N', 'N', uuid_generate_v4()),
(1000002, 11, 11, NOW(), 100, NOW(), 100, 'Y',
 'VH-002', 'Delivery Van #1', 'Mercedes Sprinter for urban routes', 50006, 200001, '2023-06-01', 'Y', 'N', 'N', uuid_generate_v4()),
-- Warehouse Equipment
(1000003, 11, 11, NOW(), 100, NOW(), 100, 'Y',
 'FL-001', 'Forklift #1', 'Toyota Electric Forklift 3-ton', 50006, 200001, '2022-06-01', 'Y', 'N', 'N', uuid_generate_v4()),
(1000004, 11, 11, NOW(), 100, NOW(), 100, 'Y',
 'FL-002', 'Forklift #2', 'Toyota Electric Forklift 2-ton', 50006, 200001, '2022-08-15', 'Y', 'N', 'N', uuid_generate_v4()),
(1000005, 11, 11, NOW(), 100, NOW(), 100, 'Y',
 'CV-001', 'Conveyor Belt #1', 'Main warehouse conveyor system', 50007, 200002, '2020-11-10', 'Y', 'N', 'N', uuid_generate_v4());

-- ============================================
-- 3. STANDARD JOBS
-- ============================================
-- JobStandarType: AA=Type A (Routine/Preventive), BB=Type B (Corrective)
-- MaintainArea: ME=Mechanical, EL=Electrical
INSERT INTO mp_jobstandar (mp_jobstandar_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                           isactive, name, jobstandartype, maintainarea, a_asset_group_id, mp_jobstandar_uu)
VALUES
(1000001, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Vehicle Oil Change', 'AA', 'ME', 50006, uuid_generate_v4()),
(1000002, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Vehicle Tire Rotation', 'AA', 'ME', 50006, uuid_generate_v4()),
(1000003, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Forklift Battery Service', 'AA', 'EL', 50006, uuid_generate_v4()),
(1000004, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Forklift Hydraulic Check', 'BB', 'ME', 50006, uuid_generate_v4()),
(1000005, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Conveyor Belt Inspection', 'AA', 'ME', 50007, uuid_generate_v4());

-- ============================================
-- 4. STANDARD JOB TASKS
-- ============================================
INSERT INTO mp_jobstandar_task (mp_jobstandar_task_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                                 isactive, mp_jobstandar_id, description, duration, c_uom_id, mp_jobstandar_task_uu)
VALUES
-- Vehicle Oil Change (1000001)
(1000001, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, 'Drain old oil', 0.5, 101, uuid_generate_v4()),
(1000002, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, 'Replace oil filter', 0.25, 101, uuid_generate_v4()),
(1000003, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, 'Add new oil (5L synthetic)', 0.25, 101, uuid_generate_v4()),
-- Vehicle Tire Rotation (1000002)
(1000004, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000002, 'Rotate front to back', 0.5, 101, uuid_generate_v4()),
(1000005, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000002, 'Check tire pressure', 0.25, 101, uuid_generate_v4()),
(1000006, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000002, 'Inspect tread depth', 0.25, 101, uuid_generate_v4()),
-- Forklift Battery Service (1000003)
(1000007, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000003, 'Check battery water level', 0.25, 101, uuid_generate_v4()),
(1000008, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000003, 'Clean battery terminals', 0.25, 101, uuid_generate_v4()),
(1000009, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000003, 'Test voltage and capacity', 0.5, 101, uuid_generate_v4()),
-- Forklift Hydraulic Check (1000004)
(1000010, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000004, 'Check hydraulic fluid level', 0.25, 101, uuid_generate_v4()),
(1000011, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000004, 'Inspect hoses for leaks', 0.5, 101, uuid_generate_v4()),
(1000012, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000004, 'Test lift mechanism', 0.5, 101, uuid_generate_v4()),
-- Conveyor Belt Inspection (1000005)
(1000013, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000005, 'Check belt tension', 0.5, 101, uuid_generate_v4()),
(1000014, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000005, 'Inspect belt condition', 0.5, 101, uuid_generate_v4()),
(1000015, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000005, 'Lubricate drive chain', 0.5, 101, uuid_generate_v4());

-- ============================================
-- 5. ASSET METERS
-- ============================================
INSERT INTO mp_assetmeter (mp_assetmeter_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                           isactive, a_asset_id, mp_meter_id, value, name, amt, datetrx, mp_assetmeter_uu)
VALUES
(1000001, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, 1000001, 'VH001-KM', 'Truck #1 Odometer', 45000, NOW(), uuid_generate_v4()),
(1000002, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000002, 1000001, 'VH002-KM', 'Van #1 Odometer', 32000, NOW(), uuid_generate_v4()),
(1000003, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000003, 1000002, 'FL001-HRS', 'Forklift #1 Hours', 1200, NOW(), uuid_generate_v4()),
(1000004, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000004, 1000002, 'FL002-HRS', 'Forklift #2 Hours', 850, NOW(), uuid_generate_v4()),
(1000005, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000005, 1000002, 'CV001-HRS', 'Conveyor Hours', 8500, NOW(), uuid_generate_v4());

-- ============================================
-- 6. MAINTENANCE SCHEDULES
-- ============================================
-- ProgrammingType: M=Meter, C=Calendar
INSERT INTO mp_maintain (mp_maintain_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                         isactive, documentno, ischild, a_asset_id, mp_jobstandar_id, mp_meter_id,
                         programmingtype, interval, lastmp, nextmp, lastread, currentmp, promuse, range,
                         datelastrun, datenextrun, docstatus, priorityrule, mp_maintain_uu)
VALUES
-- Truck #1 - Oil Change every 5000 KM
(1000001, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-F001', 'N', 1000001, 1000001, 1000001,
 'M', 5000, 40000, 45000, 45000, 45000, 500, 1000,
 '2025-11-01', NULL, 'AT', '5', uuid_generate_v4()),
-- Truck #1 - Tire Rotation every 10000 KM
(1000002, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-F002', 'N', 1000001, 1000002, 1000001,
 'M', 10000, 40000, 50000, 45000, 45000, 1000, 2000,
 '2025-10-01', NULL, 'AT', '5', uuid_generate_v4()),
-- Van #1 - Oil Change every 5000 KM
(1000003, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-F003', 'N', 1000002, 1000001, 1000001,
 'M', 5000, 30000, 35000, 32000, 32000, 500, 1000,
 '2025-12-01', NULL, 'AT', '5', uuid_generate_v4()),
-- Forklift #1 - Battery Service every 250 hours
(1000004, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-F004', 'N', 1000003, 1000003, 1000002,
 'M', 250, 1000, 1250, 1200, 1200, 50, 100,
 '2025-10-20', NULL, 'AT', '3', uuid_generate_v4()),
-- Forklift #2 - Battery Service every 250 hours
(1000005, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-F005', 'N', 1000004, 1000003, 1000002,
 'M', 250, 750, 1000, 850, 850, 50, 100,
 '2025-11-15', NULL, 'AT', '3', uuid_generate_v4()),
-- Conveyor - Inspection every 14 days (Calendar)
(1000006, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-F006', 'N', 1000005, 1000005, NULL,
 'C', 14, NULL, NULL, NULL, NULL, NULL, NULL,
 '2026-01-05', '2026-01-19', 'AT', '7', uuid_generate_v4());

-- ============================================
-- 7. METER LOGS (Sample Readings)
-- ============================================
INSERT INTO mp_assetmeter_log (mp_assetmeter_log_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                               isactive, mp_assetmeter_id, datetrx, amt, currentamt, description, mp_assetmeter_log_uu)
VALUES
-- Truck #1 KM readings
(1000001, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, '2025-11-01', 500, 40500, 'Weekly reading', uuid_generate_v4()),
(1000002, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, '2025-11-15', 1000, 41500, 'Bi-weekly', uuid_generate_v4()),
(1000003, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, '2025-12-01', 1500, 43000, 'Monthly', uuid_generate_v4()),
(1000004, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, '2025-12-15', 1000, 44000, 'Bi-weekly', uuid_generate_v4()),
(1000005, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, '2026-01-01', 1000, 45000, 'New Year', uuid_generate_v4()),
-- Van #1 KM readings
(1000006, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000002, '2025-11-01', 400, 30400, 'Weekly', uuid_generate_v4()),
(1000007, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000002, '2025-12-01', 800, 31200, 'Monthly', uuid_generate_v4()),
(1000008, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000002, '2026-01-01', 800, 32000, 'Monthly', uuid_generate_v4()),
-- Forklift #1 Hours
(1000009, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000003, '2025-11-01', 50, 1050, 'Bi-weekly', uuid_generate_v4()),
(1000010, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000003, '2025-12-01', 75, 1125, 'Monthly', uuid_generate_v4()),
(1000011, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000003, '2026-01-01', 75, 1200, 'Monthly', uuid_generate_v4()),
-- Forklift #2 Hours
(1000012, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000004, '2025-11-01', 40, 790, 'Bi-weekly', uuid_generate_v4()),
(1000013, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000004, '2025-12-01', 30, 820, 'Monthly', uuid_generate_v4()),
(1000014, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000004, '2026-01-01', 30, 850, 'Monthly', uuid_generate_v4()),
-- Conveyor Hours
(1000015, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000005, '2025-11-01', 150, 8200, 'Monthly', uuid_generate_v4()),
(1000016, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000005, '2025-12-01', 180, 8380, 'Monthly', uuid_generate_v4()),
(1000017, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000005, '2026-01-01', 120, 8500, 'Monthly', uuid_generate_v4());

-- ============================================
-- SUMMARY: Set 1 - Fleet Equipment
-- ============================================
-- Scenario: Logistics/Distribution Company
-- Assets: 2 Delivery Vehicles, 2 Forklifts, 1 Conveyor
-- Meters: Kilometers (vehicles), Operating Hours (equipment)
-- Jobs: Oil Change, Tire Rotation, Battery Service, Hydraulic Check, Belt Inspection
-- Maintenance: Mix of Meter-based and Calendar-based schedules
