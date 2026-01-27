-- ============================================
-- AssetMaintenance Sample Data for GardenWorld
-- ============================================
-- Run after 2Pack installation to set up test data
-- GardenWorld: AD_Client_ID=11, AD_Org_ID=11
-- SuperUser: AD_User_ID=100
--
-- This file contains 3 Business Model Sample Sets:
--   Set 1: Fleet Equipment (ID 1000001-1000099)
--   Set 2: Building/Facility (ID 1000101-1000199)
--   Set 3: Manufacturing (ID 1000201-1000299)
--
-- Each set demonstrates different maintenance scenarios.
-- See DemoGuide.md for detailed walkthrough.
-- ============================================
--
-- *** IMPORTANT: AFTER LOADING THIS SQL ***
-- Run "Sequence Check" from iDempiere to synchronize ID sequences:
--   1. Login as System Administrator (SuperUser/System)
--   2. Menu: System Admin → General Rules → System Rules → Sequence Check
--   3. Click OK to run
-- Without this, creating new records will cause duplicate key errors.
-- See data/history/technical_notes.txt for details.
-- ============================================

-- ============================================
-- SET 1: FLEET EQUIPMENT MAINTENANCE
-- ============================================
-- Business Model: Delivery vehicles, warehouse equipment
-- Use Case: Logistics, distribution, warehousing companies
-- ID Range: 1000001-1000099
-- ============================================

DELETE FROM mp_assetmeter_log WHERE mp_assetmeter_log_id BETWEEN 1000001 AND 1000099;
DELETE FROM mp_maintain_task WHERE mp_maintain_task_id BETWEEN 1000001 AND 1000099;
DELETE FROM mp_maintain WHERE mp_maintain_id BETWEEN 1000001 AND 1000099;
DELETE FROM mp_assetmeter WHERE mp_assetmeter_id BETWEEN 1000001 AND 1000099;
DELETE FROM mp_jobstandar_task WHERE mp_jobstandar_task_id BETWEEN 1000001 AND 1000099;
DELETE FROM mp_jobstandar WHERE mp_jobstandar_id BETWEEN 1000001 AND 1000099;
DELETE FROM a_asset WHERE a_asset_id BETWEEN 1000001 AND 1000099;
DELETE FROM mp_meter WHERE mp_meter_id BETWEEN 1000001 AND 1000099;

