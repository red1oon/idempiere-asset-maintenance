-- AD_Ref_List values for MP_MaintainArea (AD_Reference_ID = 53397)
-- These are the dropdown values for the MaintainArea column in MP_JobStandar

-- Check if values already exist before inserting
INSERT INTO ad_ref_list (ad_ref_list_id, ad_client_id, ad_org_id, isactive, created, createdby, updated, updatedby,
  value, name, description, ad_reference_id, entitytype, ad_ref_list_uu)
SELECT 200801, 0, 0, 'Y', now(), 100, now(), 100,
   'ME', 'Mechanical', 'Mechanical maintenance area', 53397, 'U', uuid_generate_v4()
WHERE NOT EXISTS (SELECT 1 FROM ad_ref_list WHERE ad_reference_id = 53397 AND value = 'ME');

INSERT INTO ad_ref_list (ad_ref_list_id, ad_client_id, ad_org_id, isactive, created, createdby, updated, updatedby,
  value, name, description, ad_reference_id, entitytype, ad_ref_list_uu)
SELECT 200802, 0, 0, 'Y', now(), 100, now(), 100,
   'EL', 'Electrical', 'Electrical maintenance area', 53397, 'U', uuid_generate_v4()
WHERE NOT EXISTS (SELECT 1 FROM ad_ref_list WHERE ad_reference_id = 53397 AND value = 'EL');
