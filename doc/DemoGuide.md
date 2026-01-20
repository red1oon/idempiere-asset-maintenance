# Asset Maintenance Demo Guide

**Version:** 1.13 for iDempiere Release 13
**Module:** Maintenance Prevention (MP)

---

## Overview

The Maintenance Prevention module helps organizations schedule and track preventive maintenance for physical assets. It supports two programming types:

- **Meter-based (M)**: Trigger maintenance when usage reaches a threshold (e.g., every 5000 km)
- **Calendar-based (C)**: Trigger maintenance on a time interval (e.g., every 30 days)

---

## Menu Structure

```
Maintenance Prevention (MP)
├── Work Shop (Operational)
│   ├── Meter Log          - Record meter readings
│   ├── Request OT         - Create maintenance requests
│   └── Work Order (OT)    - Execute work orders
├── Office (Management)
│   ├── Prognosis (Forecast)    - Forecast upcoming maintenance
│   ├── Prognosis Approval      - Approve forecasts
│   └── Requests Approval       - Approve requests
└── Setup (Configuration)
    ├── Meter              - Define measurement types
    ├── Maintenance        - Schedule maintenance
    ├── Standard Job       - Job templates with tasks
    ├── Department         - Organizational units
    └── Cost Center        - Cost tracking
```

---

## Sample Data Sets

Three business model scenarios are included for reference:

| Set | Business Model | Assets | Use Case |
|-----|---------------|--------|----------|
| 1 | Fleet Equipment | Trucks, Vans, Forklifts, Conveyor | Logistics, Distribution |
| 2 | Building/Facility | HVAC, Elevators, Fire Systems, Generator | Property Management |
| 3 | Manufacturing | CNC Machines, Assembly Line, Compressor | Factory, Production |

---

## Set 1: Fleet Equipment Maintenance

**Scenario:** A distribution company maintaining delivery vehicles and warehouse equipment.

### Assets
| Code | Name | Meter Type |
|------|------|------------|
| VH-001 | Delivery Truck #1 | Kilometers |
| VH-002 | Delivery Van #1 | Kilometers |
| FL-001 | Forklift #1 | Operating Hours |
| FL-002 | Forklift #2 | Operating Hours |
| CV-001 | Conveyor Belt #1 | Operating Hours |

### Standard Jobs
| Job | Type | Area | Trigger |
|-----|------|------|---------|
| Vehicle Oil Change | Type A (Routine) | Mechanical | Every 5,000 km |
| Vehicle Tire Rotation | Type A (Routine) | Mechanical | Every 10,000 km |
| Forklift Battery Service | Type A (Routine) | Electrical | Every 250 hours |
| Forklift Hydraulic Check | Type B (Corrective) | Mechanical | On demand |
| Conveyor Belt Inspection | Type A (Routine) | Mechanical | Every 14 days |

### Demo Walkthrough

1. **Setup → Meter**: View "Kilometers" and "Operating Hours" meters
2. **Setup → Standard Job**: Open "Vehicle Oil Change" - see 3 tasks:
   - Drain old oil (0.5 hr)
   - Replace oil filter (0.25 hr)
   - Add new oil (0.25 hr)
3. **Setup → Maintenance**: View MP-F001 schedule:
   - Asset: Delivery Truck #1
   - Job: Vehicle Oil Change
   - Interval: 5,000 km (Meter-based)
   - Last MP: 40,000 km, Next MP: 45,000 km
4. **Work Shop → Meter Log**: Add a new reading for Truck #1
5. **Office → Prognosis**: Run forecast to see upcoming maintenance

---

## Set 2: Building/Facility Maintenance

**Scenario:** A commercial office building with HVAC, elevators, and fire safety systems.

### Assets
| Code | Name | Meter Type |
|------|------|------------|
| HVAC-001 | Main AC Unit Floor 1-3 | Operating Hours |
| HVAC-002 | Main AC Unit Floor 4-6 | Operating Hours |
| ELV-001 | Passenger Elevator #1 | Elevator Trips |
| ELV-002 | Passenger Elevator #2 | Elevator Trips |
| ELV-003 | Service Elevator | Elevator Trips |
| FIRE-001 | Fire Alarm System | - |
| FIRE-002 | Sprinkler System | - |
| GEN-001 | Backup Generator | Run Hours |

### Standard Jobs
| Job | Type | Area | Trigger |
|-----|------|------|---------|
| HVAC Filter Replacement | Type A | Mechanical | Every 30 days |
| HVAC Coil Cleaning | Type A | Mechanical | Every 2,000 hours |
| Elevator Monthly Inspection | Type A | Mechanical | Every 30 days |
| Elevator Annual Certification | Type A | Mechanical | Every 365 days |
| Fire Alarm Test | Type A | Electrical | Every 90 days |
| Sprinkler Inspection | Type A | Mechanical | Every 365 days |
| Generator Load Test | Type A | Electrical | Every 30 days |

### Key Points

- **Calendar-based dominance**: Most building maintenance follows fixed schedules for regulatory compliance
- **Compliance requirements**: Fire alarm (quarterly), elevator certification (annual), sprinkler (annual)
- **Generator testing**: Monthly load tests to ensure emergency readiness

### Demo Walkthrough

1. **Setup → Maintenance**: View MP-B005 (Elevator Annual Certification)
   - Programming Type: Calendar (C)
   - Interval: 365 days
   - Date Next Run: 2026-06-01
