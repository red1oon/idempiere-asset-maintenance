/**
 * Licensed under the KARMA v.1 Law of Sharing. As others have shared freely to you, so shall you share freely back to us.
 * If you shall try to cheat and find a loophole in this license, then KARMA will exact your share.
 * and your worldly gain shall come to naught and those who share shall gain eventually above you.
 * In compliance with previous GPLv2.0 works of ComPiere USA, OFBConsulting CHILE, Redhuan D. Oon (www.red1.org) and other contributors 
 * THIS ASSET MAINTENANCE module is contribution of Ramiro Vergara, OFB Consulting, CHILE.
*/
package org.maintenance.process;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.logging.Level;

import org.compiere.process.ProcessInfoParameter;
import org.compiere.process.SvrProcess;
import org.compiere.util.DB;
import org.compiere.util.Env;
import org.maintenance.model.X_MP_Maintain;
import org.maintenance.model.X_MP_OT;

/**
 *	
 *	
 *  @author Fabian Aguilar faaguilar
 *  @version $Id: ProcessOT.java,v 1.2 2008/06/12 00:51:01  $
 */
public class MPProcessOT extends SvrProcess
{
	
	/**
	 *  Prepare - e.g., get Parameters.
	 */
	private String P_DocAction;
	/*OT ID*/
	private int 			Record_ID;
	
	protected void prepare()
	{
		ProcessInfoParameter[] para = getParameter();
		for (int i = 0; i < para.length; i++)
		{
			String name = para[i].getParameterName();
			if (para[i].getParameter() == null)
				;
			else if (name.equals("DocAction"))
				P_DocAction = (String)para[i].getParameter();
			else
				log.log(Level.SEVERE, "prepare - Unknown Parameter: " + name);
		}
		
		Record_ID=getRecord_ID();
	}	//	prepare

	/**
	 *  Perrform process.
	 *  @return Message (clear text)
	 *  @throws Exception if not successful
	 */
	protected String doIt() throws Exception
	{
		
		X_MP_OT OT=new X_MP_OT(Env.getCtx(), Record_ID,get_TrxName());
		String sql="Select count(1) from MP_OT_TASK where STATUS!='CO' and MP_OT_ID=?";
		if(DB.getSQLValue(get_TrxName(), sql, Record_ID)>0 && OT.getDocStatus().equals("DR"))
			return "Task Not Completed";
		
			
			String mysql="select distinct MP_MAINTAIN_ID from MP_OT_TASK where MP_OT_ID=?";
			PreparedStatement pstmt = null;
			try
			{
				pstmt = DB.prepareStatement(mysql, get_TrxName());
				pstmt.setInt(1, Record_ID);
				ResultSet rs = pstmt.executeQuery();
				while (rs.next())
				{
					X_MP_Maintain mp= new X_MP_Maintain(Env.getCtx(), rs.getInt(1),get_TrxName());
					if(OT.getDocStatus().equals("CO") && P_DocAction.equals("VO")){
						if(mp.getProgrammingType().equals("C"))
							mp.setDateNextRun(new Timestamp(mp.getDateLastRun().getTime() -(mp.getInterval().longValue()*86400000) ));
						else{
							mp.setnextmp(mp.getnextmp().subtract(mp.getInterval()));
							mp.setlastmp(mp.getnextmp().subtract(mp.getInterval()));
						}
					}
					if(OT.getDocStatus().equals("DR"))
						mp.setDateLastOT(OT.getDateTrx() );
					
					mp.save();
				}
				rs.close();
				pstmt.close();
				pstmt = null;
			}
			catch (Exception e)
			{
				log.log(Level.SEVERE, sql, e);
			}
			
			if(OT.getDocStatus().equals("DR") && P_DocAction.equals("CO"))
			{
				DB.executeUpdateEx("Update MP_OT_RESOURCE set Processed='Y' where MP_OT_TASK_ID IN (select MP_OT_TASK_ID from MP_OT_TASK where MP_OT_ID=?)", new Object[]{OT.getMP_OT_ID()}, get_TrxName());
				DB.executeUpdateEx("Update MP_OT_TASK set Processed='Y' where MP_OT_ID=?", new Object[]{OT.getMP_OT_ID()}, get_TrxName());
				OT.setDocStatus("CO");
				OT.setDocAction("--");
				OT.setProcessed(true);
				OT.save();
				
				return "OT Completed";
			}
			else if(OT.getDocStatus().equals("CO") && P_DocAction.equals("VO")){
				OT.setDocStatus("VO");
				OT.setDocAction("--");
				OT.setProcessed(true);
				return "OT Voided";
			}
			return "";
		
	}	//	doIt


	
}	//	CopyOrder
