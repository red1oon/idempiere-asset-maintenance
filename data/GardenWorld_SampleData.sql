-- AssetMaintenance Sample Data for GardenWorld
-- Run after 2Pack installation to set up test data
-- GardenWorld: AD_Client_ID=11, AD_Org_ID=11
-- SuperUser: AD_User_ID=100

-- ============================================
-- CLEANUP (Remove existing sample data)
-- ============================================
DELETE FROM mp_assetmeter_log WHERE mp_assetmeter_log_id >= 1000001;
DELETE FROM mp_maintain WHERE mp_maintain_id >= 1000001;
DELETE FROM mp_assetmeter WHERE mp_assetmeter_id >= 1000001;
DELETE FROM mp_jobstandar_task WHERE mp_jobstandar_task_id >= 1000001;
DELETE FROM mp_jobstandar WHERE mp_jobstandar_id >= 1000001;
DELETE FROM a_asset WHERE a_asset_id >= 1000001;
DELETE FROM mp_meter WHERE mp_meter_id >= 1000001;

-- ============================================
-- 1. METERS (Measurement Types)
-- ============================================
INSERT INTO mp_meter (mp_meter_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive, name, maxday, mp_meter_uu)
VALUES
(1000001, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Kilometers', 30, uuid_generate_v4()),
(1000002, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Operating Hours', 7, uuid_generate_v4());

-- ============================================
-- 2. ASSETS (Vehicles and Equipment)
-- ============================================
-- Uses existing GardenWorld asset products: Asset Vehicle (200001), Computers (200002)
INSERT INTO a_asset (a_asset_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive,
                     value, name, description, a_asset_group_id, m_product_id, assetservicedate, isowned, isdepreciated, isfullydepreciated, a_asset_uu)
VALUES
-- Vehicles (using Asset Vehicle product 200001)
(1000001, 11, 11, NOW(), 100, NOW(), 100, 'Y',
 'VH-001', 'Delivery Truck #1', 'Ford F-150 for deliveries', 50006, 200001, '2023-01-15', 'Y', 'N', 'N', uuid_generate_v4()),
(1000002, 11, 11, NOW(), 100, NOW(), 100, 'Y',
 'VH-002', 'Forklift #1', 'Toyota Forklift for warehouse', 50006, 200001, '2022-06-01', 'Y', 'N', 'N', uuid_generate_v4()),
-- Equipment (using Computers product 200002 as placeholder)
(1000003, 11, 11, NOW(), 100, NOW(), 100, 'Y',
 'EQ-001', 'Fertilizer Mixer', 'Industrial fertilizer mixing equipment', 50007, 200002, '2021-03-20', 'Y', 'N', 'N', uuid_generate_v4()),
(1000004, 11, 11, NOW(), 100, NOW(), 100, 'Y',
 'EQ-002', 'Conveyor Belt #1', 'Main warehouse conveyor belt', 50007, 200002, '2020-11-10', 'Y', 'N', 'N', uuid_generate_v4());

-- ============================================
-- 3. STANDARD JOBS (Maintenance Templates)
-- ============================================
-- JobStandarType: PM=Preventive, CR=Corrective
-- MaintainArea: ME=Mechanical, EL=Electrical
INSERT INTO mp_jobstandar (mp_jobstandar_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                           isactive, name, jobstandartype, maintainarea, a_asset_group_id, mp_jobstandar_uu)
VALUES
-- Vehicle maintenance jobs
(1000001, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Vehicle Oil Change', 'PM', 'ME', 50006, uuid_generate_v4()),
(1000002, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Vehicle Tire Inspection', 'PM', 'ME', 50006, uuid_generate_v4()),
(1000003, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Forklift Battery Check', 'PM', 'EL', 50006, uuid_generate_v4()),
-- Equipment maintenance jobs
(1000004, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Mixer Lubrication', 'PM', 'ME', 50007, uuid_generate_v4()),
(1000005, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Conveyor Belt Tension', 'PM', 'ME', 50007, uuid_generate_v4());

-- ============================================
-- 4. STANDARD JOB TASKS
-- ============================================
-- C_UOM_ID: 101=Hour, 102=Day
INSERT INTO mp_jobstandar_task (mp_jobstandar_task_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                                 isactive, mp_jobstandar_id, description, duration, c_uom_id, mp_jobstandar_task_uu)
VALUES
-- Tasks for Vehicle Oil Change (Job 1000001)
(1000001, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, 'Drain old oil', 0.5, 101, uuid_generate_v4()),
(1000002, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, 'Replace oil filter', 0.25, 101, uuid_generate_v4()),
(1000003, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, 'Add new oil (5L)', 0.25, 101, uuid_generate_v4()),
-- Tasks for Vehicle Tire Inspection (Job 1000002)
(1000004, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000002, 'Check tire pressure all wheels', 0.5, 101, uuid_generate_v4()),
(1000005, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000002, 'Check tire wear pattern', 0.25, 101, uuid_generate_v4()),
-- Tasks for Forklift Battery Check (Job 1000003)
(1000006, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000003, 'Check battery water level', 0.25, 101, uuid_generate_v4()),
(1000007, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000003, 'Clean battery terminals', 0.25, 101, uuid_generate_v4()),
(1000008, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000003, 'Test battery voltage', 0.25, 101, uuid_generate_v4()),
-- Tasks for Mixer Lubrication (Job 1000004)
(1000009, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000004, 'Grease all bearings', 1.0, 101, uuid_generate_v4()),
(1000010, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000004, 'Check gear oil level', 0.5, 101, uuid_generate_v4()),
-- Tasks for Conveyor Belt Tension (Job 1000005)
(1000011, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000005, 'Inspect belt condition', 0.5, 101, uuid_generate_v4()),
(1000012, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000005, 'Adjust tension rollers', 1.0, 101, uuid_generate_v4()),
(1000013, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000005, 'Lubricate drive chain', 0.5, 101, uuid_generate_v4());

-- ============================================
-- 5. ASSET METERS (Link Assets to Meters)
-- ============================================
INSERT INTO mp_assetmeter (mp_assetmeter_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                           isactive, a_asset_id, mp_meter_id, value, name, amt, datetrx, mp_assetmeter_uu)
VALUES
-- Delivery Truck - KM meter
(1000001, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, 1000001, 'VH001-KM', 'Truck #1 Odometer', 45000, NOW(), uuid_generate_v4()),
-- Forklift - Operating Hours meter
(1000002, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000002, 1000002, 'VH002-HRS', 'Forklift #1 Hours', 1200, NOW(), uuid_generate_v4()),
-- Fertilizer Mixer - Operating Hours meter
(1000003, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000003, 1000002, 'EQ001-HRS', 'Mixer Op. Hours', 5600, NOW(), uuid_generate_v4()),
-- Conveyor Belt - Operating Hours meter
(1000004, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000004, 1000002, 'EQ002-HRS', 'Conveyor Hours', 8500, NOW(), uuid_generate_v4());

-- ============================================
-- 6. MAINTENANCE SCHEDULES
-- ============================================
-- ProgrammingType: M=Meter, C=Calendar
-- DocStatus: AT=Active
-- PriorityRule: 5=Medium, 3=High, 7=Low
INSERT INTO mp_maintain (mp_maintain_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                         isactive, documentno, ischild, a_asset_id, mp_jobstandar_id, mp_meter_id,
                         programmingtype, interval, lastmp, nextmp, lastread, currentmp, promuse, range,
                         datelastrun, datenextrun, docstatus, priorityrule, mp_maintain_uu)
VALUES
-- Delivery Truck - Oil Change every 5000 KM (Meter-based)
(1000001, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-000001', 'N', 1000001, 1000001, 1000001,
 'M', 5000, 40000, 45000, 45000, 45000, 500, 1000,
 '2025-11-01', NULL, 'AT', '5', uuid_generate_v4()),

-- Delivery Truck - Tire Inspection every 30 days (Calendar-based)
(1000002, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-000002', 'N', 1000001, 1000002, NULL,
 'C', 30, NULL, NULL, NULL, NULL, NULL, NULL,
 '2025-12-15', '2026-01-14', 'AT', '5', uuid_generate_v4()),

-- Forklift - Battery Check every 250 hours (Meter-based)
(1000003, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-000003', 'N', 1000002, 1000003, 1000002,
 'M', 250, 1000, 1250, 1200, 1200, 50, 100,
 '2025-10-20', NULL, 'AT', '3', uuid_generate_v4()),

-- Mixer - Lubrication every 500 hours (Meter-based)
(1000004, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-000004', 'N', 1000003, 1000004, 1000002,
 'M', 500, 5500, 6000, 5600, 5600, 100, 200,
 '2025-12-01', NULL, 'AT', '5', uuid_generate_v4()),

-- Conveyor - Belt Tension every 14 days (Calendar-based)
(1000005, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-000005', 'N', 1000004, 1000005, NULL,
 'C', 14, NULL, NULL, NULL, NULL, NULL, NULL,
 '2026-01-05', '2026-01-19', 'AT', '7', uuid_generate_v4());

-- ============================================
-- 7. ASSET METER LOGS (Sample Readings)
-- ============================================
INSERT INTO mp_assetmeter_log (mp_assetmeter_log_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                               isactive, mp_assetmeter_id, datetrx, amt, currentamt, description, mp_assetmeter_log_uu)
VALUES
-- Delivery Truck KM readings
(1000001, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, '2025-11-01', 500, 40500, 'Weekly reading', uuid_generate_v4()),
(1000002, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, '2025-11-08', 520, 41020, 'Weekly reading', uuid_generate_v4()),
(1000003, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, '2025-11-15', 480, 41500, 'Weekly reading', uuid_generate_v4()),
(1000004, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, '2025-11-22', 510, 42010, 'Weekly reading', uuid_generate_v4()),
(1000005, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, '2025-11-29', 495, 42505, 'Weekly reading', uuid_generate_v4()),
(1000006, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, '2025-12-06', 530, 43035, 'Weekly reading', uuid_generate_v4()),
(1000007, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, '2025-12-13', 465, 43500, 'Weekly reading', uuid_generate_v4()),
(1000008, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, '2025-12-20', 500, 44000, 'Weekly reading', uuid_generate_v4()),
(1000009, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, '2025-12-27', 500, 44500, 'Weekly reading', uuid_generate_v4()),
(1000010, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, '2026-01-03', 500, 45000, 'Weekly reading', uuid_generate_v4()),

-- Forklift Hours readings
(1000011, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000002, '2025-11-01', 40, 1040, 'Weekly hours', uuid_generate_v4()),
(1000012, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000002, '2025-11-15', 45, 1085, 'Bi-weekly hours', uuid_generate_v4()),
(1000013, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000002, '2025-12-01', 50, 1135, 'Bi-weekly hours', uuid_generate_v4()),
(1000014, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000002, '2025-12-15', 35, 1170, 'Bi-weekly hours', uuid_generate_v4()),
(1000015, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000002, '2026-01-01', 30, 1200, 'Holiday period', uuid_generate_v4()),

-- Mixer Hours readings
(1000016, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000003, '2025-11-01', 100, 5400, 'Monthly reading', uuid_generate_v4()),
(1000017, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000003, '2025-12-01', 120, 5520, 'Monthly reading', uuid_generate_v4()),
(1000018, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000003, '2026-01-01', 80, 5600, 'Monthly reading', uuid_generate_v4()),

-- Conveyor Hours readings
(1000019, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000004, '2025-11-01', 150, 8200, 'Monthly reading', uuid_generate_v4()),
(1000020, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000004, '2025-12-01', 180, 8380, 'Monthly reading', uuid_generate_v4()),
(1000021, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000004, '2026-01-01', 120, 8500, 'Monthly reading', uuid_generate_v4());

-- ============================================
-- SUMMARY
-- ============================================
-- Created:
-- 2 Meter Types (Kilometers, Operating Hours)
-- 4 Assets (2 Vehicles, 2 Equipment)
-- 5 Standard Jobs with 13 Tasks
-- 4 Asset Meters linking assets to measurement types
-- 5 Maintenance Schedules (3 Meter-based, 2 Calendar-based)
-- 21 Meter Log entries for testing Prognosis

-- To test the setup:
-- 1. Open Asset Meter Log window and add new readings
-- 2. Run the Prognosis process to generate forecasted maintenance
-- 3. Check the Maintenance window for scheduled items
-- 4. Generate Work Orders (OT) from the Prognosis
