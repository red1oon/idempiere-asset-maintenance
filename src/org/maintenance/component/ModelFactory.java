/**
 * Licensed under the KARMA v.1 Law of Sharing. As others have shared freely to you, so shall you share freely back to us.
 * If you shall try to cheat and find a loophole in this license, then KARMA will exact your share.
 * and your worldly gain shall come to naught and those who share shall gain eventually above you.
 * In compliance with previous GPLv2.0 works of ComPiere USA, OFBConsulting CHILE, Redhuan D. Oon (www.red1.org) and other contributors 
 * THIS ASSET MAINTENANCE module is contribution of Ramiro Vergara, OFB Consulting, CHILE.
*/
package org.maintenance.component;

import java.sql.ResultSet;

import org.adempiere.base.IModelFactory;
import org.compiere.model.PO;
import org.compiere.util.Env;

public class ModelFactory implements IModelFactory {

	@Override
	public Class<?> getClass(String tableName) {
		 if (tableName.equals(MMPOTTask.Table_Name)) {
		     return MMPOTTask.class;
		 } else if(tableName.equals(MMPJobStandardTask.Table_Name)){
			 return MMPJobStandardTask.class;
		 } else if(tableName.equals(MMPOT.Table_Name)){
			 return MMPOT.class;
		 }else if(tableName.equals(MMPJobStandardResource.Table_Name)){
			 return MMPJobStandardResource.class;
		 } else if(tableName.equals(MMPJobStandard.Table_Name)){
			 return MMPJobStandard.class;
		 } else if(tableName.equals(MMPMaintain.Table_Name)){
			 return MMPMaintain.class;
		 }
		 return null; 
	}

	@Override
	public PO getPO(String tableName, int Record_ID, String trxName) {
		if (tableName.equals(MMPOTTask.Table_Name)) {
		     return new MMPOTTask(Env.getCtx(), Record_ID, trxName);
		} else  if (tableName.equals(MMPJobStandardTask.Table_Name)) {
		     return new MMPJobStandardTask(Env.getCtx(), Record_ID, trxName);
		}else  if (tableName.equals(MMPJobStandardResource.Table_Name)) {
		     return new MMPJobStandardResource(Env.getCtx(), Record_ID, trxName);
		}else  if (tableName.equals(MMPJobStandard.Table_Name)) {
		     return new MMPJobStandard(Env.getCtx(), Record_ID, trxName);
		}else  if (tableName.equals(MMPMaintain.Table_Name)) {
		     return new MMPMaintain(Env.getCtx(), Record_ID, trxName);
		}
		return null;
	}

	@Override
	public PO getPO(String tableName, ResultSet rs, String trxName) {
		if (tableName.equals(MMPOTTask.Table_Name)) {
		     return new MMPOTTask(Env.getCtx(), rs, trxName);
		} else if (tableName.equals(MMPJobStandardTask.Table_Name)) {
			 return new MMPJobStandardTask(Env.getCtx(), rs, trxName);
		} else if (tableName.equals(MMPJobStandardResource.Table_Name)) {
			 return new MMPJobStandardResource(Env.getCtx(), rs, trxName);
		} else if (tableName.equals(MMPJobStandard.Table_Name)) {
			 return new MMPJobStandard(Env.getCtx(), rs, trxName);
		} else if (tableName.equals(MMPMaintain.Table_Name)) {
			 return new MMPMaintain(Env.getCtx(), rs, trxName);
		}
		return null;
	}
}