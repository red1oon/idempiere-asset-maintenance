-- ============================================
-- SET 2: BUILDING/FACILITY MAINTENANCE
-- ============================================
-- Business Model: Commercial building, office, property management
-- Use Case: Property managers, facility management, real estate
-- GardenWorld: AD_Client_ID=11, AD_Org_ID=11
-- ID Range: 1000101-1000199
-- ============================================

-- CLEANUP Set 2
DELETE FROM mp_assetmeter_log WHERE mp_assetmeter_log_id BETWEEN 1000101 AND 1000199;
DELETE FROM mp_maintain WHERE mp_maintain_id BETWEEN 1000101 AND 1000199;
DELETE FROM mp_assetmeter WHERE mp_assetmeter_id BETWEEN 1000101 AND 1000199;
DELETE FROM mp_jobstandar_task WHERE mp_jobstandar_task_id BETWEEN 1000101 AND 1000199;
DELETE FROM mp_jobstandar WHERE mp_jobstandar_id BETWEEN 1000101 AND 1000199;
DELETE FROM a_asset WHERE a_asset_id BETWEEN 1000101 AND 1000199;
DELETE FROM mp_meter WHERE mp_meter_id BETWEEN 1000101 AND 1000199;

-- ============================================
-- 1. METERS (Building-specific)
-- ============================================
INSERT INTO mp_meter (mp_meter_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive, name, maxday, mp_meter_uu)
VALUES
(1000101, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Operating Hours (HVAC)', 7, uuid_generate_v4()),
(1000102, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Elevator Trips', 7, uuid_generate_v4()),
(1000103, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Generator Run Hours', 30, uuid_generate_v4());

-- ============================================
-- 2. ASSETS (Building Equipment)
-- ============================================
INSERT INTO a_asset (a_asset_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive,
                     value, name, description, a_asset_group_id, m_product_id, assetservicedate, isowned, isdepreciated, isfullydepreciated, a_asset_uu)
VALUES
-- HVAC Systems
(1000101, 11, 11, NOW(), 100, NOW(), 100, 'Y',
 'HVAC-001', 'Main AC Unit Floor 1-3', 'Carrier 50-ton Rooftop Unit', 50007, 200002, '2020-03-15', 'Y', 'N', 'N', uuid_generate_v4()),
(1000102, 11, 11, NOW(), 100, NOW(), 100, 'Y',
 'HVAC-002', 'Main AC Unit Floor 4-6', 'Carrier 50-ton Rooftop Unit', 50007, 200002, '2020-03-15', 'Y', 'N', 'N', uuid_generate_v4()),
-- Elevators
(1000103, 11, 11, NOW(), 100, NOW(), 100, 'Y',
 'ELV-001', 'Passenger Elevator #1', 'Otis Gen2 - 10 stops', 50007, 200002, '2019-06-01', 'Y', 'N', 'N', uuid_generate_v4()),
(1000104, 11, 11, NOW(), 100, NOW(), 100, 'Y',
 'ELV-002', 'Passenger Elevator #2', 'Otis Gen2 - 10 stops', 50007, 200002, '2019-06-01', 'Y', 'N', 'N', uuid_generate_v4()),
(1000105, 11, 11, NOW(), 100, NOW(), 100, 'Y',
 'ELV-003', 'Service Elevator', 'Freight elevator - 2 ton capacity', 50007, 200002, '2019-06-01', 'Y', 'N', 'N', uuid_generate_v4()),
-- Fire Safety
(1000106, 11, 11, NOW(), 100, NOW(), 100, 'Y',
 'FIRE-001', 'Fire Alarm System', 'Notifier NFS2-3030 Panel', 50007, 200002, '2019-01-15', 'Y', 'N', 'N', uuid_generate_v4()),
(1000107, 11, 11, NOW(), 100, NOW(), 100, 'Y',
 'FIRE-002', 'Sprinkler System', 'Wet pipe system - 6 floors', 50007, 200002, '2019-01-15', 'Y', 'N', 'N', uuid_generate_v4()),
-- Power
(1000108, 11, 11, NOW(), 100, NOW(), 100, 'Y',
 'GEN-001', 'Backup Generator', 'Caterpillar 500kW Diesel', 50007, 200002, '2020-01-10', 'Y', 'N', 'N', uuid_generate_v4());

-- ============================================
-- 3. STANDARD JOBS (Building Maintenance)
-- ============================================
INSERT INTO mp_jobstandar (mp_jobstandar_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                           isactive, name, jobstandartype, maintainarea, a_asset_group_id, mp_jobstandar_uu)
VALUES
-- HVAC Jobs
(1000101, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'HVAC Filter Replacement', 'AA', 'ME', 50007, uuid_generate_v4()),
(1000102, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'HVAC Coil Cleaning', 'AA', 'ME', 50007, uuid_generate_v4()),
(1000103, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'HVAC Refrigerant Check', 'BB', 'ME', 50007, uuid_generate_v4()),
-- Elevator Jobs
(1000104, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Elevator Monthly Inspection', 'AA', 'ME', 50007, uuid_generate_v4()),
(1000105, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Elevator Annual Certification', 'AA', 'ME', 50007, uuid_generate_v4()),
-- Fire Safety Jobs
(1000106, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Fire Alarm Test', 'AA', 'EL', 50007, uuid_generate_v4()),
(1000107, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Sprinkler Inspection', 'AA', 'ME', 50007, uuid_generate_v4()),
-- Generator Jobs
(1000108, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'Generator Load Test', 'AA', 'EL', 50007, uuid_generate_v4());

-- ============================================
-- 4. STANDARD JOB TASKS
-- ============================================
INSERT INTO mp_jobstandar_task (mp_jobstandar_task_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                                 isactive, mp_jobstandar_id, description, duration, c_uom_id, mp_jobstandar_task_uu)
VALUES
-- HVAC Filter Replacement (1000101)
(1000101, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000101, 'Access rooftop unit', 0.25, 101, uuid_generate_v4()),
(1000102, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000101, 'Remove old filters', 0.25, 101, uuid_generate_v4()),
(1000103, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000101, 'Install new MERV-13 filters', 0.5, 101, uuid_generate_v4()),
(1000104, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000101, 'Record pressure drop readings', 0.25, 101, uuid_generate_v4()),
-- HVAC Coil Cleaning (1000102)
(1000105, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000102, 'Apply coil cleaner solution', 0.5, 101, uuid_generate_v4()),
(1000106, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000102, 'Pressure wash coils', 1.0, 101, uuid_generate_v4()),
(1000107, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000102, 'Straighten bent fins', 0.5, 101, uuid_generate_v4()),
-- HVAC Refrigerant Check (1000103)
(1000108, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000103, 'Check refrigerant pressure', 0.5, 101, uuid_generate_v4()),
(1000109, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000103, 'Leak detection scan', 1.0, 101, uuid_generate_v4()),
(1000110, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000103, 'Top up refrigerant if needed', 0.5, 101, uuid_generate_v4()),
-- Elevator Monthly Inspection (1000104)
(1000111, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000104, 'Check door operation', 0.25, 101, uuid_generate_v4()),
(1000112, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000104, 'Inspect cables and sheaves', 0.5, 101, uuid_generate_v4()),
(1000113, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000104, 'Test emergency phone', 0.25, 101, uuid_generate_v4()),
(1000114, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000104, 'Lubricate guide rails', 0.5, 101, uuid_generate_v4()),
-- Elevator Annual Certification (1000105)
(1000115, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000105, 'Full safety inspection', 2.0, 101, uuid_generate_v4()),
(1000116, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000105, 'Load test (125%)', 1.0, 101, uuid_generate_v4()),
(1000117, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000105, 'Emergency brake test', 0.5, 101, uuid_generate_v4()),
(1000118, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000105, 'Update certification certificate', 0.5, 101, uuid_generate_v4()),
-- Fire Alarm Test (1000106)
(1000119, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000106, 'Test all pull stations', 1.0, 101, uuid_generate_v4()),
(1000120, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000106, 'Test smoke detectors (sample)', 1.0, 101, uuid_generate_v4()),
(1000121, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000106, 'Verify panel communication', 0.5, 101, uuid_generate_v4()),
-- Sprinkler Inspection (1000107)
(1000122, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000107, 'Visual inspection all floors', 2.0, 101, uuid_generate_v4()),
(1000123, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000107, 'Check valve tamper switches', 0.5, 101, uuid_generate_v4()),
(1000124, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000107, 'Test water flow alarm', 0.5, 101, uuid_generate_v4()),
-- Generator Load Test (1000108)
(1000125, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000108, 'Pre-start inspection', 0.5, 101, uuid_generate_v4()),
(1000126, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000108, 'Run at 50% load - 30 min', 0.5, 101, uuid_generate_v4()),
(1000127, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000108, 'Run at 75% load - 30 min', 0.5, 101, uuid_generate_v4()),
(1000128, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000108, 'Check fuel level and quality', 0.25, 101, uuid_generate_v4());

-- ============================================
-- 5. ASSET METERS
-- ============================================
INSERT INTO mp_assetmeter (mp_assetmeter_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                           isactive, a_asset_id, mp_meter_id, value, name, amt, datetrx, mp_assetmeter_uu)
VALUES
-- HVAC Hours
(1000101, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000101, 1000101, 'HVAC001-HRS', 'AC Unit 1-3 Hours', 12500, NOW(), uuid_generate_v4()),
(1000102, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000102, 1000101, 'HVAC002-HRS', 'AC Unit 4-6 Hours', 12500, NOW(), uuid_generate_v4()),
-- Elevator Trips
(1000103, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000103, 1000102, 'ELV001-TRIP', 'Elevator #1 Trips', 85000, NOW(), uuid_generate_v4()),
(1000104, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000104, 1000102, 'ELV002-TRIP', 'Elevator #2 Trips', 82000, NOW(), uuid_generate_v4()),
(1000105, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000105, 1000102, 'ELV003-TRIP', 'Service Elev Trips', 25000, NOW(), uuid_generate_v4()),
-- Generator Hours
(1000106, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000108, 1000103, 'GEN001-HRS', 'Generator Run Hours', 120, NOW(), uuid_generate_v4());

-- ============================================
-- 6. MAINTENANCE SCHEDULES
-- ============================================
INSERT INTO mp_maintain (mp_maintain_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                         isactive, documentno, ischild, a_asset_id, mp_jobstandar_id, mp_meter_id,
                         programmingtype, interval, lastmp, nextmp, lastread, currentmp, promuse, range,
                         datelastrun, datenextrun, docstatus, priorityrule, mp_maintain_uu)
VALUES
-- HVAC Unit 1-3: Filter every 30 days (Calendar)
(1000101, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-B001', 'N', 1000101, 1000101, NULL,
 'C', 30, NULL, NULL, NULL, NULL, NULL, NULL,
 '2025-12-15', '2026-01-14', 'AT', '5', uuid_generate_v4()),
-- HVAC Unit 1-3: Coil cleaning every 2000 hours (Meter)
(1000102, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-B002', 'N', 1000101, 1000102, 1000101,
 'M', 2000, 12000, 14000, 12500, 12500, 200, 500,
 '2025-10-01', NULL, 'AT', '5', uuid_generate_v4()),
-- HVAC Unit 4-6: Filter every 30 days (Calendar)
(1000103, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-B003', 'N', 1000102, 1000101, NULL,
 'C', 30, NULL, NULL, NULL, NULL, NULL, NULL,
 '2025-12-15', '2026-01-14', 'AT', '5', uuid_generate_v4()),
-- Elevator #1: Monthly inspection every 30 days
(1000104, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-B004', 'N', 1000103, 1000104, NULL,
 'C', 30, NULL, NULL, NULL, NULL, NULL, NULL,
 '2025-12-20', '2026-01-19', 'AT', '3', uuid_generate_v4()),
-- Elevator #1: Annual certification every 365 days
(1000105, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-B005', 'N', 1000103, 1000105, NULL,
 'C', 365, NULL, NULL, NULL, NULL, NULL, NULL,
 '2025-06-01', '2026-06-01', 'AT', '3', uuid_generate_v4()),
-- Elevator #2: Monthly inspection
(1000106, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-B006', 'N', 1000104, 1000104, NULL,
 'C', 30, NULL, NULL, NULL, NULL, NULL, NULL,
 '2025-12-20', '2026-01-19', 'AT', '3', uuid_generate_v4()),
-- Fire Alarm: Quarterly test (90 days)
(1000107, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-B007', 'N', 1000106, 1000106, NULL,
 'C', 90, NULL, NULL, NULL, NULL, NULL, NULL,
 '2025-10-15', '2026-01-13', 'AT', '3', uuid_generate_v4()),
-- Sprinkler: Annual inspection (365 days)
(1000108, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-B008', 'N', 1000107, 1000107, NULL,
 'C', 365, NULL, NULL, NULL, NULL, NULL, NULL,
 '2025-03-01', '2026-03-01', 'AT', '3', uuid_generate_v4()),
-- Generator: Monthly load test (30 days)
(1000109, 11, 11, NOW(), 100, NOW(), 100, 'Y', 'MP-B009', 'N', 1000108, 1000108, NULL,
 'C', 30, NULL, NULL, NULL, NULL, NULL, NULL,
 '2025-12-15', '2026-01-14', 'AT', '5', uuid_generate_v4());

-- ============================================
-- 7. METER LOGS (Sample Readings)
-- ============================================
INSERT INTO mp_assetmeter_log (mp_assetmeter_log_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby,
                               isactive, mp_assetmeter_id, datetrx, amt, currentamt, description, mp_assetmeter_log_uu)
VALUES
-- HVAC Unit 1-3 Hours
(1000101, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000101, '2025-10-01', 350, 11800, 'Monthly reading', uuid_generate_v4()),
(1000102, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000101, '2025-11-01', 380, 12180, 'Monthly reading', uuid_generate_v4()),
(1000103, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000101, '2025-12-01', 320, 12500, 'Monthly reading', uuid_generate_v4()),
-- HVAC Unit 4-6 Hours
(1000104, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000102, '2025-10-01', 340, 11820, 'Monthly reading', uuid_generate_v4()),
(1000105, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000102, '2025-11-01', 360, 12180, 'Monthly reading', uuid_generate_v4()),
(1000106, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000102, '2025-12-01', 320, 12500, 'Monthly reading', uuid_generate_v4()),
-- Elevator #1 Trips
(1000107, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000103, '2025-10-01', 2500, 80000, 'Monthly count', uuid_generate_v4()),
(1000108, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000103, '2025-11-01', 2800, 82800, 'Monthly count', uuid_generate_v4()),
(1000109, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000103, '2025-12-01', 2200, 85000, 'Monthly count', uuid_generate_v4()),
-- Elevator #2 Trips
(1000110, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000104, '2025-10-01', 2400, 77200, 'Monthly count', uuid_generate_v4()),
(1000111, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000104, '2025-11-01', 2600, 79800, 'Monthly count', uuid_generate_v4()),
(1000112, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000104, '2025-12-01', 2200, 82000, 'Monthly count', uuid_generate_v4()),
-- Service Elevator Trips
(1000113, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000105, '2025-10-01', 800, 23400, 'Monthly count', uuid_generate_v4()),
(1000114, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000105, '2025-11-01', 900, 24300, 'Monthly count', uuid_generate_v4()),
(1000115, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000105, '2025-12-01', 700, 25000, 'Monthly count', uuid_generate_v4()),
-- Generator Hours (infrequent - only during outages/tests)
(1000116, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000106, '2025-10-15', 2, 116, 'Monthly test', uuid_generate_v4()),
(1000117, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000106, '2025-11-15', 2, 118, 'Monthly test', uuid_generate_v4()),
(1000118, 11, 11, NOW(), 100, NOW(), 100, 'Y', 1000106, '2025-12-15', 2, 120, 'Monthly test', uuid_generate_v4());

-- ============================================
-- SUMMARY: Set 2 - Building/Facility
-- ============================================
-- Scenario: Commercial Office Building (6 floors)
-- Assets: 2 HVAC Units, 3 Elevators, Fire System, Generator
-- Meters: Operating Hours, Elevator Trips, Generator Hours
-- Jobs: Filter change, Coil cleaning, Elevator inspect, Fire test, etc.
-- Key Features:
--   - Heavy use of Calendar-based maintenance (regulatory compliance)
--   - Fire safety quarterly/annual requirements
--   - Elevator certification requirements
--   - Generator monthly testing requirement
