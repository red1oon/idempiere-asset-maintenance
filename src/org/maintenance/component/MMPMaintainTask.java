/**
 * Licensed under the KARMA v.1 Law of Sharing. As others have shared freely to you, so shall you share freely back to us.
 * If you shall try to cheat and find a loophole in this license, then KARMA will exact your share.
 * and your worldly gain shall come to naught and those who share shall gain eventually above you.
 * In compliance with previous GPLv2.0 works of ComPiere USA, OFBConsulting CHILE, Redhuan D. Oon (www.red1.org) and other contributors 
 * THIS ASSET MAINTENANCE module is contribution of Ramiro Vergara, OFB Consulting, CHILE.
*/
package org.maintenance.component;

import java.sql.ResultSet;
import java.util.Properties;

import org.adempiere.base.IModelFactory;
import org.compiere.model.PO;
import org.maintenance.model.X_MP_Maintain_Task;

public class MMPMaintainTask extends X_MP_Maintain_Task implements IModelFactory {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public MMPMaintainTask(Properties ctx, int MP_Maintain_Task_ID,
			String trxName) {
		super(ctx, MP_Maintain_Task_ID, trxName);
		// TODO Auto-generated constructor stub
	}

	public MMPMaintainTask(Properties ctx, ResultSet rs, String trxName) {
		super(ctx, rs, trxName);
	}

	@Override
	public Class<?> getClass(String tableName) {
		  if (Table_Name.equals(tableName)) {
			     return org.maintenance.component.MMPMaintainTask.class;
			   } else { 
				   return null;
			   }
	}

	@Override
	public PO getPO(String tableName, int Record_ID, String trxName) {
		 if (Table_Name.equals(tableName)) {
		     return new org.maintenance.component.MMPMaintainTask(getCtx(), Record_ID, trxName);
		   } else {
			   return null;
		   }
	}

	@Override
	public PO getPO(String tableName, ResultSet rs, String trxName) {
		 if (Table_Name.equals(tableName)) {
		     return new org.maintenance.component.MMPMaintainTask(getCtx(), rs, trxName);
		   } else {
			   return null;
		   }
	}
}
