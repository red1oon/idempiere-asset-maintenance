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

import org.maintenance.model.X_MP_Maintain_Resource;

public class MMPMaintainResource extends X_MP_Maintain_Resource{

	public MMPMaintainResource(Properties ctx, ResultSet rs, String trxName) {
		super(ctx, rs, trxName);
		// TODO Auto-generated constructor stub
	}

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public MMPMaintainResource(Properties ctx, int MP_Maintain_Resource_ID,
			String trxName) {
		super(ctx, MP_Maintain_Resource_ID, trxName);
		// TODO Auto-generated constructor stub
	}

}
