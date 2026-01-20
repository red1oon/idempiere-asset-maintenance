-- ============================================
-- LOAD ALL SAMPLE DATA SETS
-- ============================================
-- This script loads all 3 business model sample data sets
-- for AssetMaintenance/Maintenance Prevention module
--
-- GardenWorld: AD_Client_ID=11, AD_Org_ID=11
--
-- Business Models:
--   Set 1: Fleet Equipment (ID 1000001-1000099)
--   Set 2: Building/Facility (ID 1000101-1000199)
--   Set 3: Manufacturing (ID 1000201-1000299)
--
-- Usage:
--   psql -d idempiere -f LoadAllSampleData.sql
--   OR run each set individually
-- ============================================

\echo '============================================'
\echo 'Loading AssetMaintenance Sample Data'
\echo '============================================'

\echo ''
\echo 'Loading Set 1: Fleet Equipment...'
\i Set1_FleetEquipment.sql

\echo ''
\echo 'Loading Set 2: Building/Facility...'
\i Set2_BuildingFacility.sql

\echo ''
\echo 'Loading Set 3: Manufacturing...'
\i Set3_Manufacturing.sql

\echo ''
\echo '============================================'
\echo 'Sample Data Load Complete!'
\echo '============================================'
\echo ''
\echo 'Summary:'
\echo '  Set 1 - Fleet: Trucks, Vans, Forklifts, Conveyor'
\echo '  Set 2 - Building: HVAC, Elevators, Fire, Generator'
\echo '  Set 3 - Manufacturing: CNC, Assembly, Compressor, Press'
\echo ''
\echo 'Total: 19 Assets, 21 Jobs, 23 Maintenance Schedules'
\echo '============================================'
