# Asset Maintenance Plugin for iDempiere

Preventive and corrective maintenance management for iDempiere assets.

Originally developed by OFB Consulting (Chile). 
Converted to OSGi plugin by red1org@gmail.com.
Sponsored by Zeeshan@SYSNOVA.com

## Features

- **Preventive Maintenance** - Schedule recurring maintenance by calendar or meter readings
- **Meter Tracking** - Track asset usage (kilometers, hours, cycles)
- **Job Standards** - Create reusable job templates with tasks and resources
- **Maintenance Requests** - Submit unscheduled or emergency work requests
- **Work Orders** - Execute and complete maintenance tasks
- **Maintenance Forecast** - Predict upcoming maintenance needs

## Installation

### Step 1: Deploy the Plugin

Copy the plugin JAR to your iDempiere plugins folder, or deploy from Eclipse:

```bash
# If using Eclipse, export as Deployable plug-ins
# Target: {idempiere-server}/plugins/
```

### Step 2: Start the Plugin

1. Open the OSGi console or use Felix Web Console
2. Find the bundle: `org.asset.maintenance`
3. Start the bundle (if not auto-started)

```bash
# OSGi console commands
ss org.asset  # Find bundle ID
start <id>    # Start the bundle
```

### Step 3: Verify 2Pack Installation

When the plugin starts, it automatically installs the 2Pack from `META-INF/2Pack.zip`:

1. Check the server log for: `2Pack PreventiveMaintenance installed`
2. Or check: System Admin → General Rules → System Rules → Installed Plug-ins

### Step 4: Reset Cache

After 2Pack installation:
1. Login as System Administrator
2. Go to: System Admin → General Rules → System Rules → Reset Cache
3. Click the Process button

### Step 5: Install Sample Data (Optional)

To load GardenWorld sample data for testing:

1. Login as **GardenAdmin** (Client: GardenWorld)
2. Go to: System Admin → General Rules → System Rules → Pack In
3. Click the folder icon and select: `data/GardenWorldSample.zip`
4. Click Process to import

The sample data includes:
- 15 assets (vehicles, equipment, facilities)
- 3 meters (Odometer, Operating Hours, Production Cycles)
- 8 standard job templates
- 10 preventive maintenance schedules
- Maintenance requests and work orders

## Menu Location

After installation, find the module at:
- **Maintenance Prevention (MP)** menu folder

Key windows:
- Preventive Maintenance - Schedule maintenance
- Meter - Define meter types
- Job Standard - Create job templates
- Maintenance Request - Submit requests
- Work Order - Execute maintenance
- Maintenance Forecast - Run prognosis

## File Structure

```
org.asset.maintenance/
├── META-INF/
│   ├── 2Pack.zip           # System dictionary (AD_Client_ID=0) with Help content
│   ├── 2Pack_13.0.0.zip    # Versioned copy
│   └── MANIFEST.MF
├── data/
│   ├── GardenWorldSample.zip  # Sample data (AD_Client_ID=11)
│   ├── scripts/            # Development SQL scripts
│   └── history/            # Archived files
├── src/                    # Java source code
└── doc/                    # Documentation
```

## Version History

- **13.0.0** - iDempiere 13 compatibility, Help content, English names
- **1.0.a** - Original OSGi conversion from OFB Consulting code

## Support

- GitHub Issues: https://github.com/red1oon/idempiere-asset-maintenance
- iDempiere Forums: https://www.idempiere.org/forums

## License

GPL v2 - See LICENSE file
