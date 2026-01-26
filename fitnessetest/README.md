# Asset Maintenance FitNesse Tests

FitNesse acceptance tests for the iDempiere Asset Maintenance plugin.

## Test Coverage

| Test | Model | Description |
|------|-------|-------------|
| Test01_MP_Meter | MP_Meter | Meter types (Km, Hours, Days) |
| Test02_MP_AssetMeter | MP_AssetMeter | Asset-meter links |
| Test03_MP_AssetMeter_Log | MP_AssetMeter_Log | Meter reading history |
| Test04_MP_JobStandar | MP_JobStandar | Standard job definitions |
| Test05_MP_JobStandar_Task | MP_JobStandar_Task | Job task templates |
| Test06_MP_Maintain | MP_Maintain | Maintenance schedules |
| Test07_MP_OT | MP_OT | Work orders & DocType |
| Test08_MP_OT_Task | MP_OT_Task | Work order tasks |
| Test09_MP_OT_Resource | MP_OT_Resource | Work order resources |
| Test10_MP_OT_Request | MP_OT_Request | Maintenance requests |
| Test11_CreateWorkOrder | Full Workflow | Create & complete WO |

## Prerequisites

1. **iDempiere running** with FitNesse plugins:
   - `org.idempiere.fitnesse.server`
   - `org.idempiere.fitnesse.fixture`

2. **2Packs imported:**
   - `202601261000_SYSTEM_PreventiveMaintenance.zip`
   - `202601261000_GardenWorld_SampleData.zip`

3. **Generic runner** from `red1-ninja-roundtrip`:
   - `RUN_FitNesseTest.sh`

## Running Tests

### Via Wiki UI
```bash
# Start FitNesse
cd idempiere-fitnesse && ./run.sh

# Open browser: http://localhost:8089
# Import wiki pages and run
```

### Via Command Line (Silent)
```bash
# Run all tests
./RUN_AssetMaintenanceTests.sh

# Run with XML output (for CI)
./RUN_AssetMaintenanceTests.sh xml

# Run single test (using generic runner)
$ROUNDTRIP_HOME/RUN_FitNesseTest.sh Test07_MP_OT test
```

## Environment Variables

| Variable | Description |
|----------|-------------|
| `ROUNDTRIP_HOME` | Path to red1-ninja-roundtrip |
| `FITNESSE_HOME` | FitNesse installation |
| `FITNESSE_PORT` | FitNesse port (default: 8089) |
| `IDEMPIERE_HOME` | iDempiere installation |

## Key Assertions

### DocType Auto-Default
```
!|Create Record|
|*Table*      |MP_OT                    |
|description  |Test WO                  |
|*Save*       |                         |

!|Assert Record|
|*Table*      |MP_OT                    |
|c_doctype_id |50010                    |  <-- Auto-set!
```

### Meter Count Verification
```
!|Set Variable|
|@Count@      |@SQL=SELECT COUNT(*) FROM mp_meter WHERE ad_client_id=11|

!|Assert Variable|
|@Count@      |3|
```

## References

- [iDempiere FitNesse](https://github.com/idempiere/idempiere-fitnesse)
- [Fixture Reference](https://wiki.idempiere.org/en/Fitnesse.FixtureReference)
