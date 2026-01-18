package org.maintenance.component;

import java.sql.ResultSet;
import java.util.Properties;

import org.maintenance.model.X_MP_JobStandar;

public class MMPJobStandard extends X_MP_JobStandar{

	/**
	 * 
	 */
	private static final long serialVersionUID = 4347346233639094456L;

	public MMPJobStandard(Properties ctx, int MP_JobStandar_ID, String trxName) {
		super(ctx, MP_JobStandar_ID, trxName); 
	}
	public MMPJobStandard(Properties ctx, ResultSet rs, String trxName) {
		super(ctx, rs, trxName); 
	}

}