2. **Setup → Standard Job**: Open "Fire Alarm Test" - see compliance tasks
3. **Setup → Meter**: View "Elevator Trips" meter (tracks usage)

---

## Set 3: Manufacturing Equipment

**Scenario:** A small manufacturing plant with CNC machines, assembly line, and utilities.

### Assets
| Code | Name | Meter Type |
|------|------|------------|
| CNC-001 | CNC Lathe #1 | Spindle Hours |
| CNC-002 | CNC Mill #1 | Spindle Hours |
| ASM-001 | Assembly Line A | Production Cycles |
| PKG-001 | Packaging Machine #1 | Production Cycles |
| CMP-001 | Air Compressor | Machine Hours |
| PRS-001 | Hydraulic Press | Production Cycles |

### Standard Jobs
| Job | Type | Area | Trigger |
|-----|------|------|---------|
| CNC Spindle Lubrication | Type A | Mechanical | Every 500 spindle hrs |
| CNC Way Wiper Replacement | Type A | Mechanical | Every 2,000 spindle hrs |
| CNC Coolant System Service | Type A | Mechanical | Every 1,000 spindle hrs |
| Conveyor Belt Inspection | Type A | Mechanical | Every 7 days |
| Sensor Calibration | Type A | Electrical | Every 30 days |
| Compressor Oil Change | Type A | Mechanical | Every 4,000 hours |
| Air Filter Replacement | Type A | Mechanical | Every 2,000 hours |
| Hydraulic Fluid Change | Type A | Mechanical | Every 10,000 cycles |

### Key Points

- **Meter-based dominance**: Manufacturing triggers maintenance by actual usage
- **CNC-specific**: Spindle hours track cutting time (wear)
- **High-cycle equipment**: Assembly line cycles in the hundreds of thousands
- **Critical utilities**: Compressor serves entire plant

### Demo Walkthrough

1. **Setup → Meter**: View "Production Cycles" meter (maxday=1 for daily reading)
2. **Setup → Maintenance**: View MP-M001 (CNC Spindle Lubrication)
   - Interval: 500 spindle hours
   - Promuse (Warning): 50 hours before due
   - Range: 100 hours overdue tolerance
3. **Work Shop → Meter Log**: See high-volume cycle counts

---

## Workflow: Complete Cycle

### Step 1: Setup (One-time)

1. Define **Meters** (measurement types)
2. Create **Standard Jobs** with tasks
3. Link **Assets** to meters (Asset → Asset Meter tab)
4. Create **Maintenance** schedules

### Step 2: Daily Operations

1. **Meter Log**: Record readings (manual or automated)
2. System calculates when maintenance is due

### Step 3: Planning

1. **Prognosis (Forecast)**: Run to see upcoming maintenance
2. **Prognosis Approval**: Review and approve

### Step 4: Execution

1. **Request OT**: Create maintenance request
2. **Requests Approval**: Approve request
3. **Work Order (OT)**: Execute and complete

---

## Key Concepts

### Programming Types

| Type | Code | When to Use |
|------|------|-------------|
| Meter-based | M | Usage-driven (km, hours, cycles) |
| Calendar-based | C | Time-driven (days, weeks, months) |

### Maintenance Fields (Meter-based)

| Field | Description |
|-------|-------------|
| Interval | Units between maintenance (e.g., 5000 km) |
| LastMP | Last maintenance point |
| NextMP | Next maintenance due point |
| CurrentMP | Current meter reading |
| Promuse | Warning threshold before due |
| Range | Overdue tolerance |

### Maintenance Fields (Calendar-based)

| Field | Description |
|-------|-------------|
| Interval | Days between maintenance |
| DateLastRun | When last performed |
| DateNextRun | When next due |

### Job Standard Types

| Code | Name | Description |
|------|------|-------------|
| AA | Type A | Routine/Preventive maintenance |
| BB | Type B | Corrective maintenance |

### Maintain Areas

| Code | Name |
|------|------|
| ME | Mechanical |
| EL | Electrical |

---

## Loading Sample Data

```bash
# Load all 3 sets
psql -d idempiere -f data/GardenWorld_SampleData.sql

# Or load individual sets
psql -d idempiere -f data/Set1_FleetEquipment.sql
psql -d idempiere -f data/Set2_BuildingFacility.sql
psql -d idempiere -f data/Set3_Manufacturing.sql
```

---

## Summary Statistics

| Item | Set 1 | Set 2 | Set 3 | Total |
|------|-------|-------|-------|-------|
| Meters | 2 | 3 | 3 | 8 |
| Assets | 5 | 8 | 6 | 19 |
| Standard Jobs | 5 | 8 | 8 | 21 |
| Job Tasks | 15 | 28 | 28 | 71 |
| Asset Meters | 5 | 6 | 6 | 17 |
| Maintenance Schedules | 6 | 9 | 8 | 23 |
| Meter Logs | 17 | 18 | 20 | 55 |

---

## Next Steps

1. **Explore the data**: Navigate each menu item with the sample data
2. **Create Print Formats**: Build reports using iDempiere's Print Format
3. **Run Prognosis**: Forecast upcoming maintenance
4. **Add your own**: Use sample data as templates for your business

---

*Asset Maintenance Module for iDempiere Release 13*