INSERT INTO mp_meter (mp_meter_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive, name, maxday, mp_meter_uu)
VALUES
(1000001, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Kilometers', 30, uuid_generate_v4()),
(1000002, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Operating Hours', 7, uuid_generate_v4());

INSERT INTO a_asset (a_asset_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive,
                     value, name, description, a_asset_group_id, m_product_id, assetservicedate, isowned, isdepreciated, isfullydepreciated, a_asset_uu)
VALUES
(1000001, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'VH-001', 'Delivery Truck #1', 'Ford F-150 for local deliveries', 50006, 200001, '2023-01-15', 'Y', 'N', 'N', uuid_generate_v4()),
(1000002, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'VH-002', 'Delivery Van #1', 'Mercedes Sprinter for urban routes', 50006, 200001, '2023-06-01', 'Y', 'N', 'N', uuid_generate_v4()),
(1000003, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'FL-001', 'Forklift #1', 'Toyota Electric Forklift 3-ton', 50006, 200001, '2022-06-01', 'Y', 'N', 'N', uuid_generate_v4()),
(1000004, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'FL-002', 'Forklift #2', 'Toyota Electric Forklift 2-ton', 50006, 200001, '2022-08-15', 'Y', 'N', 'N', uuid_generate_v4()),
(1000005, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'CV-001', 'Conveyor Belt #1', 'Main warehouse conveyor system', 50007, 200002, '2020-11-10', 'Y', 'N', 'N', uuid_generate_v4());

INSERT INTO mp_jobstandar (mp_jobstandar_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                           isactive, name, jobstandartype, maintainarea, a_asset_group_id, mp_jobstandar_uu)
VALUES
(1000001, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Vehicle Oil Change', 'AA', 'ME', 50006, uuid_generate_v4()),
(1000002, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Vehicle Tire Rotation', 'AA', 'ME', 50006, uuid_generate_v4()),
(1000003, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Forklift Battery Service', 'AA', 'EL', 50006, uuid_generate_v4()),
(1000004, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Forklift Hydraulic Check', 'BB', 'ME', 50006, uuid_generate_v4()),
(1000005, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Conveyor Belt Inspection', 'AA', 'ME', 50007, uuid_generate_v4());

INSERT INTO mp_jobstandar_task (mp_jobstandar_task_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                                 isactive, mp_jobstandar_id, description, duration, c_uom_id, mp_jobstandar_task_uu)
VALUES
(1000001, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, 'Drain old oil', 0.5, 101, uuid_generate_v4()),
(1000002, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, 'Replace oil filter', 0.25, 101, uuid_generate_v4()),
(1000003, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, 'Add new oil (5L synthetic)', 0.25, 101, uuid_generate_v4()),
(1000004, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000002, 'Rotate front to back', 0.5, 101, uuid_generate_v4()),
(1000005, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000002, 'Check tire pressure', 0.25, 101, uuid_generate_v4()),
(1000006, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000002, 'Inspect tread depth', 0.25, 101, uuid_generate_v4()),
(1000007, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000003, 'Check battery water level', 0.25, 101, uuid_generate_v4()),
(1000008, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000003, 'Clean battery terminals', 0.25, 101, uuid_generate_v4()),
(1000009, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000003, 'Test voltage and capacity', 0.5, 101, uuid_generate_v4()),
(1000010, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000004, 'Check hydraulic fluid level', 0.25, 101, uuid_generate_v4()),
(1000011, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000004, 'Inspect hoses for leaks', 0.5, 101, uuid_generate_v4()),
(1000012, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000004, 'Test lift mechanism', 0.5, 101, uuid_generate_v4()),
(1000013, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000005, 'Check belt tension', 0.5, 101, uuid_generate_v4()),
(1000014, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000005, 'Inspect belt condition', 0.5, 101, uuid_generate_v4()),
(1000015, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000005, 'Lubricate drive chain', 0.5, 101, uuid_generate_v4());

INSERT INTO mp_assetmeter (mp_assetmeter_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                           isactive, a_asset_id, mp_meter_id, value, name, amt, datetrx, mp_assetmeter_uu)
VALUES
(1000001, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, 1000001, 'VH001-KM', 'Truck #1 Odometer', 45000, NOW(), uuid_generate_v4()),
(1000002, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000002, 1000001, 'VH002-KM', 'Van #1 Odometer', 32000, NOW(), uuid_generate_v4()),
(1000003, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000003, 1000002, 'FL001-HRS', 'Forklift #1 Hours', 1200, NOW(), uuid_generate_v4()),
(1000004, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000004, 1000002, 'FL002-HRS', 'Forklift #2 Hours', 850, NOW(), uuid_generate_v4()),
(1000005, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000005, 1000002, 'CV001-HRS', 'Conveyor Hours', 8500, NOW(), uuid_generate_v4());

INSERT INTO mp_maintain (mp_maintain_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                         isactive, documentno, ischild, a_asset_id, mp_jobstandar_id, mp_meter_id,
                         programmingtype, interval, lastmp, nextmp, lastread, currentmp, promuse, range,
                         datelastrun, datenextrun, docstatus, priorityrule, mp_maintain_uu)
VALUES
(1000001, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-F001', 'N', 1000001, 1000001, 1000001, 'M', 5000, 40000, 45000, 45000, 45000, 500, 1000, '2025-11-01 00:00:00', NULL, 'AT', '5', uuid_generate_v4()),
(1000002, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-F002', 'N', 1000001, 1000002, 1000001, 'M', 10000, 40000, 50000, 45000, 45000, 1000, 2000, '2025-10-01 00:00:00', NULL, 'AT', '5', uuid_generate_v4()),
(1000003, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-F003', 'N', 1000002, 1000001, 1000001, 'M', 5000, 30000, 35000, 32000, 32000, 500, 1000, '2025-12-01 00:00:00', NULL, 'AT', '5', uuid_generate_v4()),
(1000004, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-F004', 'N', 1000003, 1000003, 1000002, 'M', 250, 1000, 1250, 1200, 1200, 50, 100, '2025-10-20 00:00:00', NULL, 'AT', '3', uuid_generate_v4()),
(1000005, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-F005', 'N', 1000004, 1000003, 1000002, 'M', 250, 750, 1000, 850, 850, 50, 100, '2025-11-15 00:00:00', NULL, 'AT', '3', uuid_generate_v4()),
(1000006, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-F006', 'N', 1000005, 1000005, NULL, 'C', 14, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-05 00:00:00', '2026-01-19 00:00:00', 'AT', '7', uuid_generate_v4());

INSERT INTO mp_maintain_task (mp_maintain_task_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                              isactive, mp_maintain_id, description, duration, c_uom_id, mp_maintain_task_uu)
VALUES
-- MP-F001: Vehicle Oil Change
(1000001, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, 'Drain old oil', 0.5, 101, uuid_generate_v4()),
(1000002, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, 'Replace oil filter', 0.25, 101, uuid_generate_v4()),
(1000003, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, 'Add new oil (5L synthetic)', 0.25, 101, uuid_generate_v4()),
-- MP-F002: Vehicle Tire Rotation
(1000004, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000002, 'Rotate front to back', 0.5, 101, uuid_generate_v4()),
(1000005, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000002, 'Check tire pressure', 0.25, 101, uuid_generate_v4()),
(1000006, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000002, 'Inspect tread depth', 0.25, 101, uuid_generate_v4()),
-- MP-F003: Vehicle Oil Change (Van)
(1000007, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000003, 'Drain old oil', 0.5, 101, uuid_generate_v4()),
(1000008, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000003, 'Replace oil filter', 0.25, 101, uuid_generate_v4()),
(1000009, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000003, 'Add new oil (5L synthetic)', 0.25, 101, uuid_generate_v4()),
-- MP-F004: Forklift Battery Service
(1000010, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000004, 'Check battery water level', 0.25, 101, uuid_generate_v4()),
(1000011, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000004, 'Clean battery terminals', 0.25, 101, uuid_generate_v4()),
(1000012, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000004, 'Test voltage and capacity', 0.5, 101, uuid_generate_v4()),
-- MP-F005: Forklift Battery Service (FL-002)
(1000013, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000005, 'Check battery water level', 0.25, 101, uuid_generate_v4()),
(1000014, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000005, 'Clean battery terminals', 0.25, 101, uuid_generate_v4()),
(1000015, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000005, 'Test voltage and capacity', 0.5, 101, uuid_generate_v4()),
-- MP-F006: Conveyor Belt Inspection
(1000016, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000006, 'Check belt tension', 0.5, 101, uuid_generate_v4()),
(1000017, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000006, 'Inspect belt condition', 0.5, 101, uuid_generate_v4()),
(1000018, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000006, 'Lubricate drive chain', 0.5, 101, uuid_generate_v4());

INSERT INTO mp_assetmeter_log (mp_assetmeter_log_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                               isactive, mp_assetmeter_id, datetrx, amt, currentamt, description, mp_assetmeter_log_uu)
VALUES
(1000001, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, '2025-11-01 00:00:00', 500, 40500, 'Weekly reading', uuid_generate_v4()),
(1000002, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, '2025-11-15 00:00:00', 1000, 41500, 'Bi-weekly', uuid_generate_v4()),
(1000003, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, '2025-12-01 00:00:00', 1500, 43000, 'Monthly', uuid_generate_v4()),
(1000004, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, '2025-12-15 00:00:00', 1000, 44000, 'Bi-weekly', uuid_generate_v4()),
(1000005, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000001, '2026-01-01 00:00:00', 1000, 45000, 'New Year', uuid_generate_v4()),
(1000006, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000002, '2025-11-01 00:00:00', 400, 30400, 'Weekly', uuid_generate_v4()),
(1000007, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000002, '2025-12-01 00:00:00', 800, 31200, 'Monthly', uuid_generate_v4()),
(1000008, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000002, '2026-01-01 00:00:00', 800, 32000, 'Monthly', uuid_generate_v4()),
(1000009, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000003, '2025-11-01 00:00:00', 50, 1050, 'Bi-weekly', uuid_generate_v4()),
(1000010, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000003, '2025-12-01 00:00:00', 75, 1125, 'Monthly', uuid_generate_v4()),
(1000011, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000003, '2026-01-01 00:00:00', 75, 1200, 'Monthly', uuid_generate_v4()),
(1000012, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000004, '2025-11-01 00:00:00', 40, 790, 'Bi-weekly', uuid_generate_v4()),
(1000013, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000004, '2025-12-01 00:00:00', 30, 820, 'Monthly', uuid_generate_v4()),
(1000014, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000004, '2026-01-01 00:00:00', 30, 850, 'Monthly', uuid_generate_v4()),
(1000015, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000005, '2025-11-01 00:00:00', 150, 8200, 'Monthly', uuid_generate_v4()),
(1000016, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000005, '2025-12-01 00:00:00', 180, 8380, 'Monthly', uuid_generate_v4()),
(1000017, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000005, '2026-01-01 00:00:00', 120, 8500, 'Monthly', uuid_generate_v4());


-- ============================================
-- SET 2: BUILDING/FACILITY MAINTENANCE
-- ============================================
-- Business Model: Commercial building, office, property management
-- Use Case: Property managers, facility management, real estate
-- ID Range: 1000101-1000199
-- ============================================

DELETE FROM mp_assetmeter_log WHERE mp_assetmeter_log_id BETWEEN 1000101 AND 1000199;
DELETE FROM mp_maintain_task WHERE mp_maintain_task_id BETWEEN 1000101 AND 1000199;
DELETE FROM mp_maintain WHERE mp_maintain_id BETWEEN 1000101 AND 1000199;
DELETE FROM mp_assetmeter WHERE mp_assetmeter_id BETWEEN 1000101 AND 1000199;
DELETE FROM mp_jobstandar_task WHERE mp_jobstandar_task_id BETWEEN 1000101 AND 1000199;
DELETE FROM mp_jobstandar WHERE mp_jobstandar_id BETWEEN 1000101 AND 1000199;
DELETE FROM a_asset WHERE a_asset_id BETWEEN 1000101 AND 1000199;
DELETE FROM mp_meter WHERE mp_meter_id BETWEEN 1000101 AND 1000199;

INSERT INTO mp_meter (mp_meter_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive, name, maxday, mp_meter_uu)
VALUES
(1000101, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Operating Hours (HVAC)', 7, uuid_generate_v4()),
(1000102, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Elevator Trips', 7, uuid_generate_v4()),
(1000103, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Generator Run Hours', 30, uuid_generate_v4());

INSERT INTO a_asset (a_asset_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive,
                     value, name, description, a_asset_group_id, m_product_id, assetservicedate, isowned, isdepreciated, isfullydepreciated, a_asset_uu)
VALUES
(1000101, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'HVAC-001', 'Main AC Unit Floor 1-3', 'Carrier 50-ton Rooftop Unit', 50007, 200002, '2020-03-15', 'Y', 'N', 'N', uuid_generate_v4()),
(1000102, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'HVAC-002', 'Main AC Unit Floor 4-6', 'Carrier 50-ton Rooftop Unit', 50007, 200002, '2020-03-15', 'Y', 'N', 'N', uuid_generate_v4()),
(1000103, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'ELV-001', 'Passenger Elevator #1', 'Otis Gen2 - 10 stops', 50007, 200002, '2019-06-01', 'Y', 'N', 'N', uuid_generate_v4()),
(1000104, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'ELV-002', 'Passenger Elevator #2', 'Otis Gen2 - 10 stops', 50007, 200002, '2019-06-01', 'Y', 'N', 'N', uuid_generate_v4()),
(1000105, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'ELV-003', 'Service Elevator', 'Freight elevator - 2 ton', 50007, 200002, '2019-06-01', 'Y', 'N', 'N', uuid_generate_v4()),
(1000106, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'FIRE-001', 'Fire Alarm System', 'Notifier NFS2-3030 Panel', 50007, 200002, '2019-01-15', 'Y', 'N', 'N', uuid_generate_v4()),
(1000107, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'FIRE-002', 'Sprinkler System', 'Wet pipe system - 6 floors', 50007, 200002, '2019-01-15', 'Y', 'N', 'N', uuid_generate_v4()),
(1000108, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'GEN-001', 'Backup Generator', 'Caterpillar 500kW Diesel', 50007, 200002, '2020-01-10', 'Y', 'N', 'N', uuid_generate_v4());

INSERT INTO mp_jobstandar (mp_jobstandar_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                           isactive, name, jobstandartype, maintainarea, a_asset_group_id, mp_jobstandar_uu)
VALUES
(1000101, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'HVAC Filter Replacement', 'AA', 'ME', 50007, uuid_generate_v4()),
(1000102, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'HVAC Coil Cleaning', 'AA', 'ME', 50007, uuid_generate_v4()),
(1000103, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'HVAC Refrigerant Check', 'BB', 'ME', 50007, uuid_generate_v4()),
(1000104, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Elevator Monthly Inspection', 'AA', 'ME', 50007, uuid_generate_v4()),
(1000105, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Elevator Annual Certification', 'AA', 'ME', 50007, uuid_generate_v4()),
(1000106, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Fire Alarm Test', 'AA', 'EL', 50007, uuid_generate_v4()),
(1000107, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Sprinkler Inspection', 'AA', 'ME', 50007, uuid_generate_v4()),
(1000108, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Generator Load Test', 'AA', 'EL', 50007, uuid_generate_v4());

INSERT INTO mp_jobstandar_task (mp_jobstandar_task_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                                 isactive, mp_jobstandar_id, description, duration, c_uom_id, mp_jobstandar_task_uu)
VALUES
(1000101, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000101, 'Access rooftop unit', 0.25, 101, uuid_generate_v4()),
(1000102, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000101, 'Remove old filters', 0.25, 101, uuid_generate_v4()),
(1000103, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000101, 'Install new MERV-13 filters', 0.5, 101, uuid_generate_v4()),
(1000104, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000101, 'Record pressure drop readings', 0.25, 101, uuid_generate_v4()),
(1000105, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000102, 'Apply coil cleaner solution', 0.5, 101, uuid_generate_v4()),
(1000106, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000102, 'Pressure wash coils', 1.0, 101, uuid_generate_v4()),
(1000107, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000102, 'Straighten bent fins', 0.5, 101, uuid_generate_v4()),
(1000108, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000103, 'Check refrigerant pressure', 0.5, 101, uuid_generate_v4()),
(1000109, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000103, 'Leak detection scan', 1.0, 101, uuid_generate_v4()),
(1000110, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000103, 'Top up refrigerant if needed', 0.5, 101, uuid_generate_v4()),
(1000111, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000104, 'Check door operation', 0.25, 101, uuid_generate_v4()),
(1000112, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000104, 'Inspect cables and sheaves', 0.5, 101, uuid_generate_v4()),
(1000113, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000104, 'Test emergency phone', 0.25, 101, uuid_generate_v4()),
(1000114, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000104, 'Lubricate guide rails', 0.5, 101, uuid_generate_v4()),
(1000115, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000105, 'Full safety inspection', 2.0, 101, uuid_generate_v4()),
(1000116, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000105, 'Load test (125%)', 1.0, 101, uuid_generate_v4()),
(1000117, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000105, 'Emergency brake test', 0.5, 101, uuid_generate_v4()),
(1000118, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000105, 'Update certification certificate', 0.5, 101, uuid_generate_v4()),
(1000119, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000106, 'Test all pull stations', 1.0, 101, uuid_generate_v4()),
(1000120, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000106, 'Test smoke detectors (sample)', 1.0, 101, uuid_generate_v4()),
(1000121, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000106, 'Verify panel communication', 0.5, 101, uuid_generate_v4()),
(1000122, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000107, 'Visual inspection all floors', 2.0, 101, uuid_generate_v4()),
(1000123, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000107, 'Check valve tamper switches', 0.5, 101, uuid_generate_v4()),
(1000124, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000107, 'Test water flow alarm', 0.5, 101, uuid_generate_v4()),
(1000125, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000108, 'Pre-start inspection', 0.5, 101, uuid_generate_v4()),
(1000126, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000108, 'Run at 50% load - 30 min', 0.5, 101, uuid_generate_v4()),
(1000127, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000108, 'Run at 75% load - 30 min', 0.5, 101, uuid_generate_v4()),
(1000128, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000108, 'Check fuel level and quality', 0.25, 101, uuid_generate_v4());

INSERT INTO mp_assetmeter (mp_assetmeter_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                           isactive, a_asset_id, mp_meter_id, value, name, amt, datetrx, mp_assetmeter_uu)
VALUES
(1000101, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000101, 1000101, 'HVAC001-HRS', 'AC Unit 1-3 Hours', 12500, NOW(), uuid_generate_v4()),
(1000102, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000102, 1000101, 'HVAC002-HRS', 'AC Unit 4-6 Hours', 12500, NOW(), uuid_generate_v4()),
(1000103, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000103, 1000102, 'ELV001-TRIP', 'Elevator #1 Trips', 85000, NOW(), uuid_generate_v4()),
(1000104, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000104, 1000102, 'ELV002-TRIP', 'Elevator #2 Trips', 82000, NOW(), uuid_generate_v4()),
(1000105, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000105, 1000102, 'ELV003-TRIP', 'Service Elev Trips', 25000, NOW(), uuid_generate_v4()),
(1000106, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000108, 1000103, 'GEN001-HRS', 'Generator Run Hours', 120, NOW(), uuid_generate_v4());

INSERT INTO mp_maintain (mp_maintain_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                         isactive, documentno, ischild, a_asset_id, mp_jobstandar_id, mp_meter_id,
                         programmingtype, interval, lastmp, nextmp, lastread, currentmp, promuse, range,
                         datelastrun, datenextrun, docstatus, priorityrule, mp_maintain_uu)
VALUES
(1000101, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-B001', 'N', 1000101, 1000101, NULL, 'C', 30, NULL, NULL, NULL, NULL, NULL, NULL, '2025-12-15 00:00:00', '2026-01-14 00:00:00', 'AT', '5', uuid_generate_v4()),
(1000102, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-B002', 'N', 1000101, 1000102, 1000101, 'M', 2000, 12000, 14000, 12500, 12500, 200, 500, '2025-10-01 00:00:00', NULL, 'AT', '5', uuid_generate_v4()),
(1000103, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-B003', 'N', 1000102, 1000101, NULL, 'C', 30, NULL, NULL, NULL, NULL, NULL, NULL, '2025-12-15 00:00:00', '2026-01-14 00:00:00', 'AT', '5', uuid_generate_v4()),
(1000104, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-B004', 'N', 1000103, 1000104, NULL, 'C', 30, NULL, NULL, NULL, NULL, NULL, NULL, '2025-12-20 00:00:00', '2026-01-19 00:00:00', 'AT', '3', uuid_generate_v4()),
(1000105, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-B005', 'N', 1000103, 1000105, NULL, 'C', 365, NULL, NULL, NULL, NULL, NULL, NULL, '2025-06-01 00:00:00', '2026-06-01 00:00:00', 'AT', '3', uuid_generate_v4()),
(1000106, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-B006', 'N', 1000104, 1000104, NULL, 'C', 30, NULL, NULL, NULL, NULL, NULL, NULL, '2025-12-20 00:00:00', '2026-01-19 00:00:00', 'AT', '3', uuid_generate_v4()),
(1000107, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-B007', 'N', 1000106, 1000106, NULL, 'C', 90, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-15 00:00:00', '2026-01-13 00:00:00', 'AT', '3', uuid_generate_v4()),
(1000108, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-B008', 'N', 1000107, 1000107, NULL, 'C', 365, NULL, NULL, NULL, NULL, NULL, NULL, '2025-03-01 00:00:00', '2026-03-01 00:00:00', 'AT', '3', uuid_generate_v4()),
(1000109, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-B009', 'N', 1000108, 1000108, NULL, 'C', 30, NULL, NULL, NULL, NULL, NULL, NULL, '2025-12-15 00:00:00', '2026-01-14 00:00:00', 'AT', '5', uuid_generate_v4());

INSERT INTO mp_maintain_task (mp_maintain_task_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                              isactive, mp_maintain_id, description, duration, c_uom_id, mp_maintain_task_uu)
VALUES
-- MP-B001: HVAC Filter Replacement (Unit 1-3)
(1000101, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000101, 'Access rooftop unit', 0.25, 101, uuid_generate_v4()),
(1000102, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000101, 'Remove old filters', 0.25, 101, uuid_generate_v4()),
(1000103, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000101, 'Install new MERV-13 filters', 0.5, 101, uuid_generate_v4()),
(1000104, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000101, 'Record pressure drop readings', 0.25, 101, uuid_generate_v4()),
-- MP-B002: HVAC Coil Cleaning
(1000105, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000102, 'Apply coil cleaner solution', 0.5, 101, uuid_generate_v4()),
(1000106, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000102, 'Pressure wash coils', 1.0, 101, uuid_generate_v4()),
(1000107, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000102, 'Straighten bent fins', 0.5, 101, uuid_generate_v4()),
-- MP-B003: HVAC Filter Replacement (Unit 4-6)
(1000108, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000103, 'Access rooftop unit', 0.25, 101, uuid_generate_v4()),
(1000109, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000103, 'Remove old filters', 0.25, 101, uuid_generate_v4()),
(1000110, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000103, 'Install new MERV-13 filters', 0.5, 101, uuid_generate_v4()),
(1000111, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000103, 'Record pressure drop readings', 0.25, 101, uuid_generate_v4()),
-- MP-B004: Elevator #1 Monthly Inspection
(1000112, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000104, 'Check door operation', 0.25, 101, uuid_generate_v4()),
(1000113, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000104, 'Inspect cables and sheaves', 0.5, 101, uuid_generate_v4()),
(1000114, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000104, 'Test emergency phone', 0.25, 101, uuid_generate_v4()),
(1000115, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000104, 'Lubricate guide rails', 0.5, 101, uuid_generate_v4()),
-- MP-B005: Elevator #1 Annual Certification
(1000116, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000105, 'Full safety inspection', 2.0, 101, uuid_generate_v4()),
(1000117, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000105, 'Load test (125%)', 1.0, 101, uuid_generate_v4()),
(1000118, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000105, 'Emergency brake test', 0.5, 101, uuid_generate_v4()),
(1000119, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000105, 'Update certification certificate', 0.5, 101, uuid_generate_v4()),
-- MP-B006: Elevator #2 Monthly Inspection
(1000120, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000106, 'Check door operation', 0.25, 101, uuid_generate_v4()),
(1000121, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000106, 'Inspect cables and sheaves', 0.5, 101, uuid_generate_v4()),
(1000122, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000106, 'Test emergency phone', 0.25, 101, uuid_generate_v4()),
(1000123, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000106, 'Lubricate guide rails', 0.5, 101, uuid_generate_v4()),
-- MP-B007: Fire Alarm Test
(1000124, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000107, 'Test all pull stations', 1.0, 101, uuid_generate_v4()),
(1000125, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000107, 'Test smoke detectors (sample)', 1.0, 101, uuid_generate_v4()),
(1000126, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000107, 'Verify panel communication', 0.5, 101, uuid_generate_v4()),
-- MP-B008: Sprinkler Inspection
(1000127, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000108, 'Visual inspection all floors', 2.0, 101, uuid_generate_v4()),
(1000128, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000108, 'Check valve tamper switches', 0.5, 101, uuid_generate_v4()),
(1000129, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000108, 'Test water flow alarm', 0.5, 101, uuid_generate_v4()),
-- MP-B009: Generator Load Test
(1000130, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000109, 'Pre-start inspection', 0.5, 101, uuid_generate_v4()),
(1000131, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000109, 'Run at 50% load - 30 min', 0.5, 101, uuid_generate_v4()),
(1000132, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000109, 'Run at 75% load - 30 min', 0.5, 101, uuid_generate_v4()),
(1000133, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000109, 'Check fuel level and quality', 0.25, 101, uuid_generate_v4());

INSERT INTO mp_assetmeter_log (mp_assetmeter_log_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                               isactive, mp_assetmeter_id, datetrx, amt, currentamt, description, mp_assetmeter_log_uu)
VALUES
(1000101, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000101, '2025-10-01 00:00:00', 350, 11800, 'Monthly', uuid_generate_v4()),
(1000102, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000101, '2025-11-01 00:00:00', 380, 12180, 'Monthly', uuid_generate_v4()),
(1000103, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000101, '2025-12-01 00:00:00', 320, 12500, 'Monthly', uuid_generate_v4()),
(1000104, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000102, '2025-10-01 00:00:00', 340, 11820, 'Monthly', uuid_generate_v4()),
(1000105, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000102, '2025-11-01 00:00:00', 360, 12180, 'Monthly', uuid_generate_v4()),
(1000106, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000102, '2025-12-01 00:00:00', 320, 12500, 'Monthly', uuid_generate_v4()),
(1000107, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000103, '2025-10-01 00:00:00', 2500, 80000, 'Monthly', uuid_generate_v4()),
(1000108, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000103, '2025-11-01 00:00:00', 2800, 82800, 'Monthly', uuid_generate_v4()),
(1000109, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000103, '2025-12-01 00:00:00', 2200, 85000, 'Monthly', uuid_generate_v4()),
(1000110, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000104, '2025-10-01 00:00:00', 2400, 77200, 'Monthly', uuid_generate_v4()),
(1000111, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000104, '2025-11-01 00:00:00', 2600, 79800, 'Monthly', uuid_generate_v4()),
(1000112, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000104, '2025-12-01 00:00:00', 2200, 82000, 'Monthly', uuid_generate_v4()),
(1000113, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000105, '2025-10-01 00:00:00', 800, 23400, 'Monthly', uuid_generate_v4()),
(1000114, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000105, '2025-11-01 00:00:00', 900, 24300, 'Monthly', uuid_generate_v4()),
(1000115, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000105, '2025-12-01 00:00:00', 700, 25000, 'Monthly', uuid_generate_v4()),
(1000116, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000106, '2025-10-15 00:00:00', 2, 116, 'Monthly test', uuid_generate_v4()),
(1000117, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000106, '2025-11-15 00:00:00', 2, 118, 'Monthly test', uuid_generate_v4()),
(1000118, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000106, '2025-12-15 00:00:00', 2, 120, 'Monthly test', uuid_generate_v4());


-- ============================================
-- SET 3: MANUFACTURING EQUIPMENT
-- ============================================
-- Business Model: Factory, production line, industrial equipment
-- Use Case: Manufacturing plants, assembly lines, food processing
-- ID Range: 1000201-1000299
-- ============================================

DELETE FROM mp_assetmeter_log WHERE mp_assetmeter_log_id BETWEEN 1000201 AND 1000299;
DELETE FROM mp_maintain_task WHERE mp_maintain_task_id BETWEEN 1000201 AND 1000299;
DELETE FROM mp_maintain WHERE mp_maintain_id BETWEEN 1000201 AND 1000299;
DELETE FROM mp_assetmeter WHERE mp_assetmeter_id BETWEEN 1000201 AND 1000299;
DELETE FROM mp_jobstandar_task WHERE mp_jobstandar_task_id BETWEEN 1000201 AND 1000299;
DELETE FROM mp_jobstandar WHERE mp_jobstandar_id BETWEEN 1000201 AND 1000299;
DELETE FROM a_asset WHERE a_asset_id BETWEEN 1000201 AND 1000299;
DELETE FROM mp_meter WHERE mp_meter_id BETWEEN 1000201 AND 1000299;

INSERT INTO mp_meter (mp_meter_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive, name, maxday, mp_meter_uu)
VALUES
(1000201, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Machine Hours', 7, uuid_generate_v4()),
(1000202, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Production Cycles', 1, uuid_generate_v4()),
(1000203, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Spindle Hours (CNC)', 7, uuid_generate_v4());

INSERT INTO a_asset (a_asset_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive,
                     value, name, description, a_asset_group_id, m_product_id, assetservicedate, isowned, isdepreciated, isfullydepreciated, a_asset_uu)
VALUES
(1000201, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'CNC-001', 'CNC Lathe #1', 'Haas ST-10 CNC Turning Center', 50007, 200002, '2021-03-15', 'Y', 'N', 'N', uuid_generate_v4()),
(1000202, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'CNC-002', 'CNC Mill #1', 'Haas VF-2 Vertical Mill', 50007, 200002, '2021-03-15', 'Y', 'N', 'N', uuid_generate_v4()),
(1000203, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'ASM-001', 'Assembly Line A', 'Main product assembly line', 50007, 200002, '2019-06-01', 'Y', 'N', 'N', uuid_generate_v4()),
(1000204, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'PKG-001', 'Packaging Machine #1', 'Automated box sealer and labeler', 50007, 200002, '2020-01-15', 'Y', 'N', 'N', uuid_generate_v4()),
(1000205, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'CMP-001', 'Air Compressor', 'Atlas Copco GA-30 Rotary Screw', 50007, 200002, '2018-09-01', 'Y', 'N', 'N', uuid_generate_v4()),
(1000206, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'PRS-001', 'Hydraulic Press', '100-ton forming press', 50007, 200002, '2017-05-20', 'Y', 'N', 'N', uuid_generate_v4());

INSERT INTO mp_jobstandar (mp_jobstandar_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                           isactive, name, jobstandartype, maintainarea, a_asset_group_id, mp_jobstandar_uu)
VALUES
(1000201, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'CNC Spindle Lubrication', 'AA', 'ME', 50007, uuid_generate_v4()),
(1000202, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'CNC Way Wiper Replacement', 'AA', 'ME', 50007, uuid_generate_v4()),
(1000203, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'CNC Coolant System Service', 'AA', 'ME', 50007, uuid_generate_v4()),
(1000204, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Conveyor Belt Inspection', 'AA', 'ME', 50007, uuid_generate_v4()),
(1000205, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Sensor Calibration', 'AA', 'EL', 50007, uuid_generate_v4()),
(1000206, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Compressor Oil Change', 'AA', 'ME', 50007, uuid_generate_v4()),
(1000207, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Air Filter Replacement', 'AA', 'ME', 50007, uuid_generate_v4()),
(1000208, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Hydraulic Fluid Change', 'AA', 'ME', 50007, uuid_generate_v4());

INSERT INTO mp_jobstandar_task (mp_jobstandar_task_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                                 isactive, mp_jobstandar_id, description, duration, c_uom_id, mp_jobstandar_task_uu)
VALUES
(1000201, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000201, 'Check spindle oil level', 0.25, 101, uuid_generate_v4()),
(1000202, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000201, 'Top up spindle oil', 0.25, 101, uuid_generate_v4()),
(1000203, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000201, 'Check for leaks', 0.25, 101, uuid_generate_v4()),
(1000204, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000202, 'Remove old way wipers', 0.5, 101, uuid_generate_v4()),
(1000205, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000202, 'Clean way surfaces', 0.5, 101, uuid_generate_v4()),
(1000206, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000202, 'Install new wipers', 0.5, 101, uuid_generate_v4()),
(1000207, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000202, 'Test axis movement', 0.25, 101, uuid_generate_v4()),
(1000208, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000203, 'Drain old coolant', 0.5, 101, uuid_generate_v4()),
(1000209, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000203, 'Clean sump and tank', 1.0, 101, uuid_generate_v4()),
(1000210, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000203, 'Replace coolant filter', 0.25, 101, uuid_generate_v4()),
(1000211, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000203, 'Fill with fresh coolant', 0.5, 101, uuid_generate_v4()),
(1000212, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000204, 'Check belt tension', 0.5, 101, uuid_generate_v4()),
(1000213, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000204, 'Inspect for wear/damage', 0.5, 101, uuid_generate_v4()),
(1000214, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000204, 'Lubricate bearings', 0.5, 101, uuid_generate_v4()),
(1000215, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000205, 'Test proximity sensors', 0.5, 101, uuid_generate_v4()),
(1000216, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000205, 'Calibrate photoelectric sensors', 0.5, 101, uuid_generate_v4()),
(1000217, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000205, 'Verify safety interlocks', 0.5, 101, uuid_generate_v4()),
(1000218, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000206, 'Drain old oil', 0.5, 101, uuid_generate_v4()),
(1000219, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000206, 'Replace oil filter', 0.25, 101, uuid_generate_v4()),
(1000220, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000206, 'Fill with new synthetic oil', 0.5, 101, uuid_generate_v4()),
(1000221, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000206, 'Check oil separator', 0.25, 101, uuid_generate_v4()),
(1000222, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000207, 'Remove old filter element', 0.25, 101, uuid_generate_v4()),
(1000223, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000207, 'Clean filter housing', 0.25, 101, uuid_generate_v4()),
(1000224, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000207, 'Install new filter', 0.25, 101, uuid_generate_v4()),
(1000225, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000208, 'Drain hydraulic reservoir', 1.0, 101, uuid_generate_v4()),
(1000226, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000208, 'Replace hydraulic filter', 0.5, 101, uuid_generate_v4()),
(1000227, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000208, 'Fill with ISO 46 hydraulic oil', 1.0, 101, uuid_generate_v4()),
(1000228, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000208, 'Bleed air from system', 0.5, 101, uuid_generate_v4());

INSERT INTO mp_assetmeter (mp_assetmeter_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                           isactive, a_asset_id, mp_meter_id, value, name, amt, datetrx, mp_assetmeter_uu)
VALUES
(1000201, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000201, 1000203, 'CNC001-SPD', 'Lathe Spindle Hours', 4500, NOW(), uuid_generate_v4()),
(1000202, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000202, 1000203, 'CNC002-SPD', 'Mill Spindle Hours', 3800, NOW(), uuid_generate_v4()),
(1000203, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000203, 1000202, 'ASM001-CYC', 'Assembly Cycles', 125000, NOW(), uuid_generate_v4()),
(1000204, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000204, 1000202, 'PKG001-CYC', 'Packaging Cycles', 89000, NOW(), uuid_generate_v4()),
(1000205, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000205, 1000201, 'CMP001-HRS', 'Compressor Hours', 18500, NOW(), uuid_generate_v4()),
(1000206, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000206, 1000202, 'PRS001-CYC', 'Press Cycles', 45000, NOW(), uuid_generate_v4());

INSERT INTO mp_maintain (mp_maintain_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                         isactive, documentno, ischild, a_asset_id, mp_jobstandar_id, mp_meter_id,
                         programmingtype, interval, lastmp, nextmp, lastread, currentmp, promuse, range,
                         datelastrun, datenextrun, docstatus, priorityrule, mp_maintain_uu)
VALUES
(1000201, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-M001', 'N', 1000201, 1000201, 1000203, 'M', 500, 4000, 4500, 4500, 4500, 50, 100, '2025-11-15 00:00:00', NULL, 'AT', '3', uuid_generate_v4()),
(1000202, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-M002', 'N', 1000201, 1000202, 1000203, 'M', 2000, 4000, 6000, 4500, 4500, 200, 500, '2025-09-01 00:00:00', NULL, 'AT', '5', uuid_generate_v4()),
(1000203, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-M003', 'N', 1000202, 1000203, 1000203, 'M', 1000, 3000, 4000, 3800, 3800, 100, 200, '2025-10-01 00:00:00', NULL, 'AT', '5', uuid_generate_v4()),
(1000204, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-M004', 'N', 1000203, 1000204, NULL, 'C', 7, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-13 00:00:00', '2026-01-20 00:00:00', 'AT', '5', uuid_generate_v4()),
(1000205, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-M005', 'N', 1000203, 1000205, NULL, 'C', 30, NULL, NULL, NULL, NULL, NULL, NULL, '2025-12-20 00:00:00', '2026-01-19 00:00:00', 'AT', '3', uuid_generate_v4()),
(1000206, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-M006', 'N', 1000205, 1000206, 1000201, 'M', 4000, 16000, 20000, 18500, 18500, 500, 1000, '2025-08-01 00:00:00', NULL, 'AT', '5', uuid_generate_v4()),
(1000207, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-M007', 'N', 1000205, 1000207, 1000201, 'M', 2000, 18000, 20000, 18500, 18500, 200, 500, '2025-11-01 00:00:00', NULL, 'AT', '5', uuid_generate_v4()),
(1000208, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-M008', 'N', 1000206, 1000208, 1000202, 'M', 10000, 40000, 50000, 45000, 45000, 1000, 2000, '2025-07-15 00:00:00', NULL, 'AT', '5', uuid_generate_v4());

INSERT INTO mp_maintain_task (mp_maintain_task_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                              isactive, mp_maintain_id, description, duration, c_uom_id, mp_maintain_task_uu)
VALUES
-- MP-M001: CNC Spindle Lubrication (Lathe)
(1000201, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000201, 'Check spindle oil level', 0.25, 101, uuid_generate_v4()),
(1000202, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000201, 'Top up spindle oil', 0.25, 101, uuid_generate_v4()),
(1000203, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000201, 'Check for leaks', 0.25, 101, uuid_generate_v4()),
-- MP-M002: CNC Way Wiper Replacement (Lathe)
(1000204, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000202, 'Remove old way wipers', 0.5, 101, uuid_generate_v4()),
(1000205, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000202, 'Clean way surfaces', 0.5, 101, uuid_generate_v4()),
(1000206, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000202, 'Install new wipers', 0.5, 101, uuid_generate_v4()),
(1000207, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000202, 'Test axis movement', 0.25, 101, uuid_generate_v4()),
-- MP-M003: CNC Coolant System Service (Mill)
(1000208, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000203, 'Drain old coolant', 0.5, 101, uuid_generate_v4()),
(1000209, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000203, 'Clean sump and tank', 1.0, 101, uuid_generate_v4()),
(1000210, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000203, 'Replace coolant filter', 0.25, 101, uuid_generate_v4()),
(1000211, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000203, 'Fill with fresh coolant', 0.5, 101, uuid_generate_v4()),
-- MP-M004: Assembly Line Conveyor Belt Inspection
(1000212, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000204, 'Check belt tension', 0.5, 101, uuid_generate_v4()),
(1000213, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000204, 'Inspect for wear/damage', 0.5, 101, uuid_generate_v4()),
(1000214, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000204, 'Lubricate bearings', 0.5, 101, uuid_generate_v4()),
-- MP-M005: Assembly Line Sensor Calibration
(1000215, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000205, 'Test proximity sensors', 0.5, 101, uuid_generate_v4()),
(1000216, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000205, 'Calibrate photoelectric sensors', 0.5, 101, uuid_generate_v4()),
(1000217, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000205, 'Verify safety interlocks', 0.5, 101, uuid_generate_v4()),
-- MP-M006: Compressor Oil Change
(1000218, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000206, 'Drain old oil', 0.5, 101, uuid_generate_v4()),
(1000219, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000206, 'Replace oil filter', 0.25, 101, uuid_generate_v4()),
(1000220, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000206, 'Fill with new synthetic oil', 0.5, 101, uuid_generate_v4()),
(1000221, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000206, 'Check oil separator', 0.25, 101, uuid_generate_v4()),
-- MP-M007: Compressor Air Filter Replacement
(1000222, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000207, 'Remove old filter element', 0.25, 101, uuid_generate_v4()),
(1000223, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000207, 'Clean filter housing', 0.25, 101, uuid_generate_v4()),
(1000224, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000207, 'Install new filter', 0.25, 101, uuid_generate_v4()),
-- MP-M008: Hydraulic Press Fluid Change
(1000225, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000208, 'Drain hydraulic reservoir', 1.0, 101, uuid_generate_v4()),
(1000226, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000208, 'Replace hydraulic filter', 0.5, 101, uuid_generate_v4()),
(1000227, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000208, 'Fill with ISO 46 hydraulic oil', 1.0, 101, uuid_generate_v4()),
(1000228, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000208, 'Bleed air from system', 0.5, 101, uuid_generate_v4());

INSERT INTO mp_assetmeter_log (mp_assetmeter_log_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                               isactive, mp_assetmeter_id, datetrx, amt, currentamt, description, mp_assetmeter_log_uu)
VALUES
(1000201, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000201, '2025-10-01 00:00:00', 150, 4050, 'Monthly', uuid_generate_v4()),
(1000202, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000201, '2025-11-01 00:00:00', 200, 4250, 'Monthly', uuid_generate_v4()),
(1000203, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000201, '2025-12-01 00:00:00', 180, 4430, 'Monthly', uuid_generate_v4()),
(1000204, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000201, '2026-01-01 00:00:00', 70, 4500, 'Monthly', uuid_generate_v4()),
(1000205, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000202, '2025-10-01 00:00:00', 120, 3440, 'Monthly', uuid_generate_v4()),
(1000206, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000202, '2025-11-01 00:00:00', 180, 3620, 'Monthly', uuid_generate_v4()),
(1000207, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000202, '2025-12-01 00:00:00', 130, 3750, 'Monthly', uuid_generate_v4()),
(1000208, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000202, '2026-01-01 00:00:00', 50, 3800, 'Monthly', uuid_generate_v4()),
(1000209, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000203, '2025-10-01 00:00:00', 8000, 109000, 'Monthly', uuid_generate_v4()),
(1000210, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000203, '2025-11-01 00:00:00', 9000, 118000, 'Monthly', uuid_generate_v4()),
(1000211, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000203, '2025-12-01 00:00:00', 7000, 125000, 'Monthly', uuid_generate_v4()),
(1000212, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000204, '2025-10-01 00:00:00', 6000, 77000, 'Monthly', uuid_generate_v4()),
(1000213, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000204, '2025-11-01 00:00:00', 7000, 84000, 'Monthly', uuid_generate_v4()),
(1000214, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000204, '2025-12-01 00:00:00', 5000, 89000, 'Monthly', uuid_generate_v4()),
(1000215, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000205, '2025-10-01 00:00:00', 350, 17800, 'Monthly', uuid_generate_v4()),
(1000216, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000205, '2025-11-01 00:00:00', 400, 18200, 'Monthly', uuid_generate_v4()),
(1000217, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000205, '2025-12-01 00:00:00', 300, 18500, 'Monthly', uuid_generate_v4()),
(1000218, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000206, '2025-10-01 00:00:00', 1500, 42000, 'Monthly', uuid_generate_v4()),
(1000219, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000206, '2025-11-01 00:00:00', 1800, 43800, 'Monthly', uuid_generate_v4()),
(1000220, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000206, '2025-12-01 00:00:00', 1200, 45000, 'Monthly', uuid_generate_v4());


-- ============================================
-- SUMMARY
-- ============================================
-- Total Records Created:
--   Meters: 8 (2 Fleet + 3 Building + 3 Manufacturing)
--   Assets: 19 (5 Fleet + 8 Building + 6 Manufacturing)
--   Standard Jobs: 21 (5 Fleet + 8 Building + 8 Manufacturing)
--   Job Tasks: 71 (15 Fleet + 28 Building + 28 Manufacturing)
--   Asset Meters: 17 (5 Fleet + 6 Building + 6 Manufacturing)
--   Maintenance: 23 (6 Fleet + 9 Building + 8 Manufacturing)
--   Maintenance Tasks: 79 (18 Fleet + 33 Building + 28 Manufacturing)
--   Meter Logs: 55 (17 Fleet + 18 Building + 20 Manufacturing)
--
-- See DemoGuide.md for detailed walkthrough of each scenario.
-- ============================================
