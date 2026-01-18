/**
 * Licensed under the KARMA v.1 Law of Sharing. As others have shared freely to you, so shall you share freely back to us.
 * If you shall try to cheat and find a loophole in this license, then KARMA will exact your share.
 * and your worldly gain shall come to naught and those who share shall gain eventually above you.
 * In compliance with previous GPLv2.0 works of ComPiere USA, OFBConsulting CHILE, Redhuan D. Oon (www.red1.org) and other contributors 
 * THIS ASSET MAINTENANCE module is contribution of Ramiro Vergara, OFB Consulting, CHILE.
*/
package org.maintenance.model;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Properties;
import java.util.logging.Level;

import org.compiere.model.CalloutEngine;
import org.compiere.model.GridField;
import org.compiere.model.GridTab;
import org.compiere.util.DB;
import org.compiere.util.Env;

/**
 *	Order CalloutAssetMPLog.
 *	
 *  @author Fabian Aguilar OFB faaguilar
 *  @version $Id: CalloutAssetMPLog.java,v 1.34 2010/12/20 21:57:24  Exp $
 */
public class CalloutAssetMPLog extends CalloutEngine
{

	public String assetLog (Properties ctx, int WindowNo, GridTab mTab, GridField mField, Object value)
	{
		if(value==null)
			return "";

		Integer AssetMeter_ID = (Integer)mTab.getValue("MP_AssetMeter_ID");
		if(AssetMeter_ID==null)
			return "";
		Integer Meter_ID=DB.getSQLValue(null, "select MP_Meter_ID from MP_AssetMeter " +
				"where MP_AssetMeter_ID="+AssetMeter_ID);
		
		Integer Asset_ID = DB.getSQLValue(null, "select A_Asset_ID from MP_AssetMeter " +
				"where MP_AssetMeter_ID="+AssetMeter_ID);
		BigDecimal amt= (BigDecimal)mTab.getValue("Amt");
		int count=DB.getSQLValue(null,"select count(1) from MP_AssetMeter" +
				" WHERE MP_Meter_ID=?" +
				"  AND A_ASSET_ID=?", new Object[]{Meter_ID,Asset_ID});
		
		BigDecimal oldAmt=Env.ZERO;
		
		if(count<=1){
			mTab.setValue("CurrentAmt", amt);
		
		}
		else {
			PreparedStatement pstmt = null;
			String sql="SELECT AMT FROM MP_AssetMeter "+
			"WHERE ISACTIVE='N' AND MP_Meter_ID=? AND A_ASSET_ID=? "+
			"ORDER BY DateTrx DESC";
			try
			{
				pstmt = DB.prepareStatement(sql, null);
				pstmt.setInt(1, Meter_ID);
				pstmt.setInt(2, Asset_ID);
				ResultSet rs = pstmt.executeQuery();
				if (rs.next())
				{
					mTab.setValue("CurrentAmt", amt.add(rs.getBigDecimal(1)));
					oldAmt=rs.getBigDecimal(1);
				}
				rs.close();
				pstmt.close();
				pstmt = null;
			}
			catch (Exception e)
			{
				log.log(Level.SEVERE, sql, e);
			}
		}
		
		BigDecimal maxAmt=DB.getSQLValueBD(null,"select max(l.amt) from MP_AssetMeter_Log l" +
				" where l.MP_AssetMeter_ID=?", new Object[]{AssetMeter_ID});
		
		if(maxAmt==null)
			maxAmt=Env.ZERO;
		
		
		amt=amt.add(oldAmt);
		
		DB.executeUpdate("Update MP_AssetMeter  m set" +
				" Amt=" + (maxAmt.compareTo(amt)>0?maxAmt:amt)  +
				" where m.MP_AssetMeter_ID="+AssetMeter_ID.intValue(), null);
		
		return "";
	}	//	charge

	
	public String meterSearch (Properties ctx, int WindowNo, GridTab mTab, GridField mField, Object value)
	{
		if(value==null)
			return "";
		
		Integer AssetMeterSearch_ID = (Integer)mTab.getValue("MP_AssetMeterSearch_ID");
		if(AssetMeterSearch_ID==null)
			return "";
		
		mTab.setValue("MP_AssetMeter_ID", AssetMeterSearch_ID);
		
		return "";
	}
	

}	//	BlumosOrder

