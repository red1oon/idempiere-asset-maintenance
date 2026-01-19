-- Migration script: Rename M_BOM_ID to PP_Product_BOM_ID
-- For iDempiere 13 compatibility (M_BOM deprecated, replaced by PP_Product_BOM)
-- Run this BEFORE deploying the updated plugin

-- MP_OT_Resource table
ALTER TABLE MP_OT_Resource RENAME COLUMN M_BOM_ID TO PP_Product_BOM_ID;

-- MP_JobStandar_Resource table
ALTER TABLE MP_JobStandar_Resource RENAME COLUMN M_BOM_ID TO PP_Product_BOM_ID;

-- MP_Maintain_Resource table
ALTER TABLE MP_Maintain_Resource RENAME COLUMN M_BOM_ID TO PP_Product_BOM_ID;

-- Update AD_Column for MP_OT_Resource.PP_Product_BOM_ID
UPDATE AD_Column SET ColumnName = 'PP_Product_BOM_ID', Name = 'BOM',
    AD_Reference_ID = (SELECT AD_Reference_ID FROM AD_Reference WHERE Name = 'Table Direct'),
    AD_Reference_Value_ID = (SELECT AD_Table_ID FROM AD_Table WHERE TableName = 'PP_Product_BOM')
WHERE AD_Table_ID = (SELECT AD_Table_ID FROM AD_Table WHERE TableName = 'MP_OT_Resource')
  AND ColumnName = 'M_BOM_ID';

-- Update AD_Column for MP_JobStandar_Resource.PP_Product_BOM_ID
UPDATE AD_Column SET ColumnName = 'PP_Product_BOM_ID', Name = 'BOM',
    AD_Reference_ID = (SELECT AD_Reference_ID FROM AD_Reference WHERE Name = 'Table Direct'),
    AD_Reference_Value_ID = (SELECT AD_Table_ID FROM AD_Table WHERE TableName = 'PP_Product_BOM')
WHERE AD_Table_ID = (SELECT AD_Table_ID FROM AD_Table WHERE TableName = 'MP_JobStandar_Resource')
  AND ColumnName = 'M_BOM_ID';

-- Update AD_Column for MP_Maintain_Resource.PP_Product_BOM_ID
UPDATE AD_Column SET ColumnName = 'PP_Product_BOM_ID', Name = 'BOM',
    AD_Reference_ID = (SELECT AD_Reference_ID FROM AD_Reference WHERE Name = 'Table Direct'),
    AD_Reference_Value_ID = (SELECT AD_Table_ID FROM AD_Table WHERE TableName = 'PP_Product_BOM')
WHERE AD_Table_ID = (SELECT AD_Table_ID FROM AD_Table WHERE TableName = 'MP_Maintain_Resource')
  AND ColumnName = 'M_BOM_ID';

-- Sync terminology
SELECT register_migration_script('202601_IDEMPIERE-13_BOM_Migration.sql') FROM dual;
